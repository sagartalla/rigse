# This file defines the minimum set of data needed for an 
# An Investigations Instance to boot (in the 'test' environement)
# also includes a few samples of how to instantiate singletons like
# Anonymous and Admin users...
# Many factory calls chain other factory calls to create dependant objects.
# couldn' get that to work for admin_projects though! 
# ( Factory(:admin_projects) throws an error. )

# print "Loading default data set... "
# 
# anon =  Factory.next :anonymous_user
# admin = Factory.next :admin_user
# 
# device_config = Factory.create(:device_config)
# versioned_jnlp = Factory(:maven_jnlp_versioned_jnlp)
# 
# # Admin::Project.create_or_update_default_project_from_settings_yml
# 
# puts "done."