require 'json'

def build_events
  events = []
  text = File.open('event').read
  text.each_line do |line|
    line = line.gsub!(/\n?/, "")
    line = line.gsub!(/。/, "")
    line = line.gsub(/\s+/, "")
    line = line.split(/\|/)

    name = line[1]
    time = line[0]
    event = {name: name, time: time}
    events << event
  end

  events
end


def build_poets
  poets = []
  text = File.open('poet').read
  text.each_line do |line|
    line = line.gsub(/\s+/, "")
    line = line.split(/\|/)

    name = line[0]
    time = line[1]

    time = time.split(/-/)


    birth_time = time[0]
    death_time = time[1]

    poet = {name: name, birth_time: birth_time, death_time: death_time}
    poets << poet
  end

  poets
end

def build_emperors
  emperors = []
  text = File.open('emperor').read
  text.each_line do |line|
    line = line.gsub(/\s+/, "")
    line = line.split(/\|/)

    temple_name = line[0]
    name = line[1]
    time = line[2]

    time = time.split(/-/)


    start_time = time[0]
    end_time = time[1]


    emperor = {name: name, temple_name: temple_name, start_time: start_time, end_time: end_time}
    emperors << emperor
  end

  emperors

  
end

def build_data
  data = {emperors: build_emperors, events: build_events, poets: build_poets}
  data = data.to_json

  fJson = File.open('data.json', 'w')
  fJson.write(data)
  fJson.close
end

build_data