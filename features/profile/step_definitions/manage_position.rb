Given /^I click the first "edit" link for a position$/ do
  @browser.link(:xpath, '//div[@id="experience"]//p[@class="actions"]/a').click
end