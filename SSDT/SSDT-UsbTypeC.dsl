//
// Dell XPS 15 9560
//
// This SSDT fixes Type-C hot plug, and attempts to implement Thunderbolt device tree structure.
//
// Credit to dpassmor for the original ExpressCard idea:
// https://www.tonymacx86.com/threads/usb-c-hotplug-questions.211313/
//
DefinitionBlock ("", "SSDT", 2, "DXPS", "UsbTypeC", 0x00000000)
{
    External (_SB_.PCI0.RP15.PXSX, DeviceObj)

    Scope (\_GPE)
    {
        Method (YTBT, 2, NotSerialized)
        {
            Return (Zero)
        }
    }

	// USB-C
	Scope (_SB.PCI0.RP15.PXSX) // UPSB
	{
		// This is the key fix for machines that turn off the Type-C port, right here.
		Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
		{
			Return (One) // Returning 0 means not a removable device. But we want to act like an ExpressCard! (credit dpassmor)
		}

		Method (_STA, 0, NotSerialized)  // _STA: Status
		{
			Return (0x0F)
		}
	}
}