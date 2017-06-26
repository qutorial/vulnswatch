When(/^I go to homepage$/) do
  visit root_path
end

Then(/^I should see the the welcome message$/) do
  expect(page).to have_content("ζάχαρη")
end

