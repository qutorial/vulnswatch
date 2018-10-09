Given(/^the following vulnerabilities exist:$/) do |table|
  table.hashes.each do |vuln|
    vulnerability = Vulnerability.create(vuln.except "components")
    vuln["components"].split(/, ?/).each do |component|
      component, username = component.scan(/(\w*)\s+by\s+(\w*)/)[0]
      theuser = User.where("name LIKE ?", "%#{username}%")[0]
      vulnerability.tags.build(component: component, user: theuser).save!
    end
  end
end

Given(/^following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(name: user[:name], email: user[:email], password: user[:password], password_confirmation: user[:password])
  end
end

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |project|
    user = User.find_by(name: project[:user])
    user.projects.build(name: project[:name], 
        systems_description: project[:description]).save!
  end
end

Given(/^'([^\']*)' has logged in with '([^\']*)' and '([^\']*)'$/) do |user, email, password|
 step "I can login with email '#{email}' and password '#{password}'"
end

When(/^I go to vulnerabilities page$/) do
  visit vulnerabilities_path
end

When(/^I go to relevant vulnerabilities page$/) do
  visit relevant_vulnerabilities_path
end


Then(/^I should (not )?see vulnerability:? (.*)$/) do |notsee, vuln|
  re = /^#{vuln}$/
  if notsee.nil?
    expect(page).to have_link(text: re)
  else
    expect(page).not_to have_link(text: re)
  end
end

Then(/^I should (not )?see vulnerabilities: (.*)$/) do |notsee, vulns|
  vulnerabilities = vulns.split(/, ?/)
  vulnerabilities.each do |vuln|
    step "I should #{notsee}see vulnerability #{vuln}"
  end
end

When(/^go$/) do
  click_link_or_button 'Search' 
end

When(/^I search for (.*)$/) do |search|
  fill_in 'search', with: search
  step "go"
end

When(/^I filter (\w+) to be (.*)$/) do |column, filter|
  fill_in column + '_filter', with: filter
  step "go"
end

When(/^I sort (\w+) on (\w+)$/) do |sorting_way, sorting_column|
  link = find_link(sorting_column.capitalize)
  i = 0
  while i <= 3 and link[:class] != "sorting-link #{sorting_way}" do
    link.click
    link = find_link(sorting_column.capitalize)
  end
  
  expect(link[:class]).to eq "sorting-link #{sorting_way}"
end

When(/^vulnerability ([^\s]+) should stand before ([^\s]+)$/) do |v1, v2|
  expect(page.text).to match(/#{Regexp.escape(v1)}.*#{Regexp.escape(v2)}/m)
  expect(page.text).not_to match(/#{Regexp.escape(v2)}.*#{Regexp.escape(v1)}/m)
end

#When(/^follow register link$/) do
#  click_link('Register')
#end

#Then(/^I see registration form$/) do
#  expect(page).to have_field("user_name")
#  expect(page).to have_field("user_email")
#  expect(page).to have_field("user_password")
#  expect(page).to have_field("user_password_confirmation")
#end

#Given(/^a user '([^\']*)' with email '([^\']*)'  and password '([^\']*)' exists$/) do |name, email, pass|
#  User.create(:name => name, :email => email, :password => pass, :password_confirmation => pass)
#end

#When(/^I go to login page$/) do
#  visit(new_user_session_path)
#end

#When(/^I get a login form$/) do
#  expect(page).to have_field("user_email")
#  expect(page).to have_field("user_password")
#end

#Then(/^I can (not )?login with email '([^\']*)' and password '([^\']*)'$/) do |cannot, email, pass|
#  step "I go to login page"
#  fill_in 'user_email', with: email
#  fill_in 'user_password', with: pass
#  click_link_or_button 'Log in'
#  if cannot.nil?
#    expect(page).to have_content('Signed in successfully.')
#  else
#    expect(page).to have_content('Invalid Email or password.')
#  end
#end

