-- Chisel description
description = "counts how many times the accept() system call has been invoked each second"
short_description = "accept() rate"
category = "misc"

-- Chisel argument list
args = {}

-- Event counter
count = 0

-- Initialization callback
function on_init()

    -- Request the fields that we need
    ftype = chisel.request_field("evt.type")
    fdir = chisel.request_field("evt.dir")  
   
    -- respond to only the 'accept' syscall
    chisel.set_filter("evt.type = accept and evt.dir = >")

    -- set interval to 1 second
    chisel.set_interval_s(1)

    -- open log file for writing
    file = io.open("/opt/btdb/accept_rate.txt", "a")
    io.output(file)

    return true
end

-- Event parsing callback
function on_event()
    count = count + 1
    return true
end

-- Interval callback
function on_interval(ts_s, ts_ns, delta)
    io.write(count .. "\n")
    io.flush()
    count = 0
    return true
end
