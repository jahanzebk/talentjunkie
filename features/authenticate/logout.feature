@watir
@webrat
@authenticate
@logout
Feature: Logout
  As a user
  I want to logout
  So that I can make sure the session has ended
  
  Scenario: I logout successfully
    Given I authenticate successfully
    When I click the "Logout" link
    Then I should be on the welcome page
