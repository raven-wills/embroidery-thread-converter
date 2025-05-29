require 'yaml'

# Load thread color data from YAML
thread_colors = YAML.load_file(Rails.root.join('db', 'thread_colors.yml'))['colors']

thread_colors.each do |data|
  ThreadColor.find_or_create_by(dmc: data['dmc']) do |thread|
    ThreadColor::BRANDS.each do |brand|
      thread[brand] = data[brand]
    end
  end
end

puts "Seeded #{ThreadColor.count} thread colors"
