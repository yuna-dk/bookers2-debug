class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      redirect_to search_path
    else
      @books = Book.looks(params[:search], params[:word])
      render 'search_result'
    end
  end
  
end
