class CatRentalRequest < ApplicationRecord

    PSTATUS = ["PENDING", "APPROVED", "DENIED"]

    validates :cat_id, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true
    validates :status, presence: true, inclusion: {in: PSTATUS}

    belongs_to :cat

    def overlapping_requests
        CatRentalRequest.where.not("start_date > ? OR end_date < ? OR id = ?", self.end_date, self.start_date, self.id)
    end
    
    def overlapping_approved_requests
        self.overlapping_requests.where("status = ?", "APPROVED")
    end

    def does_not_overlap_approved_request
        if self.overlapping_approved_requests.where('cat_id = ?', self.cat_id).exists?
            self.errors.add(:base, "Cannot overlap with an approved request")
        end
    end

    def does_not_start_after_it_ends
        if self.start_date > self.end_date
            self.errors.add(:base, "Start date must be before end date")
        end
    end

    def overlapping_pending_requests
        self.overlapping_requests.where("status = ?", "PENDING")
    end

    def deny!
        self.status = "DENIED"
        self.save!
    end

    def approve!
        if self.overlapping_pending_requests.length > 0
            self.overlapping_pending_requests.transaction do |request|
                request.deny!
                request.save
            end
        end
        self.status = "APPROVED"
        self.save!
    end
    
    def pending?
        self.status == "PENDING"
    end


    validate :does_not_overlap_approved_request
    validate :does_not_start_after_it_ends

end