module CommentsHelper
  def format_comment(content)
    simple_format(keep_spaces_at_beginning(h(content)))
  end
  
  def keep_spaces_at_beginning(content)
    content.split("\n").map do |line|
      line.sub(/^ +/) do |spaces|
        '&nbsp;' * spaces.length
      end
    end.join("\n")
  end
end
