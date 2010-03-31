class ThemeGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      theme_name = args[0]
      m.directory File.join("public/themes/#{theme_name}/images")
      m.directory File.join("public/themes/#{theme_name}/stylesheets/sass")
      m.file("custom.sass", "public/themes/#{theme_name}/stylesheets/sass/#{theme_name}.sass")
    end
  end
end