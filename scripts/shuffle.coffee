# Description:
#   メンバーをシャッフルします。
#
# Dependencies:
#   lodash
#
# Configuration:
#   None
#
# Commands:
#   hubot <shuffle|sort|junban|シャッフル|しゃっふる|順番>
#
# Author:
#   naokazuterada

_ = require('lodash')

module.exports = (robot) ->

  people = ['mio', 'terada', 'sagawa', 'mamiko']

  robot.respond /(shuffle|sort|junban|シャッフル|しゃっふる|順番)/i, (msg) ->
    response = "OK, shuffled...\n\n"
    for person, i in _.shuffle(people)
      response += "#{i+1}: @#{person}\n"
    msg.send response
