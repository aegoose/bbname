# coding: utf-8
#
module ApiCatgErrors
  include ApiExceptions

  self.class_error_code = 20

  define_error_class 'CatgNotFound', 10, '找不到类别%s'
  define_error_class 'CatgUpdateFail', 20, '更新类别失败%s'
  define_error_class 'CatgTagKeyUpdateError', 20, '更新类别关键字有误%s'
  define_error_class 'CatgTagKeyImportError', 30, '导入类型有误%s'

end
