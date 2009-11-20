Given /^no session exists and I am on the welcome page$/ do
  Given 'I go to /logout'
end

Given /^an existing user$/ do
  @user = User.create!(:first_name => "Test", :last_name => "User", :primary_email => "test_user@test.com", :password => 'password')
end

Given /^I authenticate successfully$/ do
  Given 'an existing user'
  And 'I am on the welcome page'
  And 'I fill in "user_session[primary_email]" with "user_1@test.com"'
  And 'I fill in "user_session[password]" with "password"'
  And 'I click the "Login" button'
end