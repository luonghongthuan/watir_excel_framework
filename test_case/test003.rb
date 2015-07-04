class Test003
  def self.run_test(browser_type)
    search_text = 'Test something'
    browser = Watir::Browser.new browser_type
    browser.goto 'http://google.com'
    browser.text_field(:name => 'q').set search_text
    browser.button.click
    browser.div(:id => 'resultStats').wait_until_present
    result = browser.title.include?(search_text) ? 'P' : 'F'
    browser.close
    return result
  end
end