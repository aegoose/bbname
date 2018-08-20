
window.App = window.App || {}

App.Adminlte = (->
  return {
    reload: ->
      $.AdminLTE.layout.activate()
      # $('[data-widget="box-refresh"]')
      # $('[data-widget="tree"]').tree()
      # $('[data-widget="box-refresh"]').boxRefresh()
      # $('.box').boxWidget()
      # $('[data-toggle="control-sidebar"]').controlSidebar()
      # $('[data-widget="chat-pane-toggle"]').directChat()
      # $('body').layout()
      # $('[data-toggle="push-menu"]').pushMenu()
      # $('[data-widget="todo-list"]').todoList()
      # $('[data-widget="tree"]').tree()
  }
)()
