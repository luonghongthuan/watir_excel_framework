require 'rubygems'
require 'watir'
require "rspec"
require 'watir-webdriver'

describe 'test register page' do # Test suite or page
  # let!(:browser) { Watir::Browser.new :firefox }
  # # let!(:search_text) { 'Nguyet'}
  # before{ browser.goto 'http://www.redmine.org'}
  # after { browser.close}

  describe 'register' do
    context 'valid data' do
      it 'should register success' do
        # Test step
        # step xxx: khai bao thu vien va bien
        browser = Watir::Browser.new :firefox
        browser.goto 'https://www.heroku.com/'
        # Step n: Test expect
        browser.div(:class => 'page').wait_until_present
        browser.driver.manage.window.resize_to(375,667)
        browser.refresh
        expect(browser.span(:class => 'mobile-nav', :display => 'block').exist?).to eq(true)
        browser.driver.manage.window.resize_to(1360,768)
        browser.refresh
        expect(browser.span(:class => 'mobile-nav', :display => 'none').exist?).to eq(true)
        # close browser
        browser.close
      end
    end

  end
end






