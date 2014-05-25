require 'sinatra'
require 'rubygems'
require 'csv'
require 'pry'


#METHODS--------------------------------------------------------------
def load_movies(file_name)
  movies = []
  CSV.foreach(file_name, headers: true, header_converters: :symbol) do |movie|
    movies << movie.to_hash
  end
  movies.sort_by{|movie| movie[:title].downcase}
end


#input any key/attribute and return the hash that matches the target
#for ex: if this hash has a key :title that matches the target, return that entire hash
def get_movie_hash(movies_hashes, attribute, target)
  movies_hashes.each do |movie_hash|
    if movie_hash[attribute] == target
      return movie_hash
    end
  end
end

def get_movies(movies_per_page, page_num, array_of_movies)
  page_num = page_num.to_i
  range_start = (page_num - 1) * movies_per_page
  if page_num <= 1
    return array_of_movies[0..movies_per_page - 1]
  else
    return array_of_movies[range_start..range_start + (movies_per_page - 1)]
  end
end



#ROUTES AND VIEWS------------------------------------------------------
get '/movies' do
  @title = "All Movies Page"
  @all_movies = load_movies("movies.csv")
  @query = params["query"]

  if params[:page].to_i <= 1
    @page_number = 1
  else
    @page_number = params[:page].to_i
  end

  if params[:display] == nil
    @num_movies = 10
  else
    @num_movies = params[:display].to_i
  end


  @movies = get_movies(@num_movies, @page_number, @all_movies)

  #binding.pry

  erb :index
end


get "/" do
  redirect "/movies"
end


get '/movies/:movie_id' do

  @movie_id = params[:movie_id]
  @all_movies = load_movies("movies.csv")
  @movie_info = get_movie_hash(@all_movies, :id, @movie_id)

  @title = "#{@movie_info[:title]}"

  erb :show
end
