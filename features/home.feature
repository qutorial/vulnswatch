Feature: Hello Sahare
As a product manager
I want users to be greeted when they visit the site
They shall have options to proceed working with it

Scenario: User sees welcome page
  When I go to homepage
  Then I should see the welcome message

Scenario: User sees register link
  When I go to homepage
  Then I should see the register link

Scenario: Visitor sees no profile
  When I go to homepage
  Then I should not see 'Profile' link

Scenario: Visitor sees no profile
  When I go to homepage
  Then I should not see 'Log out' link
