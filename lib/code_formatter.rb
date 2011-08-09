class CodeFormatter
  def initialize(text)
    @text = text
  end

  def to_html
    text = @text.clone
    codes = []
    text.gsub!(/^``` ?(.*?)\r?\n(.+?)\r?\n```\r?$/m) do |match|
      code = { :id => "CODE#{codes.size}ENDCODE", :name => ($1.empty? ? nil : $1), :content => $2 }
      codes << code
      "\n\n#{code[:id]}\n\n"
    end
    html = Redcarpet.new(text, :filter_html, :hard_wrap, :autolink, :no_intraemphasis).to_html
    codes.each do |code|
      html.sub!("<p>#{code[:id]}</p>") do
        <<-EOS
          <div class="code_block">
            <div class="code_header">
              #{CGI.escapeHTML(code[:name].to_s)}
              #{clippy(code[:content])}
            </div>
            #{CodeRay.scan(code[:content], language(code[:name])).div(:css => :class)}
          </div>
        EOS
      end
    end
    html
  end

  def language(path)
    case path.to_s.strip
    when /\.yml$/ then "yaml"
    when /\.js$/ then "java_script"
    when /\.scss$/ then "css"
    when /\.erb$/, /\.html$/ then "rhtml"
    when /\.rb$/, /\.rake$/, /\.gemspec/, /file$/, /console$/, "rails" then "ruby"
    when /([a-z0-9]+)$/i then $1
    else "text"
    end
  end

  def clippy(text)
    id = "clippy_#{rand(10000000)}"
    <<-EOS
      <div id="#{id}" class="clippy">
        <span style="display:none" class="clippy_code">#{CGI.escapeHTML(text)}</span>
        <span class="clippy_label"></span>
        <object type="application/x-shockwave-flash" data="/flash/clippy.swf" width="14" height="14" id="#{id}_flash">
        <param name="movie" value="/flash/clippy.swf" />
        <param name="allowScriptAccess" value="always" />
        <param name="quality" value="high" />
        <param name="scale" value="noscale" />
        <param name="FlashVars" value="target=#{CGI.escape('#' + id)}" />
        <param name="bgcolor" value="#E0E0E0" />
        </object>
      </div>
    EOS
  end
end
