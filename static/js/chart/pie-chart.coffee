define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->
        
  class pieChart
    constructor: (@container)->
      @option =
        legend: x: 'left', orient : 'vertical'

        tooltip:
          trigger: 'item'
          formatter: "{a} <br/>{b} : {c} ({d}%)"

        toolbox: 
          show: true,
          # feature:
          #   mark: 
          #     show: true
          #   dataView:
          #     show: true
          #     readOnly: false
          #   magicType:
          #     show: true, 
          #     type: ['pie', 'funnel'],
          #     option:
          #       funnel:
          #         x: '25%',
          #         width: '50%',
          #         funnelAlign: 'left'
          #   restore: 
          #     show: true
          #   saveAsImage: 
          #     show: true

        calculable: true


      @chart = echarts.init @container
      @chart.setOption @option



    reload: (data, title, cntitle)->
      return if data.length is 0
      title = ''
      opt_title = 
        text: title
        x: 'center'

      option =
        title: opt_title
        legend: data: _.pluck(data, 'name'), x: 'left', orient : 'vertical'
        series: [{name: title, type:'pie',  data: data}]
      console.log _.extend(@option, option)
      @chart.setOption _.extend(@option, option), true
        



