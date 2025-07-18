# Remove the default wrapping of invalid input fields in an additional div which breaks bootstraps display of validation errors
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
