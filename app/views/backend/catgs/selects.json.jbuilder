if @select
  json.code 0
  json.message ""
  json.data do
    json.results do
        json.array! @catgs do |ca|
          json.id ca.id
          json.text ca.name
        end
    end
  end
else
  json.code 0
  json.message ""
  json.data do
    json.array! @catgs, partial: 'catg', as: :catg
  end
end
