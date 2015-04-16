# Description:
#   ..

module.exports = (robot) ->

  robot.hear /WHERE( IS|'S) (AMY|RHIARO)\??/i, (msg) ->
    msg.http("http://pin13.net/mf2/?url=http%3A%2F%2Frhiaro.co.uk%2Fwhere%2F").get() (err, res, body) ->
        msg.reply JSON.parse(body).items[0].properties.name + " (as of " + JSON.parse(body).items[0].properties.published + ")"

  robot.hear /URL (.*)/i, (msg) ->
    msg.reply "Give me a second.."
    msg.http("http://pin13.net/mf2/?url=http%3A%2F%2Findiewebcamp.com%2Firc-people").get() (err, res, body) ->
        for ele in JSON.parse(body).items[1].children
          n = ''+ele.properties.nickname
          if msg.match[1] is n
            return msg.reply ele.properties.url
        msg.reply "I can't find a URL for " + msg.match[1]

  robot.hear /LATEST FROM (.*)/i, (msg) ->
    msg.reply "Hang on, fetching.."
    msg.http("http://pin13.net/mf2/?url=" + msg.match[1]).get() (err, res, body) ->
      if JSON.parse(body).items.length isnt 0
        nowt = false
        for ele in JSON.parse(body).items
          if "h-entry" in ele.type
            # h-entry
            msg.reply "1"
            msg.reply ele.properties.name + " (" + ele.properties.url + ")"
            break
          else if "h-feed" in ele.type
            # h-feed -> [children] -> h-entry
            for p in ele.children
              if "h-entry" in p.type
                msg.reply "2"
                msg.reply p.properties.name + " (" + p.properties.url + ")"
                break
            break
          else if ele.children?
            for c in ele.children
              # [chilren] -> h-entry
              if "h-entry" in c.type
                msg.reply "3"
                msg.reply c.properties.name + " (" + c.properties.url + ")"
                break
              else if "h-feed" in c.type
                # [children] -> h-feed -> [children] -> h-entry
                for p in c.children
                  if "h-entry" in p.type
                    msg.reply "4"
                    msg.reply p.properties.name + " (" + p.properties.url + ")"
                    break
                break 
            break
          else
            nowt = true
      else
        msg.reply "No microformats found at " + msg.match[1]
      if nowt
        msg.reply "No h-feed or h-entry found"