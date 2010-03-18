@watir
@webrat
@authenticate
Feature: Authenticate
  As a user
  I want to authenticate
  So that I can access the service
  
  Scenario: I authenticate successfully
    Given no session exists and I am on the login page
    And an existing user
    And I fill in "primary_email" with "user_1@test.com"
    And I fill in "password" with "password"
    When I click the "Login" button
    Then I should be on the profile page
    And I should see "user 1"
    
  Scenario Outline: I fail to authenticate
  
    Given no session exists and I am on the login page
    And I fill in "primary_email" with "<primary_email>"
    And I fill in "password" with "<password>"
    When I click the "Login" button
    Then I should see "The email address or password you provided does not match our records"
    
    Examples:
      | primary_email                 | password        |
      | non_existent_email@test.com   | wrongpassword   |
