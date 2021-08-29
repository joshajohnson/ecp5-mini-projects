# ECP5 Mini Projects

A collection of projects for the [ECP5 Mini FPGA development board](https://github.com/joshajohnson/ecp5-mini/).

These projects are my own, and probably have more mistakes and bad practices in them than you can poke a stick at. Use them at your own risk.

## Verilog

Verilog projects are in `verilog`, and after changing into the project directory have the below options.
- `make` to build the project
- `make flash` to program flash over JTAG using [ecpprog](https://github.com/gregdavill/ecpprog) and a FTDI cable.
- `make sram` to program SRAM as above.
- `make dfu` to flash the board over USB. Requires the [bootloader](https://github.com/joshajohnson/had2019-playground/tree/ecp5-mini) to be flashed to the board first.
- `make DEVICE=25k` to build for a non 12F ECP5.
- `make simulate` to simulate the design with iverilog using the `$(PROJ)_tb.v` simulation file.
- `make new NAME="name"` to copy current project to new folder called `name` along with changing all in text references.

## Litex

Litex projects are in `litex
`, and after changing into the project directory run `python3 ecp5_mini.py --build --load`

Append `--device=25F` to build for a non 12F ECP5.

## nMigen

nMigen projects are in `nmigen`, and after changing into the project directory run `python3 project.py`.

## Thanks

Thanks to Konrad Beckmann for his [Pergola Projects](https://github.com/kbeckmann/pergola_projects) which this was based off.

Thanks to Greg Davill for the soc-hr example.
