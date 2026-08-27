#!/usr/bin/env python3
import evdev
from evdev import UInput, ecodes as e

# SRC_PATH = '/dev/input/event2'   # Pro Controller (버튼+스틱)
# SRC_PATH = '/dev/input/by-id/usb-Nintendo_Co.__Ltd._Pro_Controller_XXXXXX-event-joystick'
SRC_PATH = '/dev/input/by-id/usb-Nintendo.Co.Ltd._Pro_Controller_000000000001-event-joystick'

src = evdev.InputDevice(SRC_PATH)
print(f"Source: {src.name} ({SRC_PATH})")

cap = src.capabilities()
cap.pop(e.EV_SYN, None)
cap.pop(e.EV_FF, None)
cap.pop(e.EV_LED, None)
cap.pop(e.EV_MSC, None)

ui = UInput(cap, name='Pro Controller (js-bridge)',
            vendor=0x057e, product=0x2009, version=0x0110)

print("Virtual device created:", ui.device.path)
print("Mirroring events... (Ctrl+C to stop)")

try:
    for event in src.read_loop():
        ui.write_event(event)
except KeyboardInterrupt:
    pass
finally:
    ui.close()