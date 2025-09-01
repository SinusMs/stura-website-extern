require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:event)
    @event2 = events(:current_event)
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

  test "should get new" do
    get new_event_url
    assert_response :unauthorized, "Non-logged-in user should not access new event form"
    login_user
    get new_event_url
    assert_response :success, "Logged-in user should access new event form"
    login_admin
    get new_event_url
    assert_response :success, "Admin should access new event form"
  end

  test "should create event" do
    assert_difference("Event.count", 0, "Non-logged-in user should not be able to create an event") do
      post events_url, params: { event: { datetime: @event.datetime, description: @event.description, title: @event.title } }
      assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    end
    login_user
    assert_difference("Event.count", 1, "Logged-in user should be able to create an event") do
      post events_url, params: { event: { datetime: @event.datetime, description: @event.description, title: @event.title } }
      assert_redirected_to event_url(Event.last), "Should redirect to newly created event for logged-in user"
    end
    login_admin
    assert_difference("Event.count", 1, "Admin should be able to create an event") do
      post events_url, params: { event: { datetime: @event.datetime, description: @event.description, title: @event.title } }
      assert_redirected_to event_url(Event.last), "Should redirect to newly created event for admin"
    end
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success, "Anyone should be able to view an event"
    login_user
    get event_url(@event)
    assert_response :success, "Logged-in user should be able to view an event"
    login_admin
    get event_url(@event)
    assert_response :success, "Admin should be able to view an event"
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :unauthorized, "Non-logged-in user should not access edit event form"
    login_user
    get edit_event_url(@event)
    assert_response :success, "Logged-in user should access edit event form"
    login_admin
    get edit_event_url(@event)
    assert_response :success, "Admin should access edit event form"
  end

  test "should update event" do
    patch event_url(@event), params: { event: { datetime: @event.datetime, description: @event.description, title: @event.title } }
    assert_response :unauthorized, "Non-logged-in user should not be able to update event"
    login_user
    patch event_url(@event), params: { event: { datetime: @event.datetime, description: @event.description, title: "newtitle" } }
    assert_redirected_to event_url(@event), "Logged-in user should be redirected after updating event"
    @event.reload
    assert_equal "newtitle", @event.title, "Event title should be updated by logged-in user"
    login_admin
    patch event_url(@event), params: { event: { datetime: @event.datetime, description: @event.description, title: "newertitle" } }
    assert_redirected_to event_url(@event), "Admin should be redirected after updating event"
    @event.reload
    assert_equal "newertitle", @event.title, "Event title should be updated by admin"
  end

  test "should destroy event" do
    assert_difference("Event.count", 0, "Non-logged-in user should not be able to destroy event") do
      delete event_url(@event)
      assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    end
    login_user
    assert_difference("Event.count", -1, "Logged-in user should be able to destroy event") do
      delete event_url(@event)
      assert_redirected_to events_url, "Should redirect to events index after destroy for logged-in user"
    end
    login_admin
    assert_difference("Event.count", -1, "Admin should be able to destroy event") do
      delete event_url(@event2)
      assert_redirected_to events_url, "Should redirect to events index after destroy for admin"
    end
  end

  test "should handle invalid requests" do
    login_user
    get event_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for non-existent event"
    get edit_event_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for edit form of non-existent event"
    post edit_event_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for post to edit form of non-existent event"
    patch event_url(@event), params: { event: { title: nil } }
    assert_response :unprocessable_entity, "Should respond with unprocessable_entity for invalid update (missing title)"
    delete event_url(id: 456763)
    assert_response :not_found, "Should respond with not_found when trying to delete a non-existent event"
  end
end
