Feature: Showing Vulnerabilities
  As a vulnerabilty manager
  I want to see vulnerabilities, relevant vulnerabilities,
  sort them and filter them.
  
Background: vulnerabilities added, user created and logged in

  Given following users exist:
  | name		| email			| password		|
  | John Smith		| john@smith.com	| JohnIsAV3rySm0rtG4y	|
  | Alex Black		| alex@black.com	| AlexHasaC0mp13xPass2	|
  
  Given the following projects exist:
  | name		| user			| description			|
  | Workstation		| John Smith		| OpenBSD, perl			|
  | Webserver		| John Smith		| OpenBSD, python, Wordpress	|

  Given the following vulnerabilities exist:
  | name	| summary			| created       | modified   | components	|
  | CVE-2017-1  | OpenBSD vulnerability		| 2017-01-01	| 2017-01-01 |			|
  | CVE-2017-2  | Perl vulnerability		| 2017-01-02	| 2017-01-02 |			|
  | CVE-2017-3  | Microsoft vulnerability	| 2017-01-01	| 2017-01-01 |			|
  | CVE-2017-4  | Known OpenBSD vulnerability	| 2017-01-01	| 2017-01-01 | OpenBSD by John	|
  | CVE-2017-5  | Python CLI bug		| 2017-01-01	| 2017-01-01 | Python by John	|
  | CVE-2017-6  | Wordpress v.1.1 affected	| 2017-01-01	| 2017-01-01 |			|
  | CVE-2017-7  | Python not tagged bug		| 2017-01-01	| 2017-01-01 |			|
  | CVE-2017-8  | OpenBSD tagged by Alex	| 2017-01-01	| 2017-01-01 | OpenBSD by Alex	|
  | CVE-2017-9  | Well known interpreter bug	| 2017-01-01	| 2017-01-01 | Python by Alex	|
  | CVE-2017-10 | Python tagged differently	| 2017-01-01	| 2017-01-01 | libpy by Alex	|
  
  Given 'John Smith' has logged in with 'john@smith.com' and 'JohnIsAV3rySm0rtG4y'

Scenario: All vulnerabilities can be seen
  When I go to vulnerabilities page
  Then I should see vulnerabilities: CVE-2017-1, CVE-2017-2, CVE-2017-2, CVE-2017-3, CVE-2017-4, 
  And I should see vulnerabilities: CVE-2017-5, CVE-2017-6, CVE-2017-7, CVE-2017-8, CVE-2017-9
  And I should see vulnerabilities: CVE-2017-10

Scenario: Relevant vulnerabilities are displayed right
  When I go to relevant vulnerabilities page
  Then I should see vulnerabilities: CVE-2017-1, CVE-2017-2, CVE-2017-4, CVE-2017-5, CVE-2017-6, 
  And I should see vulnerabilities: CVE-2017-7, CVE-2017-8, CVE-2017-9
  And I should not see vulnerabilities: CVE-2017-3, CVE-2017-10

Scenario: Search works, and it searches tags or summary despite tags
  When I go to vulnerabilities page
  And I search for OpenBSD
  Then I should see vulnerabilities: CVE-2017-1, CVE-2017-4, CVE-2017-8
  And I should not see vulnerabilities: CVE-2017-2, CVE-2017-3, CVE-2017-5, CVE-2017-6
  And I should not see vulnerabilities: CVE-2017-7, CVE-2017-9, CVE-2017-10
  When I search for Python
  Then I should see vulnerabilities: CVE-2017-5, CVE-2017-7
  And I should see vulnerability CVE-2017-10
  And I should see vulnerability CVE-2017-9

Scenario: Search works in combination with relevance
  When I go to relevant vulnerabilities page
  And I search for Python
  Then I should see vulnerabilities: CVE-2017-5, CVE-2017-7, CVE-2017-9
  But I should not see vulnerability: CVE-2017-10
  And I should not see vulnerability: CVE-2017-8

Scenario: Filtering works, part one
  When I go to vulnerabilities page
  And I filter name to be CVE-2017-1
  Then I should see vulnerabilities: CVE-2017-1, CVE-2017-10
  And I should not see vulnerability CVE-2017-2
  When I filter component to be libpy
  Then I should see vulnerability CVE-2017-10
  And I should not see vulnerability CVE-2017-1

Scenario: Filtering works, part two
  When I go to vulnerabilities page
  And I filter summary to be OpenBSD
  Then I should see vulnerabilities: CVE-2017-1, CVE-2017-4, CVE-2017-8
  When I filter component to be OpenBSD
  Then I should not see vulnerability CVE-2017-1

Scenario: Sorting on name works on vulnerabilities
  When I go to vulnerabilities page
  And I sort descending on name
  Then vulnerability CVE-2017-2 should stand before CVE-2017-1
  When I sort ascending on name
  Then vulnerability CVE-2017-1 should stand before CVE-2017-2

Scenario: Sorting on name works on vulnerabilities
  When I go to relevant vulnerabilities page
  And I sort descending on name
  Then vulnerability CVE-2017-2 should stand before CVE-2017-1
  When I sort ascending on name
  Then vulnerability CVE-2017-1 should stand before CVE-2017-2
