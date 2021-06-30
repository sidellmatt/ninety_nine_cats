require 'action_view'


class Cat < ApplicationRecord

    include ActionView::Helpers::DateHelper

    SEXES = ["M", "F"]
    COLORS = ["black", "white", "gray", "tabby", "calico"]

    validates :birth_date, presence: true
    validates :color, presence: true, inclusion: {in: COLORS}
    validates :name, presence: true
    validates :sex, presence: true, inclusion: {in: SEXES, message: "Gender is a construct, just choose one of the two options presented and play pretend for a minute."}
    validates :description, presence: true

    has_many :cat_rental_requests, dependent: :destroy

    def age
        # today = Date.today.to_s.split("/")
        # tyear = today[0].to_i
        # tmonth = today[1].to_i
        # tday = today[2].to_i

        # birth_date = self.birth_date.to_s.split("/")
        # byear = birth_date[0].to_i
        # bmonth = birth_date[1].to_i
        # bday = birth_date[2].to_i

        # age = "tbd"
        
        # if tmonth > bmonth
        #     age = tyear - byear
        # elsif tmonth < bmonth
        #     age = (tyear - byear) - 1
        # else
        #     if tday >= bday
        #         age = tyear - byear
        #     else
        #         age = (tyear - byear) - 1
        #     end
        # end

        # age

        time_ago_in_words(self.birth_date)
    end
    

end