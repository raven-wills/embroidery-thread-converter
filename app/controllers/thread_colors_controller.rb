class ThreadColorsController < ApplicationController
  def index
    @brands = ThreadColor::BRAND_NAMES
    @conversion_results = []

    if params[:convert].present?
      @from_brand = params[:from_brand]
      @to_brand = params[:to_brand]
      @thread_numbers = params[:thread_numbers]

      if valid_conversion_params?
        @conversion_results = ThreadColor.convert_threads(
          @from_brand, @to_brand, @thread_numbers
        )
      else
        flash.now[:alert] = "Please select different brands and enter thread numbers"
      end
    end
  end

  # API endpoint for AJAX conversions (for future use)
  def convert
    results = ThreadColor.convert_threads(
      params[:from_brand],
      params[:to_brand],
      params[:thread_numbers]
    )

    render json: {
      results: results,
      from_brand: ThreadColor::BRAND_NAMES[params[:from_brand]],
      to_brand: ThreadColor::BRAND_NAMES[params[:to_brand]]
    }
  end

  private

  def valid_conversion_params?
    params[:from_brand].present? &&
    params[:to_brand].present? &&
    params[:thread_numbers].present? &&
    params[:from_brand] != params[:to_brand]
  end
end
