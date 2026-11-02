module Api
  module V1
    class IngredientsController < ApplicationController
      def index
        show_inactive = params[:inactive] == 1
        base = Ingredient.all
        base = show_inactive ? base.inactive : base.active
        ingredients = base.search(params[:q])
                          .by_category(params[:category])
                          .by_status(params[:status])
                          .order(:name)
                          .page(params[:page])
                          .per(10)
        # ingredients = Ingredient.all
        render_json(
          ingredients,
          meta: {
            show_inactive: show_inactive,
            page: ingredients.current_page,
            per_page: 10,
            total: ingredients.total_count,
            total_page: ingredients.total_page
          }
        )
      end
    end
  end
end