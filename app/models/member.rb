class Member < ApplicationRecord
    has_many :contacts, dependent: :delete_all
    scope :order_member, -> { order('generation').order('last_kana COLLATE "C" ASC').order('first_kana COLLATE "C" ASC') }
    scope :can_receive_email, ->(practice) do
        where.not(email: [nil, ''])
    end
    scope :obog, -> { where("generation < ?", 12) }
    scope :valid_members, ->(practice) do
        if practice.includes_obog
            where(leave_on_absence: false)
        else
            where(leave_on_absence: false).where("generation >= ?", 12)
        end
    end

    validates :last_kana, format: { with: /\A[ァ-ヶ]+\z/}
    validates :first_kana, format: { with: /\A[ァ-ヶ]+\z/}

    def full_name
        return self.last_name + " " + self.first_name
    end

    def full_name_kana
        if last_kana != nil and first_kana
            return self.last_kana + " " + self.first_kana
        else
            return ""
        end
    end

    def display_name
        return self.full_name + " (" + self.generation.to_s + "期）"
    end

    def display_nickname(includes_generation, includes_honorific)
        if includes_generation
            if self.nickname.blank?
                return self.full_name + (includes_honorific ? "さん" : "") + " (" + self.generation.to_s + "期）"
            else
                return self.nickname + (includes_honorific ? "さん" : "") + " (" + self.generation.to_s + "期）"
            end
        else
            if self.nickname.blank?
                return self.full_name + (includes_honorific ? "さん" : "")
            else
                return self.nickname + (includes_honorific ? "さん" : "")
            end
        end
    end

    def is_obog
        if self.generation < 12
            return true
        else
            return false
        end
    end
end
