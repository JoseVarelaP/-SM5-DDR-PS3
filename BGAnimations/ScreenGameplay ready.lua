local t = Def.ActorFrame {
	OnCommand=function(self)
		if GAMESTATE:GetCurrentSong() then
			local sleepcalc = GAMESTATE:GetCurrentSong():GetFirstSecond() - THEME:GetMetric("ScreenGameplay","MinSecondsToStep")
			self:sleep( sleepcalc > 0 and sleepcalc or 0 )
		end
	end;
};

return t;