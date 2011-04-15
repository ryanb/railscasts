module CommentsHelper
  def format_comment(comment)
    if comment.legacy?
      simple_format(keep_spaces_at_beginning(h(comment.content)))
    else
      CodeFormatter.new(comment.content).to_html.html_safe
    end
  end

  def keep_spaces_at_beginning(content)
    content.split("\n").map do |line|
      line.sub(/^ +/) do |spaces|
        '&nbsp;' * spaces.length
      end
    end.join("\n")
  end

  def fix_url(url)
    if url =~ /^https?\:\/\//
      url
    else
      "http://#{url}"
    end
  end

  def nested_comments(comments)
    comments.map do |comment, sub_comments|
      render(comment) + content_tag(:div, nested_comments(sub_comments), :class => "nested_comments")
    end.join.html_safe
  end
end
