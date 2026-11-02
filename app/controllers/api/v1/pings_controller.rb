module Api
  module V1
    class PingsController < ApplicationController
      def show
        render json: {
          status: "ok",
          service: "rails-api-service",
          time: Time.current
        }
      end

      def calculate
        a = params[:a]
        b = params[:b]
        operation = params[:operation]

        a = Float(a)
        b = Float(b)

        result = 
        case operation
        when "add" then a + b
        when "subtract" then a - b
        when "multiply" then a * b
        when "divide" then
          if b == 0
            render json: {
              status: "error",
              message: "Division by zero"
            }, status: :bad_request
            return
          end
          a / b
        end  
        render json:{
          status: "completed",
          a: a,
          b: b,
          operation: operation,
          result: result
        }
      end
    end
  end
end