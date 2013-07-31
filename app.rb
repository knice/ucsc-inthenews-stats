require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'
require 'csv_shaper'

get '/' do

	page = Nokogiri::HTML(open("http://news.ucsc.edu/inthenews/index.html"))
	@items = page.css('.archive-list li')

	erb :list

end

get '/csv' do

	attachment 'inthenews.csv'
	page = Nokogiri::HTML(open("http://news.ucsc.edu/inthenews/index.html"))
	@items = page.css('.archive-list li')

	csv_string = CsvShaper.encode do |csv|
  		csv.headers 'date', 'source', 'title', 'description', 'local', 'regional', 'national', 'international'
	  	csv.rows @items do |csv, item|
			csv.cell 'date', Time.at(item['data-published'].slice!(0..9).to_i).strftime('%B %d, %Y')
			csv.cell 'source', item.css('.source').text
			csv.cell 'title', item.css('h3 a').text
			csv.cell 'description', item.css('.description').text
			case
			 	when (item['data-rating'] == 'local') then csv.cell 'local', 1
			 	when (item['data-rating'] == 'regional') then csv.cell 'regional', 1
			 	when (item['data-rating'] == 'national') then csv.cell 'national', 1
			 	when (item['data-rating'] == 'international') then csv.cell 'international', 1
			end
		end
	end

end