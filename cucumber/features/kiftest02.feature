Feature: Press button
  As an iOS developer
  I want to be able to press a button
  And I want to insert data

  Scenario: Insert a text in the Second View
    Given The view title labelled First View
    And I press a button labelled Next
    And I enter Alessio into field 1 of the application
    And I enter Roberto into field 2 of the application
    And I press a button labelled Done
    Then The view title was First View
