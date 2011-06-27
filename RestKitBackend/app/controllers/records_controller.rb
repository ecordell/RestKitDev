class RecordsController < ApplicationController
  # GET /records
  # GET /records.xml
  def index
    @records = Record.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end
  end

  # GET /records/1
  # GET /records/1.xml
  def show
    @record = Record.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/new
  # GET /records/new.xml
  def new
    @record = Record.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/1/edit
  def edit
    @record = Record.find(params[:id])
  end

  # POST /records
  # POST /records.xml
  def create
    @record = Record.new(params[:record])

    respond_to do |format|
      if @record.save
        format.html { redirect_to(@record, :notice => 'Record was successfully created.') }
        format.xml  { render :xml => @record, :status => :created, :location => @record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /records/1
  # PUT /records/1.xml
  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        format.html { redirect_to(@record, :notice => 'Record was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.xml
  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to(records_url) }
      format.xml  { head :ok }
    end
  end
end
