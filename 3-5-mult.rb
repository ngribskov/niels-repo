require 'pry'
class ThreeFive

  def self.sum_multiples(maximum)
    sum = 0
    (maximum-1).downto(2) do |x|
      if x%3 == 0 || x%5 == 0
        sum += x
      end
    end
    puts sum
  end
  def self.even_fib(max)
    sequence = []
    a = 0
    b = 1
    while b < max
      sequence << a+b
      b,a = a+b,b
      end
      sequence.pop
    sum = 0
      sequence.each do |x|
        if x%2 == 0
          sum += x
      end
    end
    puts sum
  end

  def self.largest_prime_factor(number)
  factors = []
  x=2
  while number != 1
    if number % x == 0
      number /= x
    end
      x += 1
  end
  x -= 1
  puts x

end

def self.large_palindrome(maximum)
  a = 1
  b = 1
  largest = 0
  while a <= maximum
    b = 1
    while b <= maximum
    palindrome = a * b
    if palindrome.to_s == palindrome.to_s.reverse && palindrome > largest
      largest = palindrome
      puts "#{a} x #{b}"
      puts largest
    end
    b+=1
  end
    a += 1
  end
end
#resume here
def self.smallest_multiple(max)
  largest = Array(1..max)
  upperlimit = largest.inject(:*)
  sum = 0
  max.upto(upperlimit) do |x|
    largest.each do |y|
      if x % y == 0
        sum += 1
      end
    end
      if sum == max
        puts x
      else
        sum = 0
      end
  end
end
end
def main
  ThreeFive.smallest_multiple(20)
end

main
