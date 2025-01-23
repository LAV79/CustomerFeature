class CreateUser < ActiveInteraction::Base
  hash :params do
    string :name
    string :patronymic
    string :email
    integer :age
    string :nationality
    string :country
    string :gender
    array :interests, default: []
    array :skills, default: []
  end

  validate :check_params

  def execute
    user = User.new(params.except(:interests).except(:skills))
    user.interests = Interest.where(name: params[:interests])
    user.skills = Skill.where(name: params[:skills])
    user.save
    user
  end

  private

  def check_params
    errors.add(:params, 'Age must be greater than zero and less than or equal to 90') if params[:age] <= 0 || params[:age] > 90
    errors.add(:params, 'User with this email already exists') unless User.where(email: params[:email]).blank?
    errors.add(:params, 'Gender must be male or female') unless params[:gender].in?([ 'male', 'female' ])
  end
end
