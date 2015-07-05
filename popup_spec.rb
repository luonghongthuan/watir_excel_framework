require 'rubygems'
require 'watir'
require "rspec"
require 'watir-webdriver'

describe 'test google page' do # Test suite or page
  let!(:browser) { Watir::Browser.new :firefox }
  let!(:search_text) { 'Nguyet'}
  before{ browser.goto 'https://staging-juscollege.juscollege.com'}
  after { browser.close}

  describe 'Test popup with watir' do
      it 'should include search text in browser title' do
        # Test step
        sleep 5
        browser.link(:id => 'email-login-button').click
        browser.div(:class => 'sign-in-push').wait_until_present
        browser.text_field(:id => 'session_email').set 'jcuser01@mailinator.com'
        browser.text_field(:id => 'session_password').set '123456'
        browser.button(:name => 'commit').click

        browser.div(:class => 'event-list-padding').wait_until_present
        browser.link(:text => 'New Variant Type').click
        # modal = browser.modal_dialog
        browser.window(:index => 1).use # switch to new modal window
        browser.text_field(:id => 'variant_type_name').set 'Test new'
        browser.button(:name => 'commit').click
        browser.link(:text => 'Variant Types').click
        expect(browser.text.include?('Test new')).to eq(true)
    end
  end
end






