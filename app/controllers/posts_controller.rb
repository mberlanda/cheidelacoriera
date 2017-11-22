# frozen_string_literal: true

class PostsController < PublicController
  def all
    @title = I18n.t('home.all.title')
    @posts = Post.order(created_at: :desc).take(5)
  end
end
