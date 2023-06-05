class Api::V1::TestsController < ApplicationController

  # GET /tests
  def index
    @tests = Test.all
    render json: @tests
  end

  def create
    @test = Test.new(test_params)
    if @test.save
      render json: @test
    else
      render error: { error: 'Unable to create Test.'}, status: 400
    end
  end

  private

  def test_params
    params.require(:test).permit(:cat_name, :legs)
  end
end
