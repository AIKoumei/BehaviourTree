BTLog = BTLog or {}

function BTLog:OpenLog()
    BTLog.log = true
end

function BTLog:CloseLog()
    BTLog.log = false
end

function BTLog:__CheckCanLog()
    return BTLog.log
end
