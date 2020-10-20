from nmigen import *
from nmigen_boards.ecp5mini import *

class Blink(Elaboratable):
    def __init__(self):
        self.timer = Signal(24, reset=0)

    def elaborate(self, platform):
        m = Module()

        m.d.sync += self.timer.eq(self.timer + 1)

        led = platform.request("led", 0)
        self.led_usr = led.led_usr
        self.led_act = led.led_act
        self.btn = platform.request("button", 0)

        with m.If(self.btn):
            m.d.comb += self.led_usr.eq(1)
        with m.Else():
            m.d.comb += self.led_usr.eq(0)

        m.d.comb += self.led_act.eq(self.timer[23])

        return m


if __name__ == "__main__":
    platform = ECP5MiniPlatform()
    platform.build(Blink(), do_program=True)