# 函数防抖动
# window.App = window.App || {}
# _ = window._

debounce = (fn, delay)->
  timer = null
  triggerAt = 0

  return ->
    args = arguments
    unless timer
      timer = setTimeout(
        ->
          fn.apply(this, args)
          timer = null
          triggerAt = +(new Date())
      , delay)
      triggerAt = +(new Date())
    else if (new Date()) - triggerAt < delay
      clearTimeout(timer)
      timer = setTimeout(->
        fn.apply(this, args)
        timer = null
        triggerAt = +(new Date())
      , delay)
      triggerAt = +(new Date())

$.fn.twitter_bootstrap_confirmbox =
  defaults:
    title: "提示"
    proceed: "确定"
    proceed_class: "btn proceed"
    cancel: "取消"
    cancel_class: "btn cancel"
    fade: false
    modal_class: ""


# bootbox.success
bootbox.success = (message, callback) ->
  bootbox.dialog
    title: "成功"
    message: message
    # size: 'small'
    buttons:
      ok: {
        label: "确认",
        className: 'btn-success',
        callback: callback
      }
  return
bootbox.fail = (message, callback) ->
  bootbox.dialog
    title: "警告"
    message: message
    # size: 'small'
    buttons:
      ok: {
        label: "确认",
        className: 'btn-warning',
        callback: callback
      }
  return

$.postHtml = (opts) ->
  $.postData("html", opts)

# 将修改url的后缀名为.json的方式
$.postJSON = (opts) ->
  $.postData("json", opts)

$.postData = (type, opts) ->

  urls = opts.url.split("?")
  urlpath = urls[0] || ""

  # console.log urls

  replaceStr = "." + type
  replaceStr = "" if type == 'html'
  urlpath = urlpath.replace(/(\.\w+)?$/, replaceStr) # 添加json的后缀
  urlargs = urls[1] || ""
  myurl = urlpath
  myurl = myurl + "?" + urlargs if urlargs

  method = "post"
  method = "get" if urlargs && urlargs.indexOf("method=get") >= 0

  if opts.method
    method = opts.method
  # console.log myurl
  $.ajax
    type: method
    dataType:type
    data: opts.params
    url: myurl
    success: (jsondata)-> # {code, message, data:{ list, xxx }}
      $.parseRespData(type, jsondata, opts.callback)

$.parseRespData = (type, jsondata, callback)->
  if type is "html"
    if callback? && typeof callback is "function"
      callback(jsondata)
  else
    jsondata = jsondata.responseJSON if jsondata.responseJSON
    data = jsondata.data
    code = jsondata.code
    message = jsondata.message
    if (code == 0)
      if callback? && typeof callback is "function" && typeof data is 'object'
        callback(data)
      else if message
        bootbox.success message
      else
        # do-nothing
        console?.log jsondata
    else
      codemsg = ""
      codemsg = "<br/>(错误代码：" + code + ")" if (code > 0)
      if message
        bootbox.fail message + codemsg
      # else
      #   bootbox.alert "请求出错！" + codemsg
    false

#
# modal系列
#
_.modal_holder_selector = '#modal-holder'
_.modal_selector = '.modal'

$.onmount 'a[data-modal]', ->
  $(this).off("click").on 'click', (e)->
    location = $(this).attr('href')
    #Load modal dialog from server
    if location
      $.get location, (data)->
        $(_.modal_holder_selector)
          .html(data)
          .find(_.modal_selector).modal()
    false

# 加载成功， 重新刷新页面
$(document).on 'ajax:success', 'form[data-remote][data-reloadpage]', (event, data, status, xhr)->
  cb = ->
    App.util.reload()
  $.parseRespData("json", data, cb)
  false

# /0/ - 创建时，一般是id为0
$(document).on 'ajax:success', 'form[data-remote][data-gotopath]', (event, data, status, xhr)->
  gpath = $(event.target).data("gotopath")
  cb = (data)->
    if /\/0\//.test(gpath)
      if data && data.id
        gpath = gpath.replace(/\/0\//, "/"+data.id+"/")

      App.visit(gpath)
      return
    App.util.reload()
  $.parseRespData("json", data, cb)
  false


# 加载成功，将内容渲染到指定dom上
$(document).on 'ajax:success', 'form[data-remote][data-render-target]', (event, data, status, xhr)->
  tgdom = $(event.target).data("renderTarget")
  $tg = $(tgdom)
  console.log($tg)
  if $tg.length > 0
    $tg.html(data)
    $.onmount()
  # $.parseRespData("json", data, cb)
  false


$(document).on 'ajax:success', 'form[data-modal]', (event, data, status, xhr)->
  url = xhr.getResponseHeader('Location')
  if url
    # Redirect to url
    App.util.visit(url)
  else
    # Remove old modal backdrop
    $('.modal-backdrop').remove()

    # Replace old modal with new one
    $(_.modal_holder_selector)
      .html(data)
      .find(_.modal_selector).modal()

  false

$(document).on 'submit.query', 'form.query:not([data-remote]):not(.no-turbolinks)', ->
  if Turbolinks.supported
    $form = $(this)
    $inp = $form.find("input[name=_method][value=delete]")
    if $inp.length <= 0
      url = $form.attr 'action'
      queryString = $form.serialize()
      if url
        url += (if url.indexOf('?') isnt -1 then '&' else '?') + queryString
        App.util.visit(url, true)
        return false


$(document).on 'ajax:error', (event, data, status, xhr) ->
  $.parseRespData("json", data)

$(document).on 'ajax:success', (event, data, status, xhr)->
  $.parseRespData("json", data)

# $(document).on 'shown.bs.modal', 'form[data-modal]', (e)->

$.onmount 'form[data-toggle="validator"]', ->
  $(this).validator().on 'submit', (e) ->
    # $(this).validator('update')
    return false if e.isDefaultPrevented()

# bootstrap的插件tooltip失效, 要进行重新加载
$.onmount '[data-toggle=tooltip]', ->
  $(this).tooltip()
# bootstrap的插件carousel失效, 要进行重新加载
$.onmount '[data-ride=carousel]', ->
  $(this).carousel()
$.onmount '[data-spy=affix]', ->
  $(this).affix()


$(document).on 'ready shown.bs.modal', (e)->
  # $.AdminLTE.layout.activate()
  $.onmount()
  # console.log("------turbolinks:load")
  # console.log(e)

$(document).on 'shown.bs.modal', (e) ->
  $this = $(e.target)
  if $this.prop('id') == 'confirmation_dialog'
    $modal_dialog = $this.find('.modal-dialog')
    h0 = $(window).height()
    h1 = $modal_dialog.height()
    if h1 < h0/2 
      m_top = ( h0 - h1 )/2
      $modal_dialog.css({'margin': m_top + 'px auto'})


$(document).on 'turbolinks:load', (e)->
  # $.AdminLTE.layout.activate()
  $.onmount()

  if window.scrollPosition
    window.scrollTo.apply(window, window.scrollPosition)
    window.scrollPosition = null
  # console.log("------turbolinks:load")
  # console.log(e)

$(document).on 'turbolinks:before-visit', (e)->
  # console.log("------turbolinks:before-visit")
  # console.log(e)

$(document).on 'turbolinks:before-cache', (e)->
  $.onmount.teardown()
  # console.log("------turbolinks:before-cache")
  # console.log(e)

$(document).on 'turbolinks:request-end', (e)->
  # $.onmount.teardown()
  # console.log("------turbolinks:request-end")
  # console.log(e)


