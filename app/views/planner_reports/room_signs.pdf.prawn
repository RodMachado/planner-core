require "prawn/measurement_extensions"

prawn_document(:page_size => @page_size, :page_layout => @orientation) do |pdf|
    render "font_setup", :pdf => pdf

    page_height = pdf.bounds.top_right[1]
    page_width = pdf.bounds.top_right[0]
    
    # Each room in each day gets a seperate page
    first_page = true
    @rooms.each do |room|
        current_day = -1
        room.published_room_item_assignments.each do |assignment|
            if current_day != assignment.day || @one_per_page
                pdf.start_new_page if !first_page
                first_page = false
                current_day = assignment.day
                pdf.text  '<b>' + room.name + ' - ' + room.published_venue.name + ' <b>' + (Time.zone.parse(SiteConfig.first.start_date.to_s) + assignment.day.days).strftime('%A') + '</b>', :size => 30, :inline_format => true, :align => :center, :fallback_fonts => fallback_fonts
                pdf.move_down 1.in
                pdf.font_size 16
            end

            itemText = assignment.published_time_slot.start.strftime('%H:%M') + ' - ' + assignment.published_time_slot.end.strftime('%H:%M')
            itemText +=  " <b>" + assignment.published_programme_item.title + "</b>" 
            if assignment.published_programme_item.format
                itemText += ' (<i>'
                itemText += assignment.published_programme_item.format.name  if assignment.published_programme_item.format
                itemText += '</i>) '
            end

                first_person = true
                assignment.published_programme_item.published_programme_item_assignments.collect {|a| ([PersonItemRole['Participant'],PersonItemRole['Moderator']].include? a.role) ? a : nil}.compact.each do |p|
                    if !first_person
                        itemText += ', '
                    end
                    first_person = false
                    itemText += p.person.getFullPublicationName 
                    itemText += '(' + p.role.name[0] + ')' if p.role == PersonItemRole['Moderator']
                end

                
            pdf.text itemText, :inline_format => true, :fallback_fonts => fallback_fonts

            if ! assignment.published_programme_item.precis.blank?
                pdf.font_size 14
                pdf.move_down 0.1.in
                pdf.text assignment.published_programme_item.precis, :inline_format => true, :fallback_fonts => fallback_fonts if @include_desc
                pdf.move_down 0.1.in
                pdf.font_size 16
            end
            
        end
        title = ''
    end
end
