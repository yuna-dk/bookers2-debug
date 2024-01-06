class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == 'User'
      @users = User.looks(params[:search], params[:word])
    elsif @range == 'book'
      @books = Book.looks(params[:search], params[:word])
    elsif @range == 'tag'
      @tags = Tag.looks(params[:search], params[:word])
    end
    render 'search_result'
  end

end
