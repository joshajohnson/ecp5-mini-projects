# ECP5 Mini Projects

A collection of projects for the [ECP5 Mini FPGA development board](https://github.com/joshajohnson/ecp5-mini/).

These projects are my own, and probably have more mistakes and bad practices in them than you can poke a stick at. Use them at your own risk.

Verilog projects are in `verilog`, and after changing into the project directory have the below options.
- `make` to build the project
- `make flash` to program flash over JTAG using [ecpprog](https://github.com/gregdavill/ecpprog) and a FTDI cable.
- `make sram` to program SRAM as above.
- `make dfu` to flash the board over USB. Requires the [bootloader](https://github.com/joshajohnson/had2019-playground/tree/ecp5-mini) to be flashed to the board first.
- `make simulate` to simulate the design with iverilog using the `$(PROJ)_tb.v` simulation file.
- `make new NAME="name"` to copy current project to new folder called `name` along with changing all in text references.

nMigen projects are in `nmigen`, and after changing into the project directory run `python3 project.py`.

Thanks to Konrad Beckmann for his [Pergola Projects](https://github.com/kbeckmann/pergola_projects) which this was based off.
