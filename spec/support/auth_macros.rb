module AuthMacros
  def login(user)
    OmniAuth.config.add_mock(:github, "uid" => user.github_uid)
    visit login_path
  end
end
