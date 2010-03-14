@profile

Feature: edit profile
  In order to keep my profile up to date
  As a user
  I want to be able to create, update and delete positions from my profile

  Scenario: edit profile
  
    Given I authenticate successfully
    When I click the "Edit my profile" link
    And I click the "Save" button
    Then I should see "user 1"