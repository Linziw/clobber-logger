class ItemController < ApplicationController
  get "/items" do
    if Helpers.is_logged_in?(session)
      @user = User.find_by_id(session[:user_id])
      @items = @user.items
      @cpwsorted = @items.sort_by { |item| Helpers.cost_per_wear(item) }
      erb :'users/index'
    else
      redirect to "/"
    end
  end

  get "/items/new" do
    if Helpers.is_logged_in?(session)
      erb :"items/new"
    else
      redirect to "/"
    end
  end

  post "/items" do
    @user = User.find_by_id(session[:user_id])
    if params[:name] == "" || params[:cost == ""]
      redirect to "/items/new"
    else
      @user.items << Item.create(params)
      redirect to "/items"
    end
  end

  get "/items/:id" do
    if Helpers.is_logged_in?(session)
      @item = Item.find_by_id(params[:id])
      redirect_if_not_auth(@item)
      @user = User.find_by_id(session[:user_id])
      @times_worn = Helpers.times_worn(@item)
      @cpw = Helpers.cost_per_wear(@item)
      @item_outfits = Helpers.item_outfits(session, @item)
      erb :"items/show"
    else
      redirect to "/"
    end
  end

  delete "/items/:id" do
    @item = Item.find_by_id(params[:id])
    if Helpers.is_logged_in?(session) && @item.user_id == session[:user_id]
      @item.destroy
      redirect to "/items"
    else
      redirect to "/"
    end
  end

  post "/items/:id/edit" do
    if Helpers.is_logged_in?(session)
      @item = Item.find_by_id(params[:id])
      @user = User.find_by_id(session[:user_id])
      erb :"items/edit"
    else redirect to "/"     end
  end

  get "/items/:id/edit" do
    if Helpers.is_logged_in?(session)
      @item = Item.find_by_id(params[:id])
      redirect_if_not_auth(@item)
      @user = User.find_by_id(session[:user_id])
      erb :"items/edit"
    else redirect to "/"     end
  end

  patch "/items/:id" do
    @item = Item.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id])
    if session[:user_id] != @item.user_id
      redirect to "/items"
    elsif params[:name] == "" || params[:cost] == "" || params[:category] == ""
      redirect to "/items/#{@item.id}/edit"
    else
      @item.name = params[:name]
      @item.cost = params[:cost]
      @item.image = params[:image]
      @item.category_id = params[:category_id]
      @item.save
      redirect to "/items"
    end
  end
end
