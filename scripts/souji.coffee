# Description:
#   そうじの担当を教えてくれます
#
# Dependencies:
#   moment.js
#   lodash-node
#
# Configuration:
#   None
#
# Commands:
#   hubot [1-12|先々|先|今|来|再来]月(の)<掃除>(は？) - 該当月の掃除担当を教えてくれます
#   hubot [1-12|先々|先|今|来|再来]月(の)<そうじ>(は？) - 該当月の掃除担当を教えてくれます
#   hubot <souji> - 当月の掃除担当を教えてくれます
#   hubot <sooji> - 当月の掃除担当を教えてくれます
#   hubot <soji> - 当月の掃除担当を教えてくれます
#
# Author:
#   naokazuterada

moment = require 'moment'
cron = require('cron').CronJob
_ = require('lodash-node')

module.exports = (robot) ->

  people = ['natsuki', 'mio', 'sagawa', 'terada']
  area   = ['台所（コップも）', '窓', '階段', 'トイレ']
  start = moment("2015-06-01","YYYY-MM-DD")

  # target_arrayをcount分ずらしたものを返す
  rotate = (target_array, count=0)->
    array = target_array.slice(0) # copy

    # convert count to value in range [0, len]
    len = array.length
    count = ((count % len) + len) % len

    # rotate
    for i in [0...count]
      array.push(array.shift())
    return array

  # 引数で与えた日のゴミ当番
  touban = (target = moment())->
    passed_months = (target.year() - start.year())*12 + (target.month() - start.month())
    index = passed_months % people.length

    _people = rotate(people, index)

    result = ''
    for person, index in _people
      result += "#{area[index]}: @#{person}\n"
    return result

  # 引数で与えた日に出せるゴミ
  garbage = (target = moment())->
    switch target.format('d')*1
      when 0,3 then return '可燃ごみ'
      when 1 then   return '古紙・布'
      when 4 then   return 'ビン・缶'
      else          return

  robot.respond /((([0-9０１２３４５６７８９]+|先々|先|今|来|再来)月)|).*(掃除|そうじ|souji|sooji|soji)/i, (msg) ->
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
            msg.send "#{msg.match[3]}月のそうじ担当・・・、私にはわかりませんでした。ごめんなさい (;_;)"
            return
    res =  "#{target.month()+1}月のそうじ担当は下記のとおりです。\n\n"
    res += "#{touban(target)}"
    msg.send res

  # 定期実行
  new cron(
    cronTime: '00 00 17 * * 1-5'
    onTick: () =>
      todays_garbage = garbage()
      if todays_garbage
        todays_touban = if todays_garbage is "ビン・缶" then "@mio" else touban()
        mes =  "17時になりました。後ひとふんばり！\n"
        mes += "あっ、ゴミ出し当番の #{todays_touban} さん、今日は「#{todays_garbage}」が出せますよ〜"
        robot.send {room: "#random"}, mes
    start: true
    timeZone: "Asia/Tokyo"
  )