# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.tag! :urlset, xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9', \
                  'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', \
                  'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do
  @pages.each do |u|
    xml.url do
      xml.loc seo_url(u)
      xml.priority 0.9
    end
  end
  @items.each do |u|
    xml.url do
      xml.loc seo_url(u)
      xml.priority 0.7
    end
  end
end
