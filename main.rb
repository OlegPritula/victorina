# encoding: utf-8
#
# Викторина с хранением вопросов в XML
#
require 'rexml/document'
require_relative 'lib/question.rb'

# win hack
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

system('cls') || system('clear')
puts "\nВикторина Вопрос-Ответ\n"

# Читаем XML с вопросами и ответами
current_path = File.dirname(__FILE__)
file_name = current_path + '/data/questions.xml'
abort "К сожалению, файл с вопросами не найден." unless File.exist?(file_name)

questions = Question.read_questions_from_xml(file_name)

# счетчик правильных ответов
right_answers_counter = 0

questions.each do |question|
  question.show
  question.ask
  if question.time_over?
    puts "Время вышло... Правильный ответ #{question.correctly_answered} "
  else
    if question.is_correct?
      right_answers_counter += 1
      puts 'Верно'
    else
      puts 'Неверно'
    end
  end
end

puts
puts "У Вас #{right_answers_counter} правильных ответов из #{questions.size}"
