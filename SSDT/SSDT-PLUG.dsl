/*
 * XCPM power management compatibility table with Darwin method.
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "CpuPlug", 0x00003000)
{
    External (_PR_.CPU0, ProcessorObj)

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
    
    If (CondRefOf (\_PR.CPU0)) {
        If ((ObjectType (\_PR.CPU0) == 0x0C)) {
            Scope (\_PR.CPU0) {
                If (_OSI ("Darwin")) {
                    Method (_DSM, 4, NotSerialized)  
                    {
                        Return (PMPM (Arg0, Arg1, Arg2, Arg3))
                    }
                }
            }
        }
    }
}
