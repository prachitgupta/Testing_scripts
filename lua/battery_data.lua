local SCRIPT_NAME     = 'batt_data_logger.lua'
local RUN_INTERVAL_MS = 3000
local Filename = 'scripts/batt.log'
local voltage = 0
local current = 0
local capacity = 0

-- wrapper for gcs:send_text()
local function gcs_msg(severity, txt)
    gcs:send_text(severity, string.format('%s: %s', SCRIPT_NAME, txt))
end

local file = io.open(FILENAME, "a")

function update()

    -- fixed this line to work properly (YouTube demo has a logic error)
    if (not battery:healthy(0)) then 
        gcs:send_text(MAV_SEVERITY_WARN,"battery monitoring not started")
        return update, RUN_INTERVAL_MS
    end

    voltage = battery:voltage(0)
    current = battery:current_amp(0)
    capacity = battery:consumed_mah(0)

    file:write(string.format("Voltage = %fV  Current = %f  Capacity = %fmah",voltage,current,capacity))
    gcs_msg(MAV_SEVERITY_INFO,string.format("Voltage = %fV  Current = %fA  Capacity = %fmah",voltage,current,capacity))
    return update, RUN_INTERVAL_MS
end

gcs_msg(MAV_SEVERITY_INFO, 'Initialized.')

return update()