class LineItemsController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: :create
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  #never trust parameters from the scary internet
  def line_items_params
    params.require(:line_item).permit(:product_id)
  end
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    #@line_item = @cart.line_items.build(product: product)
    @line_item = @cart.add_product(product)
    
    respond_to do |format|
      #cada vez que acrescentamos um item a lista, zeramos o contador de passagem pelo store controller
      session[:counter]=0;
      if @line_item.save
        #format.html { redirect_to @line_item.cart}
        format.html { redirect_to store_index_url}
        #format.js {@current_item = @line_item}
        #format.js 
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    #debugger
    if @line_item.quantity>1
      @line_item.quantity -=1
      @line_item.save!
      #new_line_item_quantity = @line_item.quantity-1
      #@line_item.update(quantity: new_line_item_quantity)
      respond_to do |format|
        format.html { redirect_to store_index_url, notice: 'Line item was successfully updated.' }
        #format.js
        format.json { render :show, status: :ok, location: @line_item }
      end
    else
      @line_item.destroy
      respond_to do |format|
        #ao apagar uma linha, retorna para a tela de cart, mostrando os itens remanescentes
        format.html { redirect_to store_index_url, notice: 'Line item was successfully updated.' }
        format.js
        #format.html { redirect_to cart_path(@line_item.cart), notice: 'Line item was successfully destroyed or subtracted.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      #debugger
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
