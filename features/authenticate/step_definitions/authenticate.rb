Given /^an existing user$/ do
  @user = User.create!(:first_name => "Test", :last_name => "User", :primary_email => "test_user@test.com", :password => 'password')
end

Given /^I authenticate successfully$/ do
  Given 'an existing user'
  Given 'I am on the welcome page'
  Given 'I fill in "user_session[primary_email]" with "test_user@test.com"'
  Given 'I fill in "user_session[password]" with "password"'
  Given 'I press "login"'
end