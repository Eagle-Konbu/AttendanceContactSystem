json.extract! line_reply_message, :id, :detail, :created_at, :updated_at
json.url line_reply_message_url(line_reply_message, format: :json)
