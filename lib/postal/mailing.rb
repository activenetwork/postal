module Postal
  class Mailing < Postal::Base
    
    class << self
      
      def import(content_id)
        mail = Postal.driver.importContent(content_id)
        return mail
      end
      
    end
    
    
    DEFAULT_ATTRIBUTES = {:additional_headers => nil, 
                          :attachments => nil, 
                          :bypass_moderation => nil, 
                          :campaign => nil, 
                          :char_set_id => nil, 
                          :detect_html => nil, 
                          :dont_attempt_after_date => nil, 
                          :enable_recovery => nil, 
                          :from => nil, 
                          :html_message => nil, 
                          :html_section_encoding => nil, 
                          :is_html_section_encoded => nil, 
                          :is_text_section_encoded => nil,
                          :list_name => nil,
                          :recency_number_of_mailings => nil,
                          :recency_which => nil,
                          :reply_to => nil,
                          :resend_after_days => nil,
                          :sample_size => nil,
                          :scheduled_mailing_date => nil,
                          :subject => nil,
                          :text_message => nil,
                          :text_section_encoding => nil,
                          :title => nil,
                          :to => nil,
                          :track_opens => nil,
                          :rewrite_date_when_sent => nil,
                          :mailing => nil }
    
    attr_accessor :additional_headers, 
                  :attachments, 
                  :bypass_moderation, 
                  :campaign, 
                  :char_set_id, 
                  :detect_html, 
                  :dont_attempt_after_date, 
                  :enable_recovery, 
                  :from, 
                  :html_message, 
                  :html_section_encoding, 
                  :is_html_section_encoded, 
                  :is_text_section_encoded,
                  :list_name,
                  :recency_number_of_mailings,
                  :recency_which,
                  :reply_to,
                  :resend_after_days,
                  :sample_size,
                  :scheduled_mailing_date,
                  :subject,
                  :text_message,
                  :text_section_encoding,
                  :title,
                  :to,
                  :track_opens,
                  :rewrite_date_when_sent,
                  :mailing
    
    # Create a new mailing ready to send
    def initialize(args={})
      args = DEFAULT_ATTRIBUTES.merge(args)
      
      @list_name = args[:list_name] || Postal.options[:list_name]
      @to = args[:to] 
      
      if args[:mailing].nil?
        @additional_headers = args[:additional_headers] 
        @attachments = args[:attachments] 
        @bypass_moderation = args[:bypass_moderation] 
        @campaign = args[:campaign] 
        @char_set_id = args[:char_set_id] 
        @detect_html = args[:detect_html] 
        @dont_attempt_after_date = args[:dont_attempt_after_date] 
        @enable_recovery = args[:enable_recovery] 
        @from = args[:from] 
        @html_message = args[:html_message] 
        @html_section_encoding = args[:html_section_encoding] 
        @is_html_section_encoded = args[:is_html_section_encoded] 
        @is_text_section_encoded = args[:is_text_section_encoded]
        @recency_number_of_mailings = args[:recency_number_of_mailings]
        @recency_which = args[:recency_which]
        @reply_to = args[:reply_to]
        @resend_after_days = args[:resend_after_days]
        @sample_size = args[:sample_size]
        @scheduled_mailing_date = args[:scheduled_mailing_date]
        @subject = args[:subject]
        @text_message = args[:text_message]
        @text_section_encoding = args[:text_section_encoding]
        @title = args[:title]
        @to = args[:to]
        @track_opens = args[:track_opens]
        @rewrite_date_when_sent = args[:rewrite_date_when_sent]
        @mailing = args[:mailing]
      else
        @subject = args[:mailing].subject
        @is_html_section_encoded = args[:mailing].isHtmlSectionEncoded
        @html_section_encoding = args[:mailing].htmlSectionEncoding
        @html_message = args[:mailing].htmlMessage
        @char_set_id = args[:mailing].charSetID
        @is_text_section_encoded = args[:mailing].isTextSectionEncoded
        @text_section_encoding = args[:mailing].textSectionEncoding
        @title = args[:mailing].title
        @text_message = args[:mailing].textMessage
        @attachments = args[:mailing].attachments
        @from = args[:mailing].from
        @additional_headers = args[:mailing].additionalHeaders
        @mailing = args[:mailing]
      end
    end
    
    
    # Send the mailing
    def send
      if valid?
        
        # are we sending to a list of email addresses or member ids
        case [@to].flatten.first
        when ::String
          emails = [@to].flatten
          member_ids = []
        when ::Fixnum
          emails = []
          member_ids = [@to].flatten
        end
        
        if @mailing.nil?
          mail = Postal::Lmapi::MailingStruct.new(:additionalHeaders => @additional_headers, 
                                                  :attachments => @attachments, 
                                                  :bypassModeration => @bypass_moderation, 
                                                  :campaign => @campaign, 
                                                  :charSetID => @char_set_id, 
                                                  :detectHtml => @detect_html, 
                                                  :dontAttemptAfterDate => @dont_attempt_after_date, 
                                                  :enableRecovery => @enable_recovery, 
                                                  :from => @from, 
                                                  :htmlMessage => @html_message, 
                                                  :htmlSectionEncoding => @html_section_encoding, 
                                                  :isHtmlSectionEncoded => @is_html_section_encoded, 
                                                  :isTextSectionEncoded => @is_text_section_encoded,
                                                  :listName => @list_name,
                                                  :recencyNumberOfMailings => @recency_number_of_mailings,
                                                  :recencyWhich => @recency_which,
                                                  :replyTo => @reply_to,
                                                  :resendAfterDays => @resend_after_days,
                                                  :sampleSize => @sample_size,
                                                  :scheduledMailingDate => @scheduled_mailing_date,
                                                  :subject => @subject,
                                                  :textMessage => @text_message,
                                                  :textSectionEncoding => @text_section_encoding,
                                                  :title => @title,
                                                  # :to => @to,
                                                  :trackOpens => @track_opens,
                                                  :rewriteDateWhenSent => @rewrite_date_when_sent )
        
          return Postal.driver.sendMailingDirect(emails,member_ids,mail)
        else
          mail = Postal::Lmapi::MailingStruct.new(@mailing)
          mail.listName = @list_name || Postal.options[:list_name]
          return Postal.driver.sendMailingDirect(emails,member_ids,mail)
        end
        
      else  # mail wasn't valid
        return false
      end
    end
    
    
    # same as send() but throws an error instead of just returning false
    def send!
      if id = send
        return id
      else
        raise Postal::CouldNotSendMailing, 'Your mail was invalid and could not be sent.'
      end
    end
    
    alias_method :save, :send
    alias_method :save!, :send!
    
    
    # Determines whether the email is valid to send
    def valid?
      return validate
    end
    
    
    # Determines whether we have everything we need to send an email
    def validate
      return (@list_name && @to && @subject) ? true : false
    end
    
  end
end
