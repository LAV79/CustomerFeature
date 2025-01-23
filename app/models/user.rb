class User < ApplicationRecord
	has_and_belongs_to_many :skills
	has_and_belongs_to_many :interests

	def user_full_name = "#{surname} #{name} #{patronymic}"
end
