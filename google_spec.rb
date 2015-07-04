require 'rubygems'
require 'watir'
require "rspec"
require 'watir-webdriver'

describe 'test google page' do # Test suite or page
  let!(:browser) { Watir::Browser.new :firefox }
  let!(:search_text) { 'Nguyet'}
  before{ browser.goto 'http://google.com'}
  after { browser.close}

  describe 'search something' do
    context 'valid data' do
      it 'should include search text in browser title' do
        # Test step
        browser.text_field(:name => 'q').set search_text
        browser.button.click
        browser.div(:id => 'resultStats').wait_until_present
        # Test expect
        expect(browser.title.include?(search_text)).to eq(true)
      end
    end

    context 'invalid data' do

    end
  end
end






