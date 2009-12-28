@watir
@organization

Feature: view organization profile
  As a user
  I want to be able view organizations
  So that I can keep track of organizations

  Scenario: view an organization's profile
  
    Given I authenticate successfully
    When I go to the groupm profile page
    Then I should see "GroupM"

