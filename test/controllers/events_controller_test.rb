require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    raw_ics = Net::HTTP.get(URI(ENV.fetch("ICAL_URL", "https://www.stura.htw-dresden.de/events/@@ics_view")))
    @calendar = Icalendar::Calendar.parse(raw_ics).first
    @event = @calendar.events.first
  end

  test "should get index" do
    get events_url
    assert_response :success, "Anyone should be able to access events index"
    login_user
    get events_url
    assert_response :success, "Logged-in user should be able to access events index"
    login_admin
    get events_url
    assert_response :success, "Admin should be able to access events index"
  end

  test "should show event" do
    get event_url(@event.uid)
    assert_response :success, "Anyone should be able to view an event"
    login_user
    get event_url(@event.uid)
    assert_response :success, "Logged-in user should be able to view an event"
    login_admin
    get event_url(@event.uid)
    assert_response :success, "Admin should be able to view an event"
  end

  test "should cache ICS calendar" do
    Rails.cache.delete(:stura_ics_calendar)
    assert_nil Rails.cache.read(:stura_ics_calendar), "Cache should be empty initially"

    get events_url
    assert_not_nil Rails.cache.read(:stura_ics_calendar), "ICS calendar should be cached after request"
  end

  test "should handle invalid requests" do
    get event_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for non-existent event"
  end
end
