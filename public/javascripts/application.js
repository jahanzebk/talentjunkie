// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.fn.enable_hint = function()
{
  if(jQuery(this).val() == "")
  {
    jQuery(this).val(jQuery(this).attr('hint'));
    jQuery(this).addClass("hint");
  }
  jQuery(this).bind('focus', function()
  {
    if(jQuery(this).val() == jQuery(this).attr('hint'))
    {
      jQuery(this).val("");
      jQuery(this).removeClass("hint");
    }
  })
  
  jQuery(this).bind('blur', function()
  {
    if(jQuery(this).val() == "")
    {
      jQuery(this).val(jQuery(this).attr('hint'));
      jQuery(this).addClass("hint");
    }
  })
}
  
jQuery(document).ready(function(){
  jQuery.each(jQuery("[hint]"), function()
  {
    jQuery(this).enable_hint();
  })  
})


function extract_parameters_from(form)
{
  var params = "";
  
  jQuery.each(form.find("input[type=hidden]").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" + escape(jQuery(this).attr("value"));
  });

  jQuery.each(form.find("input[type=text]").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" + escape(jQuery(this).attr("value"));
  });
  
  jQuery.each(form.find("input[type=checkbox]").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" + (this.checked ? "true" : "");
  });

  jQuery.each(form.find("textarea").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" +  escape(this.value);
  });
  
  jQuery.each(form.find("select").get(), function()
  {
    params += "&" + jQuery(this).attr("name") + "=" +  escape(jQuery(this).attr("value"));
  });
  
  return params;
}