require "Vector2"

RectangularCoordinateSystem = RectangularCoordinateSystem or BaseClass and BaseClass() or {}

function RectangularCoordinateSystem:__init()
end

function RectangularCoordinateSystem:__delete()
end

-- 通过斜坐标的 X Y 轴角度偏移，计算被转换的坐标在原坐标的落点
-- 该斜坐标的 角度偏移 是相对于 正坐标 的坐标轴来说的
-- return Vector2
function RectangularCoordinateSystem.TranslateVector2(x_offset_angle, y_offset_angle, position)
    -- 获取斜坐标轴的两个法向量
    local x_angle_in_90 = x_offset_angle % 90
    local y_angle_in_90 = y_offset_angle % 90
    local x_vector = Vector2(math.cos(x_angle_in_90 * math.pi / 180), math.sin(x_angle_in_90 * math.pi / 180)) * RectangularCoordinateSystem.GetQuadrant(x_offset_angle)
    local y_vector = Vector2(math.sin(y_angle_in_90 * math.pi / 180), math.cos(y_angle_in_90 * math.pi / 180)) * RectangularCoordinateSystem.GetQuadrant(y_offset_angle)
    return x_vector * position + y_vector * position
end

-- 返回各个象限 45度角 的向量
function RectangularCoordinateSystem.GetQuadrant(angle)
    local quadrant = (angle % 360) / 90
    if quadrant < 1 then
        return Vector2(1, 1)
    elseif quadrant == 1 then
        return Vector2(0, 1)
    elseif quadrant < 2 then
        return Vector2(-1, 1)
    elseif quadrant == 2 then
        return Vector2(-1, 0)
    elseif quadrant < 3 then
        return Vector2(-1, -1)
    elseif quadrant == 3 then
        return Vector2(0, -1)
    elseif quadrant < 4 then
        return Vector2(1, -1)
    elseif quadrant == 4 then
        return Vector2(1, 0)
    end
end

-- local system = RectangularCoordinateSystem
-- local v2 = Vector2(100, 100)
-- local v2_result = system.TranslateVector2(0, 30, v2)
-- print(v2_result[1], v2_result[2])