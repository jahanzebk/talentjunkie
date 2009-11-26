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

function searchify_section(namespace, url, field_for_scope_id)
{
  var container           = jQuery(namespace + "_container")
  var field_for_name      = jQuery(namespace + "_name");
  var field_for_id        = jQuery(namespace + "_id");

  cache_choice(field_for_id.val(), field_for_name.val());

  field_for_name.bind("keyup", function(e)
  {
    container = jQuery(field_for_id).parent();
    var q = e.currentTarget.value;

    if(q.length < 3) return true;

    jQuery.getJSON(url, { scope_as_id: jQuery(field_for_scope_id).val(), q: q }, function(results)
    {
      if(results.length > 0)
      {
        jQuery(".in-place-results", container).show();
        jQuery(".in-place-results .holder", container).empty();
      
        cache_choice(results[0].id, results[0].name);
      
        jQuery.each(results, function(index)
        {
          jQuery(".in-place-results .holder", container).append("<div class='result'><a onmouseover='cache_choice("+ this.id + ", jQuery(this).text());'>" + this.name + "</a></div>")
        })
      }
      else
      {
        jQuery(".in-place-results", container).hide();
      }
    });
  })

  field_for_name.bind("blur", function(e)
  {
    if(selected_id > 0)
    {
      field_for_id.val(selected_id);
      field_for_name.val(selected_value);
      jQuery(".in-place-results").hide();
      clear_cached_choice();
    }
  })
}

function cache_choice(id, text)
{
  selected_id = id;
  selected_value = text;
}

function clear_cached_choice()
{
  cache_choice(null, null);
}