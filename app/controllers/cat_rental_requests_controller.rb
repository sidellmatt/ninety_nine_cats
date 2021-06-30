class CatRentalRequestsController < ApplicationController

    def new
        @cat_rental_request = CatRentalRequest.new
        @cats = Cat.all
        render :new, cats: @cats
    end

    def create
        @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
        if @cat_rental_request.save
            redirect_to cat_url(cat_rental_request_params[:cat_id])
        else
            @cats = Cat.all
            render :new, cats: @cats
        end
    end

    def approve
        @cat_rental_request = CatRentalRequest.find(params[:id])
        @cat = Cat.where('params[:cat_id] = ?', 'cat.id')
        @cats = Cat.all
        @cat_rental_request.approve!
        render :show, cat: @cat, cats: @cats, cat_rental_request: @cat_rental_request
    end

    def deny
        @cat_rental_request = CatRentalRequest.find(params[:id])
        @cat = Cat.where('params[:cat_id] = ?', 'cat.id')
        @cats = Cat.all
        @cat_rental_request.deny!
        render :show, cat: @cat, cats: @cats, cat_rental_request: @cat_rental_request
    end

    private

    def cat_rental_request_params
        params.require(:cat_rental_request).permit(:id, :cat_id, :start_date, :end_date, :status)
    end

end