{ floor } = Math

exports ?= this

pad = (l, n, s="0") ->
    r = ""+n
    r = s+r if r.length < l
    r


exports.locale = locale =
    day:
        full:"Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(' ')
        abbr:"Sun Mon Tue Wed Thu Fri Sat".split(' ')
    month:
        full:"January February March April May June July August September October November December".split(' ')
        abbr:"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split(' ')


exports.format = format =
    '%': -> "%"
    a: (d,l) -> l.day.abbr[d.getDay()]
    A: (d,l) -> l.day.full[d.getDay()]
    b: (d,l) -> l.month.abbr[d.getMonth()]
    B: (d,l) -> l.month.full[d.getMonth()]
    c: (d) -> # FIXME from_now format
    C: (d) -> pad 2, floor(d.getFullYear()/100)
    d: (d) -> pad 2, d.getDate()
    D: (d,l) -> strftime("%m/%d/%y", d, l)
    e: (d) -> format.d(d).replace('0', ' ')
    E: (d,l) -> # TODO Modifier: use alternative format, see below. (SU)
    F: (d,l) -> strftime("%Y-%m-%d", d, l)
    G: (d) -> # TODO The ISO 8601 year with century as a decimal number. The 4-digit year corresponding to the ISO week number (see %V). This has the same format and value as %y, except that if the ISO week number belongs to the previous or next year, that year is used instead. (TZ)
    g: (d) -> # TODO Like %G, but without century, i.e., with a 2-digit year (00-99). (TZ)
    h: (d,l) -> strftime("%b", d, l)
    H: (d) -> pad 2, d.getHours()
    I: (d) -> h=d.getHours() or 12; pad 2, h-(h > 12 and 12 or 0)
    j: (d) -> pad 3, floor((d - new Date("1.1.#{d.getFullYear()}"))/(1000*60*60*24))
    k: (d) -> pad 2, d.getHours(), " "
    l: (d) -> h=d.getHours() or 12; pad 2, h-(h > 12 and 12 or 0), " "
    m: (d) -> pad 2, d.getMonth()+1
    M: (d) -> pad 2, d.getMinutes()
    n: (d) -> "\n"
    O: (d) -> # TODO Modifier: use alternative format, see below. (SU)
    p: (d) -> # TODO Either 'AM' or 'PM' according to the given time value, or the corresponding strings for the current locale. Noon is treated as 'pm' and midnight as 'am'.
    P: (d) -> format.p(d)?.toLowerCase()
    r: (d,l) -> strftime("%I:%M:%S %p", d, l)
    R: (d,l) -> strftime("%H:%M", d, l)
    s: (d) -> floor(d.getTime() / 1000)
    S: (d) -> pad 2, d.getSeconds()
    t: (d) -> "\t"
    T: (d,l) -> strftime("%H:%M:%S", d, l)
    u: (d) -> (d.getDay()+5) % 6 + 1
    U: (d) -> # TODO The week number of the current year as a decimal number, range 00 to 53, starting with the first Sunday as the first day of week 01. See also %V and %W.
    V: (d) -> # TODO The ISO 8601:1988 week number of the current year as a decimal number, range 01 to 53, where week 1 is the first week that has at least 4 days in the current year, and with Monday as the first day of the week. See also %U and %W. (SU)
    w: (d) -> d.getDay()
    W: (d) -> # TODO The week number of the current year as a decimal number, range 00 to 53, starting with the first Monday as the first day of week 01.
    x: (d) -> # TODO The preferred date representation for the current locale without the time.
    X: (d) -> # TODO The preferred time representation for the current locale without the date.
    y: (d) -> y=d.getFullYear(); pad 2, y-floor(y/100)*100
    Y: (d) -> d.getFullYear()
    z: (d) -> # TODO The time-zone as hour offset from GMT. Required to emit RFC 822-conformant dates (using "%a, %d %b %Y %H:%M:%S %z"). (GNU)
    Z: (d) -> # TODO The time zone or name or abbreviation.


exports.strftime = strftime = (text = "%T", d = null, loc = locale) ->
    d ?= new Date
    d = new Date(d) unless d.constructor is Date
    for k, f of format
        regex = new RegExp("%#{k}", 'g')
        text = text.replace(regex, f(d, loc)) if regex.test(text)
    text


