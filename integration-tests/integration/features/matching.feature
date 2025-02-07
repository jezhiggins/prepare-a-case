Feature: Matching defendants to nDelius records
  In order to match defendants to probation records
  As an authenticated user
  I want to be able to confirm existing probation records match with defendants appearing in court

  Scenario: View the list of defendants with possible probation record matches for a given day in court
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    And I should see the heading "Defendants with possible NDelius records"

    And I should see medium heading with text "2 defendants partially match with existing records."
    And I should see the body text "Review and confirm the correct record for each defendant."

    And I should see the following table headings
      | Defendant | NDelius records found | Action |
    And I should see the following table rows
      | Guadalupe Hess     | 3 | Review records |
      | Felicia Villarreal | 2 | Review records |

    And I should see link "Review records" in position 1 with href "match/defendant/3597035492"
    And I should see link "Review records" in position 2 with href "match/defendant/4172564047"

    And There should be no a11y violations

  Scenario: View the list of possible NDelius records
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    And I should see the heading "Defendants with possible NDelius records"

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I should see the heading "Guadalupe Paratroop Flowerlupe Hess"
    And I should see the level 2 heading "Review possible NDelius records"
    And I should see the body text "Compare details and confirm the correct record for the defendant."
    And I should see the inset text "Details that match the defendant are highlighted."

    Then I should see the level 3 heading "Defendant details"
    And I should see the legend "3 NDelius records found"

    And I should see the following table headings
      | Name | Date of birth | Address |
    And I should see the following table rows
      | Guadalupe Paratroop Flowerlupe Hess      |
      | 18 February 1989                         |
      | 43 Hunterfly Place, Birmingham, AD21 5DR |
    And I should see the following table 2 headings
      | Name | Date of birth | Address | CRN | PNC | Probation status | Most recent event |
    And I should see the following table 2 rows
      | Guadalupe Flowerlupe Paratroop Hess                            |
      | 18 February 1989                                               |
      | 43 Hunterfly Place, Birmingham, Birmingham, AD21 5DR           |
      | V178657                                                        |
      |                                                                |
      | Current                                                        |
      | 27 November 2017 - CJA Standard Determinate Custody (6 Months) |
    And I should see the following table 3 rows
      | Guadalupe Paul Hess                                             |
      | 18 February 1989                                                |
      | Dunroamin, Leicestershire, LE2 3NA                              |
      | C178657                                                         |
      |                                                                 |
      | Previously known                                                |
      | 27 November 2017 - CJA Standard Determinate Custody (12 Months) |
    And I should see the following table 4 rows
      | Guadalupe Flowerlupe Hess                                     |
      | 18 February 1998                                              |
      | Dunroamin, Leicestershire, LE2 3NA                            |
      | B123456                                                       |
      |                                                               |
      | Previously known                                              |
      | 13 January 2015 - CJA Standard Determinate Custody (6 Months) |
    And I should see radio buttons with the following IDs
      | defendant-1 | defendant-2 | defendant-3 |

    And There should be no a11y violations

  Scenario: Display an error message if the user does not select a radio button when confirming a match
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    When I click the "Confirm record" button
    Then I should see the error message "Select an NDelius record"

    And There should be no a11y violations

  Scenario: Confirm defendant record match from bulk match list
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I click the element with id "defendant-1"
    And I click the "Confirm record" button

    Then I should be on the "Defendants with possible NDelius records" page
    And I should see the match confirmation banner message "You have successfully confirmed a record for Guadalupe Hess"

    And There should be no a11y violations

  Scenario: Confirm defendant record match from case summary
    Given I am an authenticated user
    When I navigate to the "match/defendant/3597035492" route

    And I click the element with id "defendant-1"
    And I click the "Confirm record" button

    Then I should be on the "Case summary" page
    And I should see the match confirmation banner message "You have successfully confirmed a record for Guadalupe Hess"

    And There should be no a11y violations

  Scenario: Confirm no existing defendant record match from bulk list
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I click the element with id "defendant-1"
    And I click the "Can't see the correct record?" summary link
    And I click the "confirm they have no record" link

    Then I should be on the "Defendants with possible NDelius records" page
    And I should see the match confirmation banner message "You have successfully confirmed Guadalupe Hess has no NDelius record."

    And There should be no a11y violations

  Scenario: Click the back button on matching screen when starting the journey at case summary
    Given I am an authenticated user
    When I navigate to the "match/defendant/3597035492" route

    Then I should be on the "Review possible NDelius records" page
    When I click the "Back" link
    Then I should be on the "Case summary" page

    And There should be no a11y violations

  Scenario: Click the back button on matching screen when starting the journey at match from bulk list
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    When I click the "Back" link
    Then I should be on the "Defendants with possible NDelius records" page

    And There should be no a11y violations

  Scenario: Manually match a defendant and submit without entering a CRN
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I click the element with id "defendant-1"
    And I click the "Can't see the correct record?" summary link
    And I click the "link it to them with a case reference number" link

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see the body text "Use a case reference number (CRN) to link to an existing NDelius record to the defendant."
    And I should see the level 2 heading "Defendant details"
    And I should see the following summary list 1 with keys
      | Name | Date of birth |
    And I should see the level 3 heading "Enter the CRN of the existing record"
    And I should see the text input label "Case reference number (CRN)"
    And I should see the text input with id "crn"
    And I should see the text input hint "For example, A123456"
    When I click the "Find record" button

    Then I should be on the "Link an NDelius record to the defendant" page
    Then I should see the error message "Enter a case reference number"

    And There should be no a11y violations

  Scenario: Manually match a defendant and submit with an invalid CRN
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I click the element with id "defendant-1"
    And I click the "Can't see the correct record?" summary link
    And I click the "link it to them with a case reference number" link

    Then I should be on the "Link an NDelius record to the defendant" page
    When I enter "INVALID" into text input with id "crn"
    And I click the "Find record" button

    Then I should be on the "Link an NDelius record to the defendant" page
    Then I should see the error message "CRN must be in the correct format"

    And There should be no a11y violations

  Scenario: Manually match a defendant and submit with a valid but incorrect CRN
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I click the element with id "defendant-1"
    And I click the "Can't see the correct record?" summary link
    And I click the "link it to them with a case reference number" link

    Then I should be on the "Link an NDelius record to the defendant" page
    When I enter "B654321" into text input with id "crn"
    And I click the "Find record" button

    Then I should be on the "Link an NDelius record to the defendant" page
    Then I should see the error message "No records match the CRN"

    And There should be no a11y violations

  Scenario: Manually match a defendant from the bulk list
    Given I am an authenticated user
    When I navigate to the "match/bulk" route for today
    Then I should be on the "Defendants with possible NDelius records" page

    When I click the "Review records" link
    Then I should be on the "Review possible NDelius records" page

    And I click the element with id "defendant-1"
    And I click the "Can't see the correct record?" summary link
    And I click the "link it to them with a case reference number" link

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see link "Cancel" with href "/B14LO/match/defendant/3597035492"
    When I enter "C178657" into text input with id "crn"
    And I click the "Find record" button

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see the body text "Use a case reference number (CRN) to link to an existing NDelius record to the defendant."
    And I should see the level 2 heading "Defendant details"
    And I should see the following summary list 1 with keys
      | Name | Date of birth |
    And I should see the level 3 heading "NDelius record found"
    And I should see the following summary list 2 with keys
      | Name | Date of birth | CRN | PNC | Probation status |
    When I click the "Link record to defendant" button

    Then I should be on the "Defendants with possible NDelius records" page
    And I should see the match confirmation banner message "You have successfully linked an NDelius record to Guadalupe Hess."

    And There should be no a11y violations

  Scenario: Manually match a defendant from the case list
    Given I am an authenticated user
    When I navigate to the "match/defendant/3597035492" route

    And I click the element with id "defendant-1"
    And I click the "Can't see the correct record?" summary link
    And I click the "link it to them with a case reference number" link

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see link "Cancel" with href "/B14LO/match/defendant/3597035492"
    When I enter "C178657" into text input with id "crn"
    And I click the "Find record" button

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see the body text "Use a case reference number (CRN) to link to an existing NDelius record to the defendant."
    And I should see the level 2 heading "Defendant details"
    And I should see the following summary list 1 with keys
      | Name | Date of birth |
    And I should see the level 3 heading "NDelius record found"
    And I should see the following summary list 2 with keys
      | Name | Date of birth | CRN | PNC | Probation status |
    When I click the "Link record to defendant" button

    Then I should be on the "Case summary" page
    And I should see the match confirmation banner message "You have successfully linked an NDelius record to Guadalupe Hess."

    And There should be no a11y violations

  Scenario: Manually match a defendant and choose to search again
    Given I am an authenticated user
    When I navigate to the "match/defendant/3597035492/confirm/C178657" route

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see the body text "Use a case reference number (CRN) to link to an existing NDelius record to the defendant."
    And I should see the level 2 heading "Defendant details"
    And I should see the following summary list 1 with keys
      | Name | Date of birth |
    And I should see the level 3 heading "NDelius record found"
    When I click the "search again" link

    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see the level 3 heading "Enter the CRN of the existing record"

    And There should be no a11y violations

  Scenario: Confirm no existing defendant record match from case summary
    Given I am an authenticated user
    When I navigate to the "match/defendant/3597035492" route

    And I click the "Can't see the correct record?" summary link
    And I click the "confirm they have no record" link

    Then I should be on the "Case summary" page
    And I should see the match confirmation banner message "You have successfully confirmed Guadalupe Hess has no NDelius record."

    And There should be no a11y violations

  Scenario: Attempt to confirm match but encounter a server error
    Given I am an authenticated user
    When I navigate to the "match/defendant/4172564047" route

    And I click the element with id "defendant-1"
    And I click the "Confirm record" button

    Then I should be on the "Review possible NDelius records" page

    And I should see the match confirmation banner message "Something went wrong - try again."

  Scenario: Link an NDelius record to a not known defendant from case-summary
    Given I am an authenticated user
    When I navigate to the "case/7483843110/summary" route

    And I click the "Link NDelius record" button
    Then I should be on the "Link an NDelius record to the defendant" page
    And I should see link "Cancel" with href "/B14LO/case/7483843110/summary"

    And There should be no a11y violations

  Scenario: Link an NDelius record to a not known defendant from case-summary
    Given I am an authenticated user
    When I navigate to the "case/7483843110/summary" route

    And I click the "Link NDelius record" button
    Then I should be on the "Link an NDelius record to the defendant" page

    And There should be no a11y violations

  Scenario: Unlink NDelius record from the defendant
    Given I am an authenticated user
    When I navigate to the "case/2608860141/summary" route

    Then I should be on the "Case summary" page
    When I click the "Unlink NDelius record" button

    Then I should be on the "Unlink NDelius record from the defendant" page
    When I click the "Unlink record from defendant" button

    Then I should be on the "Case summary" page
    And I should see the match confirmation banner message "You have successfully unlinked an NDelius record from Charlene Hammond."

    And There should be no a11y violations

  Scenario: Visit the unlink NDelius record from the defendant page and click the back button
    Given I am an authenticated user
    When I navigate to the "case/2608860141/summary" route

    Then I should be on the "Case summary" page
    When I click the "Unlink NDelius record" button

    Then I should be on the "Unlink NDelius record from the defendant" page
    When I click the "Back" link

    Then I should be on the "Case summary" page

    And There should be no a11y violations
