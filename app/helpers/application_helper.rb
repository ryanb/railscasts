require "builder"

module ApplicationHelper
  def textilize(text)
    CodeFormatter.new(text).to_html.html_safe unless text.blank?
  end

  def tab_link(name, url)
    selected = url.all? { |key, value| params[key] == value }
    link_to(name, url, :class => (selected ? "selected tab" : "tab"))
  end

  def avatar_url(comment_or_user, size = 64)
    default_url = "#{root_url}images/guest.png"
    token = gravatar_token(comment_or_user)
    if token.present?
      "http://gravatar.com/avatar/#{gravatar_token(comment_or_user)}.png?s=#{size}&d=#{CGI.escape(default_url)}"
    else
      default_url
    end
  end

  # TODO refactor me into comment/user class
  def gravatar_token(comment_or_user)
    case comment_or_user
    when Comment
      token = gravatar_token(comment_or_user.user)
      if token.present?
        token
      elsif comment_or_user.email.present?
        Digest::MD5.hexdigest(comment_or_user.email.downcase)
      end
    when User
      if comment_or_user.gravatar_token.present?
        comment_or_user.gravatar_token
      elsif comment_or_user.email.present?
        Digest::MD5.hexdigest(comment_or_user.email.downcase)
      end
    else nil
    end
  end

  def video_tag(path, options = {})
    xml = Builder::XmlMarkup.new
    xml.video :width => options[:width], :height => options[:height], :poster => options[:poster], :controls => "controls", :preload => "none" do
      xml.source :src => "#{path}.mp4", :type => "video/mp4"
      xml.source :src => "#{path}.m4v", :type => "video/mp4"
      xml.source :src => "#{path}.webm", :type => "video/webm"
      xml.source :src => "#{path}.ogv", :type => "video/ogg"
    end.html_safe
  end

  def field(f, attribute, options = {})
    return if f.object.new_record? && cannot?(:create, f.object, attribute)
    return if !f.object.new_record? && cannot?(:update, f.object, attribute)
    label_name = options.delete(:label)
    type = options.delete(:type) || :text_field
    content_tag(:div, (f.label(attribute, label_name) + f.send(type, attribute, options)), :class => "field")
  end
end
