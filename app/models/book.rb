class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)}
  scope :star_count, -> {order(star: :desc)}

  # タグのリレーションのみ記載
  has_many :post_book_tags, dependent: :destroy
  has_many :book_tags, through: :post_book_tags

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  def save_book_tags(tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.book_tags.pluck(:name) unless self.book_tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = tags - current_tags

    # 古いタグを消す
    old_tags.each do |old_name|
      self.book_tags.delete BookTag.find_by(name:old_name)
    end

    # 新しいタグを保存
    new_tags.each do |new_name|
      book_tag = BookTag.find_or_create_by(name:new_name)
      self.book_tags << book_tag
    end
  end

end
