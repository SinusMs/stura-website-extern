class EventsController < ApplicationController
  require "net/http"
  layout "application"

  # GET /events or /events.json
  def index
    uri = URI("https://www.stura.htw-dresden.de/events/@@ics_view")
    response = Net::HTTP.get(uri)
    @calendar = Icalendar::Calendar.parse(response).first
  end

  # GET /events/1 or /events/1.json
  def show
    uri = URI("https://www.stura.htw-dresden.de/events/@@ics_view")
    response = Net::HTTP.get(uri)
    ics_event = Icalendar::Calendar.parse(response).first.events.find { |e| e.uid == params[:id] }
    @event = Event.new(ics_event: ics_event)
  end
end
