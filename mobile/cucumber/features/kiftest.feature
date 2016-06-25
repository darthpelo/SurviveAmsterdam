Feature: Press button
  As an iOS developer
  I want to be able to press a button
  And I want to insert data

  Scenario: Open modal view
    Given The view title labelled First View
    And I press a button labelled Modal
    Then The modal view title was List
