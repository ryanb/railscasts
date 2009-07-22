every 1.day, :at => "2:34 am" do
  rake "thinking_sphinx:index"
end

every 1.day, :at => "1:15 am" do
  rake "asciicasts"
end

every :reboot do
  rake "thinking_sphinx:start"
end
