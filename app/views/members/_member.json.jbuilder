json.extract! member, :id, :first_name, :last_name, :nickname, :generation, :created_at, :updated_at
json.url member_url(member, format: :json)
