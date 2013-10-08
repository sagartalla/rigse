# encoding: utf-8

require 'spec_helper'


describe Search do
  include SolrSpecHelper

  def clean_solar_index
    Search::AllMaterials.each do |model_type|
      model_type.remove_all_from_index!
    end
  end

  def make(let_expression); end # Syntax sugar for our lets

  def collection(factory, count=3, opts={})
    results = []
    count.times do
      yield opts if block_given?
      results << FactoryGirl.create(factory.to_sym, opts)
    end
    results
  end

  before(:all) do
    solr_setup
    clean_solar_index
  end

  after(:each) do
    clean_solar_index
  end

  describe "search" do
    let(:public_opts)  { { :publication_status => "published"        }}
    let(:private_opts) { { :publication_status => "private"          }}
    let(:external_seq) { { :template => private_investigations.first }}
    let(:external_act) { { :template => private_activities.first     }}

    let(:public_investigations) { collection(:investigation, 2, public_opts) }
    let(:private_investigations){ collection(:investigation, 2, private_opts)}
    let(:public_activities)     { collection(:activity, 2, public_opts)      }
    let(:private_activities)    { collection(:activity, 2, private_opts)     }
    let(:public_ext_act)        { collection(:external_activity, 2, external_act.merge(public_opts)) }
    let(:private_ext_act)       { collection(:external_activity, 2, external_act.merge(private_opts)) }
    let(:public_ext_seq)        { collection(:external_activity, 2, external_seq.merge(public_opts)) }
    let(:private_ext_seq)       { collection(:external_activity, 2, external_seq.merge(private_opts)) }

    let(:search_opts) { {} }

    subject do
      s = Search.new(search_opts)
    end

    context "with existing collections" do
      let(:private_items) { [private_investigations, private_activities, private_ext_act, private_ext_seq].flatten}
      let(:public_items)  { [public_investigations,  public_activities, public_ext_act,  public_ext_seq].flatten}
      let(:materials)     { [public_items, private_items].flatten }

      before(:each) do
        make materials
        Sunspot.index!
      end

      describe "searching public items" do
        let(:search_opts) { {:private => false } }
        it "results should include 4 public activities and 4 public investigations" do
          subject.results[:all].should have(8).entries
          subject.results[Investigation].should have(4).entries
          subject.results[Activity].should have(4).entries
        end
      end

      describe "searching all items" do
        let(:search_opts) { {:private => true } }
        it "results should include 8 activities and 8 investigations" do
          # subject.results[:all].should have(16).entries
          subject.results[Investigation].should have(8).entries
          subject.results[Activity].should have(8).entries
        end
      end

      describe "searching only public Investigations" do
        let(:search_opts) { {:private  => false, :material_types => [Investigation]} }
        it "results should include 4 investigations" do
          subject.results[:all].should have(4).entries
          subject.results[Investigation].should have(4).entries
        end
      end

      describe "ordering" do
        describe "by date" do
          let(:search_opts) { {:private => false, :sort => Search::Newest} }
          let(:factory_opts){ {:publication_status => "published"}         }
          let(:materials) do
            [
              collection_with_rand_mod_time(:investigation, 6, factory_opts),
              collection_with_rand_mod_time(:activity, 6, factory_opts)
            ].flatten
          end

          describe "Search::Newest" do
            it "the collection should be sorted by updated_at newest ➙ oldest" do
              subject.results[Investigation].should be_ordered_by(:updated_at_desc)
              subject.results[Activity].should be_ordered_by(:updated_at_desc)
            end
          end

          describe "Search::Oldest" do
            let(:search_opts) { {:private => false, :sort_order => Search::Oldest} }
            it "the collection should be sorted by updated_at oldest ➙ newest" do
              subject.results[Investigation].should be_ordered_by(:updated_at)
              subject.results[Activity].should be_ordered_by(:updated_at)
            end
          end
        end # by date

        describe "by Popularity" do
          let(:search_opts) { {:private => false, :sort_order => Search::Popularity} }
          let(:factory_opts){ {:publication_status => "published"}         }
          let(:materials) do
            [
              collection(:investigation, 5, factory_opts) do |o|
                o[:offerings_count] = rand(0..10)
              end,
              collection(:external_activity, 5, external_seq.merge(public_opts)) do |o|
                o[:offerings_count] = rand(0..10)
              end,
              collection(:activity, 3, factory_opts) do |o|
                o[:offerings_count] = rand(0..10)
              end,
              collection(:external_activity, 3, external_act.merge(public_opts)) do |o|
                o[:offerings_count] = rand(0..10)
              end
            ].flatten
          end
          it "the collection should be sotred by offerings_count desc" do
            subject.results[Investigation].should be_ordered_by(:offerings_count_desc)
            subject.results[Activity].should be_ordered_by(:offerings_count_desc)
          end
        end
      end
    end

  end
end