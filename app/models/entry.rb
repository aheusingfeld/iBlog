class Entry < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 25
  
  validates_length_of :plans, :maximum => 1000
  
  validates_presence_of :progress
  validates_length_of :progress, :within => 3..2000
    
  validates_length_of :problems, :maximum => 1000, :if => proc { |obj| obj.problems }

  has_many :tags

  def self.page(params)
    
    options = { :page => params[:page], :order => 'created_at DESC', :include => :tags }

    mergeCondition options, :blog_id, params[:blog_id]
    mergeCondition options, :author, params[:author]
    
    # ST: das ist mir sehr peinlich, aber ich kann halt weder AR noch SQL
    ids = if params[:tag].nil? 
            :all
          else
            Tag.find_all_by_name(params[:tag], :select => 'entry_id').map {|t| t.entry_id }
          end

    Entry.paginate(ids, options)
  end

  def tags_as_string
    tags.map{|t| t.name}.join ' '
  end
    
  def tags_as_string=(tags_as_string)
    Tag.delete_all(["entry_id = ?", id])
    self.tags = tags_as_string.split(' ').map { |t| Tag.new(:name => t) }
  end

  private
  def self.mergeCondition options, name, value
    unless value.nil?
      options[ :conditions ] ||= {}
      options[ :conditions ][ name ] = value 
    end
  end
end
