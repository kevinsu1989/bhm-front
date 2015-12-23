option = {
    title : {
        text: '漏斗图',
        subtext: '纯属虚构'
    },
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c}%"
    },
    legend: {
        data : ['PV','播放器加载','CMS','分发','广告播放','正片加载','VV']
    },
    calculable : true,
    series : [
        {
            name:'漏斗图',
            type:'funnel',
            width: '40%',
            data:[
                {value:60, name:'访问'},
                {value:40, name:'咨询'},
                {value:20, name:'订单'},
                {value:80, name:'点击'},
                {value:100, name:'展现'}
            ]
        }
    ]
};
                    
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
          data : ['PV','CMS','分发','广告播放','正片加载','VV']
        series : [
          name:'漏斗图',
          type:'funnel',
          width: '40%',
          data:[
              {value:60, name:'PV'},
              # {value:40, name:'播放器加载'},
              {value:20, name:'CMS'},
              {value:80, name:'分发'},
              {value:100, name:'广告播放'},
              {value:100, name:'广告结束'},
              {value:100, name:'正片加载'},
              {value:100, name:'VV'}
          ]
        ]
    


      @chart = echarts.init @container
      @chart.setOption @option

    reload: (data, title)->
      @option.title.text = ''
      @option.series[0].data = [
        {value:100, name:'PV'},
        # {value:Math.round(data.per_flash*10000)/100, name:'播放器加载'},
        {value:Math.round(data.per_cms*10000)/100, name:'CMS',tooltip:{formatter: "{a} <br/>{b} : {c}%"}},
        {value:Math.round(data.per_dispatch*10000)/100, name:'分发'},
        {value:Math.round(data.per_ad*10000)/100, name:'广告播放'},
        {value:Math.round(data.per_ad_end*10000)/100, name:'广告结束'},
        {value:Math.round(data.per_video*10000)/100, name:'正片加载'},
        {value:Math.round(data.per_play*10000)/100, name:'VV'}
      ]
      @chart.setOption @option , true



