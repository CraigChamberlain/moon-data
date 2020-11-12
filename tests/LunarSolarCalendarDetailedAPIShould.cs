using System;
using System.Collections.Generic;
using Xunit;
using SolarLunarName.SharedTypes.Interfaces;
using SolarLunarName.Standard.ApplicationServices;
using System.Linq;
using System.IO;
using SolarLunarName.SharedTypes.Models;

namespace SolarLunarName.Standard.Tests
{
    public class LunarSolarCalendarDetailedAPIShould : LunarSolarCalendarAPIShould
    {   
        public LunarSolarCalendarDetailedAPIShould():base (Paths.LunarSolarCalendarDetailed){
        }
        //TODO has no tests on items specific to the detail - phases.

    }
}
