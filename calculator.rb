# frozen_string_literal: true

# as for 2 numbers as input from user
# ask for the type of operation to perfrom: add, subtract, multiple, divide
# perform the operation on the two numbers
# output the result
 
require 'yaml'
LANGUAGES = { 1 => :english, 2 => :spanish }.freeze

language = LANGUAGES[2]

class MessageError < StandardError; end
class LanguageError < StandardError; end
raise LanguageError, 'specified language is not available in this application' \
  unless language

MESSAGES = YAML.load_file('calculator_messages.yml')[language]

def message(*ids, msg: MESSAGES)
  return msg if ids.empty?

  key = ids.shift
  message(*ids, msg: msg[key])
end

def clear_screen
  system('cls') or system('clear')
end

def prompt(message)
  Kernel.puts "=> #{message}"
end

def valid_name?(string)
  !string.strip.empty?
end

def float?(number)
  number.strip.match(/^-?\d+\.\d+$/)
end

def integer?(number)
  number.match(/^-?\d+$/)
end

def valid_number?(number)
  integer?(number) || float?(number)
end

def valid_operator?(operator, num2)
  %w[1 2 3 4].include?(operator) \
    && !(operator == '4' && num2.zero?)
end

def convert_from_string(num_string)
  if integer? num_string
    num_string.to_i
  elsif float? num_string
    num_string.to_f
  end
end

def operation_to_message(operator)
  result =
    case operator
    when '1' then message(:calculation, :addition)
    when '2' then message(:calculation, :subtraction)
    when '3' then message(:calculation, :multiplication)
    when '4' then message(:calculation, :division)
    end.capitalize

  result
end

def input_number(ordinal)
  loop do
    prompt message(:enter_number, :request) \
      % { ordinal: message(:enter_number, ordinal) }

    number = gets.chomp
    return convert_from_string number if valid_number? number

    prompt message(:validation, :number)
  end
end

def select_operator(num2)
  loop do
    operator = Kernel.gets.chomp
    return operator if valid_operator?(operator, num2)

    if num2.zero?
      prompt message(:validation, :division_by_zero)
    else
      prompt message(:validation, :operator)
    end
  end
end

OP_MESSAGE = message(:operator_select)

clear_screen
prompt message(:welcome)

name = ''
loop do
  name = Kernel.gets.chomp
  break if valid_name? name

  prompt message(:validation, :name)
end
loops = 0

loop do
  clear_screen
  prompt message(:hi) % { name: name } if loops.zero?

  number1 = input_number(:first)
  number2 = input_number(:second)

  prompt OP_MESSAGE
  operator = select_operator(number2)

  calculating = operation_to_message operator

  prompt message(:calculation, :alert) % { calculating: calculating }
  sleep 1

  result =
    case operator
    when '1' then number1 + number2
    when '2' then number1 - number2
    when '3' then number1 * number2
    when '4' then number1 / Float(number2)
    end

  prompt message(:calculation, :result) % { result: result.round(4) }
  prompt message(:again?)

  answer = Kernel.gets.chomp
  break unless answer.downcase.start_with? 'y'

  loops += 1
end

prompt message(:goodbye) % { name: name }
