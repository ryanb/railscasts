if APP_CONFIG['hoptoad_key']
  HoptoadNotifier.configure do |config|
    config.api_key = APP_CONFIG['hoptoad_key']
  end
end
