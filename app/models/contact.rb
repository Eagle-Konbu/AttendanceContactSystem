class Contact < ApplicationRecord
    belongs_to :member
    belongs_to :practice
    enum status:{
        attend: 0,
        absent: 1,
        late: 2,
        go_early: 3,
        other: 4,
        unknown: 5
    }

    validates :member_id, presence: true
    validates :practice_id, presence: true
    validates :status, presence: true
    validates :reason, presence: true, unless: :attend?
end