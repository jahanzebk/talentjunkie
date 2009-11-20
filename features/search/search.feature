@watir
@search

Feature: search
  As an authenticated user
  I want to be able to search for organizations
  So that I can find what I am looking for

  Scenario: search for an organization

    Given I authenticate successfully
    And I am on the profile page
    When  I fill in "q" with "g"
    Then I should see ""
