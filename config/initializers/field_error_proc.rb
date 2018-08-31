# frozen_string_literal: true

# Fields with errors are directly styled in Crud::FormBuilder.
# Rails should just output the plain html tag.
ActionView::Base.field_error_proc = proc { |html_tag, _instance| html_tag }
