class ExecutiveUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :can_receive_email, ->(practice) do
    case practice.kind
    when 'run_thru'
      where(receive_email: true).where.not(email: [nil, ''])
    else
      where(receive_email: true).where.not(email: [nil, '']).where.not(position: 'subsection_cheif')
    end
  end
  #nameを必須・一意とする
  validates_uniqueness_of :user_id
  validates_presence_of :user_id

  #登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end

  enum position: {
    other: 0,
    chief: 1,
    vice_chief: 2,
    accountant: 3,
    public_relations: 4,
    assistant: 5,
    coach: 6,
    vice_coach: 7,
    subsection_cheif: 8
  }
end
