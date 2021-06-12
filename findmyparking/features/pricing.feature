Feature: Estimated Price of Parking Spot

  Background:
    Given I log in to the system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: Shaggy goes through the list of available spots to book
    Given I am on the home page
    When I enter the destination address "Liivi 2, Tartu, Estonia"
    And I enter the start time
    And I enter the end time
    And I enter the type of payment
    And I click on the Find Nearby Parking button
    Then The price to pay is displayed