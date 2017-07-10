json.extract! reaction, :id, :user_id, :vulnerability_id, :status, :text, :created_at, :updated_at
json.url reaction_url(reaction, format: :json)
