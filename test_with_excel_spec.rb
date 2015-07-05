require 'rubygems'
require 'watir'
require "rspec"
require 'watir-webdriver'
require 'watir-webdriver-performance'
require 'faker'
require 'roo'
require 'uri'
require 'json'
require 'securerandom'
require 'spreadsheet'
require_relative 'utils/excel_utils'

# require 'headless'

# headless = Headless.new
# headless.start

# import lib file
require_relative 'test_case/test003'

# Determine the directory containing chromedriver.exe
chromedriver_directory = File.join(File.absolute_path(File.dirname(__FILE__)), "browsers")

# Add that directory to the path
ENV['PATH'] = "#{ENV['PATH']}#{File::PATH_SEPARATOR}#{chromedriver_directory}"

# Determine the directory containing test case, test data file
test_data_directory = File.join(File.absolute_path(File.dirname(__FILE__)), "data")
screenshot_directory = File.join(File.absolute_path(File.dirname(__FILE__)), "screenshots")
file_path = "#{test_data_directory}/test_case_define.xlsx"
result_file_path = "#{test_data_directory}/test_case_result.xls"
test_data = Array.new

xlsx = Roo::Spreadsheet.open(file_path)

xlsx.default_sheet = 'summary'
summary_header = xlsx.row(1)
summary_rows = Array.new
(2..xlsx.last_row).each do |i|
summary_rows << Hash[[summary_header, xlsx.row(i)].transpose]
end

summary_rows.each do |test_case|
  test_case_id = test_case['test_id']
  browser_type = test_case['browser_type']
  if test_case['test_type'] == 'manual'
    result = Kernel.const_get(test_case['test_id'].capitalize).send(:run_test, browser_type)
    test_data << {'test_id' => test_case_id, 'test_result' => result }
  else
    # open browser
    browser = Watir::Browser.new browser_type
    xlsx.default_sheet = test_case_id
    header = xlsx.row(1)
    # step 0: go to home page
    (2..xlsx.last_row).each do |i|
      row = Hash[[header, xlsx.row(i)].transpose]

      unless row['what'].nil?
        row['data'] = "#{SecureRandom.hex(3)}_#{row['data']}" if (row['how'] == 'user_login' || row['how'] == 'user_mail')
        element_matcher = {row['what'].to_s => row['how'].to_s}
        element_matcher = JSON.parse(element_matcher.to_json, :symbolize_names => true)
      end

      result = nil
      if row['element'].nil?
        result = browser.send(row['action'], row['data'])
      elsif row['data'].nil? && row['what'] != nil
        if row['expect'] != nil
          result = browser.send(row['element'], element_matcher).send(row['action'])
        else
          browser.send(row['element'], element_matcher).send(row['action'])
        end
      else
        if row['expect'] != nil
          result = browser.send(row['element'], element_matcher).send(row['action'], row['data'])
        else
          browser.send(row['element'], element_matcher).send(row['action'], row['data'])
        end
      end

      if row['expect'] != nil
        test_data << {'test_id' => test_case_id, 'test_result' => result.include?(row['expect']) ? 'P' : 'F'}
      end
    end

    # Save screen shot
    browser.screenshot.save ("#{screenshot_directory}/#{test_case_id}.png")

    # close browser
    browser.close
  end
end

ExcelUtils.write_file(test_data, %w(test_id test_result), result_file_path)


puts 'Test DONE'