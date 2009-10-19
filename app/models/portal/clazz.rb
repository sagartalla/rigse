class Portal::Clazz < ActiveRecord::Base
  set_table_name :portal_clazzes
  
  acts_as_replicatable
  
  belongs_to :course, :class_name => "Portal::Course", :foreign_key => "course_id"
  belongs_to :semester, :class_name => "Portal::Semester", :foreign_key => "semester_id"
  belongs_to :teacher, :class_name => "Portal::Teacher", :foreign_key => "teacher_id"
  
  has_many :offerings, :class_name => "Portal::Offering", :foreign_key => "clazz_id"
  has_many :student_clazzes, :class_name => "Portal::StudentClazz", :foreign_key => "clazz_id"
  
  has_many :students, :through => :student_clazzes, :class_name => "Portal::Student"
  
  has_many :grade_levels, :as => :has_grade_levels, :class_name => "Portal::GradeLevel"
  has_many :grades, :through => :grade_levels, :class_name => "Portal::Grade"
  
  [:district, :virtual?, :real?].each {|method| delegate method, :to=> :course } 

  validates_presence_of :class_word
  validates_uniqueness_of :class_word
  
  include Changeable

  self.extend SearchableModel

  @@searchable_attributes = %w{name description}

  class <<self
    def searchable_attributes
      @@searchable_attributes
    end

    def display_name
      "Class"
    end
  end
  
  def title
    semester_name = semester ? semester.name : 'unknown'
    "Class: #{name}, Semester: #{semester_name}"
  end
  
  # for the accordion display
  def children
    return students
  end
  
  def user
    return teacher.user
  end
    
  def parent
    return teacher
  end
  
end