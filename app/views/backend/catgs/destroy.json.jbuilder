if @isError
  json.code 1
  json.message "更新失败"
  json.data []
else
  json.code 0
  json.message ""
  json.data do
    json.partial! "admin/product_skus/product_sku", product_sku: @product_sku
  end
end
