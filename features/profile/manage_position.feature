@watir
@profile
@position

Feature: create, update and delete position in profile
  As a user
  I want to be able to create, update and delete positions from my profile
  So that I can keep my profile up to date

  Scenario: add new position
  
    Given I authenticate successfully
    When I click the "Add a new position" link
    And I fill in "organization[name]" with "Google"
    And I fill in "position[title]" with "Software Engineer"
    And I fill in "contract[city][name]" with "London"
    And I click the "Save" button
    Then I should see "Google"
    And I should see "Software Engineer"

    Scenario: edit position