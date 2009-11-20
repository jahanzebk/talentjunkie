@authenticate
Feature: Authenticate
  As a user
  I want to authenticate
  So that I can access the service
  
  Scenario: I authenticate successfully
    Given an existing user
    And I am on the welcome page
    And I fill in "user_session[primary_email]" with "test_user@test.com"
    And I fill in "user_session[password]" with "password"
    When I click the "Login" button
    Then I should be on the home page
    