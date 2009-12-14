@authenticate
Feature: Authenticate
  As a user
  I want to authenticate
  So that I can access the service
  
  Scenario: I authenticate successfully
    Given no session exists and I am on the welcome page
    And an existing user
    And I go to the welcome page
    And I fill in "primary_email" with "test_user@test.com"
    And I fill in "password" with "password"
    When I click the "Login" button
    Then I should be on the profile page
    