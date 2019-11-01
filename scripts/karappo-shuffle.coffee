# Description:
#   Karappoメンバーのリストをシャッフルして表示
#
# Dependencies:
#   lodash
#
# Configuration:
#   None
#
# Commands:
#   hubot <shuffle|sort|junban|シャッフル|しゃっふる|順番> - Karappoメンバーのリストをシャッフルして表示
#
# Author:
#   naokazuterada

_ = require('lodash')

module.exports = (robot) ->

  people = ['mio', 'terada', 'natsuki', 'mamiko', 'kishimoto']

  robot.respond /(shuffle|sort|junban|シャッフル|しゃっふる|順番)/i, (msg) ->
    response = "OK, shuffled...\n\n"
    for person, i in _.shuffle(people)
      response += "#{i+1}: @#{person}\n"
    msg.send response
