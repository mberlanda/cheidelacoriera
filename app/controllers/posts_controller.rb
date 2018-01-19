# frozen_string_literal: true

class PostsController < PublicController
  FULL_POSTS_COUNT = 5

  def all
    @title = I18n.t('posts.all.title')
    @posts = Post.order(created_at: :desc).take(FULL_POSTS_COUNT)
  end

  def detail
    @post = Post.friendly.find(params.require(:slug))
    @title = @post.title
    @meta_description = @post.content if @post.content
    @meta_image = @post.image_url if @post.image_url
  end

  def archivio
    @title = I18n.t('posts.archivio.title')
    @posts = Post.order(created_at: :desc).offset(FULL_POSTS_COUNT).all
  end
end
