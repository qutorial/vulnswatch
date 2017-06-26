Feature: User Accounts
As a product manager 
I want users to be able to register and login

Scenario: Users gets registration form
  When I go to homepage
  And follow register link
  Then I see registration form

Scenario: Users can login
  Given a user 'Adam Smith' with email 'adam@gmail.com'  and password '123monkeyqwe123' exists
  When I go to login page
  And I get a login form
  Then I can login with email 'adam@gmail.com' and password '123monkeyqwe123'


