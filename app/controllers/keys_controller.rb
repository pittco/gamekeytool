class KeysController < ApplicationController
  before_filter :require_localhost, :except => ['claim_one','claim_prompt']

  def require_localhost
    if request.remote_ip != "127.0.0.1"
      flash[:error] = "Don't do stupid things."
      redirect_to claim_path
      return false
    else
      return true
    end
  end
  # GET /keys
  # GET /keys.json
  def index
    @keys = Key.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @keys }
    end
  end

  # GET /keys/1
  # GET /keys/1.json
  def show
    @key = Key.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @key }
    end
  end

  # GET /keys/new
  # GET /keys/new.json
  def new
    @key = Key.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @key }
    end
  end

  # GET /keys/1/edit
  def edit
    @key = Key.find(params[:id])
  end

  #GET /claim
  def claim_prompt
    @key = Key.for(request.remote_ip)

    if Key.unclaimed.empty?
      @none_available = true
    end
  end 

  #POST /claim
  def claim_one
    respond_to do |format|
      if !Key.unclaimed.empty?
        @key = Key.unclaimed.first
        @key.claimed_by = request.remote_ip
        if @key.save
          format.html {redirect_to claim_path }
        else
          format.html {redirect_to claim_path, notice: "Could not save the claim. Contact staff."}
        end
      else
        format.html {redirect_to claim_path, notice: "No more keys are available."}
      end
    end
  end


  #POST /bulk_keys
  def bulk_create
    @keys = params[:keys].split("\n").filter{|k|k.empty?}
    @keys.collect do |key|
      @key = Key.new keystring: key.strip!
      if @key.save
        nil
      else
        key
      end
    end

    @unsaved = @keys.select {|k| k.nil?}

    respond_to do |format|
      if !@unsaved.empty?
        format.html {redirect_to new_key_path, notice: "Some keys errored: #{@unsaved.join("\n")}"}
      else
        format.html { redirect_to keys_path }
      end
    end
  end
    


  # POST /keys
  # POST /keys.json
  def create
    @key = Key.new(params[:key])

    respond_to do |format|
      if @key.save
        format.html { redirect_to @key, notice: 'Key was successfully created.' }
        format.json { render json: @key, status: :created, location: @key }
      else
        format.html { render action: "new" }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /keys/1
  # PUT /keys/1.json
  def update
    @key = Key.find(params[:id])

    respond_to do |format|
      if @key.update_attributes(params[:key])
        format.html { redirect_to @key, notice: 'Key was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keys/1
  # DELETE /keys/1.json
  def destroy
    @key = Key.find(params[:id])
    @key.destroy

    respond_to do |format|
      format.html { redirect_to keys_url }
      format.json { head :no_content }
    end
  end
end
