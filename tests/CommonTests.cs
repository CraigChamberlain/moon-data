using System;
using System.Collections.Generic;
using Xunit;
using System.Text.Json;
using System.IO;
using System.Linq;


namespace SolarLunarName.Standard.Tests
{
    public abstract class CommonTests
    {   
        public CommonTests(string resourcePath){
            _resourcePath = resourcePath;
        }
        protected string _resourcePath;

        [Fact]
        public void APIShould_HaveRootDocument()
        {   
            Assert.True(System.IO.File.Exists(_resourcePath+"/index.json"));
        }

        [Fact]
        public void APIShould_RootDocumentShouldBeCorrect()
        {   
            var exampleRange = Enumerable.Range(1700,383).ToList();
            using (FileStream fs = File.OpenRead(_resourcePath+"/index.json"))
            {
                var testedRange = JsonSerializer.DeserializeAsync<Dictionary<string,List<int>>>(fs).Result;
                Assert.True(
                    exampleRange.SequenceEqual(testedRange["years"])
                );
            }

        }
        public static IEnumerable<object[]> YearRange => Enumerable.Range(1700,382).Select(x => new object[]{x});

    }
}