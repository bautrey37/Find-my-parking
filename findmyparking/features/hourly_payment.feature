Feature: Hourly Payment

  Background:
    Given I log in to the system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: Hourly Payment for users
    Given I am on the home page
    When I click the hourly option
    And I click the check nearby parking location
    And I am on reservation page
    And I click the book button
    Then the payment is done.