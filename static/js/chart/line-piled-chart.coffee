define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->
        
  class pieChart
    constructor: (@container)->
      @option =
        # backgroundColor: 'rgba(51,51,51,.4)'
        tooltip: 
          trigger: 'axis'
        grid: x: 50, y: 30, x2: 50, y2: 30, borderWidth: 0, borderColor: 'transparent'
        legend:
          data:['IE','chrome']
          x: 'right'
          padding: [8, 20, 5, 5]
        calculable : true
        yAxis: [{
          type : 'value'
          max: 100
          name: '%'
        }]

      @chart = _echarts.init @container
      # @chart.setOption @option

    #获取所有的时间点
    getAllTimes: (data)->
      times = {}
      for item in data
        times[_moment(Number(item.time_start)).format('MM-DD HH:mm')] = 0
      times


    prepareSeries: (data)->
      result = [
        {name: "IE", type: "line", stack: '总量', itemStyle: {normal: {areaStyle: {type: 'default'}}},data: []},
        {name: "chrome", type: "line", stack: '总量', itemStyle: {normal: {areaStyle: {type: 'default'}}},data: []}
      ]

      _.map data, (item)->
        result[0].data.push(Math.round 100*item.result.iepv/item.result.pv)
        result[1].data.push(Math.round 100*item.result.chromepv/item.result.pv)

      result



    reload: (data, title)->
      data = data.records
      return if data.length is 0

      times = @getAllTimes data
      option =
        series: @prepareSeries data
        xAxis: [
          type: 'category'
          data: _.keys times
          boundaryGap: false
        ]
      @chart.setOption _.extend(@option, option), true
        
