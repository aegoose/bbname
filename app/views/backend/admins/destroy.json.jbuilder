if @isError
  json.code 1
  json.message "删除失败"
  json.data []
else
  json.code 0
  json.message ""
  json.data do
    json.partial! "admin", admin: @admin
  end
end
