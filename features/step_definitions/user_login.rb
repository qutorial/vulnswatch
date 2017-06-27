When(/^follow register link$/) do
  click_link('Register')
end

Then(/^I see registration form$/) do
  expect(page).to have_field("user_name")
  expect(page).to have_field("user_email")
  expect(page).to have_field("user_password")
  expect(page).to have_field("user_password_confirmation")
end

Given(/^a user '([^\']*)' with email '([^\']*)'  and password '([^\']*)' exists$/) do |name, email, pass|
  User.create(:name => name, :email => email, :password => pass, :password_confirmation => pass)
end

When(/^I go to login page$/) do
  visit(new_user_session_path)
end

When(/^I get a login form$/) do
  expect(page).to have_field("user_email")
  expect(page).to have_field("user_password")
end

Then(/^I can (not )?login with email '([^\']*)' and password '([^\']*)'$/) do |cannot, email, pass|
  step "I go to login page"
  fill_in 'user_email', with: email
  fill_in 'user_password', with: pass
  click_link_or_button 'Log in'
  if cannot.nil?
    expect(page).to have_content('Signed in successfully.')
  else
    expect(page).to have_content('Invalid Email or password.')
  end
end

