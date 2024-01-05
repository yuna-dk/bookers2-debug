class PostBooksController < ApplicationController

  def create
    @post_book = PostBook.new(post_book_params)
    @post_book.end_user_id = current_end_user.id
    # 受け取った値を半角スペースで区切って配列にする
    tag_list = params[:post_book][:name].split(' ')
    if @post_book.save
      @post_book.save_book_tags(tag_list)
      redirect_to post_books_path
    else
      render :new
    end
  end

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = BookTag.all
    　#検索されたタグを受け取る
    @tag = BookTag.find(params[:book_tag_id])
    　#検索されたタグに紐づく投稿を表示
    @post_books = @tag.post_books
  end

  def index
    @post_books = PostBook.all
    @tag_list = BookTag.all
  end

  def show
    @post_book = PostBook.find(params[:id])
    @tag_list = @post_book.book_tags.pluck(:name).join(' ')
    @post_book_tags = @post_book.book_tags
  end

end
