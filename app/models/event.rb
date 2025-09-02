class Event
  include ActiveModel::API

  attr_accessor :uid, :dtstart, :dtend, :summary, :description, :location, :url
  attr_accessor :contact_phone, :contact_email, :contact_name
  attr_accessor :type

  def type
    /[0-9]\. Sitzung/.match(self.summary) ? :Sitzung : :Veranstaltung
  end

  def ics_event=(ics)
    self.uid = ics.uid
    self.dtstart = ics.dtstart
    self.dtend = ics.dtend
    self.summary = ics.summary
    self.description = ics.description
    self.location = ics.location
    self.url = ics.url&.to_s

    contact_arr = ics.contact.map { |c| c.split(",") }.flatten.map(&:strip)
    self.contact_phone = contact_arr.find { |c| /^\+?[0-9\s\-()]+$/.match(c.strip) }
    self.contact_email = contact_arr.find { |c| URI::MailTo::EMAIL_REGEXP.match(c.strip) }
    self.contact_name = contact_arr.first unless [ self.contact_phone, self.contact_email ].include?(contact_arr.first)
  end
end
