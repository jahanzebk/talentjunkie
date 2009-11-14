@authenticate
Feature: Authenticate
  As a user
  I want to authenticate
  So that I can access the service
  
  Scenario: I authenticate successfully
    Given an existing user
    And I go to the login page
    And I fill in "user_session[primary_email]" with "test_user@test.com"
    And I fill in "user_session[password]" with "password"
    When I press "login"
    Then I should be on the home page
    