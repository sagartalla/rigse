# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file was generated by Cucumber-Rails and is only here to get you a head start
# These step definitions are thin wrappers around the Capybara/Webrat API that lets you
# visit pages, interact with widgets and make assertions about page content.
#
# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong
#


require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step_text, parent|
  with_scope(parent) { step step_text }
end

# Rails-Portal specific "#primay" div.
# hacky fix for bug junit reports in capybara (> 0.9.0)
# jenkins will choke on nested CDATA entries.
When /^(.*) in the content$/ do |step|
  step "#{step} within #primary"
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step_text, parent, table_or_string|
  with_scope(parent) { step "#{step_text}:", table_or_string }
end

def verify_current_path(expected_path)
    # add simple retry support incase there is a redirect here
  10.times {
    current_path = URI.parse(current_url).path
    break if current_path == expected_path
    sleep(0.05)
  }
  current_path.should == expected_path
end

def verified_visit(path)
  visit path
  verify_current_path(path)
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  verified_visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  verified_visit path_to(page_name)
end

When /^(?:|I )try to go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )press "([^"]*)" inside element with selector "([^"]*)"$/ do |button, selector|
  within(selector) do
    find_button(button).click
  end
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    step %{I fill in "#{name}" with "#{value}"}
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
  choose(field)
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

And /^I accept the upcoming javascript confirm box$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
end

And /^I decline the upcoming javascript confirm box$/ do
  page.evaluate_script('window.confirm = function() { return false; }')
end

Then /^(?:|I )should see "([^"]*)" (\d+) times?$/ do |text, count|
  (page.find(:xpath, '//body').text.split(text).length - 1).should == count.to_i
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('.//*', :text => regexp)
  else
    assert page.has_xpath?('.//*', :text => regexp)
  end
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end
 
Then /^(?:|I )should be on (.+)$/ do |page_name|
  # often path_to does a DB lookup, and often this is called while the page is still loading
  # since there is only a single DB connection this can result in 2 threads trying to use the same connection at once
  # so to work around this, we just try multple times if there is an error
  expected_path = nil
  20.times { |time|
    begin
      expected_path = path_to(page_name)
      break
    rescue
      raise if time == 19
      sleep(0.05)
      next
    end
  }

  verify_current_path(path_to(page_name))
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')} 
  
  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end


And /^I select "(.+)" from the html dropdown "(.+)"$/ do |label, dropdown_id|
  page.execute_script("
    var bSuccess = false;
    
    var strDropdownId = '#{dropdown_id}_chzn';
    var arrListItems =  Prototype.Selector.select('#'+ strDropdownId +'> div.chzn-drop > ul.chzn-results > li');    
    
    for (var i = 0; i < arrListItems.length; i++)
    {
      if (arrListItems[i].innerHTML.stripTags().strip() == '#{label}')
      {
        bSuccess = true;
        arrListItems[i].simulate('mouseup');
        break;
      }
    }
    
    return bSuccess;
  ")
end

And /^I receive a file for download with a filename like "(.+)"$/ do |filename|

  pattern = "filename=(.*?)#{Regexp.escape(filename)}(.*?)"
  pattern = Regexp.compile(pattern)

  page.response_headers['Content-Disposition'].should =~ pattern
end

And /^(?:|I )fill "(.*)" in the tinyMCE editor with id "(.*)"$/ do |html, editor_id|
  # make sure the editor is on the page, this also triggers capybara to do its
  # automatic waiting if it isn't on the page yet
  page.should have_css("##{editor_id}")
  evaluate_script("tinyMCE.getInstanceById('#{editor_id}').setContent('#{html}');")
end


