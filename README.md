# ✨TESTBENCH AUTOMATION ON A MIPS-BASED MICROPROCESSOR IMPLEMENTED IN VERILOG

Welcome to my B.Tech Major project! This tool is designed to automate the creation of test benches for a custom designed MIPS processors for a given assembly file. `Navya B`, [Prajwal KP](https://github.com/prajwal19012002), `Sarun Babu` and `Vishnu P` where also with me during this Project

> [!IMPORTANT] 
>   THE GENERATED TESTBENCH IS NOT FOR *FULL FUNCTIONALTY VERIFICATION*, FOR A GIVEN ASSEMBLY CODE -> IT GENERATE A TESTBENCH TO RUN THAT ASSEMBLY CODE IN THIS MIPS PROCESSOR
 
## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The primary objective of this project is to streamline the microprocessor verification process by developing a Python script capable of automating testbench generation from assembly programs. Manual testbench creation for complex microprocessors can be time-consuming and error-prone, hindering development efficiency. By automating this process, the project aims to significantly reduce development time and enhance productivity. The microprocessor's 5-stage pipeline architecture divides instruction execution into discrete stages: **Instruction Fetch, Decode, Execute, Memory Access, and Write-Back**. This approach facilitates concurrent instruction processing, thereby improving throughput. Leveraging the advantages of the MIPS 32 architecture, the project aims to create a comprehensive solution for microprocessor verification.

## Features

- **32-bit processor**: Processor contain 32 32-bit wide registers and each instruction is 32-bit.
- **5 Stage pipeline**: Instruction Fetch, Decode, Execute, Memory Access, and Write-Back.
- **Custom Instruction Set**: 24 6-bit custom instruction set.
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
    git clone https://github.com/Nidhinchandran47/MIPS_testbench_generator.git
    cd MIPS_testbench_generator
    ```

2. **Set up the environment:**

    Ensure that you have the necessary tools and compilers for hardware description languages (Verilog) installed on your system.

## Usage

Using the Automatic Test Bench Generation tool is straightforward. Here are the basic steps:

1. **Open the MIPS HDL in complier**

2. **Run the tool:**

    ```sh
    python script.py
    ```
    Enter the assembly file name with txt extention.

3. **Review and use the generated test benches** in your verification process.
   The script will shoe if errors are there in the input, else provide the testbench. Copy it to the compiler and simulate.



## Contributing

Contributions are welcome! If you'd like to contribute to the project, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch**.
3. **Commit your changes**.
4. **Push to the branch**.
5. **Create a new Pull Request**.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

😁 Thank you for using the Automatic Test Bench Generation tool! If you have any questions or need further assistance, feel free to open an issue in the repository. Happy testing!
