class PostBookTag < ApplicationRecord
  belongs_to :post_book
  belongs_to :book_tag
end
