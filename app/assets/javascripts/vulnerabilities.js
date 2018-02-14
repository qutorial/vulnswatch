//= require jquery3
//= require turbolinks

bulk_checkbox_click_vulns = function() {
    var chkbox = $('#bulk-checkbox')
    var checked = chkbox.is(':checked');
    $(".vulnerability_checkbox").each(function(){
        $(this).prop('checked', checked);
    });
}

bulk_react_button_click_vulns = function() {
    $(".vulnerability_checkbox:checked").each(function(){
        var input = $("<input>").attr("type", "hidden")
                .attr("name", "vulns[]")
                .val($(this).val());
        $('#bulk-reaction-form').append($(input));
    });
    $('#bulk-reaction-form').submit();
}

var doubleclickpreventor = 1;

flip_the_checkbox_inside_vulns = function(event){
    if(doubleclickpreventor==2){
        doubleclickpreventor=0;
    }
    ++doubleclickpreventor;
    if(doubleclickpreventor == 2){
        $(this).find(":checkbox").click();
    }
}

vulnerability_checkbox_event_propagation_stop = function(event){
    event.stopPropagation();
}

clear_vulnerabilities_search_vulns = function(event) {
    $('#search_form').find("input[type=text], textarea").val("");
    var input = $("<input>").attr("type", "hidden")
                .attr("name", "clearsearch")
                .val("yes");
    $('#search_form').append($(input));
    $('#search_form').submit();
}

bind_vulns_buttons = function() {
   $('#bulk-checkbox').click(bulk_checkbox_click_vulns);
   $('#bulk-react-button').click(bulk_react_button_click_vulns);
   $('tr.vuln-tr').click(flip_the_checkbox_inside_vulns);
   $("input.vulnerability_checkbox").click(vulnerability_checkbox_event_propagation_stop);
   $('#vulns-index-search-clear').click(clear_vulnerabilities_search_vulns);
   $('#vulns-relax-search').click(clear_vulnerabilities_search_vulns);
}
  
$( document ).ready(bind_vulns_buttons);
$( document ).on('turbolinks:load', bind_vulns_buttons);