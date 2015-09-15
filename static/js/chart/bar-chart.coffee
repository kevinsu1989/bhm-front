define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class barChart
    constructor: (@container)->
      @option =
        legend: x: 'right', padding: [8, 20, 5, 5]
        grid: x: 40, y: 60, x2: 20, y2: 20, borderWidth: 0, borderColor: 'transparent'
        tooltip:
          trigger: "axis"

        toolbox: show: false
        calculable: true
        xAxis: [
          type: "category"
          boundaryGap: false
        ]

      @chart = echarts.init @container
      @chart.setOption @option


    #获取所有的时间点
    getAllTimes: (data)->
      times = {}
      for item in data
        times[_moment(Number(item.timeStart)).format('MM-DD HH:mm')] = 0
      times

    #剪切Top5
    cutTopN: (data)->
      list = (value for key, value of data)
      list.sort (left, right)-> if left.total > right.total then -1 else 1
      list.splice 0, 5

    #准备数据
    prepareSeries: (data, title, cntitle)->
      result = [
        {name: cntitle, type: "bar", data: []}
      ]

      _.map data, (item)->
        result[0].data.push(Math.round item.result[title])

      result

    getStyles: (data, color)->
      rgba = _utils.hex2rgba color
      color = _utils.formatString 'rgba({0}, {1}, {2}, {3})', rgba.r, rgba.g, rgba.b, 0.6
      name: data.name
      type: data.type
      smooth: true
      symbol: 'none'
      itemStyle:
        normal:
          color: color
      data: data.data

    reload: (origin, title, cntitle)->
      return if origin.length is 0
      originTimes = @getAllTimes origin
      data = @prepareSeries origin, title, cntitle
      colors = { "first_paint": '#2f91da', "dom_ready": '#00ff00', "first_view": '#ff00ff', "load_time": '#ff0000'}

      series = [@getStyles data[0], colors[title] || '#2f91da']
      xAxis = [
        type: 'category'
        data: _.keys origin
        splitLine: show: false
        axisLabel:
          formatter: (text)->
            text
      ]

      yAxis = [
        type: 'value'
        splitLine: show: false
        name: 'ms'
      ]
      option =
        xAxis: xAxis
        yAxis: yAxis
        legend: data: _.pluck(data, 'name'), x: 'right', padding: [8, 20, 5, 5]
        series: series
      @chart.setOption _.extend(@option, option), true
        
