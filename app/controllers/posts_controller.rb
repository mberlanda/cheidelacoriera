# frozen_string_literal: true

class PostsController < PublicController
  def all
    @posts = Post.order(created_at: :desc).take(5)
  end
end
