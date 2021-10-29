class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    before_save   :downcase_email
    before_create :create_activation_digest
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    private

        # メールアドレスをすべて小文字にする
        def downcase_email
            self.email = email.downcase
        end

        # 有効化トークンとダイジェストを作成および代入する
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
