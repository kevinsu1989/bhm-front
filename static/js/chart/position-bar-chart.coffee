define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class positionBarChart
    constructor: (@container)->
      @option =
        title:
          x: 'left'
          text: 'ECharts例子个数统计'
          textStyle:
            fontSize: 15
          padding: [10,0,0,25]
        tooltip: 
            trigger: 'item'
        calculable: true
        backgroundColor: '#efefef'
        grid: x: 50, x2:60, y: 40, y2: 40, borderWidth: 0
        xAxis: [
          type: 'category'
          show: false
          splitLine: show: false
          data: ['白屏时间', '首屏时间', 'DomReady', '完全加载']
          axisLabel:
            margin: 0
            show: false
        ]
        yAxis: [
            type: 'value'
            show: false
        ]    
        series: [
          name: ''
          type: 'bar'
          itemStyle: 
            normal: 
              color: (params, index)->
                colorList = ['rgba(255, 0, 0, 1)','rgba(0, 255, 0, 1)']
                colorList[index]
              label: 
                show: true
                position: 'bottom'
                formatter: '{b}\n{c}%'
          data: [12,21,10,4]
        ]
    


      @chart = echarts.init @container
      @chart.setOption @option
    prepareData: (data)->
      arr = []
      sum = 0
      for key of data
        sum += ~~data[key]

      for key of data
        arr.push Math.round(data[key]/sum*10000)/100

      arr

    prepareXAxis: (data, value)->
      arr = []
      k = 0
      for key of data
        arr.push "#{key*value}ms~#{(~~key+1)*value}ms" 
        k = key
     
      arr[arr.length-1] = "#{k*value}ms~∞" 
      arr

    getColorList: (start, end, count)->
      start = start.split(',')
      end = end.split(',')
      start2end = [(start[0]*1-end[0]*1)/count,(start[1]*1-end[1]*1)/count,(start[2]*1-end[2]*1)/count,(start[3]*1-end[3]*1)/count]
      arr = []
      for num in [1..count]
        arr.push "rgba(#{[Math.round(start[0]-start2end[0]*num),Math.round(start[1]-start2end[1]*num),Math.round(start[2]-start2end[2]*num),start[3]-start2end[3]*num].join(',')})"

      arr

    reload: (data, value, title)->
      _colorList = @getColorList '0,255,0,1', '255,0,0,1', 10
      # console.log _colorList
      @option.title.text = title
      @option.series[0].name = title
      @option.series[0].data = @prepareData data
      @option.xAxis[0].data = @prepareXAxis data, value
      @option.series[0].itemStyle.normal.color = (params, index)->
        colorList = _colorList
        colorList[index]
      @chart.setOption @option , true



