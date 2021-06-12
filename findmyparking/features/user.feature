Feature: User page

  Background:
    Given I log in to the system as "shaggy" and "parool"
    When I enter the user credentials
    And I submit the credentials
    Then I should see a welcome message

  Scenario: Shaggy goes to his user page
    Given I am logged in
    When I type the user page URL in the URL bar
    Then I access my personal user page