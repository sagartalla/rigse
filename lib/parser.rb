require 'open-uri'
require 'yaml'
require 'spreadsheet'
require 'hpricot'
####################################################################
# Parser --
####################################################################
class Parser
  attr_accessor :logger
  def initialize
    @domains = {}
    @themes = {}
    @logger = Logger.new(STDOUT)
  end

  #
  #
  #
  def process_rigse_data
    # should delete old stuff
    remove_old_data

    make_domains(File.join([RAILS_ROOT] + %w{config rigse_data domains.yml}))
    make_themes(File.join([RAILS_ROOT] + %w{config rigse_data themes.yml}))
    parse(File.join([RAILS_ROOT] + %w{config rigse_data science_gses PS_RI_K-12.xhtml}))
    parse(File.join([RAILS_ROOT] + %w{config rigse_data science_gses ESS_RI_K-12.xhtml}))
    parse(File.join([RAILS_ROOT] + %w{config rigse_data science_gses LS_RI_K-12.xhtml}))
    GradeSpanExpectation.find(:all).each { |gse|  gse.set_gse_key }
  end
  #
  #
  #
  def clean_text(text) 
    if(text)
      # remove all non-ascii ecept elipses, which I like
      text.gsub!(/[^\x20-\x7E|…]/,"")
      text.gsub!("\n"," ")
      text.gsub!("\t"," ")
      text.gsub!(/\?+/,"")
      text.squeeze!(" ")
      text.strip!
    end
    text
  end

  #
  #
  #
  def remove_old_data
    classes_to_clean = [
      Domain,
      KnowledgeStatement,
      AssessmentTarget,
      GradeSpanExpectation,
      ExpectationStem,
      Expectation,
      UnifyingTheme, 
      BigIdea]
      classes_to_clean.each { | c| c.destroy_all }
  end

  #
  #
  #
  def make_domains(domain_yaml)
    data = YAML::load(File.open(domain_yaml))
    data.keys.each do |key| 
      puts key
      d = Domain.find_or_create_by_key(:key => key, :name => data[key])
      d.save
      puts d.inspect
      @domains[key] = d
    end
  end

  #
  #
  #
  def make_themes(theme_yaml)
    data = YAML::load(File.open(theme_yaml))
    data.keys.each do |key|
      theme = UnifyingTheme.find_or_create_by_key(:key => key, :name => data[key])
      theme.save
      @themes[key] = theme
    end
  end


  #
  # use spreadsheet to pull in additional (incomplete) expectations
  #
  def parse_ri_goals_xls(path_to_xls)
    spreadsheet = Spreadsheet.open path_to_xls
    sheet = spreadsheet.worksheet 'Science'
    domain_regex = @domains.keys.join("|")
    regex = /(#{domain_regex})(\d+)\(([K|0-9]\s*[-|–]\s*[K|0-9]+)\)\s*[-|–]\s*([0-9]+)([a-b])(.+)/
    sheet.each do |row| 
      if (row[1])
        begin
          matches = (row[1]).match(regex) # we are only after column #2
          if (matches) # PS3(9-11)-10b Comparing and contrasting electromagnetic waves to mechanical waves.
            (domain_key,someNumber,grade_span,target_number,expectaton_ordinal,description) = matches.captures
            if (domain_key)
              if (domain_key !="PS") # we already have all of these
                expectation  = Expectation.new(:description => description, :ordinal => expectaton_ordinal)
                expectation.save
              end
            end
          end
        rescue
          logger.warn "problem reading #{row} / #{sheet}"
        end
      end
    end
  end


  # Parse a xhtml file looking for 
  # table_heading_regex to seperate 
  #
  def parse(path)
    doc = Hpricot(open(path))
    table_number = 0

    (doc/:table).each do | table |
      table_number = table.attributes['class'].gsub("Table","") 
      case table_number.to_i(10)
      when 1
        import_enduring_knowledge table
      when 2
        import_unifying_themes table
      else
        import_gses table
      end
    end
  end


  #
  #
  #
  def import_enduring_knowledge (table)
    domain_keys = Domain.find(:all).map { |domain| domain.key }
    regex = /^#{domain_keys.join("|")}/
    (table/:tr/:td).each do | td |  
      data = td.inner_text.strip
      if (data =~ regex)
        parse_knowledge_statement data
      end
    end
  end

  #
  #
  #
  def parse_knowledge_statement(text)
    knowledge_statement = nil
    regex = /([A-Z]+)\s?([0-9])(.+)/mi
    matches = text.match(regex)

    if (matches)
      (domain_key,number,statement) = matches.captures
      domain = Domain.find_by_key(domain_key)
      if (domain)
        knowledge_statement = KnowledgeStatement.find(
        :first, 
        :conditions => { :domain_id => domain.id, :number => number }
        )
        unless (knowledge_statement)
          knowledge_statement=KnowledgeStatement.new
        end
        knowledge_statement.domain = domain
        knowledge_statement.number = number
        knowledge_statement.description = statement
        knowledge_statement.save
      end
    else
      logger.warn "unable to parse knowledge statement in text: #{text}"
    end
    return knowledge_statement
  end # end for method dec    


  #
  #
  def import_unifying_themes(table)
    relevent_columns = ((table/:tr)[2]/:td).each do |td| 
      themeName = ((td/:p)[0]).inner_text.strip 
      theme = UnifyingTheme.find_by_name(themeName)
      if (theme)
        (td/:li).each do  |li|
          big_idea = BigIdea.new
          big_idea.description = (clean_text(li.inner_text)).gsub(/^\./,"")
          big_idea.unifying_theme = theme 
          big_idea.save
        end
      else
        logger.warn "could not find theme for : #{themeName}"
      end
    end   
  end

  #
  #
  #s
  def import_gses(table)
    row_number = 0
    knowledge_statement=nil
    assessment_targets = []
    (table/:tr).each do | row |
      row_number = row_number + 1
      column = 0
      (row/:td).each do | data |
        column = column + 1 
        columntext = data.inner_text
        clean_text(columntext)
        case row_number
        when 2,5
          assessment_targets[column] = parse_assesment_target columntext
        when 4,7
          assessment_target_index = (column / 2.0).ceil
          if (assessment_targets[assessment_target_index])
            grade_span_expectation = parse_grade_span_expectation(data.inner_text,assessment_targets[assessment_target_index])
          end
        end # end case

      end # end for data
    end # end for row

  end # end for method declaration


  #
  #
  #
  def parse_assesment_target(text)
    assessment_target = nil
    domain_regex = @domains.keys.join("|")
    space_or_dashes = "[\s|-|–|-]+"
    # (ESS)\s*([0-9]+)\s*\(([K|0-9|\-|\–|\-|\s])+\)[\s|\-|\–|\-][\s|\-|\–|\-]*([A-Z|\s|\+]+)\s*[\s|\-|\–|\-]*(\d+)(.+)
    regex = /(#{domain_regex})\s*([0-9]+)\s*\(([K|0-9|\-|\–|\s])+\)[\s|\-|\–]*([A-Z|\s|\+]+)\s*[\s|\-|\–|\-]*(\d+)(.+)/mx

    matches = text.match(regex)
    if (matches)
      (domain_key,ek_key,grade_span,unifying_theme_key,number,target) = matches.captures

      themes = unifying_theme_key.split('+');
      themes.map { |theme| theme.strip }
      unifying_theme_key = themes[0]

      domain = @domains[domain_key.strip]

      if (domain)
        knowledge_statement = KnowledgeStatement.find(
        :first, 
        :conditions => { :domain_id => domain.id, :number => ek_key })
      else
        logger.warn "could not find domain for #{domain_key}"
      end

      assessment_target = AssessmentTarget.new(:knowledge_statement => knowledge_statement, :number => number)
      unifying_theme = @themes[unifying_theme_key.strip]
      if (unifying_theme)
        assessment_target.unifying_theme = unifying_theme
      else
        logger.warn "could not find unifying theme that matches: #{unifying_theme_key}"
      end
      assessment_target.description = target
      assessment_target.grade_span = grade_span
      assessment_target.save
    else
      logger.warn "can't parse assessment target text is #{text}"
    end
    return assessment_target
  end # end for method dec


  #
  #
  #
  def parse_grade_span_expectation(text, assessment_target)
    gse = nil
    regex = /.*?\(\s?(Ext|[K|0-9].{1,5}[K|0-9])\s?\).{0,5}[0-9](.+)/mi
    matches = text.match(regex)
    if (matches)
      (grade_span,body) = matches.captures
      clean_text(body)
      (stem_string,body) = body.split("…")
      if body
        statement_strings = body.split(/[0-9]{1,2}[a-z]{1,4}/)
        statement_strings.each { |s| clean_text(s) }
        statement_strings.reject! { |s| s == "" || s == nil || s == " " }
        gse = GradeSpanExpectation.new
        gse.grade_span = grade_span
        gse.assessment_target = assessment_target
        gse.save
        stem = ExpectationStem.find_or_create_by_description(stem_string)
        stem.save # force an id
        expectation = Expectation.find(:first, :conditions =>   { :expectation_stem_id => stem, :grade_span_expectation_id => gse })
        expectation ||= Expectation.new(:expectation_stem => stem, :grade_span_expectation => gse)
        expectation.save
        ordinal = 'a'
        expectations = statement_strings.map { | ss | 
          expectation_indicator  = ExpectationIndicator.new(:description => ss, :ordinal => ordinal)
          expectation_indicator.expectation = expectation
          expectation_indicator.save
          ordinal = ordinal.next
          expectation
        }
      end
    else
      logger.warn "can't parse grade span expectation text = #{text}"
    end
    return gse
  end # end for method dec

end # end for class
