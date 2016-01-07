define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class positionStackBarChart
    constructor: (@container)->
      @option =       
        title:
          x: 'left'
          text: ''
          textStyle:
            fontSize: 15
          padding: [10,0,0,30]
        backgroundColor: '#ddd'
        grid: x: 50, x2:60, y: 40, y2: 40, borderWidth: 0
        tooltip : 
          axisPointer: {
            type: 'shadow'
          }
        
        legend: 
          data:['网络','网页加载','资源加载']
          y:'bottom'

        
        xAxis: [
          {
            type : 'value'
          }
        ]
        yAxis: [
          {
            type : 'category',
            data : [''],
            width: '40%'
          }
        ]
        series: [
          {
            name:'网络',
            type:'bar',
            stack: '总量',
            width: '40%',
            itemStyle : { normal: {color: 'rgba(50,173,250,1)'}},
            data:[{value:20,tooltip: {formatter: "{a}{b} : {c}%"}}]
          },{
            name:'网页加载',
            type:'bar',
            stack: '总量',
            width: '40%',
            itemStyle : { normal: {color: 'rgba(234,200,94,1)'}},
            data:[{value:20,tooltip: {formatter: "{a}{b} : {c}%"}}]
          },{
            name:'资源加载',
            type:'bar',
            stack: '总量',
            width: '40%',
            itemStyle : { normal: {color: 'rgba(86,188,118,1)'}},
            data:[{value:20,tooltip: {formatter: "{a}{b} : {c}%"}}]
          }
        ]
      @chart = echarts.init @container
      @chart.setOption @option

    reload: (data, title)->
      @option.title.text = title
      @option.series[0].data[0] = {
        value : Math.round(data.first_paint / data.load_time * 10000) / 100,
        tooltip : {formatter: "{a}{b} <br/>占比：{c}%<br/>耗时：#{Math.round(data.first_paint)}ms"}
      }
      @option.series[1].data[0] = {
        value : Math.round((data.dom_ready - data.first_paint) / data.load_time * 10000) / 100,
        tooltip : {formatter: "{a}{b} <br/>占比：{c}%<br/>耗时：#{Math.round(data.dom_ready - data.first_paint)}ms"}
      }
      @option.series[2].data[0] = {
        value : Math.round((data.load_time - data.dom_ready) / data.load_time * 10000) / 100,
        tooltip : {formatter: "{a}{b} <br/>占比：{c}%<br/>耗时：#{Math.round(data.load_time - data.dom_ready)}ms"}
      }

      @chart.setOption @option , true

                            