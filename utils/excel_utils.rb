class ExcelUtils
  def self.write_file(test_data, columns, file_name)
    # Update test results report
    excel_book = Spreadsheet::Workbook.new
    sheet_page = excel_book.create_worksheet :name => 'Test Results'
    sheet_page.insert_row(0, columns)
    row_index = 1

    test_data.each do |test|
      sheet_page.insert_row(row_index, [
                                         test['test_id'],
                                         test['test_result']
                                     ])
      row_index += 1
    end


    excel_book.write file_name
  end


end