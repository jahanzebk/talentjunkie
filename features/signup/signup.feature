@signup
Feature: sign up
  As a guest
  I want to be able to sign up
  So that I can use the service

  Scenario Outline: sign up for an account
  
    Given I go to the welcome page
    When  I fill in "user[first_name]" with "<first_name>"
    And  I fill in "user[last_name]" with "<last_name>"
    And I fill in "user[primary_email]" with "<email>"
    And I fill in "user[password]" with "<password>"
    And I press "sign up"
    Then I should see "ok"
  
    Examples:
      | email                         | first_name  | last_name         | password |
      | j@j.com                       | John        | Coltrane          | password |
      | ron.carter@gmail.com          | Ron         | Carter            | password |
      | jack@gulpd.com                | Jack        | DeJonhette        | password |
      | lou_reed@hotmail.com          | Lou         | Reed              | password |

  Scenario Outline: Sign up for an account with invalid details
    Given I go to the welcome page
    When  I fill in "user[first_name]" with "<first_name>"
    And  I fill in "user[last_name]" with "<last_name>"
    And I fill in "user[primary_email]" with "<email>"
    And I fill in "user[password]" with "<password>"
    And I press "sign up"
    Then I should not see "ok"

    Examples:
      | email                         | first_name  | last_name       | password |
      | m@d.com                       | Miles       | Davis           |          |
      |                               | George      | Coleman         | password |
