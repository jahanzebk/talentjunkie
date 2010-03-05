cache = new Array();

jQuery.fn.ajaxify_form = function()
{
  jQuery(this).bind('submit', function(e)
  {
    e.stopPropagation();
    var form = jQuery(this);

    jQuery.ajax(
    {
      url: jQuery(this).attr("action"),
      type: "POST",
      data: form.serialize(),
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
        //jQuery("input[type='submit']", form).attr('value', submit_button_label);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown)
      {
        jQuery("input[type='submit']", form).attr('value', submit_button_label);
        
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
            messages += "<p>" + label + " " + error_message + "</p>";
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

function searchify_section(namespace, url, field_for_scope)
{
  var container           = jQuery(namespace + "_container")
  var field_for_id        = jQuery(namespace + "_id");
  var field_for_name      = jQuery(namespace + "_name");
  var keep_searching      = true;
  var last_search_length  = 100;
  
  field_for_name.bind("keyup", function(e)
  {
    var q = e.currentTarget.value;

    if(q.length < 2 || (keep_searching == false && last_search_length < q.length))
    {
      clear_cached_choice(namespace);
      jQuery(".in-place-results", container).hide();
      return true;
    }

    jQuery.getJSON(url, { scope_as_value: jQuery(field_for_scope).val(), q: q }, function(results)
    {
      last_search_length = q.length;
      
      if(results.length > 0)
      {
        keep_searching = true;
        jQuery(".in-place-results", container).show();
        jQuery(".in-place-results .holder", container).empty();
      
        jQuery.each(results, function(index)
        {
          // jQuery(".in-place-results .holder", container).append("<div class='result'><a>" + this.name + "</a></div>")
          jQuery(".in-place-results .holder", container).append("<div class='result'><a onmouseover='cache_choice(\"" + namespace + "\", " + this.id + " ,jQuery(this).text());'>" + this.name + "</a></div>")
        })
      }
      else
      {
        keep_searching = false;
        clear_cached_choice(namespace);
        jQuery(".in-place-results", container).hide();
      }
    });
  })

  field_for_name.bind("blur", function(e)
  {
    if(get_cached_choiced(namespace)[0] != null)
    {
      field_for_id.val(get_cached_choiced(namespace)[0]);
      field_for_name.val(get_cached_choiced(namespace)[1]);
    }
    jQuery(".in-place-results").hide();
    clear_cached_choice(namespace);
  })
}

function cache_choice(key, id, text)
{
  cache[key] = [id, text];
  return true;
}

function get_cached_choiced(key)
{
  return cache[key];
}

function clear_cached_choice(key)
{
  return cache_choice(key, null, null);
}

function fb_login()
{
  window.location.replace("/sessions_fb/create");
  return true;
  
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
    beforeSend: function() {},
    complete: function() {},
    error: function(XMLHttpRequest, textStatus, errorThrown) {},
    success: function(json, textStatus)
    {
      // window.location.replace(json.url);
    }
  });    
}