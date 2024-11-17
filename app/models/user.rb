class User < ApplicationRecord
  class User < ApplicationRecord
    # Deviseモジュール
    devise :database_authenticatable, :registerable, :validatable

    # JWT認証用メソッド
    def generate_jwt
      payload = { user_id: id, exp: 1.week.from_now.to_i }
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end
  end
end
