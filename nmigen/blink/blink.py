# Blink the three LEDs in a counting pattern.

from nmigen import *
from nmigen_boards.ecp5_mini import *


class Blink(Elaboratable):
    def __init__(self, maxperiod):
        self.maxperiod = maxperiod

    def elaborate(self, platform):
        led = platform.request("led_act")

        m = Module()

        counter = Signal(range(self.maxperiod + 1))

        with m.If(counter == 0):
            m.d.sync += [
                led.eq(~led),
                counter.eq(self.maxperiod)
            ]
        with m.Else():
            m.d.sync += counter.eq(counter - 1)

        return m

if __name__ == "__main__":
    platform = ECP5MiniPlatform()
    platform.build(Blink(10000000), do_program=True)
