define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class playerLineChart
    constructor: (@container)->
      @option =   
        backgroundColor: 'rgba(51,51,51,.4)' 
        title:
          x: 'center'
          text: 'PV-VV分时图'
          textStyle:
            fontSize: 15
          padding: [20]
        legend: x: 'left'
        grid: x: 50, y: 60, x2: 20, y2: 20, borderWidth: 0, borderColor: 'transparent'
        tooltip:
          trigger: "axis"

        toolbox: show: false
        calculable: true
        boundaryGap: true
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
        {name: "播放器加载", type: "line", data: []},
        {name: "CMS", type: "line", data: []},
        {name: "分发", type: "line", data: []},
        {name: "广告播放", type: "line", data: []},
        # {name: "正片加载", type: "line", data: []},
        {name: "广告结束", type: "line", data: []},
        {name: "VV", type: "line", data: []}
      ]

      _.map data, (item)->
        result[0].data.push(Math.round item.per_flash*100)
        result[1].data.push(Math.round item.per_cms*100)
        result[2].data.push(Math.round item.per_dispatch*100)
        result[3].data.push(Math.round item.per_ad*100)
        # result[4].data.push(Math.round item.per_video*100)
        result[4].data.push(Math.round item.per_ad_end*100)
        result[5].data.push(Math.round item.per_play*100)
        
      # @cutTopN result

      result

    getStyles: (data, color)->
      rgba = _utils.hex2rgba color
      color = _utils.formatString 'rgba({0}, {1}, {2}, {3})', rgba.r, rgba.g, rgba.b, 0.6
      name: data.name
      type: data.type
      smooth: true
      symbol: 'none'
      # itemStyle:
      #   normal:
      #     color: color
      data: data.data

    reload: (origin)->
      return if !origin || origin.length is 0
      originTimes = @getAllTimes origin
      data = @prepareSeries origin
      colors = ['#2f91da', '#00ff00', '#ff00ff', '#ff0000', '#0ff0f0', '#0000ff', '#00f0ff']

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
        name: '%'
        max: 100
      ]
      option =
        xAxis: xAxis
        yAxis: yAxis
        legend: data: _.pluck(data, 'name'), x: 'right', padding: [40, 20, 5, 5]
        series: series

      @chart.setOption _.extend(@option, option), true
        
