if @isError
  json.code 1
  json.message @errmsg || "导入失败"
  json.data []
else
  json.code 0
  json.message @errmsg
  json.data []
end
