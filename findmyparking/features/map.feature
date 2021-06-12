Feature: Show Available Parking Spots On A Map
  In order to know where exactly to park my car
  As a car owner
  I want to see nearby available parking spaces overlaid on a map

  Background:
    Given I log in to the STRS system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: Shaggy sees a close by parking spot on the map
    Given I navigate to the home page
    When I enter the destination address "Liivi 2, Tartu, Estonia"
    And I enter the start time
    And I enter the end time
    And I enter the type of payment
    And I click on the Find Nearby Parking button
    Then I should see a map with the available parking spaces

