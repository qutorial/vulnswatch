When /^I go to homepage$/ do
  visit root_path
end

Then /^I should see the (.*)$/ do |e|
  if /welcome message/ =~ e
    expect(page).to have_content("ζάχαρη")
  elsif /register link/ =~ e
    expect(page).to have_selector(:link_or_button, 'Register')    
  end
end

