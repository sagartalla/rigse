  module OtmlHelper

  def ot_menu_display_name(object)
    if teacher_only?(object) 
      return "+ #{object.name}"
    end
    return object.name
  end
  
  def ot_refid_for(object, *prefixes)
    if object.is_a? String
      '${' + object + '}'
    else
      if prefixes.empty?
        '${' + dom_id_for(object) + '}'
      else
        '${' + dom_id_for(object, prefixes) + '}'
      end
    end
  end

  def ot_local_id_for(object, *prefixes)
    if object.is_a? String
      object
    else
      if prefixes.empty?
        dom_id_for(object)
      else
        dom_id_for(object, prefixes)
      end
    end
  end
  
  def imports
    imports = %w{
      org.concord.data.state.OTDataChannelDescription
      org.concord.data.state.OTDataField
      org.concord.data.state.OTDataStore
      org.concord.data.state.OTDataTable
      org.concord.datagraph.state.OTDataAxis
      org.concord.datagraph.state.OTDataCollector
      org.concord.otrunk.graph.OTDataCollectorViewConfig
      org.concord.datagraph.state.OTDataGraph
      org.concord.datagraph.state.OTDataGraphable
      org.concord.datagraph.state.OTMultiDataGraph
      org.concord.datagraph.state.OTPluginView
      org.concord.framework.otrunk.view.OTFrame
      org.concord.framework.otrunk.wrapper.OTBlob
      org.concord.graph.util.state.OTDrawingTool2
      org.concord.otrunk.OTSystem
      org.concord.otrunk.control.OTButton
      org.concord.otrunk.ui.OTCardContainer
      org.concord.otrunk.ui.OTTabContainer
      org.concord.otrunk.ui.OTChoice
      org.concord.otrunk.ui.swing.OTChoiceViewConfig
      org.concord.otrunk.ui.OTCurriculumUnit
      org.concord.otrunk.ui.OTText
      org.concord.otrunk.ui.OTUDLContainer
      org.concord.otrunk.ui.OTSection
      org.concord.otrunk.ui.menu.OTMenu
      org.concord.otrunk.ui.menu.OTMenuRule
      org.concord.otrunk.ui.menu.OTNavBar
      org.concord.otrunk.ui.question.OTQuestion
      org.concord.otrunk.view.OTFolderObject
      org.concord.otrunk.view.OTViewBundle
      org.concord.otrunk.view.OTViewChild
      org.concord.otrunk.view.OTViewEntry
      org.concord.otrunk.view.OTViewMode
      org.concord.otrunk.view.document.OTCompoundDoc
      org.concord.otrunk.view.document.OTCssText
      org.concord.otrunk.view.document.OTDocumentViewConfig
      org.concord.otrunk.view.document.edit.OTDocumentEditViewConfig
      org.concord.otrunkmw.OTModelerPage
      org.concord.otrunknl4.OTNLogoModel
      org.concord.sensor.state.OTZeroSensor
      org.concord.sensor.state.OTDeviceConfig
      org.concord.sensor.state.OTExperimentRequest
      org.concord.sensor.state.OTInterfaceManager
      org.concord.sensor.state.OTSensorDataProxy
      org.concord.sensor.state.OTSensorRequest
      org.concord.otrunk.biologica.OTWorld
      org.concord.otrunk.biologica.OTOrganism
      org.concord.otrunk.biologica.OTStaticOrganism
      org.concord.otrunk.biologica.OTChromosome
      org.concord.otrunk.biologica.OTChromosomeZoom
      org.concord.otrunk.biologica.OTBreedOffspring
      org.concord.otrunk.biologica.OTPedigree
      org.concord.otrunk.biologica.OTMultipleOrganism
      org.concord.otrunk.biologica.OTFamily
      org.concord.otrunk.biologica.OTSex
      org.concord.otrunk.labbook.OTLabbook
      org.concord.otrunk.labbook.OTLabbookView
      org.concord.otrunk.labbook.OTLabbookButton
      org.concord.otrunk.labbook.OTLabbookEntryChooser
      org.concord.otrunk.util.OTLabbookBundle
      org.concord.otrunk.util.OTLabbookEntry
    } + (@otrunk_imports || []).uniq
  end
  
  def ot_imports
    capture_haml do
      haml_tag :imports do
        imports.each do |import|
          haml_tag :import, :/, :class => import
        end
      end
    end
  end

  def view_entries
    [
      ['text_edit_view', 'org.concord.otrunk.ui.OTText', 'org.concord.otrunk.ui.swing.OTTextEditView'],
      ['question_view', 'org.concord.otrunk.ui.question.OTQuestion', 'org.concord.otrunk.ui.question.OTQuestionView'],
      ['choice_radio_button_view', 'org.concord.otrunk.ui.OTChoice', 'org.concord.otrunk.ui.swing.OTChoiceRadioButtonView'],
      ['data_drawing_tool2_view', 'org.concord.graph.util.state.OTDrawingTool2', 'org.concord.datagraph.state.OTDataDrawingToolView'],
      ['blob_image_view', 'org.concord.framework.otrunk.wrapper.OTBlob', 'org.concord.otrunk.ui.swing.OTBlobImageView'],
      ['data_collector_view', 'org.concord.datagraph.state.OTDataCollector', 'org.concord.datagraph.state.OTDataCollectorView'],
      ['data_graph_view', 'org.concord.datagraph.state.OTDataGraph', 'org.concord.datagraph.state.OTDataGraphView'],
      ['data_field_view', 'org.concord.data.state.OTDataField', 'org.concord.data.state.OTDataFieldView'],
      ['data_drawing_tool_view', 'org.concord.graph.util.state.OTDrawingTool', 'org.concord.datagraph.state.OTDataDrawingToolView'],
      ['multi_data_graph_view', 'org.concord.datagraph.state.OTMultiDataGraph', 'org.concord.datagraph.state.OTMultiDataGraphView'],
      ['button_view', 'org.concord.otrunk.control.OTButton', 'org.concord.otrunk.control.OTButtonView'],
      ['data_table_view', 'org.concord.data.state.OTDataTable', 'org.concord.data.state.OTDataTableView'],
      ['udl_container', 'org.concord.otrunk.ui.OTUDLContainer', 'org.concord.otrunk.ui.OTUDLContainerView'],
      ['curriculum_unit_view', 'org.concord.otrunk.ui.OTCurriculumUnit', 'org.concord.otrunk.ui.swing.OTCurriculumUnitView'],
      ['section_view', 'org.concord.otrunk.ui.OTSection', 'org.concord.otrunk.ui.swing.OTSectionView'],
      ['menu_page_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.ui.menu.OTMenuPageView'],
      ['menu_accordion_section_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.swingx.OTMenuAccordionSectionView'],
      ['menu_section_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.ui.menu.OTMenuSectionView'],
      ['menu_page_expand_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.ui.menu.OTMenuPageExpandView'],
      ['card_container_view', 'org.concord.otrunk.ui.OTCardContainer', 'org.concord.otrunk.ui.swing.OTCardContainerView'],
      ['tab_container_view','org.concord.otrunk.ui.OTTabContainer', 'org.concord.otrunk.ui.swing.OTTabContainerView'],
      ['nav_bar', 'org.concord.otrunk.ui.menu.OTNavBar', 'org.concord.otrunk.ui.menu.OTNavBarView'],
      ['modeler_page_view', 'org.concord.otrunkmw.OTModelerPage', 'org.concord.otrunkmw.OTModelerPageView'],
      ['n_logo_model', 'org.concord.otrunknl4.OTNLogoModel', 'org.concord.otrunknl4.OTNLogoModelView'],
      ['biologica_world', 'org.concord.otrunk.biologica.OTWorld', 'org.concord.otrunk.ui.swing.OTNullView'],
      ['biologica_organism', 'org.concord.otrunk.biologica.OTOrganism', 'org.concord.otrunk.ui.swing.OTNullView'],
      ['biologica_static_organism', 'org.concord.otrunk.biologica.OTStaticOrganism', 'org.concord.otrunk.biologica.ui.OTStaticOrganismView'],
      ['biologica_chromosome','org.concord.otrunk.biologica.OTChromosome','org.concord.otrunk.biologica.ui.OTChromosomeView'],
      ['biologica_chromosome_zoom','org.concord.otrunk.biologica.OTChromosomeZoom','org.concord.otrunk.biologica.ui.OTChromosomeZoomView'],
      ['biologica_breed_offspring','org.concord.otrunk.biologica.OTBreedOffspring','org.concord.otrunk.biologica.ui.OTBreedOffspringView'],
      ['biologica_pedigree','org.concord.otrunk.biologica.OTPedigree','org.concord.otrunk.biologica.ui.OTPedigreeView'],
      ['biologica_multiple_organism','org.concord.otrunk.biologica.OTMultipleOrganism','org.concord.otrunk.biologica.ui.OTMultipleOrganismView'],
      ['biologica_family','org.concord.otrunk.biologica.OTFamily','org.concord.otrunk.ui.swing.OTNullView'],
      ['biologica_sex','org.concord.otrunk.biologica.OTSex','org.concord.otrunk.biologica.ui.OTSexView'],
      ['lab_book_button_view', 'org.concord.otrunk.labbook.OTLabbookButton' 'org.concord.otrunk.labbook.ui.OTLabbookButtonEditView'],
      ['lab_book_view' ,'org.concord.otrunk.labbook.OTLabbook', 'org.concord.otrunk.labbook.ui.OTLabbookView'],
      ['lab_book_entry_chooser', 'org.concord.otrunk.labbook.OTLabbookEntryChooser', 'org.concord.otrunk.labbook.ui.OTLabbookEntryChooserEditView']
    ] + (@otrunk_view_entries || []).uniq
  end
  
  def authoring_view_entries
    [
      ['text_edit_edit_view', 'org.concord.otrunk.ui.OTText', 'org.concord.otrunk.ui.swing.OTTextEditEditView'],
      ['question_edit_view', 'org.concord.otrunk.ui.question.OTQuestion', 'org.concord.otrunk.ui.question.OTQuestionEditView'],
      ['choice_radio_button_edit_view', 'org.concord.otrunk.ui.OTChoice', 'org.concord.otrunk.ui.swing.OTChoiceComboBoxEditView'],
#      ['data_drawing_tool2_view', 'org.concord.graph.util.state.OTDrawingTool2', 'org.concord.datagraph.state.OTDataDrawingToolView'],
#      ['blob_image_view', 'org.concord.framework.otrunk.wrapper.OTBlob', 'org.concord.otrunk.ui.swing.OTBlobImageView'],
      ['data_collector_edit_view', 'org.concord.datagraph.state.OTDataCollector', 'org.concord.otrunk.graph.OTDataCollectorEditView'],
#      ['data_graph_view', 'org.concord.datagraph.state.OTDataGraph', 'org.concord.datagraph.state.OTDataGraphView'],
#      ['data_field_view', 'org.concord.data.state.OTDataField', 'org.concord.data.state.OTDataFieldView'],
      ['data_drawing_tool_edit_view', 'org.concord.graph.util.state.OTDrawingTool', 'org.concord.otrunk.graph.OTDataDrawingToolEditView'],
#      ['multi_data_graph_view', 'org.concord.datagraph.state.OTMultiDataGraph', 'org.concord.datagraph.state.OTMultiDataGraphView'],
#      ['button_view', 'org.concord.otrunk.control.OTButton', 'org.concord.otrunk.control.OTButtonView'],
      ['data_table_edit_view', 'org.concord.data.state.OTDataTable', 'org.concord.otrunk.ui.swing.OTDataTableEditView'],
      ['udl_container_edit_view', 'org.concord.otrunk.ui.OTUDLContainer', 'org.concord.otrunk.ui.OTUDLContainerEditView'],
      ['curriculum_unit_edit_view', 'org.concord.otrunk.ui.OTCurriculumUnit', 'org.concord.otrunk.ui.swing.OTCurriculumUnitEditView'],
#      ['section_view', 'org.concord.otrunk.ui.OTSection', 'org.concord.otrunk.ui.swing.OTSectionView'],
      ['menu_page_edit_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.ui.menu.OTMenuPageEditView'],
#      ['menu_accordion_section_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.swingx.OTMenuAccordionSectionView'],
      ['menu_section_edit_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.ui.menu.OTMenuSectionEditView'],
      ['menu_page_expand_edit_view', 'org.concord.otrunk.ui.menu.OTMenu', 'org.concord.otrunk.ui.menu.OTMenuPageEditView'],
#      ['card_container_view', 'org.concord.otrunk.ui.OTCardContainer', 'org.concord.otrunk.ui.swing.OTCardContainerView'],
#      ['nav_bar', 'org.concord.otrunk.ui.menu.OTNavBar', 'org.concord.otrunk.ui.menu.OTNavBarView'],
      ['modeler_page_edit_view', 'org.concord.otrunkmw.OTModelerPage', 'org.concord.otrunkmw.OTModelerPageEditView'],
      ['n_logo_model_edit_view', 'org.concord.otrunknl4.OTNLogoModel', 'org.concord.otrunknl4.OTNLogoModelEditView'],
      ['biologica_world', 'org.concord.otrunk.biologica.OTWorld', 'org.concord.otrunk.biologica.OTWorldEditView'],
      ['biologica_organism', 'org.concord.otrunk.biologica.OTOrganism', 'org.concord.otrunk.biologica.OTOrganismEditView'],
      ['biologica_static_organism', 'org.concord.otrunk.biologica.OTStaticOrganism', 'org.concord.otrunk.biologica.ui.OTStaticOrganismEditView'],
      ['biologica_chromosome','org.concord.otrunk.biologica.OTChromosome','org.concord.otrunk.biologica.ui.OTChromosomeEditView'],
      ['biologica_chromosome_zoom','org.concord.otrunk.biologica.OTChromosomeZoom','org.concord.otrunk.biologica.ui.OTChromosomeZoomEditView'],
      ['biologica_breed_offspring','org.concord.otrunk.biologica.OTBreedOffspring','org.concord.otrunk.biologica.ui.OTBreedOffspringEditView'],
      ['biologica_pedigree','org.concord.otrunk.biologica.OTPedigree','org.concord.otrunk.biologica.ui.OTPedigreeEditView'],
      ['biologica_multiple_organism','org.concord.otrunk.biologica.OTMultipleOrganism','org.concord.otrunk.biologica.ui.OTMultipleOrganismEditView'],
      ['biologica_family','org.concord.otrunk.biologica.OTFamily','org.concord.otrunk.ui.swing.OTNullView'],
      ['biologica_sex','org.concord.otrunk.biologica.OTSex','org.concord.otrunk.biologica.ui.OTSexEditView']
    ] + (@otrunk_edit_view_entries || []).uniq
  end

  def ot_view_bundle(options={})
    @left_nav_panel_width =  options[:left_nav_panel_width] || 0
    title = options[:title] || 'RITES sample'
    use_scroll_pane = (options[:use_scroll_pane] || false).to_s
    authoring = options[:authoring] || false
    if authoring
      current_mode = 'authoring'
    else
      current_mode = 'student'
    end
    render :partial => "otml/ot_view_bundle", :locals => { :view_entries => view_entries, :authoring_view_entries => authoring_view_entries, :use_scroll_pane => use_scroll_pane, :left_nav_panel_width => @left_nav_panel_width, :title => title, :authoring => authoring, :current_mode => current_mode }
  end

  def ot_script_engine_bundle
    engines = [
      'org.concord.otrunk.script.js.OTJavascript', 'org.concord.otrunk.script.js.OTJavascriptEngine',
      'org.concord.otrunk.script.jruby.OTJRuby', 'org.concord.otrunk.script.jruby.OTJRubyEngine'
    ]
    render :partial => "otml/ot_script_engine_bundle", :locals => { :engines => engines }
  end

  def ot_sharing_bundle
    render :partial => "otml/ot_sharing_bundle"
  end

  def ot_interface_manager
    # FIXME
    # hard-coded to be'vernier_goio' because we don't have access to
    # the real current_user when this request comes from a Java client.
    # see: http://jira.concord.org/browse/RITES-211
    vendor_interface = VendorInterface.find(6)  
    render :partial => "otml/ot_interface_manager", :locals => { :vendor_interface => vendor_interface }
  end

  def ot_bundles(options={})
    capture_haml do
      haml_tag :bundles do
        haml_concat ot_view_bundle(options)
        haml_concat ot_interface_manager
      end
    end
  end

  def ot_sensor_data_proxy(data_collector)
    probe_type = data_collector.probe_type
    capture_haml do
      haml_tag :OTSensorDataProxy, :local_id => ot_local_id_for(data_collector, :data_proxy) do
         haml_tag :request do
           haml_tag :OTExperimentRequest, :period => probe_type.period.to_s do
             haml_tag :sensorRequests do
               haml_tag :OTSensorRequest, :stepSize => probe_type.step_size.to_s, 
                :type => probe_type.ptype.to_s, :unit => probe_type.unit, :port => probe_type.port.to_s, 
                :requiredMax => probe_type.max.to_s, :requiredMin => probe_type.min.to_s,
                :displayPrecision => "#{data_collector.probe_type.display_precision}"
            end
          end
        end
      end
    end
  end
  
  # %OTDataStore{ :local_id => ot_local_id_for(data_collector, :data_store), :numberChannels => '2' }
  #   - if data_collector.data_store_values.length > 0
  #     %values
  #       - data_collector.data_store_values.each do |value|
  #         %float= value
  # 
  def generate_otml_datastore(data_collector)
    capture_haml do
      haml_tag :OTDataStore, :local_id => ot_local_id_for(data_collector, :data_store), :numberChannels => '2' do
        if data_collector.data_store_values && data_collector.data_store_values.length > 0
          haml_tag :values do
            data_collector.data_store_values.each do |value|
              haml_tag(:float, :<) do
                haml_concat(value)
              end
            end
          end
        end
      end
    end
  end
  
  def otml_for_calibration_filter(calibration)
    filter = calibration.data_filter
    if filter
      capture_haml do
        ot_name = filter.otrunk_object_class.split(".")[-1]
        haml_tag ot_name.to_sym, :sourceChanel => "1" do
          haml_tag :source
          if block_given? 
            yield
          end
        end
      end
    end
  end

end


