@signup
Feature: sign up
  As a guest
  I want to be able to sign up
  So that I can use the service

  Scenario Outline: sign up for an account
  
    Given I go to the signup page
    When I fill in "user[primary_email]" with "<email>"
    And I fill in "user[password]" with "<password>"
    And I press "sign up"
    Then I should see "Thank you for signing up"
    Then I should be on the login page
  
    Examples:
      | email                         | first_name  | last_name         | password |
      | j@j.com                       | John        | Coltrane          | password |
      | ron.carter@gmail.com          | Ron         | Carter            | password |
      | jack@gulpd.com                | Jack        | DeJonhette        | password |
      | lou_reed@hotmail.com          | Lou         | Reed              | password |

  Scenario Outline: Sign up for an account with invalid details
    Given I go to the signup page
    And I fill in "user[primary_email]" with "<email>"
    And I fill in "user[password]" with "<password>"
    When I press "sign up"
    Then I should see "prohibited this user from being saved"

    Examples:
      | email                         | first_name  | last_name       | password |
      | m@d.com                       | Miles       | Davis           |          |
      |                               | George      | Coleman         | password |
