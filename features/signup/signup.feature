@watir
@signup

Feature: sign up
  As a guest
  I want to be able to sign up
  So that I can use the service

  Scenario Outline: sign up for an account
  
    Given no session exists and I am on the welcome page
    When  I fill in "simple_user[first_name]" with "<first_name>"
    And  I fill in "simple_user[last_name]" with "<last_name>"
    And I fill in "simple_user[primary_email]" with "<email>"
    And I fill in "simple_user[password]" with "<password>"
    And I click the "Sign up" button
    Then I should see "<first_name> <last_name>"
    And I should see "Get started"
  
    Examples:
      | email                         | first_name  | last_name         | password |
      | j@j.com                       | John        | Coltrane          | password |
      | ron.carter@gmail.com          | Ron         | Carter            | password |
      | jack@gulpd.com                | Jack        | DeJonhette        | password |
      | lou_reed@hotmail.com          | Lou         | Reed              | password |

  Scenario Outline: Sign up for an account with invalid details

    Given no session exists and I am on the welcome page
    When  I fill in "simple_user[first_name]" with "<first_name>"
    And  I fill in "simple_user[last_name]" with "<last_name>"
    And I fill in "simple_user[primary_email]" with "<email>"
    And I fill in "simple_user[password]" with "<password>"
    And I click the "Sign up" button
    Then I should not see "<first_name> <last_name>"
    And I should see "<error>"

    Examples:
      | email                         | first_name  | last_name       | password | error                                            |
      | m@d.com                       | Miles       | Davis           |          | Password must be at least 4 characters long      |
      |                               | George      | Coleman         | password | Email address is invalid                         |
