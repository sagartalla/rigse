namespace :rigse do
  namespace :import do
    
    require 'hpricot'
    
    desc "erase and import ITSI activities"
    task :erase_and_import_itsi_activities => :environment do
      raise "need an 'itsi' specification in database.yml to run this task" unless ActiveRecord::Base.configurations['itsi']
      ITSIDIY_URL = ActiveRecord::Base.configurations['itsi']['asset_url']
      Investigation.find(:all, :conditions => "name like 'ITSI%'").each {|i| print 'd'; i.destroy }
      puts
      itsi_user = Itsi::User.find_by_login('itest')
      rites_itsi_import_user = ItsiImporter.find_or_create_itsi_import_user
      itsi_activities = Itsi::Activity.find_all_by_user_id_and_collectdata_model_active_and_public(itsi_user, false, true)
      itsi_activities.each do |itsi_activity| 
        print '.'
        ItsiImporter.create_investigation_from_itsi(itsi_activity, rites_itsi_import_user)
      end
    end

    desc "erase and import ITSI Units from indexed from the CCPortal"
    task :erase_and_import_ccp_itsi_units => :environment do
      raise "need an 'itsi' specification in database.yml to run this task" unless ActiveRecord::Base.configurations['itsi']
      raise "need an 'ccportal' specification in database.yml to run this task" unless ActiveRecord::Base.configurations['ccportal']
      ITSIDIY_URL = ActiveRecord::Base.configurations['itsi']['asset_url']
      Investigation.find(:all, :conditions => "name like 'ITSI Unit%'").each {|i| print 'd'; i.destroy }
      puts
      rites_itsi_import_user = ItsiImporter.find_or_create_itsi_import_user
      ccp_itsi_project = Ccportal::Project.find_by_project_name('ITSI')
      ccp_itsi_project.units.each do |ccp_itsi_unit|
        print '.'
        ItsiImporter.create_investigation_from_ccp_itsi_unit(ccp_itsi_unit, rites_itsi_import_user)
      end
    end
  end
end


