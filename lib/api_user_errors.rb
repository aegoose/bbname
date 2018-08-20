# coding: utf-8
#
module ApiUserErrors
  include ApiExceptions

  self.class_error_code = 10

  define_error_class 'AdminNotActived', -1, '用户(%s)未激活'
  # define_error_class 'UserCantOrder', 7, '用户存在进行中订单, 暂时不能预约'
  define_error_class 'AdminNotFound', 10, '找不到用户(%s)'
  define_error_class 'AdminUpdateError', 20, '更新失败%s'
  define_error_class 'AdminDestroyError', 8888, '删除失败%s'


  define_error_class 'BranchUpdateError', 10, '更新失败%s'
  define_error_class 'BranchDeleteError', 11, '删除失败%s'
end
