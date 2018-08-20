window.App = window.App || {}
_ = window._

# 工具类,依赖jquery,lodash-core
App.util = {
  FORM_ELEMENTS: "input, textarea, select, button"

  # 取得上下文（jquery对象)，如果已经提供context，则将其包装成jquery对象，否则上下文设置为$(document.body)
  getContext: ($context)->
    return if $context then $($context) else $(document.body)

  # 隐藏 $selector, 并将其里面的表单元素禁用
  hideAndDisable: ($selector)->
    $selector.hide().find(App.util.FORM_ELEMENTS).prop('disabled', true)
    $selector.filter(App.util.FORM_ELEMENTS).prop('disabled', true)

  # 显示 $selector, 并将其里面的表单元素启用
  showAndEnable: ($selector)->
    $selector.show().find(App.util.FORM_ELEMENTS).prop('disabled', false)
    $selector.filter(App.util.FORM_ELEMENTS).prop('disabled', false)

  # 访问链接
  visit: (url, keepPosition = false) ->
    if window.Turbolinks and Turbolinks.supported
      if keepPosition
        window.scrollPosition = [window.scrollX, window.scrollY]
      Turbolinks.visit url
    else
      location.href = url

  reload: ->
    if window.Turbolinks and Turbolinks.supported
      window.scrollPosition = [window.scrollX, window.scrollY]
      Turbolinks.visit(window.location, { action: 'replace' })
      # Turbolinks.visit url
    else
      location.reload()

  # html 转义
  htmlDecode: (str)->
    s = ""
    return "" if str.length is 0
    s = str.replace(/&amp;/g, "&")
    s = s.replace(/&lt;/g, "<")
    s = s.replace(/&gt;/g, ">")
    s = s.replace(/&nbsp;/g, " ")
    s = s.replace(/&#39;/g, "\'")
    s = s.replace(/&quot;/g, "\"")
    s = s.replace(/<br>/g, "\n")

  htmlEncode: (str)->
    s = ""
    return "" if str.length is 0
    s = str.replace(/&/g, "&amp;")
    s = s.replace(/</g, "&lt;")
    s = s.replace(/>/g, "&gt;")
    s = s.replace(/\'/g, "&#39;")
    s = s.replace(/\ /g, "&nbsp;")
    s = s.replace(/\"/g, "&quot;")
    s = s.replace(/\n/g, "<br>")

  # 生成hash code
  hashCode: (str)->
    hash = 0
    return hash if !str or str.length is 0
    for i in [0..str.length - 1]
      chr = str.charCodeAt(i)
      hash = ((hash << 5) - hash) + chr
      hash |= 0
    hash

  # 输入小数
  inputFloat: ($e)->
    thisVal = $e.val()
    valAry = thisVal.split('.')
    pointLength = valAry.length - 1
    reg2 = /\.{2}/g
    reg3 = /[^\d.]/g
    # 如果连续两个小数点
    if reg2.test(thisVal)
      $e.val thisVal.replace(reg2,'.')

    #　如果输入两个小数点
    if pointLength >= 2
      $e.val thisVal.substring(0, thisVal.lastIndexOf('.'))

    # 如果先输入小数点
    if thisVal.indexOf('.') == 0
      $e.val '0' + '.'

    # 如果小数点后超出两位
    if pointLength >= 1
      if valAry[1].length >= 2
        $e.val valAry[0] + '.' + valAry[1].substring(0, 2)

    #$e.val thisVal


    # 如果输入非数字
    if reg3.test(thisVal)
      str = thisVal.replace(/[^\d.]/g, "");
      $e.val str

  # 基于bootstrap弹出层, modal必须有一个唯一id
  # modalHtml: 新的完整的弹出层html
  # shownCallback: 弹出层弹出后的回调, 参数为新的modal jq对象
  # beforeReplaceCallback: 旧的弹出层弹被替换前的回调, 参数为旧的modal jq对象
  showModal: (modalHtml, beforeReplaceCallback, shownCallback) ->
    $newModal = $(modalHtml)
    unless $newModal.attr('id')
      console.error("弹出层必须指定id!")
      return null

    $oldModal = $("##{$newModal.attr('id')}")
    $modal = $oldModal
    if $oldModal.length > 0
      beforeReplaceCallback($oldModal) if typeof beforeReplaceCallback is 'function'
      $oldModal.html($newModal.html()).modal('show').modal('handleUpdate')
    else
      $(document.body).append $newModal
      $newModal.modal('show')
      $modal = $newModal
    shownCallback($modal) if typeof shownCallback is 'function'
    return $modal

  setupChosen: ($context) ->
    $context = @getContext($context)
    $('.chosen-select', $context).each ->
      $this = $ this
      $this.chosen({
        placeholder_text_single: '请选择'
        placeholder_text_multiple: '请选择'
        allow_single_deselect: true
        no_results_text: '没有匹配结果'
        width: '100%'
        search_contains: true
      })
      $chosenContainer = $this.siblings '.chosen-container'
      $this.siblings('.chosen-container').insertBefore $this

  # 图片预览, 根据指定url全屏弹出图片.
  previewImage: (url) ->
    return unless url
    # get or create preview container
    $previewContainer = $('.preview-container')
    if $previewContainer.length is 0
      $previewContainer = $('
        <div class="preview-container">
          <div class="preview-layer"></div>
          <i class="close-btn fa fa-times"></i>
          <div class="image-container"></div>
        </div>
      ')
      $(document.body).append($previewContainer)
      $previewContainer.on 'click', '.preview-layer, .close-btn', ->
        $previewContainer.removeClass('shown')
        $('html').removeClass('disabled-scroll')
    $previewContainer.addClass('shown loading').removeClass('loaded-error')
    $('html').addClass('disabled-scroll')

    # load image
    img = new Image()
    img.onload = ->
      mt = 0 # margin-top
      ml = 0 # margin-left
      cssW = 0
      cssH = 0
      cw = $previewContainer.width() - 96
      ch = $previewContainer.height() - 96
      cw = 96 if cw <= 96
      ch = 96 if ch <= 96
      w = img.width
      h = img.height

      # 容器尺寸较大
      if cw > w and ch > h
        cssW = w
        cssH = h
      else
        if h / w > ch / cw # 图片纵横比大于容器(竖型)
          cssW = ch / h * w
          cssH = ch
        else
          cssW = cw
          cssH = cw / w * h

      mt = cssH / 2
      ml = cssW / 2
      $previewContainer.removeClass('loading').find('.image-container').empty()
      .css({
        width: cssW,
        height: cssH,
        'margin-top': -mt,
        'margin-left': -ml
      })
      .append img
    img.onerror = ->
      $previewContainer.removeClass('loading').addClass('loaded-error')
    img.src = url

  # 依赖underscore && jquery, 居中弹出消息
  popMessage: (content, opts)->
    template = _.template("""
      <div class='pop-message'>
        <div class="alert-message message-<%=type%>">
          <i class="close fa fa-times"></i>
          <div class="message-body">
            <i class="icon <%=icon%>"></i>
            <%=content%>
          </div>
        </div>
        <div class="message-layer"></div>
      </div>
    """)

    # init options
    options = $.extend({}, {
      content: content,
      type: 'success', # success, info, warning, danger,
      icon: 'fa fa-check',
      duration: 5000, #自动消失等待时间
      hide: null, #callback, 弹出层消失后调用
      cancelText: '取消',
      okText: '确认'
    }, opts)

    unless opts && opts.icon
      options.icon = switch options.type
        when 'success'  then 'fa fa-check-circle'
        when 'info'     then 'fa fa-info-circle'
        when 'warning'  then 'fa fa-exclamation-circle'
        when 'danger'   then 'fa fa-times-circle'
        else
          'fa fa-info-circle'
    options.duration = 1000 if options.duration < 1000

    # build view
    $msgContainer = $(template(options))
    $popMsg = $msgContainer.find('.alert-message')
    # remove exist pop message
    $('.pop-message').trigger('remove.popmessage')
    $('body').append($msgContainer)

    # set position
    $popMsg.addClass('pre-visible')
    $popMsg.css({
      'left': '50%',
      'top': '50%',
      'margin-left': -$popMsg.outerWidth() / 2,
      'margin-top': -$popMsg.outerHeight() / 2
    })
    $popMsg.removeClass('pre-visible')

    # events handlers
    $msgContainer.on('click.popmessage', '.message-layer', ->
      $msgContainer.trigger('close.popmessage')
    ).on('close.popmessage', ->
      $popMsg.fadeOut(300, ->
        options.hide() if typeof options.hide is 'function'
        $msgContainer.off '.popmessage'
        $msgContainer.remove()
      )
    ).on('remove.popmessage', ->
      $msgContainer.off '.popmessage'
      $msgContainer.remove()
    )

    # show
    $popMsg.fadeIn(300)

    # auto close
    setTimeout(->
      $msgContainer.trigger('close.popmessage')
    , options.duration)

  # 依赖script js,
  loadScript: (script, scriptObjName, ready) ->
    runReady = ->
      if window[scriptObjName]
        ready() if typeof ready is 'function'
        App.util.log(scriptObjName + ' has been loaded.') if App.util.log
      else
        setTimeout(runReady, 300)

    if window[scriptObjName]
      ready() if typeof ready is 'function'
    else
      $script script, runReady

  # 加载高德地图
  loadAMap: (->
    getCallbackName = (index)->
      n = index or 1;
      name = "onloadAMap#{n}"
      if window[name] then getCallbackName(n + 1) else name

    return (ready) ->
      cbName = getCallbackName()
      window[cbName] = ->
        ready() if typeof ready is 'function'
        window[cbName] = null

      if window.AMap
        window[cbName]()
      else
        $script "//webapi.amap.com/maps?v=1.3&key=587b267d6434c7244728673a47bc06d3&callback=#{cbName}")()

  # 加载echarts
  loadECharts: (ready) ->
    App.util.loadScript '/vendor/echarts.min.js', 'echarts', ready

  # 创建缓存版ajax
  createCacheableAjax: ->
    cache = {}
    PENDDING_FLAG = "__cache_pendding__"

    return (ajaxProperties, done = $.noop, fail = $.noop, beforeSend = $.noop)->
      key = JSON.stringify(ajaxProperties)
      success = ajaxProperties.success || $.noop
      error = ajaxProperties.error || $.noop
      delete ajaxProperties.success
      delete ajaxProperties.error

      if cache[key] and cache[key] isnt PENDDING_FLAG
        done(cache[key])
        success(cache[key])
      else
        cache[key] = PENDDING_FLAG
        beforeSend()
        $.ajax.call($, ajaxProperties)
        .done((data)->
          cache[key] = data
          done(data)
          success(data)
        ).fail((jxhr) ->
          cache[key] = null
          if typeof fail is 'function'
            fail(jxhr)
          error(jxhr)
        )

  # 获取form的validator(jquery validatetion)
  getValidator: (form)->
    $form = $ form
    return $.data($form[0], "validator")


  # 打印特定区域
  # @param {object} opts 打印选项，包含选项如下
  # {
  #   $elem: 必须。打印元素
  #   beforePrint: 可选，打印前的回调，可对$elem(克隆对象)进行修改，必须返回jquery元素对象
  # }
  print: (opts)->
    throw('打印功能需要指定打印元素（jquery对象）:$elem') if (!opts.$elem)

    destroyPrintView = () ->
      $('.print-view').remove()
      $(document).off('.ddc_print')
      $('body').removeClass('print')

    buildPrintView = ($elem) ->
      destroyPrintView()

      $printView = $(
        '<div class="print-view">' +
        ' <div class="print-body"></div>' +
        ' <div class="print-actions">' +
        '   <a herf="javascript:void(0)" class="print-cancel btn btn-line-default">取消</a>' +
        '   <a herf="javascript:void(0)" class="print-confirm btn btn-line-primary">确认打印</a>' +
        ' </div>' +
        '</div>')
      $printView.find('.print-body').append($elem)
      $('body').addClass('print').append($printView)

      $(document)
      .on('click.ddc_print', '.print-view .print-cancel',  destroyPrintView)
      .on('click.ddc_print', '.print-view .print-confirm', ->
        $printView.addClass('printing')
        print()

        setTimeout(->
          $printView.removeClass('printing')
        , 0)
      )

    $elem = opts.$elem.clone(false)
    $elem = opts.beforePrint($elem) if typeof opts.beforePrint is 'function'
    buildPrintView($elem)

  loading:{
    show:()->
      $('body').append($("<div class='u-loading'></div>"))
    hide:()->
      $('.u-loading').remove()
  }
}
