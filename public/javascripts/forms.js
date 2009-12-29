jQuery.fn.ajaxify_form = function()
{
  jQuery(this).bind('submit', function(e)
  {
    e.stopPropagation();
    var form = jQuery(this);
    
    // tinyMCE.triggerSave();
    
    var params = extract_parameters_from(form);
    
    jQuery.ajax(
    {
      url: jQuery(this).attr("action"),
      type: "POST",
      data: params,
      dataType: "json",
      beforeSend: function()
      {
        jQuery("#form-error", form).hide();
        jQuery("input[type='text']", form).removeClass("error");
        submit_button_label = jQuery("input[type='submit']", form).attr('value');
        jQuery("input[type='submit']", form).attr('value', "Processing...");
      },
      complete: function()
      {
        jQuery("input[type='submit']", form).attr('value', submit_button_label);
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
            var field = jQuery("#" + id, form);
            var error_message = jQuery(field_and_error_message, form)[1];
            
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
        jQuery("input[type='submit']", form).attr('value', "Redirecting...");
        window.location.replace(json.url);
      }
    });    
    return false;
  })
}

function init_tiny_mce_basic()
{
  // tinyMCE.init({
  //   mode : "textareas",
  //   theme : "advanced",
  //   theme_advanced_buttons1 : "bold,italic,underline",
  //   theme_advanced_buttons2 : "",
  //   theme_advanced_buttons3 : "",
  //   add_form_submit_trigger : false,
  //   theme_advanced_source_editor_width : 600,
  //   theme_advanced_toolbar_location : "top",
  //   theme_advanced_toolbar_align : "left",
  // });
}

function init_tiny_mce_full()
{
  // tinyMCE.init({
  //   mode : "textareas",
  //   theme : "advanced",
  //   theme_advanced_blockformats : "p,div,h1,h2",
  //   theme_advanced_buttons1 : "formatselect,bold,italic,underline",
  //   theme_advanced_buttons2 : "",
  //   theme_advanced_buttons3 : "",
  //   add_form_submit_trigger : false,
  //   theme_advanced_source_editor_width : 600,
  //   theme_advanced_toolbar_location : "top",
  //   theme_advanced_toolbar_align : "left",
  // });
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

function fb_login()
{
  window.location.replace("/sessions_fb/create");
  return true;
  
  console.debug("test!")
  
  var session = FB.Facebook.apiClient.get_session();

  params = ""
  jQuery.each(session, function(k, v) {
    params += "&" + k + "=" + v
  })
  
  jQuery.ajax(
  {
    url: "/sessions_fb",
    type: "POST",
    data: params,
    dataType: "json",
    beforeSend: function()
    {
      console.debug("beforeSend")
    },
    complete: function()
    {
      console.debug("complete")
    },
    error: function(XMLHttpRequest, textStatus, errorThrown)
    {
      console.debug(textStatus);
    },
    success: function(json, textStatus)
    {
      console.debug(json)
      // window.location.replace(json.url);
    }
  });    
}