#
#
#

module TagsService
  
  def self.tag_counts_on(_class, context)
    _class.tag_counts_on(context)
  end

  def self.getTagCounts(classname, context)
    ActiveRecord::Base.connection.select_all tagCountSql(classname, context).to_sql
  end
  
  def self.getTags(instance, context)
    ActsAsTaggableOn::Tag.joins(:taggings).where(taggingSql(instance, context)).collect{|e| e.name}
  end

protected  

  def self.tagCountSql(classname, context)
    taggings = Arel::Table.new(:taggings)
    tags = Arel::Table.new(:tags)
    
    q = taggings.project(taggings[:tag_id].count.as("count"), taggings[:tag_id]).where(self.constraints()).where(
        taggings[:taggable_type].eq(classname).and(taggings[:context].eq(context))
        ).group(taggings[:tag_id]).having(taggings[:tag_id].count.gt(0)).as('taggs')
    
    tags.project(Arel.sql('tags.*, taggs.count AS count')).join(q).on('tags.id = taggs.tag_id').order("count desc")
  end
  
  def self.taggingSql(instance, context)
    taggings = Arel::Table.new(:taggings)
    taggings[:taggable_id].eq(instance.id.to_s).where(self.constraints()).and(taggings[:taggable_type].eq(instance.class.name))
  end
  
  def self.conditions
    nil
  end

  def self.constraints(*args)
    true
  end

end
