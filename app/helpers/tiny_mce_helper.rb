module TinyMceHelper

  def mce_init_string
    'tinyMCE.init({mode:"textareas",theme:"advanced",theme_advanced_toolbar_location:"top",theme_advanced_buttons1:"justifyleft,justifycenter,justifyright,justifyfull,|,bold,italic,underline,strikethrough,|,fontselect,fontsizeselect|,bullist,numlist,hr|,undo,redo,link,unlink,image",theme_advanced_toolbar_align:"left",theme_advanced_buttons2:"",theme_advanced_buttons:"",theme_advanced_statusbar_location:"bottom",theme_advanced_resizing:true});' 
  end

end
