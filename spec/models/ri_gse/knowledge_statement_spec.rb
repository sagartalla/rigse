require File.expand_path('../../../spec_helper', __FILE__)

describe RiGse::KnowledgeStatement do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    RiGse::KnowledgeStatement.create!(@valid_attributes)
  end
end
