require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'
require 'csv_shaper'
require 'json'

get '/' do

	page = Nokogiri::HTML(open("http://news.ucsc.edu/inthenews/2015/index.html"))
	@items = page.css('.archive-list li')
	erb :list

end

get '/csv' do

	t = Time.now.strftime("%d%B%Y")
	attachment  t + '-inthenews.csv'
	page = Nokogiri::HTML(open("http://news.ucsc.edu/inthenews/2014/index.html"))
	@items = page.css('.archive-list li')

	csv_string = CsvShaper.encode do |csv|
  	csv.headers 'date', 'creator', 'source', 'title', 'description', 'url'
	  csv.rows @items do |csv, item|
			csv.cell 'date', item.css('.date span').text
			csv.cell 'creator', item['data-submitter']
			csv.cell 'source', item.css('.source').text
			csv.cell 'title', item.css('h3 a').text
			csv.cell 'description', item.css('.description').text
			csv.cell 'url', item.css('h3 a')[0]['href']
		end
	end

end


get '/json' do

	page = Nokogiri::HTML(open("http://news.ucsc.edu/inthenews/index.html"))
	@items = page.css('.archive-list li')

	rows = []

	@items.each do |item|
		rows << {
			'date' => Time.at(item['data-published'].slice!(0..9).to_i).strftime('%B %d, %Y'),
			'creator' => item['data-submitter'],
			'source' => item.css('.source').text,
			'title' => item.css('h3 a').text,
			'description' => item.css('.description').text
		}
		# case
	 # 		when (item['data-rating'] == 'local') then 'reach' => 'local', 1
	 # 		when (item['data-rating'] == 'regional') then 'reach' => 'regional', 1
	 # 		when (item['data-rating'] == 'national') then 'reach' => 'national', 1
	 # 		when (item['data-rating'] == 'international') then 'reach' => 'international', 1
		# end
	end

	JSON.pretty_generate(rows)

end