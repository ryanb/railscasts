module AuthMacros
  def login(user = nil)
    user ||= Factory(:user)
    OmniAuth.config.add_mock(:github, "uid" => user.github_uid)
    visit login_path
    @_current_user = user
  end

  def current_user
    @_current_user
  end
end
