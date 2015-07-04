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
require 'headless'

headless = Headless.new
headless.start

# import lib file
require_relative 'test_case/test002'

# Determine the directory containing chromedriver.exe
chromedriver_directory = File.join(File.absolute_path(File.dirname(__FILE__)), "browsers")

# Add that directory to the path
ENV['PATH'] = "#{ENV['PATH']}#{File::PATH_SEPARATOR}#{chromedriver_directory}"

# Determine the directory containing test case, test data file
test_data_directory = File.join(File.absolute_path(File.dirname(__FILE__)), "data")
file_path = "#{test_data_directory}/test_case_define.xlsx"
result_file_path = "#{test_data_directory}/test_case_result.xls"
test_data = Array.new

xlsx = Roo::Spreadsheet.open(file_path)
browser_type = 'chrome'
browser = Watir::Browser.new
xlsx.default_sheet = 'summary'
summary_header = xlsx.row(1)
summary_rows = Array.new
(2..xlsx.last_row).each do |i|
summary_rows << Hash[[header, xlsx.row(i)].transpose]
end

summary_rows.each do |row|



# module_name = Kernel.const_get("test002".capitalize)
#
# puts module_name.send(:run_test)

# Test step
xlsx.sheets.each do |sheet|
  puts sheet
  next if sheet == 'summary'
  xlsx.default_sheet = sheet
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
        puts result
      else
        browser.send(row['element'], element_matcher).send(row['action'])
      end

    else
      if row['expect'] != nil
        result = browser.send(row['element'], element_matcher).send(row['action'], row['data'])
        puts result
      else
        browser.send(row['element'], element_matcher).send(row['action'], row['data'])
      end
    end

    if row['expect'] != nil
      test_data << {'test_id' => sheet, 'test_result' => result.include?(row['expect']) ? 'P' : 'F'}
    end
  end
end

puts test_data.inspect
# Update test results report
excel_book = Spreadsheet::Workbook.new
sheet_page = excel_book.create_worksheet :name => 'Test Results'
sheet_page.insert_row(0, ['test_id', 'test_result'])
#format the sheet page
row_index = 1

test_data.each do |test|
  sheet_page.insert_row(row_index, [
                                     test['test_id'],
                                     test['test_result']
                                 ])
  row_index += 1
end


excel_book.write result_file_path


# close browser
browser.close

puts 'Test DONE'