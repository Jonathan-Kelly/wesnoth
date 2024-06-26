local AH = wesnoth.require "ai/lua/ai_helper.lua"
local MAIUV = wesnoth.require "ai/micro_ais/micro_ai_unit_variables.lua"

return function(cfg)
    -- Calculate next waypoint and rating for all messengers
    -- Return next messenger to move and waypoint toward which it should move
    -- Also return the array of all messengers (for escort move evaluation,
    -- so that it only needs to be done in one place, in case the syntax is changed some more)
    -- Returns nil for first 3 arguments if no messenger has moves left
    -- Returns nil for all arguments if there are no messengers on the map

    local filter = wml.get_child(cfg, "filter") or { id = cfg.id }
    local messengers = wesnoth.units.find_on_map { side = wesnoth.current.side, wml.tag["and"] ( filter ) }
    if (not messengers[1]) then return end

    local waypoints = AH.get_multi_named_locs_xy('waypoint', cfg)

    -- Set the next waypoint for all messengers
    -- Also find those with MP left and return the one to next move, together with the WP to move toward
    local max_rating, best_messenger, x, y = - math.huge, nil, nil, nil
    for _,messenger in ipairs(messengers) do
        -- To avoid code duplication and ensure consistency, we store some pieces of
        -- information in the messenger units, even though it could be calculated each time it is needed
        local wp_i = MAIUV.get_mai_unit_variables(messenger, cfg.ai_id, "wp_i") or 1
        local wp_x, wp_y = waypoints[wp_i][1], waypoints[wp_i][2]

        -- If this messenger is within 3 hexes of the next waypoint, we go on to the one after that
        -- except if it's the last one
        local dist_wp = wesnoth.map.distance_between(messenger.x, messenger.y, wp_x, wp_y)
        if (dist_wp <= 3) and (wp_i < #waypoints) then wp_i = wp_i + 1 end

        -- Also store the rating for each messenger
        -- For now, this is simply a "forward rating"
        local rating = wp_i - dist_wp / 1000.

        -- If invert_order= key is set, we want to move the rearmost messenger first.
        if cfg.invert_order then rating = - rating end

        MAIUV.set_mai_unit_variables(messenger, cfg.ai_id, { wp_i = wp_i, wp_x = wp_x, wp_y = wp_y, wp_rating = rating })

        if (messenger.moves > 0) and (rating > max_rating) then
            best_messenger, max_rating = messenger, rating
            x, y = wp_x, wp_y
        end
    end

    return best_messenger, x, y, messengers
end
