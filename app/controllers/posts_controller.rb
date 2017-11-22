# frozen_string_literal: true

class PostsController < PublicController
  def all
    @title = I18n.t('home.all.title')
    @posts = Post.order(created_at: :desc).take(5)
  end

  def detail
    @post = Post.friendly.find(params.require(:slug))
    @title = @post.title
    @meta_description = @post.content if @post.content
    @meta_image = @post.image_url if @post.image_url
  end
end
