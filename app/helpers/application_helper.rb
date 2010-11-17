module ApplicationHelper
  def textilize(text)
    Textilizer.new(text).to_html.html_safe unless text.blank?
  end
end
