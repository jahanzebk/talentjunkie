jQuery.fn.ajaxify_form = function()
{
  jQuery(this).bind('submit', function(e)
  {
    e.stopPropagation();
    var form = jQuery(this);
    var params = extract_parameters_from(form);

    jQuery.ajax(
    {
      url: jQuery(this).attr("action"),
      type: "POST",
      data: params,
      dataType: "json",
      beforeSend: function()
      {
        jQuery("#form-error").hide();
        jQuery("input[type='text']").removeClass("error");
        submit_button_label = jQuery("input[type='submit']").attr('value');
        jQuery("input[type='submit']").attr('value', "Processing...");
      },
      complete: function()
      {
        jQuery("input[type='submit']").attr('value', submit_button_label);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown)
      {
        var errors_for_models = jQuery.evalJSON(XMLHttpRequest.responseText);

        var messages = "";
      
        jQuery.each(errors_for_models, function(model, errors)
        {
          jQuery.each(errors, function(index, field_and_error_message)
          {
            var id = model + "_" + jQuery(field_and_error_message)[0];
            var field = jQuery("#" + id);
            var error_message = jQuery(field_and_error_message)[1];
            
            var label = field.attr("field_name") == undefined ? field.attr("name") : field.attr("field_name");
          
            field.addClass("error");
            messages += label + " " + error_message + "<br />";
          })

        })

        jQuery("#form-error").html(messages);
        jQuery("#form-error").fadeIn("slow");

      },
      success: function(json, textStatus)
      {
        window.location.replace(json.url);
      }
    });    
    return false;
  })
}