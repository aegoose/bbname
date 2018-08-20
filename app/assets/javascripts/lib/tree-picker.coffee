window.App = window.App || {}

cloneTreeNode = (node, childrenKey)->
  newNode = {}
  for key,value of node
    if key isnt childrenKey
      newNode[key] = value
  newNode

filterTree = (collections, childrenKey, filter)->
  result = []
  for item in collections
    if !item[childrenKey] or item[childrenKey].length is 0
      if typeof filter is 'function'
        result.push(item) if filter(item)
      else
        result.push(item)
    else
      newChildren = filterTree(item[childrenKey], childrenKey, filter)
      newItem = cloneTreeNode(item, childrenKey)
      if newChildren.length > 0
        newItem[childrenKey] = newChildren
        result.push(newItem)
      else
        if typeof filter is 'function'
          result.push(newItem) if filter(newItem)
        else
          result.push(newItem)
  return result

filterLeaves = (collections, childrenKey, filter)->
  result = []
  for item in collections
    if item[childrenKey] and item[childrenKey].length isnt 0
      subResult = filterLeaves(item[childrenKey], childrenKey, filter)
      if subResult.length isnt 0
        newItem = cloneTreeNode(item, childrenKey)
        newItem[childrenKey] = subResult
        result.push(newItem)
    else
      if typeof filter is 'function'
        result.push(item) if filter(item)
      else
        result.push(item)
  result

class App.TreePicker
  constructor: (elem, opts) ->
    @$elem = $ elem
    @$pickerContainer = null
    @opts = $.extend(true, {}, App.TreePicker.DEFAULTS, opts, {multiple: @$elem.prop('multiple')}, @$elem.data())
    @selectedIds = @opts.selectedids || @$elem.find('option:selected').map(->this.value).get()
    @data = App.TreePicker.cache[@opts.url]
    @init()

  setBlankOptIfNeeded: ->
    if @opts.blankOption
      @data = [{id: '', name: @opts.blankOption}].concat(@data)

  init: ->
    # fixme: build select
    childrenKey = @opts.childrenKey
    myElem = @$elem
    myThis = this
    myvalue = myElem.val()
    optText = myElem.find("option[value='']").first().text()
    @opts.blankOption = optText if optText
    _build_select = (list) ->
      for item in list
        myopt = $("<option>")
          .appendTo(myElem)
          .val(item.id)
          .text(item.name)

        hasChildren = item[childrenKey] && item[childrenKey].length > 0
        if hasChildren
          _build_select(item[childrenKey])
      return

    _init_select_value = () ->
      if myvalue? && myvalue
        mytext = myElem
          .find('option[value='+myvalue+']')
          .prop('selected', true)
          .text()
        if mytext? && myThis.$pickerContainer?
          myThis.$pickerContainer.find('.input-mocker').text mytext

    if @data

      @setBlankOptIfNeeded()
      @$elem.empty()
      _build_select(@data)
      @buildView({list: @data})
      _init_select_value()

    else
      @opts.canResetCached = true # 从url请求，可重置缓存
      $.getJSON(@opts.url)
        .done((data) =>
          if data.data?
            @data = App.TreePicker.cache[@opts.url] = data.data
          else
            @data = App.TreePicker.cache[@opts.url] = data

          @setBlankOptIfNeeded()
          @$elem.empty()
          _build_select(@data)
          @buildView({list: @data})
          _init_select_value()
          return data
        ).fail(() =>
          @$elem.empty()
          @buildView({error: true})
        )
    return @data

  buildTree: (list, query) ->
    selectedIds = @selectedIds
    shouldExpand = !!query
    childrenKey = @opts.childrenKey
    _build = (list, query) ->
      html = '<ul>'
      for item, i in list
        hasChildren = item[childrenKey] && item[childrenKey].length > 0
        className = if selectedIds.indexOf(item.id) != -1 then 'selected' else ''
        icon = ''
        if hasChildren
          icon = if shouldExpand then "<i class='item-icon fa fa-angle-down'></i>" else "<i class='item-icon fa fa-angle-right'></i>"
        liClassName = if i is list.length - 1 then 'last' else ''
        liClassName += ' open' if shouldExpand
        name = item.name
        if !!query
          splitStart = name.toLowerCase().indexOf(query.toLowerCase())
          if splitStart isnt -1
            name = name.substring(0, splitStart) + '<strong>' + name.substr(splitStart, query.length) + '</strong>' + name.substring(splitStart + query.length)

        html += "<li class='#{liClassName}'>#{icon}<a href='javascript:void(0);' data-id='#{item.id || ""}' class='#{className}' title='#{name}'>#{name}</a>"
        if hasChildren
          html += _build(item[childrenKey], query)
        html += '</li>'
      html += '</ul>'
    return _build(list, query)

  buildView: (obj = {})->
    if obj.error
      tpl = '<div class="tree-picker-container"><div class="input-mocker">' + @opts.blankOption + '</div><div class="error">数据加载错误!</div></div>'
    else
      tpl = "
        <div class='tree-picker-container'>
          <div class='input-mocker'>#{@opts.blankOption}</div>
          <div class='picker-panel'>
            <input class='query form-control input-sm' placeholder='搜索'/>
            <div class='tree'>
            #{@buildTree(obj.list)}
            </div>
          </div>
        </div>
      "

    # @$elem.siblings(".tree-picker-container").remove()
    @$pickerContainer = $(tpl)
    @$pickerContainer.insertBefore @$elem
    showText = @$pickerContainer.find('a.selected').map(-> $(this).text()).get().join(', ')
    @$pickerContainer.find('.input-mocker').text showText if showText
    @listeningEvents()

  search: (query)->
    filterFn = if @opts.canPickParent then filterTree else filterLeaves
    if @$pickerContainer && @data
      if query
        list = filterFn(@data, @opts.childrenKey, (item)->
          item.name.toLowerCase().indexOf(query.toLowerCase()) isnt -1
        )
        if list.length > 0
          @$pickerContainer.find('.tree').html(@buildTree(list, query))
      else
        @$pickerContainer.find('.tree').html(@buildTree(@data, query))

  showView: ->
    if @$pickerContainer
      @$pickerContainer.addClass('shown')
      @$pickerContainer.find('.query').focus()
      # @$elem.trigger('tree_picker:show')

  hideView: ->
    if @$pickerContainer
      @$pickerContainer.removeClass('shown')
      # @$elem.trigger('tree_picker:hide')


  listeningEvents: ->
    $elem = @$elem
    multiple = @opts.multiple
    canPickParent = @opts.canPickParent
    _this = @
    if @$pickerContainer
      $(document).off('click.tree_picker')
        .on('click.tree_picker', (e)->
          $target = $(e.target)
          unless $target.is('.tree-picker-container') or $target.closest('.tree-picker-container').length > 0
            $('.tree-picker').each ->
              op = $(this).data('tree_picker')
              op && op.hideView()
        )

      @$pickerContainer.off('.tree_picker')
        .on 'click.tree_picker', '.input-mocker', =>
          $('.tree-picker').not(@$elem).treePicker('hideView')
          if @$pickerContainer.is('.shown') then @hideView() else @showView();
          false
        .on 'click.tree_picker', 'li a', ->
          $this = $ this
          isLeaf = $this.closest('li').find('ul').length is 0
          if canPickParent or isLeaf
            id = $this.data('id')
            isSelected = !$this.is('.selected')
            $container = $this.closest('.tree-picker-container')

            unless id
              $elem.find('option').prop('selected', false)
              $container.find('ul a').removeClass('selected')
              $container.find('.input-mocker').text _this.opts.blankOption
              _this.hideView()
            else
              if multiple
                $elem.find("option[value='#{id}']").prop('selected', isSelected)
                if isSelected then $this.addClass('selected') else $this.removeClass('selected')
              else if isSelected
                $elem.find("option[value='#{id}']").prop('selected', true)
                $container.find('ul a').removeClass('selected')
                $this.addClass('selected')
                _this.hideView()
              else
                _this.hideView()

              $container.find('.input-mocker').text $container.find('a.selected').map(-> $(this).text()).get().join(', ')
            $elem.trigger('tree_picker:change').trigger('change')
          else
            $this.siblings('.item-icon').trigger('click.tree_picker')
          false
      .on 'click.tree_picker', '.item-icon', ->
        $this = $ this
        if $this.is('.fa-angle-right')
          $this.removeClass('fa-angle-right').addClass('fa-angle-down')
          $this.closest('li').addClass('open')
        else
          $this.addClass('fa-angle-right').removeClass('fa-angle-down')
          $this.closest('li').removeClass('open')
      .on 'keyup.tree_picker', '.query', _.debounce((e)=>
          @search(e.target.value)
      , 300)
  destroy: ->
    $(document).off('.tree_picker')
    @$pickerContainer.off('.tree_picker')

App.TreePicker.DEFAULTS = {
  url: ''
  blankOption: ''
  multiple: false
  canPickParent: true
  canResetCached: false
  childrenKey: 'children' # 孩子结点
}

App.TreePicker.cache = {}
App.TreePicker.resetCached = (uri)->
  if uri == "all"
    for k of @cache
      @cache[k] = null
  else if uri
    @cache[uri] = null

  return

$.fn.treePicker = (opts)->
  return this.each ->
    $this = $ this
    picker = $this.data('tree_picker')
    unless picker
      # opts1 = $this.data()
      # $.extend(opts1, opts) if typeof opts == 'object'
      picker = new App.TreePicker(this, opts)
      # console.log (picker)
      $this.data('tree_picker', picker)
    if (typeof opts is 'string')
      picker[opts]() if typeof picker[opts] is 'function'
