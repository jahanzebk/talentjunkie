Given /^an existing user$/ do
  @user = User.create!(:primary_email => "test_user@test.com", :password => 'password')
end

Given /^I authenticate successfully$/ do
  Given 'an existing user'
  Given 'I go to the login page'
  Given 'I fill in "user_session[primary_email]" with "test_user@test.com"'
  Given 'I fill in "user_session[password]" with "password"'
  Given 'I press "login"'
end