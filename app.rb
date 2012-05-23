require 'sinatra'
require 'sanitize'

get '/' do
  erb :form
end  

post '/clean' do
    # @output = Sanitize.clean(params[:html_code], Sanitize::Config::BASIC)
    @html = Sanitize.clean(params[:html_code],
      :elements => %w[ a abbr b blockquote br cite code dd dfn div dl dt em h1 h2 h3 h4 h5 h6 i kbd li mark ol p q s img samp small strike strong sub sup time u ul var],
      :attributes => {
        'a'          => ['href', 'title'], 
        'blockquote' => ['cite'],
        'img'        => ['alt', 'src']}
      )
      
    erb :clean
end