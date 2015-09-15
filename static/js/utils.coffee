#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 10:53 AM
#    Description:

define [

], ()->
  #去除前后的空格
  trim: (text)-> text and text.replace(/^\s+/, "" ).replace(/\s+$/, "")
  #格式化文本
  formatString: (text, args...)->
    return text if not text
    #如果第一个参数是数组，则直接使用这个数组
    args = args[0] if args.length is 1 and args[0] instanceof Array
    text.replace /\{(\d+)\}/g, (m, i) -> args[i]

  #提取text中包括规则的模板html，即包含在textarea中的
  extractTemplate: (expr, text)->
    $(text).find(expr).val()


  hex2rgba: (hex)->
    `
    var rgba = {r: 0, g: 0, b: 0, a: 0}
    var c, o = [], k = 0, m = hex.match(
      /^#(([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})|([0-9a-f])([0-9a-f])([0-9a-f]))$/i);

    if (!m) return rgba;
    for (var i = 2, s = m.length; i < s; i++) {
      if (undefined === m[i]) continue;
      c = parseInt(m[i], 16);
      o[k++] = c + (i > 4 ? c * 16 : 0);
    }
    rgba.r = o[0]
    rgba.g = o[1]
    rgba.b = o[2]
    `
    return rgba;
