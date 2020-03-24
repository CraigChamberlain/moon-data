using System;
using System.Collections.Generic;
using Xunit;
using SolarLunarName.Standard.ApplicationServices;
using System.Linq;
using SolarLunarName.Standard.RestServices.LocalJson;

namespace SolarLunarName.Standard.Tests
{
    public class NewMoonDataAPIShould
    {   
        private readonly MoonDataClient _client;

        public NewMoonDataAPIShould(){
            _client = new Standard.RestServices.LocalJson.MoonDataClient(@"../../../../../moon-data/api/new-moon-data");
        }

        [Theory]
        [MemberData(nameof(YearRange))]
        public void NewMoonDataAPIShould_HaveEither12or13NewMoons(int year)
        {   
            var calendar = _client.GetYear(year.ToString());
            var numberOfMonths = calendar.Count();
            Assert.True(numberOfMonths == 12 || numberOfMonths == 13, "Returns year of 12 or 13 new moons.");


        }

        [Theory]
        [MemberData(nameof(YearRange))]
        public void NewMoonDataAPIShould_BeSorted(int year)
        {   
            var calendar = _client.GetYear(year.ToString());
            Assert.True(IsOrdered(calendar), "Months are in correct order.");

        }
        
        [Theory]
        [MemberData(nameof(YearRange))]
        public void NewMoonDataAPIShould_AllBeOfTheRightYear(int year)
        {   
            var calendar = _client.GetYear(year.ToString());
            Assert.True(calendar.All(date => date.Year == year), "Months are all of right year.");

        }

        public bool IsOrdered<T>(IList<T> list, IComparer<T> comparer = null)
        {
                if (comparer == null)
                {
                    comparer = Comparer<T>.Default;
                }

                if (list.Count > 1)
                {
                    for (int i = 1; i < list.Count; i++)
                    {
                        if (comparer.Compare(list[i - 1], list[i]) > 0)
                        {
                            return false;
                        }
                    }
                }
                return true;
        }

  
        public static IEnumerable<object[]> YearRange => Enumerable.Range(1700,381).Select(x => new object[]{x});


    }
}
