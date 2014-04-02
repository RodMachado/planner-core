
# TODO - if a programme item we need to get the title...
json.array!(@changes) do |change|
    json.action change.action
    json.user User.find(change.user_id).login
    json.type change.auditable_type
    json.time change.created_at.strftime('%A %H:%M, %-d %B %Y')
    
    #json.attrs change.new_attributes
    
    if change.action == 'destroy'
        json.title change.audited_changes["title"] if change.audited_changes["title"] # for program items .. but for assignments we need...
    elsif change.action == 'create'
        json.title change.audited_changes["title"] if change.audited_changes["title"] # for program items .. but for assignments we need...

        change.audited_changes.each do |k, v|
            idx = k.index('_id')
            className = nil
            if idx
                className = k.slice(0, idx).capitalize.gsub(/_[a-z]/){ |s| s[1].capitalize }
            end
            
            if className && !(['Role', 'Format', 'SetupType'].include? className)
                instance = eval ( className + '.find ' + v.to_s )
                json.title   instance.title if className == 'ProgrammeItem'
                json.person   instance.getFullPublicationName if className == 'Person'
            elsif ['Role', 'Format', 'SetupType'].include? className
                json.set! className.downcase, (Enum.find v).name if v
            elsif v
                json.set! k,  v if v && v != ""
            end
        end
    else
        # change to collection of attributes
        change.audited_changes.each {|k,v| json.set! k, v[1].to_s } #.encode("iso-8859-1").force_encoding("utf-8")
        json.title ProgrammeItem.find( change.auditable_id ).title
    end
end