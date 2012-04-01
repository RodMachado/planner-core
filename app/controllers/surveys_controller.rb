class SurveysController < PlannerController
  def index
    @surveys = Survey.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  def show
    @survey = Survey.find params[:id]

    render :layout => 'content'
  end

  def new
    @survey = Survey.new
    render :layout => 'content'
  end

  def edit
    @survey = Survey.find params[:id]

    render :layout => 'content'
  end

  def update
    @survey = Survey.find params[:id]

    if @survey.update_attributes(params[:survey])
      # Go back to the main page
      @surveys = Survey.all
      render :survey_list, :layout => 'plain'
    else
      render :action => 'edit', :status => 500, :layout => 'content'
    end
  end

  def destroy
    @survey = Survey.find params[:id]
    @survey.destroy
    # redirect_to :action => 'index'
      @surveys = Survey.all
          render :survey_list, :layout => 'plain'
  end

  def create
    @survey = Survey.new params[:survey]
    if @survey.save
      @surveys = Survey.all
      render :survey_list, :layout => 'plain'
    else
      render :action => 'new'
    end
  end

end