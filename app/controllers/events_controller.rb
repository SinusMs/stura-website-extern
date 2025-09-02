class EventsController < ApplicationController
  require "net/http"
  layout "application"

  # GET /events or /events.json
  def index
    @calendar = fetch_calendar
  end

  # GET /events/1 or /events/1.json
  def show
    calendar = fetch_calendar
    ics_event = calendar.events.find { |e| e.uid == params[:id] }
    @event = Event.new(ics_event: ics_event)
  end

  private

  def fetch_calendar
    raw_ics = Rails.cache.fetch(:stura_ics_calendar, expires_in: 5.minutes) do
      Net::HTTP.get(URI("https://www.stura.htw-dresden.de/events/@@ics_view"))
    end
    Icalendar::Calendar.parse(raw_ics).first
  end
end
