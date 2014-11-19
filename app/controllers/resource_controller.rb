#
#
#
class ResourceController < PlannerController

  before_filter :load_resource

  respond_to :json
  
  def create
    begin
      @object.save!
      render json: @object.to_json, :content_type => 'application/json' if !lookup_context.exists? :create, params[:controller]
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end
  
  def show
    render json: @object.to_json, :content_type => 'application/json' if !lookup_context.exists? :show, params[:controller]
  end
    
  def update
    begin
      @object.update_attributes params[object_name]
      render json: @object.to_json, :content_type => 'application/json' if !lookup_context.exists? :update, params[:controller]
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end
  
  def destroy
    begin
      @object.destroy
      render status: :ok, text: {}.to_json
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end

  protected
    def action
      params[:action].to_sym
    end

    def collection
      model_class.scoped
    end
    
    def model_name
       "#{controller_name.classify}".downcase.singularize
    end

    def model_class
      self.class.name.sub('Controller', '').singularize.constantize
      # "#{controller_name.classify}".constantize
    end

    def object_name
      controller_name.singularize
    end

    def load_resource
      if member_action?
        @object ||= load_resource_instance

        instance_variable_set("@#{object_name}", @object)
      else
        @collection ||= collection

        instance_variable_set("@#{controller_name}", @collection)
      end
    end

    def load_resource_instance
      if new_actions.include?(action)
        build_resource
      elsif params[:id]
        find_resource
      end
    end
    
    def find_resource
      model_class.find(params[:id])
    end
  
    def build_resource
      model_class.new params[object_name] #"#{model_name}"]
    end
    
    def collection_actions
      [:index]
    end

    def member_action?
      !collection_actions.include? action
    end

    def new_actions
      [:new, :create]
    end
end