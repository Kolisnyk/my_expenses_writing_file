if (Gem.win_platform?)
  #Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(#Encoding.default_external,
                    Encoding.default_internal)
  end
end

require "rexml/document"
require "date"

puts "Статья расхода средств"
expense_text = STDIN.gets.chomp

puts "Сумма расходов"
expense_amount = STDIN.gets.chomp.to_i

puts "Дата расходов в формате ДД.ММ.ГГГГ, например 01.01.2010 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

expense_date = nil

if date_input == ''
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts "Категория расходов"

expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

file = File.new(file_name, "r:UTF-8")
doc = REXML::Document.new(file)
file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element 'expense', {
                                'date' => expense_date.to_s,
                                'category' => expense_category,
                                'amount' => expense_amount
                                }

expense.text =expense_text

file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close

puts "Ваша запись сохранена"

