@watir
@profile
@diploma

Feature: create, update and delete diploma in profile
  As a user
  I want to be able to create, update and delete diplomas from my profile
  So that I can keep my profile up to date

  Scenario: add and edit new diploma
  
    Given I authenticate successfully
    When I click the "Add a new diploma or certification" link
    And I fill in "organization[name]" with "Oxford University"
    And I fill in "degree[degree]" with "MSc"
    And I fill in "degree[major]" with "Software Engineering"
    And I click the "Save" button
    Then I should see "Oxford University"
    And I should see "MSc in Software Engineering"

