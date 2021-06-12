Feature: Update parking spaces after parking time is completed

  Background:
    Given I log in to the system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: System updates the parking spaces availability
    Given I am on the reservation page
    When I click on the book button
    And the time of the booking ends
    Then after a short period of time, the system updates the availability of that parking spot.