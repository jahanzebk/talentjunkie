#@authenticate
Feature: Logout
  As a user
  I want to logout
  So that I can make sure the session has ended
  
  Scenario: I logout successfully
    Given I authenticate successfully
    When I follow "logout"
    Then I should be on the welcome page
