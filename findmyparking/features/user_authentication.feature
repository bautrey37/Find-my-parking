Feature: User Authentication
  As a user
  I want to be able to authenticate myself to the system

  Scenario: Login to system
    Given I have the login credentials 
    When I click on the log in button on the main page
    And I enter my credentials
    And I click on the submit button
    Then I should see the message "Welcome scoob"