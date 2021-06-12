Feature: Summarize Available Parking Spots
  In order to park my car
  As a car owner
  I want to see nearby available parking spaces

  Background:
    Given I log in to the system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: Shaggy finds a parking spot
    Given I navigate to the home page
    When I enter the destination address "Liivi 2, Tartu, Estonia",
    And I enter the start time
    And I enter the end time
    And I enter the type of payment
    And I click on the Find Nearby Parking button
    Then I am navigated Reservation page
    And I should see a summary of available parking spaces around "Liivi 2, Tartu, Estonia"
