class FindingsController < ApplicationController
  protect_from_forgery with: :exception

  def update
    f = Finding.find(params[:id])
    if f.update(finding_params)
      render json: { ok: true }
    else
      render json: { ok: false, errors: f.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def finding_params
    params.require(:finding).permit(:label, :value, :date, :confidence)
  end
end
