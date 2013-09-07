# Foreign Function Interface: Used to load & link to SDL2 module
require 'ffi'
require 'sdl2/window'

module SDL2
  # This module is the direct Foreign Function Interface for SDL2
  module Raw
    

   
    
    
    
    # Returns the raw value instead of the enum symbol.
          

    # Blend mode used in rendery_copy and drawing
    BLENDMODE_NONE      = 0x00000000
    BLENDMODE_BLEND     = 0x00000001
    BLENDMODE_ADD       = 0x00000002
    BLENDMODE_MOD       = 0x00000004

    enum :blend_mode, [
      :none, BLENDMODE_NONE,
      :blend, BLENDMODE_BLEND,
      :add, BLENDMODE_ADD,
      :mod, BLENDMODE_MOD
    ]

    enum :error_code, [
      :no_mem, 
      :file_read, 
      :file_write, 
      :file_seek, 
      :unsupported, 
      :last_error
    ]


    

    enum :event_type,
    [
      :first_event, 0,
      :quit, 0x100,
      # iOS Signals
      :app_terminating,
      :app_low_memory,
      :app_will_enter_background,
      :app_did_enter_background,
      :app_will_enter_foreground,
      :app_did_enter_foreground,
      # Window Events
      :window_event, 0x200,
      :sys_wm_event,
      # Keyboard events
      :key_down, 0x300,
      :key_up,
      :text_editing,
      :text_input,
      # Mouse events
      :mouse_motion, 0x400,
      :mouse_button_down,
      :mouse_button_up,
      :mouse_wheel,
      # Joystick events
      :joy_axis_motion,  0x600,
      :joy_ball_motion,
      :joy_hat_motion,
      :joy_button_down,
      :joy_button_up,
      :joy_device_added,
      :joy_device_removed,
      # Game controller events
      :controller_axis_motion,  0x650,
      :controller_button_down,
      :controller_button_up,
      :controller_device_added,
      :controller_device_removed,
      :controller_device_remapped,
      # Touch events
      :finger_down,  0x700,
      :finger_up,
      :finger_motion,
      # Gesture events
      :dollar_gesture,  0x800,
      :dollar_record,
      :dollar_multigesture,
      # Clipboard events
      :clipboard_update, 0x900,
      # Drag & Drop File Open Request
      :drop_file, 0x1000,
      # Events user create should be here.
      :user_event, 0x8000,
      # Last event possible.
      :last_event, 0xFFFF
    ]

    class CommonEvent < FFI::Struct
      layout :type, :uint32,
      :timestamp, :uint32

    end
    
    # VIDEO     
      
    
    
    
    enum :window_event_id, [
      :none, 
      :shown, 
      :hidden, 
      :exposed, 
      :moved, 
      :resized, 
      :size_changed, 
      :minimized, 
      :maximized, 
      :restored, 
      :enter, 
      :leave, 
      :focus_gained, 
      :focus_lost, 
      :close
    ]        
    typedef :pointer, :gl_context
    
    
    
    enum :gl_profile, [ 
      :core,          0x0001, 
      :compatibility, 0x0002,
      :es,            0x0004
    ]
    
    enum :gl_context_flag, [
      :debug,               0x0001,
      :forward_compatible,  0x0002,
      :robust_access,       0x0004,
      :reset_isolation,     0x0008
    ]

    
    
    class WindowEvent < FFI::Struct
      layout :type, :uint32,
        :timestamp, :uint32,
        :windowID, :uint32,
        :event, :window_event_id,
        :padding1, :uint32,
        :padding2, :uint32,
        :padding3, :uint32,
        :data1, :int32,
        :data2, :int32
    end

    
    
    
      
  end
end
