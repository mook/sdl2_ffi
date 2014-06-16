module SDL2
  class Event
    #  @brief A video driver dependent system event (event.syswm.*)
    #         This event is disabled by default, you can enable it with
    # SDL_EventState()
    #
    #  @note If you want to use this event, you should include SDL_syswm.h.
    class SysWM < Abstract
      layout *SHARED + [
        :msg, SDL2::SysWM::Msg.by_ref
      ]
    end

  end
end