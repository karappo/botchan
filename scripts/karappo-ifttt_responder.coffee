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
    if(msg.message.text.match(/(\w*) entered the office/))
      msg.send JSON.stringify(msg.message,null,'  ')
      msg.send "どーんといこう！"