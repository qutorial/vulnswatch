When /^I go to homepage$/ do
  visit root_path
end

Then /^I should see the (.*)$/ do |e|
  if /welcome message/ =~ e
    expect(page).to have_content("ζάχαρη")
  elsif /register link/ =~ e
    expect(page).to have_selector(:link_or_button, 'Register')    
  else
    unimplemented
  end
end

Then /^I should (not )?see '(.*)' link$/ do |see, e|
  see = /not/ =~ see ? false : true
  num = page.all('a', :text => e).count
  fail "Link #{e} broke the condition to be seen: #{see}" unless (num > 0) == see
end
