if @isError
  json.code 1
  json.message "更新失败"
  json.data []
else
  json.code 0
  json.message ""
  json.data do
    json.partial! "catg", catg: @catg
  end
end
