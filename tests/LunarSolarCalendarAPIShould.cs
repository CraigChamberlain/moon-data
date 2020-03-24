using System;
using System.Collections.Generic;
using Xunit;
using SolarLunarName.Standard.ApplicationServices;
using System.Linq;

namespace SolarLunarName.Standard.Tests
{
    public class LunarSolarCalendarAPIShould
    {   
        private readonly CalendarDataService _calendarDataService;

        public LunarSolarCalendarAPIShould(){
            var client = new Standard.RestServices.LocalJson.LunarCalendarClient(@"../../../../../moon-data/api/lunar-solar-calendar");
            _calendarDataService = new CalendarDataService(client);
        }

        [Theory]
        [MemberData(nameof(YearRange))]
        public void LunarSolarCalendarAPIShould_HaveEither13or14Months(int year)
        {
            var calendar = _calendarDataService.GetSolarLunarYear(year);
            var numberOfMonths = calendar.Count();
            Assert.True(numberOfMonths == 13 || numberOfMonths == 14, "Returns year of 13 or 14 months.");


        }

        [Theory]
        [MemberData(nameof(YearRange))]
        public void LunarSolarCalendarAPIShould_HaveMonthsOf30DaysOrLess(int year)
        {
            var calendar = _calendarDataService.GetSolarLunarYear(year);
            var first = calendar.First().Days;
            var last = calendar.Last().Days;
            var remaining = calendar.Skip(1).SkipLast(1).Select(month => month.Days);
            
            Assert.True(first <= 30 && first > 0 , "First Month should be between 1 and 30 days");
            Assert.True(remaining.All(days => days == 29 || days == 30) , "Middle Month should be between 29 or 30 days");
            Assert.True(last <= 30 && last > 0 , "Last Month should be between 1 and 30 days");
        
        }

        [Theory]
        [MemberData(nameof(YearRange))]
        public void LunarSolarCalendarAPIShould_DaysTotalling365(int year)
        {   
            var startOfNextYear = new DateTime(year + 1 , 1, 1);
            var actualDays = startOfNextYear.AddDays(-1).DayOfYear;
            var calendar = _calendarDataService.GetSolarLunarYear(year);
            Assert.True(calendar.Sum(month => month.Days) == actualDays, "A years months should have the same number of total days as the gregorian year.");
        
        }

        [Theory]
        [MemberData(nameof(YearRange))]
        public void LunarSolarCalendarAPIShould_MonthsShouldNotSkipOrDuplicateDays(int year)
        {   
            var calendar = _calendarDataService.GetSolarLunarYear(year);
            var firstMonths = calendar.SkipLast(1);

            var firstMonthsHaveCorrectDays = 
                    firstMonths
                        .Select((m, i) => m.Date.AddDays(m.Days) == calendar[i + 1].Date )
                        .All(x => x);
            

            var lastMonthHasCorrectDays = 
                    calendar
                        .Select(m => m.Date.AddDays(m.Days))
                        .Last()
                        .Equals(new DateTime(year + 1 , 1, 1))                  
                        ;



            Assert.True(firstMonthsHaveCorrectDays , "A month should account for all days before the next and not overlap.");
            Assert.True(lastMonthHasCorrectDays , "The final month should account for all days remaining in the year before the next and not overlap.");
        
        
        }

  
        public static IEnumerable<object[]> YearRange => Enumerable.Range(1700,381).Select(x => new object[]{x});


    }
}
