module SDL2
  class Event
    # @brief An event used to request a file open by the system (event.drop.*)
    #        This event is disabled by default, you can enable it with
    # SDL_EventState()
    # @note If you enable this event, you must free the filename in the event.
    #
    class Drop < Abstract

      layout *SHARED + [
        :file, :string
      ]
      member_readers *members
      member_writers *members
    end

  end
end