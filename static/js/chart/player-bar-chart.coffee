define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class barChart
    constructor: (@container)->
      @option =
        title:
          x: 'center'
          text: 'ECharts例子个数统计'
          textStyle:
            fontSize: 15
        tooltip: 
            trigger: 'item'
        calculable: true
        grid: x: 50, borderWidth: 0, y: 40, y2: 20   
        yAxis: [
          type: 'category'
          show: false
          splitLine: show: false
          sort: 'ascending'
          data: ['广告结束-VV', '广告开始-广告结束', '分发-广告开始', 'CMS-分发', '播放器加载-CMS', 'PV-播放器加载']
          axisLabel:
            margin: 0
            show: false
        ]
        xAxis: [
            type: 'value'
            show: false
        ]    
        series: [
          # name: '性能数据'
          type: 'bar'
          itemStyle: 
            normal: 
              color: (params, index)->
                colorList = [ '#FE69B3','#6495ED','#32CC32', '#DA70D6', '#87CEFA', '#FF7F50']
                colorList[index]
              label: 
                show: true
                position: 'right'
                formatter: '{b}\n{c}%'
          data: [12,1,1,4,30,5]
        ]
    


      @chart = echarts.init @container
      @chart.setOption @option

    reload: (data, title)->
      @option.title.text = title
      console.log data
      @option.series[0].data = [ 
        Math.round((data.per_ad_end-data.per_play)*10000)/100,
        Math.round((data.per_ad-data.per_ad_end)*10000)/100, 
        Math.round((data.per_dispatch-data.per_ad)*10000)/100,
        Math.round((data.per_cms-data.per_dispatch)*10000)/100, 
        Math.round((data.per_flash-data.per_cms)*10000)/100, 
        Math.round((1-data.per_flash)*10000)/100
      ]
      console.log @option.series[0].data
      @chart.setOption @option , true



