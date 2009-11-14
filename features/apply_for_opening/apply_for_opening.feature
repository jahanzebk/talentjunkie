@openings
Feature: Apply for opening
  As a user
  I want to apply for an opening
  So that I can have a shot at getting a job
  
  Scenario: I apply for an existing opening
    Given an existing user
    And I go to the login page
    And I fill in "user_session[primary_email]" with "test_user@test.com"
    And I fill in "user_session[password]" with "password"
    When I press "login"
    Then I should be on the home page
