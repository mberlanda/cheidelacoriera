# frozen_string_literal: true

class ApplicationScrubber < Rails::Html::PermitScrubber
  def initialize
    super
    self.tags = %w[a blockquote b br div em font i li ol p pre u ul]
    self.attributes = %w[align color face href size style target title]
  end

  def skip_node?(node)
    node.text?
  end
end
