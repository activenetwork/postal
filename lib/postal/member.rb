module Postal
  class Member < Postal::Base
    
    class << self
      
      def find_by_filter(*args)
        unless args.find { |arg| arg.match(/ListName/) }
          args << "ListName=#{Postal.options[:list_name]}"
        end
        begin
          if soap_members = Postal.driver.selectMembers(args)
            return parse_members(soap_members)
          else
            return nil
          end
        rescue
          return nil
        end
      end
      
      
      # Will NOT let you delete the entire list's members (only pass a ListName) Returns the number of members that were deleted, or nil if none were
      def destroy(*args)
        unless args.find { |arg| arg.match(/ListName/) }
          args << "ListName=#{Postal.options[:list_name]}"
        end
        # raise Postal::WouldDeleteAllMembers, 'Not passing any parameters (other than ListName) to this method will delete ALL members of a list. If you really want to delete all members of this list, use destroy! instead.' if args.to_a.size == 1 && args.to_a.first.match(/ListName/)
        return Postal.driver.deleteMembers(args)
      end
      
      
      # WILL let you delete an entire list's members (only pass a ListName). Returns the number of members that were deleted, or nil if none were
      # def destroy!(*args)
      #   return Postal.driver.deleteMembers(args)
      # end
      
      
      protected
      
        def find_by_email(args,options)
          if args.size == 1
            list_name = Postal.options[:list_name]
          else
            list_name = args.last
          end
          email = args.first
          member_id = 0

          begin
            return find_by_filter("EmailAddress=#{email}")
            # return Postal.driver.getMemberID(Postal::Lmapi::SimpleMemberStruct.new(list_name,member_id,email))
          rescue Savon::SOAP::Fault => soap_fault
            return nil
          end
        end
      
      
        def find_by_id(args,options)
          member_id = args.first
          return find_by_filter("MemberID=#{member_id}")
          # return Postal.driver.getEmailFromMemberID(member_id)
        end
        
      
        # Find one or more members by name
        def find_some(args,options={})
          case args.first
          when ::String
            find_by_email(args,options)
          when ::Fixnum
            find_by_id(args,options)
          when nil
            find_by_struct(options)
          end
        end
      
        def parse_members(return_hash)
          case return_hash[:item]
          when Hash
            member = build_member_from_hash(return_hash[:item])
          when Array 
            members = return_hash[:item].each do |member|
              build_member_from_hash(member)
            end
          end
          if member
            return member
          else
            return members
          end
        end
        
        def build_member_from_hash(member_hash)
          demographics = {}
          member_hash[:demographics][:item].each { |demo| demographics.merge!({ demo[:name].to_sym => demo[:value] }) }
          Member.new(:email => member_hash[:email_address], :name => member_hash[:full_name], :id => member_hash[:member_id], :list_name => member_hash[:list_name], :demographics => demographics)
        end
        
    end
    
    DEFAULT_ATTRIBUTES = { :id => nil, :email => nil, :name => nil, :list_name => nil, :demographics => {} }
    
    attr_accessor :id, :email, :name, :list_name, :demographics
    
    
    # Create a new member instance
    def initialize(attributes={})
      attributes = DEFAULT_ATTRIBUTES.merge(attributes)
      @id = attributes[:id]
      @email = attributes[:email]
      @name = attributes[:name]
      @list_name = attributes[:list_name] || Postal.options[:list_name]
      @demographics = attributes[:demographics]
    end
    
    
    # Save the member to Lyris and returns the member ID that was created. Returns `false` if the save fails.
    def save
      # if @list is a list Object then get the name out (all Lyris wants is the name)
      list_name = @list_name
      begin
        @id = Postal.driver.createSingleMember(@email, @name, list_name)
        update_attributes(@demographics) unless @demographics.empty?
        return @id
      rescue Savon::SOAP::Fault
        return false
      end
    end
    
    
    # Saves the member to Lyris and returns the member ID that was created. Throws an error if the save fails.
    def save!
      if id = save
        return id
      else
        raise Postal::CouldNotCreateMember, 'Could not create a new member. The most likely cause is that the specified list already contains this email address.'
      end
    end


    def unsubscribe
      list_name = @list_name
      return Postal.driver.unsubscribe(list_name, @id, @email)
    end
    
    
    # Update the demographics for a user
    def update_attributes(attributes={})
      list_name = @list_name
      demos = attributes.collect { |key,value| {'Name' => key, 'Value' => value} }
      return Postal.driver.updateMemberDemographics(list_name, @id, @email, demos)
    end
    
    
    # Throw an error if demographics couldn't be saved
    def update_attributes!(attributes={})
      if update_attributes(attributes)
        return true
      else
        raise Postal::CouldNotUpdateMember, 'Could not update the member. The most likely cause is that your demographics are invalid.'
      end
    end
    
  end
end
