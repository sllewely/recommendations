class Api::V1::MediaController < Api::V1::ApiController

  def index
    @media = current_user.media
    render json: {total_count: @media.count, data: @media}
  end

  def create
    @medium = Medium.new(medium_params.merge!(user_id: current_user.id))
    # Create UserMedia
    # Find or Create media
    # Use media type
    
    if @medium.save
      render json: @medium
    else
      render error: { error: 'Unable to create Medium.'}, status: 400
    end
  end


  private

  def medium_params
    params.require(:media).permit(:name, user_medium_attributes: [:notes])
  end



end