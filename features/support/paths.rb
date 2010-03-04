module NavigationHelpers

  def path_to(page_name)
    case page_name
    
    when /the welcome page/
      "#{@base_url}/"

    when /the home page/
      "#{@base_url}/home"

    when /the profile page/
      "#{@base_url}/people/#{@user.id}"

    when /the login page/
      "#{@base_url}/login"
      
    when /the logout page/
      "#{@base_url}/logout"

    when /the groupm profile page/
      "#{@base_url}/organizations/1"
      
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
