Given /^no session exists and I am on the welcome page$/ do
  Given 'I go to the logout page'
end

Given /^no session exists and I am on the login page$/ do
  Given 'I go to the logout page'
  Given 'I go to the login page'
end

Given /^an existing user$/ do
  @user = User.first
  # @user = User.create!(:first_name => "Test", :last_name => "User", :primary_email => "test_user@test.com", :password_hash => 'fd6197e449a74f3fa8ed83fd478c144a8c63f3b46a66cdd46fe84589de66ebc9', :password_salt => 'pEhebh2rUK3h5bw0NlCv')
end

Given /^I authenticate successfully$/ do
  Given 'no session exists and I am on the welcome page'
  And 'an existing user'
  And 'I go to the welcome page'
  And 'I fill in "primary_email" with "user_1@test.com"'
  And 'I fill in "password" with "password"'
  And 'I click the "Login" button'
end