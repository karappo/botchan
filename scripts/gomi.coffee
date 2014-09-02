# Description:
#   ゴミ出し当番を教えてくれます
#
# Dependencies:
#   moment.js
#
# Configuration:
#   None
#
# Commands:
#   hubot 今月のゴミは？
#   hubot 来月のゴミ当番は？
#   hubot 11月のごみ

moment = require 'moment'

module.exports = (robot) ->

  people = ["terada", "sagawa", "natsuki"]
  start = moment("2014-07-01","YYYY-MM-DD")
  
  touban = (target)->
    
    passed_months = (target.year() - start.year())*12 + (target.month() - start.month())
    index = passed_months % people.length
    people[index]

  robot.respond /((([0-9０１２３４５６７８９]+|先々|先|今|来|再来)月)|).*(ゴミ|ごみ)/i, (msg) ->
    target = moment()
    if msg.match[3]
      switch msg.match[3]
        when '先々'
          target = moment().subtract(2,'months')
        when '先'
          target = moment().subtract(1,'months')
        when '今'
          target = moment()
        when '来'
          target = moment().add(1,'months')
        when '再来'
          target = moment().add(2,'months')
        else
          num = msg.match[3]
          z = ["０","１","２","３","４","５","６","７","８","９"]
          for i in [0..9]
            num = num.replace(new RegExp(z[i],"g"), i)
          num *= 1
          target = moment().month(num - 1)
          if !target.isValid()
            msg.send "#{msg.match[3]}月のゴミ当番、私にはわかりませんでした。ごめんなさい・・・"
            return

    response = "#{target.month()+1}月のゴミ当番は @#{touban(target)} さんです。\n"
    switch moment().format('d')
      when 2,5 then response += 'おっと、今日は「可燃ごみ」が出せますよ！\n'
      when 3 then   response += 'おっと、今日は「古紙・布」が出せますよ！\n'
      when 4 then   response += 'おっと、今日は「ビン・缶」が出せますよ！\n'
    response += "\n"
    response += "可燃ゴミ：火・金の夜\n"
    response += "古紙・布：水の夜\n"
    response += "ビン・缶：木の夜\n"
    msg.send response
