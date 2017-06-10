require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'
require 'csv_shaper'
require 'json'

get '/' do
  year = Time.now.strftime("%Y").to_i
  @years = Array (2012..year)
  erb :index
end

get '/:year/:format?' do

	page = Nokogiri::HTML(open("https://news.ucsc.edu/inthenews/#{params['year']}/index.html"))
	@items = page.css('.archive-list li')
  @year = params['year']

  # If format = CSV
  if params['format'] == 'csv'
    attachment  "#{params['year']}-inthenews.csv"
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

  # If format = JSON
  elsif params['format'] == 'json'
    rows = []
    @items.each do |item|
      rows << {
        'date' => item.css('.date span').text,
        'creator' => item['data-submitter'],
        'source' => item.css('.source').text,
        'title' => item.css('h3 a').text,
        'description' => item.css('.description').text
      }
    end
    JSON.pretty_generate(rows)
  # Else show the HTML list
  else
    erb :list
  end

end
