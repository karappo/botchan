# Description:
#   そうじの担当を教えてくれます
#
# Dependencies:
#   moment
#   cron
#
# Configuration:
#   None
#
# Commands:
#   hubot [1-12|先々|先|今|来|再来]月(の)<掃除>(は？) - 該当月の掃除担当を教えてくれます
#   hubot [1-12|先々|先|今|来|再来]月(の)<そうじ>(は？) - 該当月の掃除担当を教えてくれます
#   hubot <souji|sooji|soji> - 当月の掃除担当を教えてくれます
#
# Author:
#   naokazuterada

moment = require 'moment'
cron = require('cron').CronJob

module.exports = (robot) ->

  people = ['mamiko', 'mio', 'natsuki', 'terada']
  areas  = ['台所（キッチン台・食器・床等）', 'ワークスペース（テーブル・棚・ルンバ掃除等）', '階段', 'トイレ']
  start  = moment("2015-06-01","YYYY-MM-DD")

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
      area = areas[index]
      result += "#{area}: @#{person}\n"
    return result

  # TODO そうじというワードで二重投稿してしまうのをなんとかしたい
  robot.hear /(掃除|そうじ|souji|sooji|soji)(おわり|終わり|終り|終了|完了|finish|end|OK|しました|した|やった)/i, (msg) ->
    username = msg.message.user.name
    msg.send "@#{username} さん、お掃除お疲れ様でした！"

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
    res += touban(target)
    msg.send res

  # 定期実行
  new cron(
    cronTime: '00 00 10 1 * *'
    onTick: () =>
      mes =  "おはようございます！\n"
      mes += "#{moment().month()+1}月のそうじ担当は下記のとおりです。\n\n"
      mes += touban()

      robot.send {room: "#robot"}, mes
    start: true
    timeZone: "Asia/Tokyo"
  )