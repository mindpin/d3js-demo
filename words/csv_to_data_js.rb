require 'csv'
require 'json'

words = []
relations = []
CSV.foreach("./words.csv") do |row|
  word_1 = row[1]
  word_2 = row[2]
  if !words.include?(word_1)
    words.push(word_1)
  end
  if !words.include?(word_2)
    words.push(word_2)
  end

  if word_1 != word_2
    relation = {
      :source => word_1,
      :target => word_2
    }
    relations.push(relation)
  end
end

words_json = JSON.generate(words)
relations_json = JSON.generate(relations)

str = %`
  words = #{words_json}

  relations = #{relations_json}
`

File.open("./data.js","wb") do |f|
  f << str
end
