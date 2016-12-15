# Description:
#   ルンバがお昼の時間をお知らせします
#
# Dependencies:
#   moment.js
#
# Configuration:
#   None
#
# Author:
#   naokazuterada

moment = require 'moment'
cron = require('cron').CronJob

module.exports = (robot) ->

  notif = (mes)->
    robot.send {room: "#robot"}, mes

  say = ->
    notif('もう13時ですよ！ご飯行きましょう！ご飯！')

  # 定期実行
  new cron(
    cronTime: '00 00 13 * * 1-5'
    onTick: say
    start: true
    timeZone: "Asia/Tokyo"
  )