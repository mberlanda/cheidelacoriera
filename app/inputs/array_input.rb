# frozen_string_literal: true

class ArrayInput < SimpleForm::Inputs::StringInput
  attr_accessor :output_buffer

  def input(wrapper_options = nil)
    input_html_options[:type] ||= input_type

    *existing_elements, last_elem = Array(object.public_send(attribute_name))

    existing_values = existing_elements.map do |elem|
      build_single_elem(elem, remove_button)
    end
    existing_values.push build_single_elem(last_elem, add_button)
    # rubocop:disable Rails/OutputSafety
    existing_values.join.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def input_type
    :text
  end

  private

  def build_single_elem(elem, button)
    tag.div(class: 'form-control-inline') do
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
    tag.button('+', type: :button,
                    class: "add_#{attribute_name}_button btn btn-primary")
  end

  def remove_button
    tag.button(type: :button,
               class: "remove_#{attribute_name}_button btn btn-default") do
      tag.i(nil, class: %w[fa fa-trash-o], 'aria-hidden' => true)
    end
  end
end
