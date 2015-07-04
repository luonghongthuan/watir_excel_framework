require 'rubygems'
require 'watir'
require "rspec"
require 'watir-webdriver'
require 'watir-webdriver-performance'
require 'faker'
require 'headless'
require 'securerandom'


describe 'test register page' do # Test suite or page
  # let!(:browser) { Watir::Browser.new :firefox }
  # # let!(:search_text) { 'Nguyet'}
  # before{ browser.goto 'http://www.redmine.org'}
  # after { browser.close}

  describe 'register' do
    context 'valid data' do
      it 'should register success' do
        headless = Headless.new
        headless.start
        # Test step
        # step xxx: khai bao thu vien va bien
        user_list = Array.new
        email_list = Array.new
        browser_type = 'firefox'
        action_type = 'text_field'
        parame1 = {:name => 'user[login]'}

        5.times do |count|
          uniq_id = SecureRandom.hex(2)
          user_name = Faker::Internet.user_name
          email = Faker::Internet.email

          user_list << "#{uniq_id}_#{user_name}"
          email_list << "#{uniq_id}_#{email}"
        end
        browser = Watir::Browser.new(browser_type)
        total_count = 0
        user_list.each_with_index do |user, index|
          email = email_list[index]
          # # step 0: go to home page
          browser.goto 'http://www.redmine.org'
          # step 1: click on link register
          browser.link(:class => 'register').click
          # step 2: fill login name
          browser.send(action_type, parame1).set user
          # step : fill password
          browser.text_field(:name => 'user[password]').set '123456'
          # step 2: fill confirm password
          browser.text_field(:name => 'user[password_confirmation]').set '123456'
          # step 3: first name
          browser.text_field(:name => 'user[firstname]').set Faker::Name.first_name
          # step 4: last name
          browser.text_field(:name => 'user[lastname]').set Faker::Name.last_name
          # step 5 fill email
          browser.text_field(:name => 'user[mail]').set email
          # step 6: email
          browser.select_list(:id => 'user_language').select 'English'

          # Step 4: Click Submit button
          browser.button(:name =>'commit').click

          # Step 5: Wait to result context appear
          browser.div(:id => 'flash_notice').wait_until_present

          # Step n: Test expect
          actual_result = browser.div(:id => 'flash_notice').text
          expect(actual_result.include?(email)).to eq(true)

          total_time_per_request = browser.performance.summary[:response_time]/1000
          puts total_time_per_request
          total_count += total_time_per_request
        end


        puts "Total execute time: #{total_count} seconds"
        # close browser
        # browser.close
      end
    end

  end
end






