local t = Def.ActorFrame{}

local function SetFrameDifficulty( pn )
	if GAMESTATE:GetCurrentSteps(pn) then
		local steps = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
		local DifficultyToSet = 0;
		if steps == "Difficulty_Beginner" then DifficultyToSet = 0; end
		if steps == "Difficulty_Easy" then DifficultyToSet = 1; end
		if steps == "Difficulty_Medium" then DifficultyToSet = 2; end
		if steps == "Difficulty_Hard" then DifficultyToSet = 3; end
		if steps == "Difficulty_Challenge" then DifficultyToSet = 4; end
		if steps == "Difficulty_Edit" then DifficultyToSet = 5; end
		return DifficultyToSet
	else
		return 0
	end
end

-- We need to create a spiral-like area that all items will adjust to.
local PPos = {
    ["Default"] = { SCREEN_CENTER_X-15, SCREEN_CENTER_Y-70 },
    ["PlayerNumber_P1"] = { SCREEN_CENTER_X-120, SCREEN_CENTER_Y-70 },
    ["PlayerNumber_P2"] = { SCREEN_CENTER_X+120, SCREEN_CENTER_Y-70 },
}

local Judgments = {
    {"Marvelous","TapNoteScore_W1"},
    {"Perfect","TapNoteScore_W2"},
    {"Great","TapNoteScore_W3"},
    {"Good","TapNoteScore_W4"},
    {"Boo","TapNoteScore_W5"},
    {"Miss","TapNoteScore_Miss"},
}

for player in ivalues(PlayerNumber) do
    local PFrame = Def.ActorFrame{
        Condition=GAMESTATE:IsPlayerEnabled(player),
        OnCommand=function(self)
            self:hibernate(0.6)
            if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
                self:xy( PPos[player][1]+3, PPos[player][2]-50 ):linear(0.2)
                self:xy( PPos[player][1]+40, PPos[player][2]-10 ):linear(0.2)
                self:xy( unpack(PPos[player]) )
            else
                self:xy( PPos["Default"][1]+3, PPos["Default"][2]-50 ):linear(0.2)
                self:xy( PPos["Default"][1]+40, PPos["Default"][2]-10 ):linear(0.2)
                self:xy( unpack(PPos["Default"]) )
            end
        end;
    };

    PFrame[#PFrame+1] = Def.Sprite{
        Texture=THEME:GetPathG("","Evaluation/EvalProfFrame"),
        OnCommand=function(self)
            self:zoom(0.6)
        end;
    };

    PFrame[#PFrame+1] = Def.Sprite{
        Texture=THEME:GetPathG("","DiffList"),
        OnCommand=function(self)
            self:xy(-130,-4):zoom(0.2):pause():halign(0)
            self:setstate( SetFrameDifficulty(PLAYER_1) )
        end;
    };

    PFrame[#PFrame+1] = Def.BitmapText{
        Font="Common Normal",
        Text=PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName(),
        OnCommand=function(self)
            self:zoom(0.4):xy(-130,7):halign(0)
        end;
    };

    PFrame[#PFrame+1] = Def.BitmapText{
        Font="handel gothic/20px",
        Text=string.sub( ToEnumShortString(player) ,2),
        OnCommand=function(self)
            self:zoom(0.8):xy(-144,1):halign(0)
        end;
    };

    for i,v in ipairs(Judgments) do
        PFrame[#PFrame+1] = Def.BitmapText{
            Font="bold handel gothic/25px",
            Text=string.upper(v[1]),
            OnCommand=function(self)
                self:zoom(0.7)
                :xy( -110 + (8*i), 30+(20*i) )
                :halign(0):diffusealpha(0):hibernate(0.3)
                :sleep(0.07*i):diffusealpha(1):linear(0.1)
            end;
        };

        PFrame[#PFrame+1] = Def.BitmapText{
            Font="bold handel gothic/25px",
            Text=STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores(v[2]),
            OnCommand=function(self)
                self:zoom(0.7)
                :xy( 100 + (6*i),30+(20*i))
                :halign(1):diffusealpha(0)
                :sleep(2 + (0.5*i)):diffusealpha(1):linear(0.1)
            end;
        };
    end

    t[#t+1] = PFrame
end

t[#t+1] = Def.BitmapText{
    Font="bold handel gothic/25px",
    Text=GAMESTATE:GetCurrentSong():GetDisplayMainTitle(),
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X+(130-320), SCREEN_CENTER_Y+(108-240) ):halign(0):zoom(0.8)
        :hibernate(0.5)
    end;
};

return t;