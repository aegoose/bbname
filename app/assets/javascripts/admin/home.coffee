# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window.App = window.App || {}

class App.Select2Source
  constructor: () ->
    @cached = {
      "catg": {}
    }

  getData: (type, url)->
    tyhash = @cached[type]
    return false unless tyhash
    tyhash[url]

  clear: (type)->
    @cached[type] = {}

  setCached: (type, url, data) ->
    tyhash = @cached[type]
    unless tyhash
      @cached[type] = {}
    @cached[type][url] = data

unless App.Select2Data
  App.Select2Data = new App.Select2Source()

$.fn.select2AjaxData = (type, url, slts) ->
  $elem = $(this)
  rs = App.Select2Data.getData(type, url)

  rsData = ->
    resetSelected = (obj)->
      if obj.children && obj.children.length > 0
        for chobj in obj.children
          resetSelected(chobj)

      # console.log ("2-----------")
      # console.log (obj.id + " : " + slts)
      # console.log ("2-----------")
      if slts.indexOf(obj.id) >= 0
        obj.selected = true

    for obj in rs
      resetSelected(obj)

    $elem.select2
      theme: "bootstrap"
      allowClear: !!$elem.data("allow-clear")
      selectOnClose: true
      data: rs

  if rs
    rsData()
  else
    $.postJSON
      url: url
      method: "get"
      params: {select:true}
      callback: (data) ->
        rs = data.results
        App.Select2Data.setCached(type, url, rs)
        rsData()
  $elem


$.onmount '[data-ajax-select2]', ->
  $(this).each ->
    opts = $(this).data("ajax-select2")
    ajaxUrl = opts.url
    if ajaxUrl
      ajaxType = opts.type
      slts = opts.slts
      # $(this).off("select2:open").on 'select2:open', (e) ->
      #   data = e.params.data
      #   console.log(data)
      $(this).select2AjaxData(ajaxType, ajaxUrl, slts)

#查询框
$.onmount ".query-select, .query .form-control.select", ->
  $(this).on "change", (e)->
    $sel = $(this)
    if ($fm = $sel.closest("form")).length > 0
      $fm.trigger("submit")
    else
      url = $sel.data("url")
      pname = $sel.attr("name")
      val = $sel.val() || ""
      if val
        url += (if url.indexOf("?") > 0 then "&" else "?")
        url += pname + "=" + val
      App.util.visit(url)

$.onmount ".query input.form-control[type=text]", ->
  $(this).on "keypress", (e)->
    $inp = $(this)
    keynum = e.keyCode || e.which
    console.log(keynum)
    $fm = $inp.closest("form")
    $fm.trigger("submit") if keynum == 13 && $fm.length > 0
      

# FIXME: no-use
$.onmount '.gen-title .nav-tabs a[role]', ->
  $(this).off("click").on 'click', (e)->
    $(this).tab('show')
    return false
  $(this).off("show.bs.tab").on 'show.bs.tab', (e)->
    idx = $(e.target).data("index")
    # console.log(idx)
    $par = $(this).closest(".nav-tabs")
    $par.find("[role=tabbtns] a").removeClass("active")
      .filter("[data-index="+idx+"]").addClass("active")

# falsh拷贝
$.onmount '.btn.zerocopy', ->
  $(this).each ->
    $btn = $(this)
    clip = new ZeroClipboard($btn)
    clip.on 'aftercopy', (event)->
      $btn.tooltip({title: "已复制", placement: "top", trigger:"manual"}).tooltip("show")
      offbtn = ->
        $btn.tooltip("destroy")
      setTimeout offbtn, 1000
      # console.log('Copied: ' + event.data['text/plain']);

$.onmount 'form[data-remote] .quick-submit input[type=radio]', ->
  $(this).on 'change', (e)->
    $sel = $(this)
    if $sel[0].form
      $($sel[0].form).trigger("submit")

# FIXME: no-use
$.onmount '[data-period-type]', ->
  $(this).on 'change', (e)->
    $slt = $(this)
    $begin = $slt.closest("form").find("#customer_product_end_at")
    $period = $slt.closest("form").find("#customer_product_period")
    v = $slt.val()

    if v == 'due_date'
      $begin.removeClass("hidden")
      $period.addClass("hidden")
    else
      $begin.addClass("hidden")
      $period.removeClass("hidden")

# FIXME: no-use
$.onmount '[data-upexcel]', ->
  $(this).fileupload
    dataType: "json"
    add: (e, data) ->
      types = /(\.|\/)(csv|xls|xlsx)$/i
      file = data.files[0]
      console.log(e)
      if types.test(file.type) || types.test(file.name)
        $up = $(e.target)
        $fm = $up.parent()
        $fm.find(".progress").remove()
        $('<div class="progress margin-5">
          <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">0%</div>
        </div>').appendTo($fm)
        data.context = $fm
        data.submit()
      else
        alert("#{file.name} 不是合法的csv或excel文件")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find(".progress-bar")
          .prop("aria-valuenow", progress)
          .css("width", progress+ "%")
          .text(progress + "%")
    done: (e, data) ->
      rs = data.result
      if rs && rs.code == 0 && rs.data && rs.data.url
        # data.context.find(".progress-bar").addClass("progress-bar-success")
        App.util.visit(rs.data.url)
      else
        bootbox.fail "上传有误"
        data.context.find(".progress").remove()

$.onmount '[data-process-status=0]', ->
  App.processToutMap = App.processToutMap || {}

  $thisArea = $(this)
  ty = $thisArea.data("processType")
  tout = App.processToutMap[ty] || 0
  clearTimeout(tout) if tout > 0

  url = $thisArea.data("processUrl")
  # console.log(ty + "----" + url)
  toutspan = 1000
  run = ->
    $.postHtml
      url: url
      method: "get"
      callback: (htmldata)->
        $myHtml = $(htmldata)
        if $myHtml.length > 0 && $myHtml.is("[data-process-status]")
          # console.log("------"+ $myHtml.data())
          $par = $thisArea.parent()
          $par.html($myHtml)
          newSt = $myHtml.data("processStatus")
          delete App.processToutMap[ty]
          top = $myHtml.find("pre p.alert-success").offset().top
          $('html, body').animate({scrollTop: top}, toutspan) if top > 400
          $.onmount()

  tout = setTimeout(run, 500)
  App.processToutMap[ty] = tout

$.onmount '[data-toggle=collapse] a:not([data-remote])', ->
  $(this).on 'click', (e)->
    url = $(this).attr("href")
    if url?
      App.util.visit(url)
      return false

$.onmount '#collapsePar', -> 
  $par = $(this)
  $par.find(".collapse").each ->
    $(this).on 'show.bs.collapse', ->
      # console.log("------1")
      if $par.width() <= 640 
        cid = $(this).prop("id")
        $cc = $par.find("[data-target='#"+cid+"']").closest(".query-item")
        $cc.nextAll(".query-item").addClass("force-hide hide")

    $(this).on 'hide.bs.collapse', ->
      if $par.width() <= 640 
        # console.log("------2")
        $par.find('.force-hide.hide').removeClass("force-hide hide")

$.onmount 'form a[data-query][data-close], form a[data-query][data-value]', ->
  $(this).on 'click', (e)->
    $a = $(this)
    $fm = $a.closest("form")
    datas = $a.data()
    ky = datas["query"]
    setv = datas["value"] || ""

    $inp = $fm.find("[name$='[" + ky + "]']")
    # $inp = $fm.find("[name='[" + ky + "]'") if $inp.length <= 0

    # should delete
    setv = "" if datas["close"]?

    $inp.val(setv)
    $fm.trigger('submit')
    false


$.onmount '.alert-dismissible', ->
  $(this).fadeTo(3000, 500)
    .slideUp 500, ()->
      $(this).alert('close')

$.onmount '.input-daterange', ->
  $(this).datepicker({
    format: "yyyy-mm-dd"
    language: "zh-CN"
    autoclose: true
    clearBtn: true,
    todayHighlight: true, 
    orientation: "bottom auto"
  }).on 'changeDate', ->
    $(this).closest('form').submit()

$.onmount '[data-provide]', ->
  $(this).datepicker({
    format: "yyyy-mm-dd"
    language: "zh-CN"
    autoclose: true
    clearBtn: true,
    todayHighlight: true
  })

$.onmount '.link-group', ->
  $(this).hover(
    ->
      $(this).find('.link-btn').removeClass('invisible')
    ->
      $(this).find('.link-btn').addClass('invisible')
  ) 
#   $(this).each ->
    # $(this).datepicker('clearDates')
# $.onmount '.query .time-group', ->
#   $tstart = $(this).find(".time-start")
#   $tstop = $(this).find(".time-stop")
#   if $tstart.length > 0 && $tstop.length > 0
#     $tstart.datetimepicker({
#       #'defaultDate': moment().day(-7),
#       'format': "YYYY-MM-DD"
#       'date-autoclose': true
#       'date-language': 'zh-CN'
#     }).on 'dp.change', ->
#       $tstop.data("DateTimePicker").minDate(e.date);
#       $(this).closest("form").submit()

#     $tstop.datetimepicker({
#       #defaultDate: moment(),
#       format: "YYYY-MM-DD",
#       'date-autoclose': true
#       'date-language': 'zh-CN'
#       useCurrent: false
#     }).on 'dp.change', ->
#       $tstart.data("DateTimePicker").maxDate(e.date);
#       $(this).closest("form").submit()
