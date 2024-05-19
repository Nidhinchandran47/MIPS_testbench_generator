# TESTBENCH AUTOMATION ON A MIPS-BASED MICROPROCESSOR IMPLEMENTED IN VERILOG

Welcome to my B.Tech Major project! This tool is designed to automate the creation of test benches for a custom designed MIPS processors for a given assembly file. 

> 🚨 " THE GENERATED TESTBENCH IS NOT FOR *FULL FUNCTIONALTY VERIFICATION*, FOR A GIVEN ASSEMBLY CODE -> IT GENERATE A TESTBENCH TO RUN THAT ASSEMBLY CODE IN THIS MIPS PROCESSOR"
 
## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The primary objective of this project is to streamline the microprocessor verification process by developing a Python script capable of automating testbench generation from assembly programs. Manual testbench creation for complex microprocessors can be time-consuming and error-prone, hindering development efficiency. By automating this process, the project aims to significantly reduce development time and enhance productivity. The microprocessor's 5-stage pipeline architecture divides instruction execution into discrete stages: **Instruction Fetch, Decode, Execute, Memory Access, and Write-Back**. This approach facilitates concurrent instruction processing, thereby improving throughput. Leveraging the advantages of the MIPS 32 architecture, the project aims to create a comprehensive solution for microprocessor verification.

## Features

- **32-bit processor**: Processor contain 32 32bit wide registers and each instruction is 32 bit.
- **5 Stage pipeline**: Instruction Fetch, Decode, Execute, Memory Access, and Write-Back.
- **Custom Instruction Set**: 24 6 bit custom instruction set.
- **Error Detection**: The script is able to detect errors in input assebly file.

### Instruction set
| OPCODE     | HEXCODE    | OPERATION     |
|--------------|:--------------:|:--------------|
| ADD| 00h| Add between 2 register |
| SUB| 01h| Subtract between 2 register |
| AND| 02h| Logical And between 2 register |
| OR | 03h| Logical Or between 2 register |
| STL| 04h| Compare between 2 register |
| MUL| 05h| Multiple between 2 register |
| NND| 06h| Logical Nand between 2 register |
| NOR| 07h| Logical Nor between 2 register |
| XOR| 08h| Logical Xor between 2 register |
| ROR| 09h| Rotate/Shift the selected register right  |
| ROL| 0Ah| Rotate/Shift the selected register left |
| XNR| 0Bh| Logical Xnor between 2 register |
| LW| 10h| Load to a memory location |
| SW| 11h| Store from a memory location |
| ADI| 12h| Add between a register and immediate value |
| SUI| 13h| Subtract between a register and immediate value |
| STI| 14h| Compare between a register and immediate value |
| PUS| 0Ch| Push to Stack |
| POP| 0Dh| Pop from Stack |
| JMP| 15h| Jump to an immediate location |
| JPI| 16h| Conditional Jump |
| BIF| 17h| Branch If |
| BNF| 18h| Branch Not-If |
| HLT| 3Fh| Halt |



## Installation

To install the Automatic Test Bench Generation tool, follow these steps:

1. **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/automatic-test-bench-generation.git
    cd automatic-test-bench-generation
    ```

2. **Install dependencies:**

    ```sh
    pip install -r requirements.txt
    ```

3. **Set up the environment:**

    Ensure that you have the necessary tools and compilers for hardware description languages (VHDL, Verilog, SystemVerilog) installed on your system.

## Usage

Using the Automatic Test Bench Generation tool is straightforward. Here are the basic steps:

1. **Prepare your design specifications and test scenarios.**

2. **Run the tool:**

    ```sh
    python generate_test_bench.py --input <design_file> --output <output_directory> --language <hdl_language> --config <config_file>
    ```

    - `--input`: Path to the hardware design file.
    - `--output`: Directory where the generated test bench files will be saved.
    - `--language`: Hardware description language (vhdl, verilog, systemverilog).
    - `--config`: Path to the configuration file (optional).

3. **Review and use the generated test benches** in your verification process.

## Configuration

The tool can be configured using a configuration file in JSON or YAML format. The configuration file allows you to specify various options, such as signal definitions, clock settings, and test scenarios.

Example configuration file (config.json):

```json
{
    "clock_signal": "clk",
    "reset_signal": "rst",
    "test_scenarios": [
        {
            "name": "basic_functionality",
            "stimuli": [
                {"signal": "input1", "value": "0b0010", "time": 10},
                {"signal": "input2", "value": "0b1100", "time": 20}
            ]
        }
    ]
}
```

## Contributing

Contributions are welcome! If you'd like to contribute to the project, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch** (`git checkout -b feature/your-feature-name`).
3. **Commit your changes** (`git commit -am 'Add some feature'`).
4. **Push to the branch** (`git push origin feature/your-feature-name`).
5. **Create a new Pull Request**.

Please ensure that your code adheres to the project's coding standards and includes appropriate tests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Thank you for using the Automatic Test Bench Generation tool! If you have any questions or need further assistance, feel free to open an issue in the repository. Happy testing!
