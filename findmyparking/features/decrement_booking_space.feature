Feature: Total Spaces decrement by one
  In order to park my car
  As a car owner
  I want to book an available parking spot

  Background:
    Given I log in to the system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: Shaggy books a parking spot
    Given I am on the navigation page
    When I click the book button
    Then the total available parking spots decrements by one
