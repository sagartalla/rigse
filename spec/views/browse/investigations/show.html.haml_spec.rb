require 'spec_helper'

describe "browse/investigations/show" do
  let (:user) { Factory.create(:user) }
  let (:inv) { Factory.create(:investigation, :description => '<p>desc foo bar</p>', :user => user) }
  let (:search_material) { Search::SearchMaterial.new(inv, user) }

  before(:each) do
    view.stub!(:current_visitor).and_return(user)
    assigns[:search_material] = @search_material = search_material
  end

  it 'should present an investigation description' do
    render
    rendered.should match /desc foo bar/
  end

  it 'should remove all HTML tags from the description' do
    render
    rendered.should_not match /<p>desc foo bar<\/p>/
    rendered.should_not match /&lt;p&gt;desc foo bar&lt;\/p&gt;/
  end
end