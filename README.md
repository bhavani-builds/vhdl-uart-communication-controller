# 📡 VHDL UART Communication Controller

A modular **UART communication controller designed and verified using VHDL**.

The project implements UART transmission and reception with configurable clock frequency and baud rate, even-parity generation/checking, automated simulation, and GitHub Actions-based verification.

---

## 🚀 Features

- VHDL RTL implementation
- UART transmitter
- UART receiver
- Configurable baud rate
- Configurable system clock
- 8-bit data transmission
- Start bit
- Stop bit
- Even parity
- Parity-error detection
- TX busy indication
- RX busy indication
- TX completion indication
- RX valid indication
- Automated testbench
- GHDL simulation
- GitHub Actions CI
- GHW waveform generation

---

## 🏗️ System Architecture

```text
                         UART CONTROLLER
                  ┌──────────────────────────┐
                  │                          │
                  │   ┌──────────────────┐   │
                  │   │ Baud Generator   │   │
                  │   └────────┬─────────┘   │
                  │            │             │
                  │       baud_tick          │
                  │        │       │         │
                  │        ▼       ▼         │
                  │   ┌────────┐ ┌────────┐  │
tx_data ─────────►│   │ UART   │ │ UART   │  │◄──────── rx
tx_start ────────►│   │   TX   │ │   RX   │  │
                  │   └───┬────┘ └───┬────┘  │
                  │       │          │       │
                  └───────┼──────────┼───────┘
                          │          │
                          ▼          ▼
                          TX       RX_DATA
                                     │
                                     ▼
                                PARITY CHECK
                                     │
                                     ▼
                               parity_error
