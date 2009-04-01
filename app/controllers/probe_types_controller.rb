class ProbeTypesController < ApplicationController
  # GET /probe_types
  # GET /probe_types.xml
  def index
    @probe_types = ProbeType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @probe_types }
    end
  end

  # GET /probe_types/1
  # GET /probe_types/1.xml
  def show
    @probe_type = ProbeType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @probe_type }
    end
  end

  # GET /probe_types/new
  # GET /probe_types/new.xml
  def new
    @probe_type = ProbeType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @probe_type }
    end
  end

  # GET /probe_types/1/edit
  def edit
    @probe_type = ProbeType.find(params[:id])
  end

  # POST /probe_types
  # POST /probe_types.xml
  def create
    @probe_type = ProbeType.new(params[:probe_type])

    respond_to do |format|
      if @probe_type.save
        flash[:notice] = 'ProbeType was successfully created.'
        format.html { redirect_to(@probe_type) }
        format.xml  { render :xml => @probe_type, :status => :created, :location => @probe_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @probe_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /probe_types/1
  # PUT /probe_types/1.xml
  def update
    @probe_type = ProbeType.find(params[:id])

    respond_to do |format|
      if @probe_type.update_attributes(params[:probe_type])
        flash[:notice] = 'ProbeType was successfully updated.'
        format.html { redirect_to(@probe_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @probe_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /probe_types/1
  # DELETE /probe_types/1.xml
  def destroy
    @probe_type = ProbeType.find(params[:id])
    @probe_type.destroy

    respond_to do |format|
      format.html { redirect_to(probe_types_url) }
      format.xml  { head :ok }
    end
  end
end
