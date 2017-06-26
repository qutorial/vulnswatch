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

Scenario: No profile link
  When I go to homepage
  Then I should not see 'Profile' link

Scenario: No logout link
  When I go to homepage
  Then I should not see 'Log out' link

Scenario: Log in link visible
  When I go to homepage
  Then I should see 'Log In' link

Scenario: Sign up link visible
  When I go to homepage
  Then I should see 'Sign Up' link
