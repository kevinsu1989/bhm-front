define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->
  # console.log echarts
  class mainChart
    constructor: (@container)->
      @option =
        # backgroundColor: 'rgba(51,51,51,.4)'
        legend: x: 'right', padding: [8, 20, 5, 5]
        grid: x: 50, y: 60, x2: 50, y2: 20, borderWidth: 0, borderColor: 'transparent'
        tooltip:
          trigger: "axis"
          # formatter:(params, ticket, callback)->
          #   text = "#{params[0].seriesName}：#{params[0].value}ms <br/>"
          #   text += "#{params[1].seriesName}：#{params[0].value+params[1].value}ms <br/>"
          #   text += "#{params[2].seriesName}：#{params[0].value+params[1].value+params[2].value}ms <br/>"
          #   text += "#{params[3].seriesName}：#{params[0].value+params[1].value+params[2].value+params[3].value}ms <br/>"
        toolbox: show: false
        calculable: true
        boundaryGap: true
        xAxis: [
          type: "category"
          boundaryGap: false
        ]

      @chart = _echarts.init @container
      # @chart.setOption @option


    #获取所有的时间点
    getAllTimes: (data)->
      times = {}
      for item in data
        times[_moment(Number(item.time_start)).format('MM-DD HH:mm')] = 0
      times

    #剪切Top5
    cutTopN: (data)->
      list = (value for key, value of data)
      list.sort (left, right)-> if left.total > right.total then -1 else 1
      list.splice 0, 5

    #准备数据
    prepareSeries: (data)->
      result = [
        {name: "白屏时间", type: "line", data: [], value:[]},
        {name: "页面解析", type: "line", data: [], value:[]},
        {name: "首屏时间", type: "line", data: [], value:[]},
        {name: "完全加载", type: "line", data: [], value:[]}
      ]

      _.map data, (item)->
        result[0].value.push(Math.round item.result.first_paint)
        result[0].data.push(Math.round item.result.first_paint)
        result[1].value.push(Math.round item.result.dom_ready)
        result[1].data.push(Math.round (item.result.dom_ready - item.result.first_paint))
        result[2].value.push(Math.round item.result.first_view)
        result[2].data.push(Math.round (item.result.first_view - item.result.dom_ready))
        result[3].value.push(Math.round item.result.load_time)
        result[3].data.push(Math.round (item.result.load_time - item.result.first_view))
        
      # @cutTopN result

      result

    getStyles: (item, color)->
      rgba = _utils.hex2rgba color
      color = _utils.formatString 'rgba({0}, {1}, {2}, {3})', rgba.r, rgba.g, rgba.b, 0.8
      name: item.name
      type: item.type
      smooth: true
      symbol: 'none'
      # stack: 'sum'
      itemStyle:
        normal:
          color: color
          areaStyle: 
            type: 'default'
      data: item.value

    reload: (origin)->
      return if !origin || origin.length is 0
      originTimes = @getAllTimes origin
      data = @prepareSeries origin
      colors = ['#c23531', '#314656', '#61a0a8', '#dd8668', '#91c7ae', '#bda29a', '#44525d', '#c4ccd3']

      series = (@getStyles(item, colors[index]) for item, index in data)
      xAxis = [
        type: 'category'
        data: _.keys originTimes
        splitLine: show: true
        boundaryGap: false
        axisLabel:
          formatter: (text)->
            text
      ]

      yAxis = [
        type: 'value'
        splitLine: show: true
        name: 'ms'
      ]
      option =
        xAxis: xAxis
        yAxis: yAxis
        legend: data: _.pluck(data, 'name'), x: 'right', padding: [40, 20, 5, 5]
        series: series

      @chart.setOption _.extend(@option, option), true
        
