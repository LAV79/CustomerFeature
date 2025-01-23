require 'rails_helper'
require_relative '../../app/interactions/users/create_user.rb'

RSpec.describe CreateUser do
  subject(:create_interests) { [ 'охота', 'боевые искусства', 'чтение' ].each { |i| Interest.create(name: i) } }
  subject(:create_skills) { [ 'усердие', 'трудолюбие', 'доброта' ]. each { |s| Skill.create(name: s) } }

  let(:email) { 'xxx@yyyy.com' }
  let(:gender) { 'male' }
  let(:age) { 45 }
  let(:params) { { name: 'Иван',
                  surname: 'Иванов',
                  patronymic: 'Иванович',
                  email: email,
                  age: age,
                  nationality: 'русский',
                  country: 'Москва',
                  gender: gender,
                  interests: [ 'охота', 'рыбалка' ],
                  skills: [ 'трудолюбие' ] } }
  let(:user) { CreateUser.run(params: params)  }

  it 'has been instantiated' do
    expect(user).to be_an(CreateUser)
  end

  it 'has been successful saved' do
    create_interests
    create_skills

    expect(user.valid?).to eq true
  end

  context 'adding interests and skills' do
    it 'has been successful saved' do
      expect { create_interests }.to change(Interest, :count).by(3)
      expect { create_skills }.to change(Skill, :count).by(3)
    end
  end


  context 'should see interest' do
    it 'has been successful saved' do
      create_interests
      create_skills
      expect(user.valid?).to eq true
      expect(user.result.interests.first.name).to eq 'охота'
    end
  end

  context 'should see skill' do
    it 'has been successful saved' do
      create_interests
      create_skills
      expect(user.result.skills.first.name).to eq 'трудолюбие'
    end
  end


  context 'user with this email already exists' do
    let!(:user_twice) { CreateUser.run(params: params)  }

    it 'error save' do
      expect(user.valid?).to eq false
      expect(user.errors.details[:params].first[:error]).to eq 'User with this email already exists'
    end
  end

  context 'not email' do

    it 'error save' do
      params.except!(:email)
      expect(user.valid?).to eq false
      expect(user.errors.details.inspect).to match(/params.email/)
    end
  end

  context 'age must be greater than zero' do
    let(:age) { -1 }

    it 'error save' do
      expect(user.valid?).to eq false
      expect(user.errors.details[:params].first[:error]).to eq 'Age must be greater than zero and less than or equal to 90'
    end
  end

  context 'age must be less than or equal to 90' do
    let(:age) { 91 }

    it 'error save' do
      expect(user.valid?).to eq false
      expect(user.errors.details[:params].first[:error]).to eq 'Age must be greater than zero and less than or equal to 90'
    end
  end

  context 'gender must be male or female' do
    let(:gender) { 'bot' }

    it 'error save' do
      expect(user.valid?).to eq false
      expect(user.errors.details[:params].first[:error]).to eq 'Gender must be male or female'
    end
  end
end
