// Dell XPS 15 9360 
//
// This SSDT contains a remapping of the BRT6 (brightness control) method.
//
// BRT6 Method in DSDT is renamed to BRTX, and call to BRT6 land here.
// 
// BRT6 fix the brightness key control.
// 
// Credit to darkhandz:
// https://github.com/darkhandz/XPS15-9550-Sierra
//
DefinitionBlock ("", "SSDT", 2, "DXPS", "BRT6", 0)
{
    External (_SB_.PCI0.GFX0, DeviceObj)
    External (_SB_.PCI0.GFX0.LCD_, DeviceObj)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)
    External (_SB_.PCI0.GFX0.BRTX, MethodObj)
    External (ALSE, IntObj)

    Scope (_SB.PCI0.GFX0)
    {
        Method (BRT6, 2)
        {
            If (_OSI ("Darwin"))
            {
                If ((Arg0 == One))
                {
                    Notify (^LCD, 0x86) // Device-Specific
                    Notify (^^LPCB.PS2K, 0x10) // Reserved
                    Notify (^^LPCB.PS2K, 0x0206)
                    Notify (^^LPCB.PS2K, 0x0286)
                }

                If ((Arg0 & 0x02))
                {
                    Notify (^LCD, 0x87) // Device-Specific
                    Notify (^^LPCB.PS2K, 0x20) // Reserved
                    Notify (^^LPCB.PS2K, 0x0205)
                    Notify (^^LPCB.PS2K, 0x0285)
                }
            }
            Else
            {
                \_SB.PCI0.GFX0.BRTX (Arg0, Arg1)
            }
        }
    }
}
