define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class gaugeChart
    constructor: (@container)->
      @option =
        tooltip :
          formatter : "{a} <br/>{b} : {c}%"
        toolbox : show: false
        series : [
          name:'flash加载成功率'
          type:'gauge'
          splitNumber: 5   
          axisLine: 
            lineStyle:   
              color: [[0.8, '#ff4500'],[0.85, '#A4C21E'],[1, '#228b22']]
              width: 8
   
          axisTick: 
            splitNumber: 5
            length :12    
            lineStyle: 
              color: 'auto'
    
          axisLabel: 
              textStyle:
                  color: 'auto'

          splitLine: 
            show: true
            length :30
            lineStyle:
              color: 'auto'
 
          pointer :
            width : 5
         
          title : 
            show : true,
            offsetCenter: [0, '-110%']     
            textStyle: 
              fontWeight: 'normal'

          detail :
            formatter: '{value}%'
            textStyle:
              color: 'auto'
              fontWeight: 'normal'
              fontSize: 15

          data:[{value: 50, name: '完成率'}]
    		]


      @chart = echarts.init @container
      @chart.setOption @option


    reload: (data, title)->
      @option.series[0].data[0] = 
      	value: Math.round(data * 10000)/100
      	name: title
      @chart.setOption @option, true
        

