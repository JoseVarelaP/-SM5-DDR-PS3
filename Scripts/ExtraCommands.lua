function Actor:TickSet(param)
    if param.CustomDifficulty then
        self:diffuse(CustomDifficultyToColor(param.CustomDifficulty));
    end

    return self,param
end

function SetFrameDifficulty( pn )
	if GAMESTATE:GetCurrentSteps(pn) then
        local steps = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
        local diffs = {
            ["Difficulty_Beginner"] = 0,
            ["Difficulty_Easy"] = 1,
            ["Difficulty_Medium"] = 2,
            ["Difficulty_Hard"] = 3,
            ["Difficulty_Challenge"] = 4,
            ["Difficulty_Edit"] = 5,
        };
		return diffs[steps]
	else
		return 0
	end
end

function PillTransform(self,offsetFromCenter,itemIndex,numItems)
    local zoomed_width=16;
	local zoomed_height=9;
	local spacing_x=9.35;
	self:zoomtoheight(zoomed_height)
	:x(-149.5+(spacing_x*itemIndex))
    :vertalign(bottom):zoomtowidth(50)
	:rotationz(-90):wag()
    :effectoffset( -0.035*itemIndex ):effectclock("bgm"):effectperiod(2)
    :effectmagnitude(90,0,0):cropleft(0.5)
end