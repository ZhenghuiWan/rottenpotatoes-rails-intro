class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    order = params[:ele] #retrieve movie ID from UPI route
    @movies = order == nil ? Movie.all : Movie.order("#{order} ASC") 
    @title_class = order =="title" ? "hilite" : ""
    @release_date_class = order == "release_date" ? "hilite" : ""
    
    
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    if params[:ratings].nil? 
      @r_filter = @all_ratings 
      else
        @r_filter = params[:ratings].keys
        session[:ratings] = params[:ratings]
    end
    @r_filter = session[:ratings].keys unless session[:ratings].nil?
    
    if params[:ele].nil?
      @sort = session[:ele]
    else
      @sort = params[:ele]
      session[:ele] = params[:ele]
    end
    @movies = Movie.where(:rating => @r_filter).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
