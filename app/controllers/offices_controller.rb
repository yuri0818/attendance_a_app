class OfficesController < ApplicationController
  before_action :set_office, only: [ :edit, :update, :destroy,]
  
   def index
     @offices = Office.all 
     @office = Office.new
   end       

   def show
   end 
   

   
   def create
      @office = Office.create(office_params)
    if @office.save
       flash[:info] = "拠点情報を追加しました。"
      redirect_to offices_url
    else 
      render :index
    end
   end

   
   def edit
   end
   
   def update
    if @office.update_attributes(office_params)
      flash[:success] =  "#{@office.id}の情報を更新しました。"
      redirect_to offices_url
    else
      redirect_to offices_url
    end
   end
   
   def destroy
    @office.destroy
     flash[:success] = "#{@office.id}のデータを削除しました。"
    redirect_to  @office
   end       
    
    private
     # paramsハッシュからユーザーを取得します。
    def set_office
      @office = Office.find(params[:id])
    end
    
   
    def office_params
      params.require(:office).permit(:office_name, :office_number, :office_type)
    end
end
