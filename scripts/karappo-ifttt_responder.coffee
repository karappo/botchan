# Description:
#   IFTTTからの投稿からtext情報を取得できるかのテスト
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   naokazuterada

module.exports = (robot) ->

  robot.catchAll (msg) ->
    r = new RegExp "(.*)(どーなつ|ドーナツ)(.*)", "i"
    matches = msg.message.text.match(r)
    if matches == null or matches.length == 0
      return
    msg.send "どーんといこう！"
    msg.send JSON.stringify(msg.message,　null,　'  ')

  # robot.catchAll (msg) ->
  #   if(msg.message.text.match(/(\w*) entered the office/))
  #     msg.send JSON.stringify(msg.message,null,'  ')
  #     msg.send "どーんといこう！"