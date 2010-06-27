jQuery(document).ready(function(){ 
	jQuery("#particpanttabs").tabs({
		ajaxOptions: { async: false },
		cache: false
	}).
	tabs({load : initDialog});
	
  jQuery("#participants").jqGrid({
    url:'participants/list',
    datatype: 'xml',
    colNames:['First Name','Last Name'],
    colModel :[ 
      {name:'person[first_name]', index:'first_name', width:250,
    	  editable:true,editoptions:{size:20}, formoptions:{ rowpos:1, label: "First Name", elmprefix:"(*)"},editrules:{required:true}
    	  }, 
      {name:'person[last_name]', index:'last_name', width:250,
        	  editable:true,editoptions:{size:20}, formoptions:{ rowpos:2, label: "Last Name", elmprefix:"(*)"},editrules:{required:true}
    		  } ],
    pager: jQuery('#pager'),
    rowNum:10,
    autowidth: false,
    rowList:[10,20,30],
    pager: jQuery('#pager'),
    sortname: 'last_name',
    sortorder: "asc",
    viewrecords: true,
    imgpath: 'stylesheets/cupertino/images',
    caption: 'Participants',
    editurl: '/participants',
    onSelectRow: function(ids) {
      var $tabs = $('#particpanttabs').tabs();

      $tabs.
          tabs( 'url' , 0 , 'participants/'+ids+'/registrationDetail' ).tabs( 'load' , 0 ).tabs('select', 0);
      $tabs.
          tabs( 'url' , 1 , 'participants/'+ids+'/addresses').tabs( 'load' , 1 )
          ;
      
      return false;
    }
  }); 
  
  jQuery("#participants").navGrid('#pager',
		  {view:false }, //options

		  {	// edit options
			  height:220, reloadAfterSubmit:false, jqModal:true, closeOnEscape:true,
			  bottominfo:"Fields marked with (*) are required",
			  afterSubmit: processResponse,
			  beforeSubmit : function(postdata, formid) {
			  	this.ajaxEditOptions = {url : '/participants/'+postdata.participants_id, type: 'put'};
			  	return [true, "ok"]; }
		  }, // edit options

		  { // add options
			  reloadAfterSubmit:false, jqModal:true, closeOnEscape:true,
			  bottominfo:"Fields marked with (*) are required",
			  afterSubmit: processResponse,
			  closeAfterAdd: true
		  }, // add options

		  { // del options
			  reloadAfterSubmit:false,jqModal:true, closeOnEscape:true,
			  beforeSubmit : function(postdata) {
			  this.ajaxDelOptions = {url : '/participants/'+postdata, type: 'delete' };
			  return [true, "ok"]; },
		  }, // del options

		  { // search options
			  jqModal:true, closeOnEscape:true,
			  multipleSearch:true,
			  sopt:['eq','ne'],
			  odata: ['begins with', 'does not begin with'],
			  groupOps: [ { op: "AND", text: "all" }, { op: "OR", text: "any" } ]
		  }, // search options
		  
		  {height:150, jqModal:true, closeOnEscape:true} // view options
  );
});


function initDialog(event, ui) {
	$('#edialog', ui.panel).jqm({
		ajax: '@href', 
		trigger: 'a.entrydialog',
		onLoad: adjust,
		onHide: function(hash) {
		var $tabs = $('#particpanttabs').tabs();
		var selected = $tabs.tabs('option', 'selected');
		$tabs.tabs('load', selected);
		hash.w.fadeOut('2000',function(){ hash.o.remove(); });
		}
	});
	
	$('.remove-form form', ui.panel).ajaxForm({
		target: '#tab-messages',
		success: function(response, status) {
			var $tabs = $('#particpanttabs').tabs();
			var selected = $tabs.tabs('option', 'selected');
			$tabs.tabs('load', selected);
		}
	});
}

function adjust(dialog) {
	$('.particpantInfo', dialog.w).ajaxForm({
		target: '#form-response'
	});
}

function processResponse(response, postdata) { 
	// examine return for problem - look for errorExplanation in the returned HTML
	var text = $(response.responseText).find(".errorExplanation");
	if (text.size() > 0) {
		text.css('font-size','6pt');
		text = $("<div></div>").append(text);
		return [false, text.html() ];
	}
	return [true, "Success"]; 
}
