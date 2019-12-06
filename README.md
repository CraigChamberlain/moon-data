# moon-data
__static json api__

Based on data taken from the [The United States Naval Observatory (USNO) api](https://aa.usno.navy.mil/data/docs/api.php#phase){:target="_blank"} before it was taken down for maintainence.  Reuse is with permission of USNO but they have not checked my work for errors and can not be held responsable for any errors hereinafter.
[Example of original response](/USNO/ExampleYear.json){:target="_blank"}

## UTC
All times are UTC as the moon appears in the same phase for all locations on the planet.  Adjust for local time as required.

## Endpoints 
  - moon-phase-data _/api/moon-phase-data/{year}[/index.json]_
  - new-moon-data _/api/new-moon-data/{year}[/index.json]_

Data can be served at {year} directory or optionaly at {year}/index.json.  Adding the index.json will negate a 301 redirect to increase the speed of request and may be required if your client does not support redirects.

## Date Range

Min | Max 
--- | ---
1700 | 2082

e.g.

https://craigchamberlain.github.io/moon-data/api/moon-phase-data/2083 -> 404 File not found. Http Status Code

## Examples:

### Moon Phase Data 

Returns a years worth of DateTime and Phase objects.  Phase is 0-3 for the quaters of a moon cycle as detailed in the table below with some sample representations.  Date, is the instance when each event will or has occured.

[https://craigchamberlain.github.io/moon-data/api/moon-phase-data/1700/[index.json]](https://craigchamberlain.github.io/moon-data/api/moon-phase-data/1700/)

    [{"Date":"1700-01-05T10:30:00","Phase":2},{"Date":"1700-01-12T03:34:00","Phase":3},{"Date":"1700-01-20T04:20:00","Phase":0},{"Date":"1700-01-28T05:13:00","Phase":1},{"Date":"1700-02-03T21:05:00","Phase":2},{"Date":"1700-02-10T18:59:00","Phase":3},{"Date":"1700-02-18T23:33:00","Phase":0},{"Date":"1700-02-26T16:37:00","Phase":1},...]

Where Phase =

| ID | Name | Alt. | ascii Art | UTF-8 | ascii |
| --- | --- | --- | --- | --- |  --- |
| 0 | NewMoon |  | `[____]` | 🌑 </br> `(U+1F311; f0 9f 8c 91;)` | ∙ `(&#8729; &#x2219;)`
| 1 | FirstQuarter | WaxingCressent | `[__\|)_]` | 🌓 </br> `(U+1F313; f0 9f 8c 93;)` | ⦈ `(&#10632; &#x2988;)` |
| 2 | FullMoon |  | `[_(_)_]` | 🌕 </br> `(U+1F315; f0 9f 8c 95;)` | ○ `(&#9675; &#x25cb;)` \|\| </br> ∘ `(&#8728; &#x2218;)` |
| 3 | LastQuarter | WainingCressent | `[_(\|__]` | 🌗 </br> `(U+1F317; f0 9f 8c 97;)` | ⦇ `(&#10631; &#x2987;)` |


### New Moon Data 

Returns a years worth of DateTimes of the instances of a new moon.

[https://craigchamberlain.github.io/moon-data/api/new-moon-data/1700/[index.json]]([https://craigchamberlain.github.io/moon-data/api/new-moon-data/1700/)

    ["1700-01-20T04:20:00","1700-02-18T23:33:00","1700-03-20T16:47:00","1700-04-19T06:51:00","1700-05-18T17:45:00","1700-06-17T02:16:00","1700-07-16T09:34:00","1700-08-14T16:47:00","1700-09-13T00:47:00","1700-10-12T10:15:00","1700-11-10T21:44:00","1700-12-10T11:44:00","1700-12-26T00:54:00"]



