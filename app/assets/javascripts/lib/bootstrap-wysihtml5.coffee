#= require bootstrap-wysihtml5.js
#= require bootstrap-wysihtml5/locales/zh-CN.js

# $('#some-textarea').wysihtml5({
#   toolbar: {
#     "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
#     "emphasis": true, //Italics, bold, etc. Default true
#     "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
#     "html": false, //Button which allows you to edit the generated HTML. Default false
#     "link": true, //Button to insert a link. Default true
#     "image": true, //Button to insert an image. Default true,
#     "color": false, //Button to change color of font
#     "blockquote": true, //Blockquote
#     "size": <buttonsize> //default: none, other options are xs, sm, lg
#   }
# });

$.fn.wysihtml5.locale["zh-CN"]['emphasis']['small'] = "小1号"

$.fn.extend
  # 切换上传按钮/图片
  openWysihtml5: (force=false)->
    tag = $(this).prop("tagName")

    # 只针对input和textarea
    return unless tag not in ["input", "textarea"]
    # 不强制时，若已存在，则不处理
    wy = $(this).data("wysihtml5")
    return if !force && wy?

    # 强制刷新要删除再处理
    $(this).destroyWysihtml5() if force

    # 调用editor
    wxSize = $(this).data("size")
    wxSize = "sm" unless wxSize?
    $(this).wysihtml5
      locale: "zh-CN"
      toolbar:
        fa: true
        # "font-styles": true,  # 段落类型
        # lists: true           # 列表支持
        # link: true            # 支持链接
        # image: true           # 支持图片
        # html: true            # [false], true
        color: true             # [false], true
        blockquote: false       # [true], false
        size: wxSize            # [none], xs, sm, lg
    return

  destroyWysihtml5: ->
    # 不存在则不处理
    wy = $(this).data("wysihtml5")
    return unless wy?

    $(wy.editor.toolbar.container).remove()
    $(wy.editor.currentView.editableArea).remove()
    $txtarea = $(wy.editor.editableElement).show()
    $txtarea.siblings("[name=_wysihtml5_mode]").remove()
    delete $(this).data().wysihtml5

    return

$.onmount '.wy-editor', ->
  $(this).each (i, elem) ->
    $(elem).openWysihtml5()
  return
