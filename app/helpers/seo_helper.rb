# frozen_string_literal: true

module SeoHelper
  def seo_url(path)
    path.split('?')[0]
  end
end
