# encoding: utf-8
# Класс Вопрос для игры Викторина
class Question

  # Статический метод. Возвращает массив Question объектов, найденных в 'file_name' файле
  def self.read_questions_from_xml(file_name)
    # Читаем XML с вопросами и ответами
    file = File.new(file_name, 'r:utf-8')
    doc = REXML::Document.new(file)
    file.close

    # массив, куда сложим все созданные объекты Question
    questions = []

    doc.elements.each('questions/question') do |questions_element|
      time = 0
      text = ''
      variants = []
      right_answer = 0

      # для каждого вопроса собираем текст вопроса и варианты ответов
      questions_element.elements.each do |question_element|
        case question_element.name
        when 'question'
          time = question.attributes['second']
        when 'text'
          text = question_element.text
        when 'variants'
          question_element.elements.each_with_index do |variant, index|
            variants << variant.text
            right_answer = index if variant.attributes['right']
          end
        end
      end

      # добавляем свежесозданый вопрос в массив
      questions << Question.new(time, text, variants, right_answer)
    end

    # возвращаем массив вопросов из метода
    questions
  end

  # конструктор нового вопроса
  # параметры: текст, массив вариантов ответа, индекс правильного ответа
  def initialize(time, text, answer_variants, right_answer_index)
    @time = time
    @text = text
    @answer_variants = answer_variants
    @right_answer_index = right_answer_index
  end

  # Выводит текст вопроса
  def show
    @start_time = Time.now
    puts "\nВремя на ответ: #{@time} секунд"
    puts @text
  end

  # Задаем вопрос, используя массив вариантов ответа
  def ask
    @answer_variants.each_with_index do |variant, index|
      puts "#{index + 1}. #{variant}"
    end
    user_index = STDIN.gets.chomp.to_i - 1
    @end_time = Time.now
    @correct = (@right_answer_index == user_index)
    @overtime = (@end_time - @start_time).to_i
  end

  # Возращает true если на вопрос был дан верный ответ
  def is_correct?
    @correct
  end

  # Возращает верный ответ
  def correctly_answered
    @right_answer_index + 1
  end

  # Возращает true если время было просрочено
  def time_over?
    @overtime > @time
  end
end
