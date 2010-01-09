module SparklinesHelper

  # Call with an array of data and a hash of params for the Sparklines module.
  # You can also pass :class => 'some_css_class' ('sparkline' by default).
  def sparkline_tag(results=[], options={})    
    url = { :controller => 'sparklines', :results => results.join(',') }
    options = url.merge(options)
    "<img src=\"#{ url_for options }\" class=\"#{options[:class] || 'sparkline'}\" alt=\"Sparkline Graph\" />"
  end
  
  def inline_sparkline_tag(blob, color = "#CCC")
    "<img src='data:image/png;base64,#{Base64.encode64(blob)}' style='border-bottom: 1px solid #{color}'/>"
  end

end
