//= require jquery3


bulk_checkbox_click_vulns = function() {
    var chkbox = $('#bulk-checkbox')
    var checked = chkbox.is(':checked');
    $(".vulnerability_checkbox").each(function(){
        $(this).prop('checked', checked);
    });
}

ready_vulns = function() {
   $('#bulk-checkbox').click(bulk_checkbox_click_vulns);
}
  
$( document ).ready(ready_vulns);