json.array!(@requests) do |request|
  json.extract! request, :id, :content, :post_id, :user_id
  json.url request_url(request, format: :json)
end
