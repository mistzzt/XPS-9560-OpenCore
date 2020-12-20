// XPCM Power Management, ACPIACAdapter, and Sleeping Fix
// Renames: GPRW to XPRW, _WAK to ZWAK
DefinitionBlock ("", "SSDT", 2, "DXPS", "PwrMgt", 0)
{
    External (_SB_.AC__, DeviceObj)
    External (_SB_.PCI0.LPCB.ECDV, DeviceObj)
    External (_PR_.CPU0, ProcessorObj)

    External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
    External (_SB_.PCI0.PEG0.PEGP._ON, MethodObj)
    
    External (XPRW, MethodObj)
    External (ZWAK, MethodObj)

    Method (PMPM, 4, NotSerialized) {
       If (LEqual (Arg2, Zero)) {
           Return (Buffer (One) { 0x03 })
       }

       Return (Package (0x02)
       {
           "plugin-type", 
           One
       })
    }

    If (_OSI ("Darwin"))
    {
        // XCPM power management compatibility table with Darwin method
        // Adapted from SSDT-PLUG
        Scope (\_PR.CPU0)
        {
            Method (_DSM, 4, NotSerialized)
            {
                Return (PMPM (Arg0, Arg1, Arg2, Arg3))
            }
        }

        // Power fix - cause AppleACPIACAdapter to be loaded
        Scope (\_SB.AC)
        {
            Name (_PRW, Package ()  // _PRW: Power Resources for Wake
            {
                0x18, 
                3
            })
        }

        // https://bugzilla.kernel.org/show_bug.cgi?id=109511
        Device (_SB.PCI0.LPCB.ECDV.CHRG)
        {
            Name (_HID, "DELLBBB1")  // _HID: Hardware ID
            Method (_STA, 0)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        // Power Management Interface for NVIDIA dGPU
        Device (RMDC)
        {
            Name (_HID, "RMD10000")  // _HID: Hardware ID
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                DGOF ()
            }
            
            // Disable Nvidia GPU
            Method (DGOF, 0)
            {
                If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF))
                {
                    \_SB.PCI0.PEG0.PEGP._OFF ()
                }
            }

            // Enable Nvidia GPU
            Method (DGON, 0)
            {
                If (CondRefOf (\_SB.PCI0.PEG0.PEGP._ON))
                {
                    \_SB.PCI0.PEG0.PEGP._ON ()
                }
            }
        }
    }

    // Change return value of GPRW to fix device couldnt sleep normally
    Scope (\)
    {
        Method (GPRW, 2)
        {
            If ((_OSI ("Darwin") && (0x6D == Arg0)))
            {
                Return (Package (2)
                {
                    0x6D, 
                    Zero
                })
            }

            Return (\XPRW (Arg0, Arg1))
        }
    }

    Method (_WAK, 1)  // _WAK: Wake
    {
        Local0 = ZWAK (Arg0)
        If (_OSI ("Darwin"))
        {
            \RMDC.DGOF ()
        }
        Return (Local0)
    }
    
    Scope (\_SB)
    {
        // This enables deep idle
        Method (LPS0, 0, NotSerialized)
        {
            Return (One)
        }
    }
     
    Scope (\_GPE)
    {
        // This tells xnu to evaluate _GPE.Lxx methods on resume
        Method (LXEN, 0, NotSerialized)
        {
            Return (One)
        }
    }
}