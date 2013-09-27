require 'csv'

def time_to_num(time)
  arr = time.split(".")
  Time.local(arr[0].to_i,(arr[1]||1).to_i,(arr[2]||1).to_i)
  # arr[0].to_i*1000000 + arr[1].to_i*1000 + (arr[2]||1).to_i
end

def rand_color
  "#xxxxxx".gsub("x"){|s|((rand * 16).to_i || 0).to_s(16)}
end

data = []
CSV.foreach("./origin.csv") do |row|
  next if !row[0] || !row[0].match('N')

  name = row[1]
  color = row[2] || rand_color()
  parent = row[3] || 'linux'
  time = row[4]
  data << {
    :name => name,
    :color => color,
    :time => time,
    :parent => parent
  }
end

data.sort!{|x,y|
  time_to_num(x[:time]) <=> time_to_num(y[:time])
}

CSV.open("./standard.csv", "wb") do |csv|
  csv << ["linux",'#fff', '1991.8.1','']
  data.each do |r|
    csv << [r[:name],r[:color],r[:time],r[:parent]]
  end
  #csv << ["row", "of", "CSV", "data"]
end