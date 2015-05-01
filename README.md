# rhiarobot

## Deploy

Note to self:

```
sudo docker run -it -v /opt/rhiarobot/rhiarobot:/root/mybot rhiaro/hubotplus
```

```
HUBOT_IRC_SERVER=irc.imaginarynet.org.uk \
HUBOT_IRC_ROOMS="#oreos, #yourface, #compsoc, #rhiaro, #bottest, #linked-data, #prewired, #zen-spa" \
HUBOT_IRC_NICK="rhiarobot" \
HUBOT_IRC_PORT="6667" \
HUBOT_IRC_UNFLOOD="true" \
bin/hubot -a irc --name rhiarobot
```
