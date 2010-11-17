# Railscasts

This is the source code for the [Railscasts site](http://railscasts.com/). If you want the source code for the episodes, see the [railscasts-episodes](http://github.com/ryanb/railscasts-episodes) project.

Please [let me know](https://github.com/inbox/new/ryanb) if you plan to use this app for your site.


## Setup

This is designed to run on Ruby 1.9.2 or higher. If you're using [RVM](http://rvm.beginrescueend.com/) it should automatically switch to 1.9.2 when entering the directory.

Run `script/setup`. This will generate the config files, install gems, and migrate the database.

You can then start the server with `rails s` and run the specs with `rake`.

You may want to install [Sphinx](http://sphinxsearch.com/), run the index and start rake commands, and set `thinking_sphinx: true` in `app_config.yml`. This isn't required since it will default to a primitive search.
