# moon-data
_static json api_

Based on data taken from the USNO api before it was taken down for maintainence.

Two endpoints new-moon-data & moon phase-data.  Both can be served with an optional index.json.  Adding the index.json will negate a 301 redirect to increase the speed of request and may be required if your client does not support redirects.

examples:

### Moon Phase Data 
_/api/moon-phase-data/{year}[/index.json]_

https://craigchamberlain.github.io/moon-data/api/moon-phase-data/1700/[index.json]
    [{"Date":"1700-01-05T10:30:00","Phase":2},{"Date":"1700-01-12T03:34:00","Phase":3},{"Date":"1700-01-20T04:20:00","Phase":0},{"Date":"1700-01-28T05:13:00","Phase":1},{"Date":"1700-02-03T21:05:00","Phase":2},{"Date":"1700-02-10T18:59:00","Phase":3},{"Date":"1700-02-18T23:33:00","Phase":0},{"Date":"1700-02-26T16:37:00","Phase":1},...]

Where Phase =
 0: NewMoon, // [     ]
 1: FirstQuarter,//WaxingCressent, [  |) ]
 2: FullMoon,// [ ( ) ]
 3: LastQuarter// WainingCressent [ (|  ]

### New Moon Data 
_/api/new-moon-data/{year}[/index.json]_

https://craigchamberlain.github.io/moon-data/api/new-moon-data/1700/[index.json]
    ["1700-01-20T04:20:00","1700-02-18T23:33:00","1700-03-20T16:47:00","1700-04-19T06:51:00","1700-05-18T17:45:00","1700-06-17T02:16:00","1700-07-16T09:34:00","1700-08-14T16:47:00","1700-09-13T00:47:00","1700-10-12T10:15:00","1700-11-10T21:44:00","1700-12-10T11:44:00","1700-12-26T00:54:00"]



