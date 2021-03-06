class ProgrammeItemsController < PlannerController
  include ProgramPlannerHelper
  #
  # Get the all the program items for a given person
  #
  def index
    if params[:person_id] # then we only get the items for a given person
      @person = Person.find(params[:person_id])
      @assignments = @person.programmeItemAssignments.includes({:programmeItem => [:time_slot, :people]}).order('time_slots.start asc').collect{|a| (a.programmeItem != nil) ? a : nil}.compact
    end
  rescue => ex
    render status: :bad_request, text: ex.message
  end

  #
  # Drop the given person from all their program items
  #
  def drop
    if params[:person_id]
      # Remove the person from the programme
      @person = Person.find(params[:person_id])

      @person.programmeItemAssignments.each do |assign|
        progitem = assign.programmeItem
        assign.destroy
        
        progitem.id_will_change! # NOTE: this will force the update date of the programme item to be changed
        progitem.save
      end

    end

    render status: :ok, text: {}.to_json
  rescue => ex
    render status: :bad_request, text: ex.message
  end
  
  #
  # Return a program item given an id
  #  
  def show
    @extra_item_json = [] if ! @extra_item_json
    @programmeItem = ProgrammeItem.find(params[:id])
    
    # Order these by last name
    @invisibleAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id =?',@programmeItem,PersonItemRole['Invisible']], :include => {:person => :pseudonym}, :order => "people.last_name"
    @moderatorAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id = ?', @programmeItem, PersonItemRole['Moderator']], :include => {:person => :pseudonym}, :order => "people.last_name"
    @participantAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id = ?', @programmeItem, PersonItemRole['Participant']] , :include => {:person => :pseudonym}, :order => "people.last_name"
    @reserveAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id = ?', @programmeItem, PersonItemRole['Reserved']] , :include => {:person => :pseudonym}, :order => "people.last_name"
  rescue => ex
    render status: :bad_request, text: ex.message
  end

  #
  # Create a new program item
  #  
  def create
    @extra_item_json = [] if ! @extra_item_json
    plain = params[:plain]
    # NOTE - name of the programmeItem passed in from form
    startTime = (params[:start_time] && params[:start_time].to_datetime) ? (params[:start_time].to_datetime + zone_delta(params[:start_time].to_datetime)) : nil
    startDay = -1
    startDay = (startTime - Time.zone.parse(SiteConfig.first.start_date.to_s).to_datetime).to_i if startTime
    roomId = params[:room_id]
    parent_id = params[:parent_id]

    begin
      ProgrammeItem.transaction do
        @programmeItem = ProgrammeItem.new(params[:programme_item])
        @programmeItem.lock_version = 0
        if @programmeItem.save
          if (startDay.to_i > -1) && startTime #&& (roomId.to_i > 0)
            room = nil
            room = Room.find(roomId) if roomId.to_i > 0 && !@programmeItem.is_break
            addItemToRoomAndTime(@programmeItem, room, startDay, startTime)
          end
        end

        if parent_id
          @programmeItem.parent_id = parent_id
          @programmeItem.save!

          if @programmeItem.parent
            @programmeItem.parent.touch
            @programmeItem.parent.save
          end
        end

        _after_save(@programmeItem)
      end
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end

  #
  # Update a program item based on the inputs
  #  
  def update
    @extra_item_json = [] if ! @extra_item_json
    startTime = (params[:start_time] && params[:start_time].to_datetime) ? (params[:start_time].to_datetime + zone_delta(params[:start_time].to_datetime)) : nil
    startDay = -1
    startDay = (startTime - Time.zone.parse(SiteConfig.first.start_date.to_s).to_datetime).to_i if startTime
    roomId = params[:room_id]
    parent_id = params[:parent_id]
    
    begin
      ProgrammeItem.transaction do
        @programmeItem = ProgrammeItem.find(params[:id])

        if @programmeItem.parent
          @programmeItem.parent.touch
          @programmeItem.parent.save
        end

        if @programmeItem.update_attributes(params[:programme_item])
          
          if (startDay.to_i > -1) && startTime #&& (roomId.to_i > 0)
            room = nil
            room = Room.find(roomId) if roomId.to_i > 0 && !@programmeItem.is_break
            addItemToRoomAndTime(@programmeItem, room, startDay, startTime)
          else
            if (@programmeItem.room_item_assignment)
               @programmeItem.room_item_assignment.destroy
            end
          end
          
          ts = @programmeItem.time_slot
          if (ts)
            ts.end = ts.start + @programmeItem.duration.minutes
            ts.save
          end
        end
        
        if parent_id
          @programmeItem.parent_id = parent_id
          @programmeItem.save!

          if @programmeItem.parent
            @programmeItem.parent.touch
            @programmeItem.parent.save
          end
        end
        
        _after_save(@programmeItem)
      end
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end
  
  #
  # Destroy the given program item
  #
  def destroy
    programmeItem = ProgrammeItem.find(params[:id])

    begin
      ProgrammeItem.transaction do
        programmeItem.destroy
    
        render status: :ok, text: {}.to_json
      end
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end
  
  #
  #
  #
  def list
    limit = params[:limit] ? params[:limit].to_i : nil
    offset = params[:offset] ? params[:offset].to_i : nil
    search = params[:search] ? params[:search] : nil
    include_breaks = params[:no_breaks] == nil

    sort_by = params[:sort] ? params[:sort] : 'title'
    sort_order = params[:order] ? params[:order] : 'asc'

    if search
      query = ["parent_id is null AND is_break is false AND title like ?", '%' + search + '%'] 
      query = ["parent_id is null AND title like ?", '%' + search + '%'] if include_breaks
    else
      query = ["parent_id is null AND is_break is false"]
      query = ["parent_id is null"] if include_breaks
    end

    @total = ProgrammeItem.where(query).count
    @items = ProgrammeItem.where(query).offset(offset).limit(limit).order(sort_by + ' ' + sort_order)

  end
  
  #
  #
  #
  def get_children
    id = params[:id]
    order = params[:sord]
    rows = params[:rows] ? params[:rows].to_i : 15
    @page = params[:page] ? params[:page].to_i : 1
    page_to = params[:page_to]

    sort_by = params[:sort] ? params[:sort] : 'title'
    sort_order = params[:order] ? params[:order] : 'asc'
    
    item = ProgrammeItem.find id

    if item
      @count = item.children.size
      if page_to && !page_to.empty?
        gotoNum = item.children.where(['programme_items.title <= ?', page_to]).size
        if gotoNum
          @page = (gotoNum / rows.to_i).floor
          @page += 1 if gotoNum % rows.to_i > 0
        end
      end
    
      @items = item.children.offset(rows*(@page -1)).limit(rows).order(sort_by + ' ' + sort_order)
    end

    if rows.to_i > 0
      @nbr_pages = (@count / rows.to_i).floor
      @nbr_pages += 1 if @count % rows.to_i > 0
    else
      @nbr_pages = 1
    end

  end

  #
  # Get list of program items...
  #  
  def getList
    rows = params[:rows] ? params[:rows] : 15
    @page = params[:page] ? params[:page].to_i : 1
    idx = params[:sidx]
    order = params[:sord]
    context = params[:context]
    theme_ids = params[:theme_ids] ? params[:theme_ids].split(",") : nil
    tags = params[:tags]
    nameSearch = params[:namesearch]
    filters = params[:filters]
    extraClause = params[:extraClause]
    include_children = params[:include_children] ? (params[:include_children] == 'true') : true

    @currentId = params[:current_selection]
    @currentId = nil if ! ProgrammeItem.exists? @currentId
    page_to = params[:page_to]
    
    ignoreScheduled = params[:igs] == 'true' # TODO
    ignorePending = params[:igp] == 'true'

    @count = ProgramItemsService.countItems filters, extraClause, nameSearch, context, tags, theme_ids, ignoreScheduled, include_children
    
    if page_to && !page_to.empty?
      gotoNum = ProgramItemsService.countItems filters, extraClause, nameSearch, context, tags, theme_ids, ignoreScheduled, include_children, page_to
      if gotoNum
        @page = (gotoNum / rows.to_i).floor
        @page += 1 if gotoNum % rows.to_i > 0
      end
    end

    if rows.to_i > 0
      @nbr_pages = (@count / rows.to_i).floor
      @nbr_pages += 1 if @count % rows.to_i > 0
    else
      @nbr_pages = 1
    end
    
    @items = ProgramItemsService.findItems rows, @page, idx, order, filters, extraClause, nameSearch, context, tags, theme_ids, ignoreScheduled, include_children
  end

  #
  # Update the participants associated with this programme item
  #  
  def updateParticipants
    @extra_item_json = [] if ! @extra_item_json
    programmeItem = ProgrammeItem.find(params[:id])

    begin
      ProgrammeItem.transaction do
        # 1. Clear out the current set of participants    
        programmeItem.people.clear # remove it from the person.
        programmeItem.id_will_change! # NOTE: this will force the update date of the programme item to be changed
        programmeItem.save
    
        # 2. Create the new sets
        addParticipant(programmeItem.id, params['moderators'],PersonItemRole['Moderator'])
        addParticipant(programmeItem.id, params['participants'],PersonItemRole['Participant'])
        addParticipant(programmeItem.id, params['reserves'],PersonItemRole['Reserved'])
        addParticipant(programmeItem.id, params['invisibles'],PersonItemRole['Invisible'])
        
        @programmeItem = ProgrammeItem.find(params[:id])
        @invisibleAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id =?',@programmeItem,PersonItemRole['Invisible']], :include => {:person => :pseudonym}
        @moderatorAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id = ?', @programmeItem, PersonItemRole['Moderator']], :include => {:person => :pseudonym}
        @participantAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id = ?', @programmeItem, PersonItemRole['Participant']] , :include => {:person => :pseudonym}
        @reserveAssociations = ProgrammeItemAssignment.find :all, :conditions => ['programme_item_id = ? AND role_id = ?', @programmeItem, PersonItemRole['Reserved']] , :include => {:person => :pseudonym}
      end
    rescue => ex
      render status: :bad_request, text: ex.message
    end
  end
  
  # ---------------------------------
  def assign_reference_numbers
    ProgrammeItem.transaction do
      ProgramItemsService.assign_reference_numbers
    end
  end
  
private

  def _after_save(item)
    if item.respond_to? :update_themes
      if !item.is_break
        theme_names = params[:theme_name_ids].split(",") # comma seperated list, split into ids
        item.update_themes theme_names
      else  
        item.update_themes []
      end
    end
  end

  def zone_delta(_time)
    start_offset = Time.zone.parse(SiteConfig.first.start_date.to_s).to_datetime.in_time_zone.utc_offset
    item_offset = _time.in_time_zone.utc_offset
    ((start_offset - item_offset)/60).minutes
  end
  
  #
  #
  #
  def addParticipant(itemid, participants, role)
    if participants
      participants.each do |personHash|
        p = Person.find(personHash['id'])
        assignment = ProgrammeItemAssignment.create(:programme_item_id => itemid, :person => p, :role => role)
        assignment.save
      end
    end
  end
  
 
end
