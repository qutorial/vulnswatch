Feature: User Accounts
As a product manager 
I want users to be able to register and login

Scenario: Users gets registration form
  When I go to homepage
  And follow register link
  Then I see registration form

Scenario: There is a login form
  When I go to login page
  Then I get a login form

Scenario: Users can login
  Given a user 'Adam Smith' with email 'adam@gmail.com'  and password '123monkeyqwe123' exists
  Then I can login with email 'adam@gmail.com' and password '123monkeyqwe123'

Scenario: Wrong password does not work
  Given a user 'Adam Smith' with email 'adam@gmail.com'  and password '123monkeyqwe123' exists
  Then I can not login with email 'adam@gmail.com' and password '123wrong'

Scenario: Wrong email does not work
  Given a user 'Adam Smith' with email 'adam@gmail.com'  and password '123monkeyqwe123' exists
  Then I can not login with email 'wrong@gmail.com' and password '123monkeyqwe123'


