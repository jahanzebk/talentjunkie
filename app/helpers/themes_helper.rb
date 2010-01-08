module ThemesHelper
  
  def get_content_header_style_for_user_profile(user)
    html = ""
    if user.theme
      foreground_color = "color: #{user.theme.header_foreground_color};" if user.theme.header_foreground_color
      background_color = "background-color: #{user.theme.header_background_color};" if user.theme.header_background_color
      background = "background: url(#{user.theme.header_background}) no-repeat;" if user.theme.header_background
      
      if (user.theme.header_background_color and user.theme.header_background_color == "#FFFFFF") or !user.theme.header_background_color
        shading = "background-color: rgba(0, 0, 0, 0.05);"
      else
        shading = "background-color: rgba(255, 255, 255, 0.1);"
      end
      
      
      html =<<HTML
  #content-header
  {
    #{foreground_color if foreground_color}
    #{background_color if background_color}
    #{background if background}
  }
  
  #content-header a,  #content-header a:hover, #content-header a:visited, #content-header h1
  {
    #{foreground_color if foreground_color}
  }
  
  #photo-and-summary, #metrics
  {
    #{shading}
  }
  
  
HTML
    end
    
    html
  end
  
  def get_color_for_sparklines(user)
    user.theme.header_foreground_color ? user.theme.header_foreground_color : "#444"
  end
  
end