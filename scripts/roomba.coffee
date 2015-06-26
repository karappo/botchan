# Description:
#   ルンバが掃除する日の前日にお知らせします
#
# Dependencies:
#   moment.js
#
# Configuration:
#   None
#
# Commands:
#   hubot roomba - 今日が木・金曜日ならメッセージを返します
#
# Author:
#   naokazuterada

moment = require 'moment'
cron = require('cron').CronJob

module.exports = (robot) ->

  robot.respond /roomba/i, (msg) ->
    say()

  notif = (mes)->
    robot.send {room: "#random"}, mes

  say = ->
    today = moment()
    switch today.format('d')*1
      when 4 then notif('今日は木曜日です。\nルンバが掃除しやすいように、椅子は中央の机に寄せ、床の上をチェックしてから帰宅しましょう。')
      when 5 then notif('今日は金曜日です。\nルンバが掃除しやすいように、床の上をチェックしてから帰宅しましょう。')

  # 定期実行
  new cron(
    cronTime: '00 00 17 * * 1-5'
    onTick: say
    start: true
    timeZone: "Asia/Tokyo"
  )