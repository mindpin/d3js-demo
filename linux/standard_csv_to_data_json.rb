require 'csv'
require 'json'

versions = []
relations = []
CSV.foreach("./standard.csv") do |row|
  name = row[0]
  color = row[1]
  time = row[2]
  parent = row[3]

  version = {
    :name => name,
    :time => time,
    :color => color
  }
  versions.push(version)

  if parent != ""
    relation = {
      :source => parent,
      :target => name
    }
    relations.push(relation)
  end
end

versions_json = JSON.generate(versions)
relations_json = JSON.generate(relations)

str = %`
  versions = #{versions_json}

  relations = #{relations_json}
`

File.open("./data.js","wb") do |f|
  f << str
end
