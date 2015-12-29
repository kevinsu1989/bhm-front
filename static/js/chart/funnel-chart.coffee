define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class funnelChart
    constructor: (@container)->
      @option =
        title:
          x: 'center'
          text: 'PV-VV漏斗图'
          textStyle:
            fontSize: 15
        tooltip: 
          trigger: 'item',
          formatter: "{a} <br/>{b} : {c}%"
        calculable: true
        legend: 
          data : ['PV','播放器加载','CMS','分发','广告播放','广告结束','VV']
        series : [
          name:'PV-VV漏斗图',
          type:'funnel',
          width: '40%',
          data:[
              {value:60, name:'PV'},
              {value:40, name:'播放器加载'},
              {value:20, name:'CMS'},
              {value:80, name:'分发'},
              {value:100, name:'广告播放'},
              {value:100, name:'广告结束'},
              # {value:100, name:'正片加载'},
              {value:100, name:'VV'}
          ]
        ]
    


      @chart = echarts.init @container
      @chart.setOption @option

    reload: (data, title)->
      @option.title.text = ''
      @option.series[0].data = [
        {value:100, name:'PV'},
        {value:Math.round(data.per_flash*10000)/100, name:'播放器加载',tooltip: {formatter: "{a} <br/>{b} : {c}%  (#{Math.round((data.per_flash-1)*10000)/100}%)"}},
        {value:Math.round(data.per_cms*10000)/100, name:'CMS',tooltip: {formatter: "{a} <br/>{b} : {c}%  (#{Math.round((data.per_cms-data.per_flash)*10000)/100}%)"}},
        {value:Math.round(data.per_dispatch*10000)/100, name:'分发',tooltip: {formatter: "{a} <br/>{b} : {c}%  (#{Math.round((data.per_dispatch-data.per_cms)*10000)/100}%)"}},
        {value:Math.round(data.per_ad*10000)/100, name:'广告播放',tooltip: {formatter: "{a} <br/>{b} : {c}%  (#{Math.round((data.per_ad-data.per_dispatch)*10000)/100}%)"}},
        {value:Math.round(data.per_ad_end*10000)/100, name:'广告结束',tooltip: {formatter: "{a} <br/>{b} : {c}%  (#{Math.round((data.per_ad_end-data.per_ad)*10000)/100}%)"}},
        {value:Math.round(data.per_play*10000)/100, name:'VV',tooltip: {formatter: "{a} <br/>{b} : {c}%  (#{Math.round((data.per_play-data.per_ad_end)*10000)/100}%)"}}
      ]
      @chart.setOption @option , true



