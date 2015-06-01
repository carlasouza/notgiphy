# Not Giphy

Because giphy slack sucks

# Usage

## Create an Imgur app

Follow the instructions at https://api.imgur.com/oauth2/addclient

## Set up an incomming webhook on Slack

Follow the instructions at https://your-team.slack.com/services/new/incoming-webhook

## Deploying on Heroku

    $ wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    $ heroku login
    $ heroku create mynotgiphy
    $ heroku config:set SLACK_URI=https://hooks.slack.com \
      SLACK_ENDPOINT=/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX \
      IMGUR_APP_ID=XXXXXXXXXXXXXXX \
      --app mynotgiphy
    $ git push heroku master

## Set up a slash command on Slack

Follow the instructions at https://your-team.slack.com/services/new/slash-commands

# Copyright

Copyright (C) 2015 Carla Souza <carlasouza.com>.

License GPLv3+: GNU GPL version 3 or later <gnu.org/licenses/gpl.html>. This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.
