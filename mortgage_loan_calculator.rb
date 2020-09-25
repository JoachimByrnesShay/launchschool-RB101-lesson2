# build a mortgage calculator (or car payment calculator -- it's the same thing).

# You'll need three pieces of information:

#     the loan amount
#     the Annual Percentage Rate (APR)
#     the loan duration

# From the above, you'll need to calculate the following things:

#     monthly interest rate
#     loan duration in months
#     monthly payment

# should the interest rate be expressed as 5 or .05, if you mean 5% interest?
#  If you're working with Annual Percentage Rate (APR), you'll need to convert that to a monthly interest rate.
#  Be careful about the loan duration -- are you working with months or years? Choose variable names carefully to assist in remembering. 
# _________________________________________________________________________________________________________________________________________________


# FIRST DRAFT

MESSAGES = {
  input: {
    loan_amt: 'Enter the loan amount in dollars:',
    apr: 'Enter the APR: (format examples: 18.9 or 13.49% or 10):',
    duration: 'Enter the loan duration in months (not years):'
  },
  invalid: { }
}.freeze

def clear_screen
  system('cls') || system('clear')
end

def positive_integer?(num)
  num.match(/^\d+$/)
end

def positive_float?(num)
  num.match(/^\d*\.\d*$/) && num.match(/\d/)
end

def valid_num?(num)
  positive_integer?(num) || positive_float?(num)
end

def valid_for_type?(value, type)
  case type
  when :loan_amt then value.to_f >= 0.01
  when :apr then value.to_f.between?(1, 50)
  when :duration then value.to_i >= 1 && positive_integer?(value)
  end
end

def valid?(value, type)
  valid_num?(value) && valid_for_type?(value, type)
end

def convert(value, type)
  type == :duration ? value.to_i : value.to_f
end

def monthly_payment(amt: loan_amt, duration: months, rate: apr)
  monthly_rate = rate / 12.0 * 0.01
  amt * (monthly_rate / (1 - (1 + monthly_rate)**-duration))
end

def get_value(type)
  loop do
    puts MESSAGES[:input][type]
    value = gets.chomp.delete('%$').strip
    return convert(value, type) if valid?(value, type)

    # puts MESSAGE[:invalid][type]
    puts 'not valid'
  end
end

# user experience
clear_screen

loan_amt = get_value(:loan_amt)
apr = get_value(:apr)
loan_dur = get_value(:duration)

payment = monthly_payment(amt: loan_amt, rate: apr, duration: loan_dur)

clear_screen
puts 'LOAN CALCULATOR RESULTS:'
puts
puts 'For a loan with the following terms:'
puts "***   Amount: $#{format('%.2f', loan_amt)}"
puts "***   Duration: #{loan_dur} months,"
puts "***   APR: #{apr}"
puts
puts 'Your monthly payment owed will be: '
puts "***   $#{payment.round(2)}."
puts 'Your total amount due will be: '
puts "***   $#{(payment * loan_dur).round(2)}."
