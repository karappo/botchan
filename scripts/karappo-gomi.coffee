# Description:
#   ゴミ出し当番を教えてくれます
#
# Dependencies:
#   moment
#   cron
#
# Configuration:
#   None
#
# Commands:
#   hubot [1-12|先々|先|今|来|再来]月(の)<ゴミ|ごみ>(は？) - 該当月のゴミ当番を教えてくれます
#   hubot <ゴミ|ごみ|gomi|trash|garbage> - 当月のごみ当番を教えてくれます
#
# Author:
#   naokazuterada

moment = require 'moment'
cron = require('cron').CronJob

module.exports = (robot) ->

  people = ["terada"]
  start = moment("2014-07-01","YYYY-MM-DD")

  # 引数で与えた日のゴミ当番
  touban = (target = moment())->
    passed_months = (target.year() - start.year())*12 + (target.month() - start.month())
    index = passed_months % people.length
    return "@#{people[index]}"

  # 引数で与えた日に出せるゴミ
  garbage = (target = moment())->
    switch target.format('d')*1
      when 0,3 then return '可燃ごみ'
      when 1 then   return '古紙・布'
      when 4 then   return 'ビン・缶'
      else          return

  robot.respond /((([0-9０１２３４５６７８９]+|先々|先|今|来|再来)月)|).*(ゴミ|ごみ|gomi|trash|garbage)/i, (msg) ->
    target = moment()
    if msg.match[3]
      switch msg.match[3]
        when '先々' then target = moment().subtract(2,'months')
        when '先'   then target = moment().subtract(1,'months')
        when '今'   then target = moment()
        when '来'   then target = moment().add(1,'months')
        when '再来' then target = moment().add(2,'months')
        else
          num = msg.match[3]
          z = ["０","１","２","３","４","５","６","７","８","９"]
          for i in [0..9]
            num = num.replace(new RegExp(z[i],"g"), i)
          num *= 1
          target = moment().month(num - 1)
          if !target.isValid()
            msg.send "#{msg.match[3]}月のゴミ当番・・・、私にはわかりませんでした。ごめんなさい (;_;)"
            return

    res =
      """
      弁天１〜４丁目のゴミスケジュールです。

      可燃ゴミ：月・木
      古紙・布：火
      ビン・缶：金
      不燃・有害ゴミ：第2・4水曜日の夜
      """

    todays_garbage = garbage()
    if todays_garbage
      res +=
        """

        おっと、今日は「#{todays_garbage}」が出せますよ！
        """

    msg.send res

  # 定期実行
  new cron(
    cronTime: '00 00 17 * * 1-5'
    onTick: () =>
      todays_garbage = garbage()
      if todays_garbage
        todays_touban = if todays_garbage is "ビン・缶" then "@mio" else touban()
        mes =
          """
          17時になりました。後ひとふんばり！
          あっ、ゴミ出し当番さん、今日は「#{todays_garbage}」が出せますよ〜
          """
        robot.send {room: "#robot"}, mes
    start: true
    timeZone: "Asia/Tokyo"
  )