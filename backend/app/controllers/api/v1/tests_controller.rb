class Api::V1::TestsController < Api::V1::ApiController

  # GET /tests
  def index
    @tests = Test.all
    render json: {total_count: @tests.count, data: @tests}
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
