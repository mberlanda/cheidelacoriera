# frozen_string_literal: true

class ArrayInput < SimpleForm::Inputs::StringInput
  attr_accessor :output_buffer

  def input(wrapper_options = nil)
    input_html_options[:type] ||= input_type

    existing_values = Array(object.public_send(attribute_name)).map do |elem|
      build_single_elem(elem, remove_button)
    end
    last_elem = build_single_elem(nil, add_button)

    existing_values.push last_elem
    # rubocop:disable Rails/OutputSafety
    existing_values.join.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def input_type
    :text
  end

  private

  def build_single_elem(elem, button)
    content_tag :div, class: 'form-control-inline' do
      build_single_input(elem) +
        button
    end
  end

  def build_single_input(value)
    @builder.text_field(
      nil,
      input_html_options.merge(
        value: value, name: "#{object_name}[#{attribute_name}][]",
        id: nil
      )
    )
  end

  def add_button
    content_tag(:button, '+', type: :button,
                              class: "add_#{attribute_name}_button btn btn-primary")
  end

  def remove_button
    content_tag(:button, type: :button,
                         class: "remove_#{attribute_name}_button btn btn-default") do
      content_tag(:i, nil, class: %w[fa fa-trash-o], 'aria-hidden' => true)
    end
  end
end
