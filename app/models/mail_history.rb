class MailHistory < ActiveRecord::Base
  attr_accessible :lock_version, :date_sent, :content, :testrun, :person_mailing_assignment_id, :person_id, :email_status_id, :mailing_id,
                  :person_mailing_assignment, :email, :person, :mailing, :email_status
    
  belongs_to :person_mailing_assignment
  belongs_to :person
  belongs_to :mailing
  
  has_enumerated :email_status, :class_name => 'EmailStatus'

  def as_json(options={})
    res = super(options)
    
    res[:status] = email_status.name
    
    return res
  end

end
