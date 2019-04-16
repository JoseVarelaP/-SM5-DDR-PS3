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
local function iris_mod_internal(str, pn)
    local ps= GAMESTATE:GetPlayerState(pn)
    local pmods= ps:GetPlayerOptionsString('ModsLevel_Song')
    ps:SetPlayerOptions('ModsLevel_Song', pmods .. ', ' .. str)
    --GAMESTATE:ApplyGameCommand('mod,'..str, pn)
end

for player in ivalues(PlayerNumber) do
    local Judg=Def.ActorFrame{
        Condition=GAMESTATE:IsPlayerEnabled(player);
        OnCommand=function(self)
            local PSideTake = (GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2)) and THEME:GetMetric("ScreenGameplay","Player".. ToEnumShortString(player) .. "TwoPlayersTwoSidesX") or THEME:GetMetric("ScreenGameplay","Player".. ToEnumShortString(player) .. "OnePlayerOneSideX")
            self:xy( PSideTake, (THEME:GetMetric("Player","ReceptorArrowsYStandard"))*-1 )
            :zoom(1.3):diffusealpha(0)
            -- Honestly this is a nice place to hide the real judgments
            if GAMESTATE:IsPlayerEnabled(player) then
                SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(player)):GetChild("Judgment"):visible(false)
            end

            -- Now apply an attack to the player!
            local modst = "*999 dark1, *999 stealth1"
            for i=2,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
                modst = modst .. ", ".. "*999".. " dark"..i..", *999 stealth"..i
            end
            iris_mod_internal(modst, player)
        end;
        EnterGameplayMessageCommand=function(self)
            self:decelerate(0.5):zoom(1):diffusealpha(1)
            
            self:queuemessage("StartReceptor1")
        end;
    };

    Judg[#Judg+1] = Def.Sprite{
        Texture=THEME:GetPathG("","GameArea"),
        OnCommand=function(self)
            -- Fit within SM's 64x64 note setting.
            self:xy(2,96):zoomx(0.95)
        end;
        EnterGameplayMessageCommand=function(self)
            self:sleep(0.4):decelerate(0.4):diffusealpha(0.7)
        end;
    };

    Judg[#Judg+1] = Def.Sprite{
        Texture=THEME:GetPathG("","PNumberBoard"),
        OnCommand=function(self)
            self:xy(0,100):zoom(1):pause():diffusealpha(0.3)
            self:setstate( string.sub( ToEnumShortString(player), 2 ) -1 )
        end;
    };

    local PInfo = Def.ActorFrame{
        OnCommand=function(self)
            self:y( -80 )
        end;
        EnterGameplayMessageCommand=function(self)
            self:sleep(0.4):decelerate(0.4):y(0)
        end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Texture=THEME:GetPathG("","PlayInfo"),
        OnCommand=function(self)
            self:xy(0,-100):zoom(0.2)
        end;
        -- I'm so sorry, but I cannot find another way of doing this without breaking sm.
        StartReceptor1MessageCommand=function(self) iris_mod_internal("*2 0 dark1, *2 0 stealth1", player) self:finishtweening():sleep(1/3):queuemessage("StartReceptor2") end;
        StartReceptor2MessageCommand=function(self) iris_mod_internal("*2 0 dark2, *2 0 stealth2", player) self:finishtweening():sleep(1/3):queuemessage("StartReceptor3") end;
        StartReceptor3MessageCommand=function(self) iris_mod_internal("*2 0 dark3, *2 0 stealth3", player) self:finishtweening():sleep(1/3):queuemessage("StartReceptor4") end;
        StartReceptor4MessageCommand=function(self) iris_mod_internal("*2 0 dark4, *2 0 stealth4", player) end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Texture=THEME:GetPathG("","DiffList"),
        OnCommand=function(self)
            self:xy(-80,-110):zoom(0.2):pause()
            self:setstate( SetFrameDifficulty(player) )
        end;
    };
    
    PInfo[#PInfo+1] = Def.BitmapText{
        Font="handel gothic/20px",
        Text=PROFILEMAN:GetProfile(player):GetDisplayName(),
        OnCommand=function(self)
            self:xy(0,280):zoom(0.8):diffusealpha(0)
        end;
        EnterGameplayMessageCommand=function(self)
            self:sleep(0.8):decelerate(0.4):diffusealpha(0.5)
        end;
    };

    -- Clone time
    PInfo[#PInfo+1] = Def.ActorProxy{
        BeginCommand=function(self)
            self:SetTarget( SCREENMAN:GetTopScreen():GetChild("Life"..ToEnumShortString(player)) )
            :xy(46, -105)
        end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Texture=THEME:GetPathG("Lifebar","Frame"),
        OnCommand=function(self)
            self:xy(44,-110):zoomy(0.55):zoomx(0.55):cropbottom(0.25)
        end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Texture=THEME:GetPathG("Lifebar","Glow"),
        OnCommand=function(self)
            self:xy(44,-110):zoomy(0.55):zoomx(0.55):cropbottom(0.25):diffusealpha(0)
            :glowramp():effectcolor1( 0,0,0,0 ):effectcolor2( color(1,1,1,1) ):effectclock("bgm"):effectperiod(1)
            :blend(Blend.Add)
        end;
        LifeChangedMessageCommand=function(self,params)
            if (params.Player == player) then
                if GAMESTATE:GetPlayerState(player):GetHealthState() == "HealthState_Hot" then
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            end
        end;
    };

    PInfo[#PInfo+1] = Def.ActorProxy{
        BeginCommand=function(self)
            self:SetTarget( SCREENMAN:GetTopScreen():GetChild("Score"..ToEnumShortString(player)) )
            :xy(60, -92)
        end;
    };

    Judg[#Judg+1] = PInfo

    for i=1,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
        Judg[#Judg+1] = Def.Quad{
            OnCommand=function(self)
                self:zoomto(64,400):diffusealpha(0):x(-64*2.5+(64*i)):vertalign(top):y( -36 )
            end;
            JudgmentMessageCommand=function(self, params)
                if params.Player == player and params.Notes then
                    for e,col in pairs(params.Notes) do
                        if e == i then
                            local cur_line = "JudgmentLine_" .. ToEnumShortString(params.TapNoteScore)
                            self:stoptweening():zoomtowidth(64):fadeleft(1):faderight(1)
                            :diffuse( JudgmentLineToColor(cur_line) )
                            :decelerate(1.1):zoomtowidth(32)
                            :diffusealpha(0)
                        end
                    end
                end
            end;
        };

        Judg[#Judg+1] = Def.Sprite{
            Texture=THEME:GetPathG("","Judgment"),
            OnCommand=function(self)
                self:xy(-64*2.5+(64*i), -64*1.3):zoom(0.3):pause():diffusealpha(0)
            end;
            JudgmentMessageCommand=function(self, params)
                if params.Player == player and params.Notes then
                    for e,col in pairs(params.Notes) do
                        if e == i then
                            local cur_line = string.sub(ToEnumShortString(params.TapNoteScore), 2)
                            self:stoptweening():diffuse(1,1,1,1):zoom(0):glow(1,1,1,1)
                            :setstate( ToEnumShortString(params.TapNoteScore) == "Miss" and 5 or cur_line-1 )
                            :linear(0.15):zoom(0.35):linear(0.15):glow(0,0,0,0):zoom(0.3):sleep(0.3)
                            :diffusealpha(0)
                        end
                    end
                end
            end;
        }
    end
    t[#t+1] = Judg
end

return t;