# OpenCore Configuration for Dell XPS 15 9560

## UEFI BIOS Variables Setup

| Variable                       | Offset | Default         | Desired         | Comment |
|--------------------------------|--------|-----------------|-----------------|---------|
| CFG Lock                       | 0x4ED  | 0x01 (Enabled)  | 0x00 (Disabled) |         |
| Above 4GB MMIO BIOS assignment | 0x79A  | 0x00 (Disabled) | 0x01 (Enabled)  |         |
| CSM Support                    | 0xFC8  | 0x01 (Enabled)  | 0x00 (Disabled) |         |