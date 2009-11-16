@watir
@signup

Feature: sign up
  As a guest
  I want to be able to sign up
  So that I can use the service

  Scenario Outline: sign up for an account

    Given I am on the welcome page
    When  I fill in the text field "user[first_name]" with "<first_name>"
    And  I fill in the text field "user[last_name]" with "<last_name>"
    And I fill in the text field "user[primary_email]" with "<email>"
    And I fill in the text field "user[password]" with "<password>"
    And I click the "Sign up" button
    Then I should see "<first_name> <last_name>"
    And I click the "LOGOUT" link

    Examples:
      | email                         | first_name  | last_name         | password |
      | j@j.com                       | John        | Coltrane          | password |
      | ron.carter@gmail.com          | Ron         | Carter            | password |
      | jack@gulpd.com                | Jack        | DeJonhette        | password |
      | lou_reed@hotmail.com          | Lou         | Reed              | password |

  Scenario Outline: Sign up for an account with invalid details

    Given I am on the welcome page
    When  I fill in the text field "user[first_name]" with "<first_name>"
    And  I fill in the text field "user[last_name]" with "<last_name>"
    And I fill in the text field "user[primary_email]" with "<email>"
    And I fill in the text field "user[password]" with "<password>"
    And I click the "Sign up" button
    Then I should not see "<first_name> <last_name>"
    And I should see "SIGN UP"

    Examples:
      | email                         | first_name  | last_name       | password |
      | m@d.com                       | Miles       | Davis           |          |
      |                               | George      | Coleman         | password |
