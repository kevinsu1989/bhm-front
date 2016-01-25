define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class barChart
    constructor: (@container)->
      @option =
        # backgroundColor: 'rgba(51,51,51,.4)'
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
                colorList = ['#c23531', '#314656', '#61a0a8', '#dd8668', '#91c7ae', '#bda29a', '#44525d', '#c4ccd3']
                colorList[params.dataIndex]
              label: 
                show: true
                position: 'right'
                formatter: '{b}\n{c}%'
          data: [12,1,1,4,30,5]
        ]
    


      @chart = _echarts.init @container
      # @chart.setOption @option

    reload: (data, title)->
      @option.title.text = title
      @option.series[0].data = [ 
        Math.round((data.per_ad_end-data.per_play)*10000)/100,
        Math.round((data.per_ad-data.per_ad_end)*10000)/100, 
        Math.round((data.per_dispatch-data.per_ad)*10000)/100,
        Math.round((data.per_cms-data.per_dispatch)*10000)/100, 
        Math.round((data.per_flash-data.per_cms)*10000)/100, 
        Math.round((1-data.per_flash)*10000)/100
      ]
      @chart.setOption @option , true



