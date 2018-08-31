function Vector2(x, y)
    local vector = {x, y}
    setmetatable(vector, 
        {
            __mul = function (t1, t2)
                return Vector2(t1[1] * t2[1], t1[2] * t2[2])
            end,
            __add = function (t1, t2)
                return Vector2(t1[1] + t2[1], t1[2] + t2[2])
            end
        }
    )
    return vector
end