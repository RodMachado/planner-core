xml.people do
  @people.each do |p|
    xml.person do
      xml.name(p.getFullName())
      p.email_addresses.each do |addr|
        if addr.isdefault
          xml.address(addr.email)
        end
      end
      xml.items do
        p.programmeItems.each do |itm|
          if itm.room # The item has to be assigned to a room and time i.e. it is scheduled
            xml.item do
              titlestr = itm.time_slot.start.strftime('%A %H:%M') + " - " + itm.time_slot.end.strftime('%H:%M')
              titlestr += ", " + itm.title + ", " + itm.room.name + " ( " + itm.room.venue.name + ")"
              xml.title(titlestr)
              xml.description(itm.precis)
              names = []
              itm.programme_item_assignments.each do |asg| #.people.each do |part|
                if asg.person != nil
                  if asg.role == PersonItemRole['Participant'] || asg.role == PersonItemRole['Moderator']
                    name = asg.person.getFullPublicationName
                    name += " (M)" if asg.role == PersonItemRole['Moderator']                
                    asg.person.email_addresses.each do |addr|
                        if addr.isdefault && (!@NoShareEmailers.index(asg.person))
                          name += "(" + addr.email + ")"
                        end
                    end
                    names << name
                  end
                end
              end
              xml.participants(names.join(', '))
              equipList = []
              if itm.equipment_types.size == 0
                  equipList << "No Equipment Needed"
              end
              itm.equipment_types.each do |equip|
                  equipList << equip.description
              end
              xml.equipment(equipList.join(', '))
            end
          end
        end
      end
    end
  end
end