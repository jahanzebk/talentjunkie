module NavigationHelpers

  def path_to(page_name)
    case page_name
    
    when /the welcome page/
      "#{@base_url}/"

    when /the home page/
      '/home'

    when /the profile page/
      '/me/profile'
      
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
