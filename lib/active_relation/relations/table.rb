module ActiveRelation
  class Table < Relation
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def attributes
      @attributes ||= connection.columns(name, "#{name} Columns").collect do |column|
        Attribute.new(self, column.name.to_sym)
      end
    end

    def qualify
      Rename.new self, qualifications
    end
    
    def prefix_for(attribute)
      name
    end
    
    def aliased_prefix_for(attribute)
      name
    end
    
    protected    
    def table_sql
      "#{quote_table_name(name)}"
    end

    private
    def qualifications
      attributes.zip(attributes.collect(&:qualified_name)).to_hash
    end
  end
end