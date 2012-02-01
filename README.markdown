# RailsCasts

This is the source code for the [RailsCasts site](http://railscasts.com/). If you want the source code for the episodes, see the [railscasts-episodes](http://github.com/ryanb/railscasts-episodes) project.

Please [let me know](http://railscasts.com/feedback) if you plan to use this app for your site.

**IMPORTANT:** This source code is out of date with the latest changes at railscasts.com to ensure the security of the payment processing. I hope to open-source the latest additions at some point.


## Setup

This is designed to run on Ruby 1.9.2 or higher. If you're using [RVM](http://rvm.beginrescueend.com/) it should automatically switch to 1.9.2 when entering the directory.

Run `script/setup`. This will generate the config files, install gems, and migrate the database.

You can then start the server with `rails s` and run the specs with `rake`.

You may want to install [Sphinx](http://sphinxsearch.com/), run the index and start rake commands, and set `thinking_sphinx: true` in `app_config.yml`. This isn't required since it will default to a primitive search.
