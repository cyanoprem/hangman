secret = "aeiouaeiou"

string = String.new('_' * secret.length)

letter = 'k'

secret.each_char.with_index do |char, index| 
  if char == letter
    string[index] = letter
  end
end

p string.gsub(//, ' ')

# p dash.gsub(//, ' ')

# p secret.count 'a'
# p string

# p string.gsub(/[i]/, '*'