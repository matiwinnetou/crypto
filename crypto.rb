require 'open-uri'
require 'json'

api = open('http://api.coinmarketcap.com/v1/ticker?limit=20')

response_status = api.status

result = JSON.parse(api.read)
lines = []
sorted_lines = []
result.each do |child|
    symbol = child['symbol']
    name = child['name']
    total_supply = child['total_supply'].to_f
    price_usd = child['price_usd'].to_f
    rank = child['rank'].to_i
    ratio = (total_supply.to_i * price_usd).to_s
    line = {'name': name,
            'symbol': symbol,
            'rank': rank,
            'total_supply': total_supply.to_i,
            'price_usd': price_usd,
            'ratio': ratio.to_f
            }
    lines.push(line)
end

sorted_lines = lines.sort_by {|l| [l[:ratio], l[:rank]] }

sorted_lines.each do |l|
  syl = l[:symbol]
  rat = l[:ratio].to_i
  rank = l[:rank].to_i
  rat = rat.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  name = l[:name]
  price = l[:price_usd]
  total_supply = l[:total_supply]
  total_supply = total_supply.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

  puts "#{name} (#{syl} [#{rank}]) - ratio: #{rat} = #{total_supply} * #{price}"
end
