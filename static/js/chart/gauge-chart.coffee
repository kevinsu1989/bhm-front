define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class gaugeChart
    constructor: (@container)->
      @option =
        # backgroundColor: 'rgba(51,51,51,.4)'
        tooltip :
          formatter : "{a} <br/>{b} : {c}%"
        toolbox : show: false
        series : [

          name:'flash加载成功率'
          type:'gauge'
          z: 3
          min:0
          max:100
          startAngle: 140
          endAngle : -140
          radius: '75%'
          splitNumber: 5        
          axisLine:          
            show: true     
            lineStyle: 
              # color: [[0.8, 'orange'],[0.85, 'lightgreen'],[1, 'skyblue']]
              width: 20
          axisTick:         
            show: true    
            splitNumber: 5  
            length :8       
            lineStyle:    
              color: '#eee'
              width: 1,
              type: 'solid'
          axisLabel:        
            show: true,
            textStyle:     
              color: '#333'
          splitLine:          
            show: true,       
            length :10,       
            lineStyle:       
              color: '#eee',
              width: 2,
              type: 'solid'
          pointer :
            length : '80%'
            width : 8
            color : 'auto'
          title :
            show : true
            offsetCenter: ['-105%', -10]   
            textStyle:      
              color: '#333'
              fontSize : 12
          detail:
            show: true
            backgroundColor: 'rgba(0,0,0,0)'
            borderWidth: 0,
            borderColor: '#ccc'
            width: 100,
            height: 20,
            offsetCenter: ['-100%', 5]      
            formatter:'{value}%'
            textStyle:     
              color: 'auto'
              fontSize : 15
    
          data:[{value: 40, name: '%'}]
    		]


      @chart = _echarts.init @container


    reload: (data, title)->
      @option.series[0].data[0] = 
      	value: Math.round(data * 10000)/100
      	name: title
      @chart.setOption @option, true
        

