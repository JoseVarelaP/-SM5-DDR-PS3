local t = Def.ActorFrame{}

-- Doubles Mode Check
local InDoubleMode = GAMESTATE:GetCurrentStyle():GetName() == "double"

-- Mod Applier
local function iris_mod_internal(str, pn)
    local ps= GAMESTATE:GetPlayerState(pn)
    local pmods= ps:GetPlayerOptionsString('ModsLevel_Song')
    ps:SetPlayerOptions('ModsLevel_Song', pmods .. ', ' .. str)
end

local SMod = {1/3, "*2 0 dark"}
local CSP = false
local RCount = {
    ["PlayerNumber_P1"] = 1,
    ["PlayerNumber_P2"] = 1,
}

-- Small function to call Color effects for Full Combo
-- Note To Self: fix this abomination of if statements
local function GetFullComboEffectColor(pss)
    local colors = {
        [6] = color("#ffffff"),
        [7] = color("#fafc44"),
        [8] = color("#06fd32"),
        [9] = color("#3399ff"),
    };
    for i=6,9 do if pss:FullComboOfScore(i) then return colors[i] end end
	return Color.White
end;

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
            local modst = "*999 dark1"
            for i=2,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
                modst = modst .. ", ".. "*999".. " dark"..i
            end
            iris_mod_internal(modst, player)
            if GAMESTATE:GetCurrentStyle():GetName() == "solo" then
                SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(player)):zoom(1.25):addy(34)
            end
        end;
        EnterGameplayMessageCommand=function(self)
            self:decelerate(1.5):zoom(1):diffusealpha(1):queuemessage("StartReceptors")
        end;
    };

    Judg[#Judg+1] = Def.Sprite{
        Texture=THEME:GetPathG("","GameArea"),
        OnCommand=function(self)
            -- Fit within SM's 64x64 note setting.
            self:xy(0,180):zoom(1.3):zoomx(-1.35)
            if InDoubleMode then
                self:x(-64*2)
            end
            if GAMESTATE:GetCurrentStyle():GetName() == "solo" then
                self:Load( THEME:GetPathG("","mc_lane") )
                :zoom(0.6):zoomx(0.595):addx(2):addy(-20)
            end
        end;
        EnterGameplayMessageCommand=function(self)
            self:sleep(0.4):decelerate(0.4):diffusealpha(0.7)
        end;
    };

    if InDoubleMode then
        Judg[#Judg+1] = Def.Sprite{
            Texture=THEME:GetPathG("","GameArea"),
            OnCommand=function(self)
                -- Fit within SM's 64x64 note setting.
                self:xy(0,180):zoom(1.3):zoomx(1.35)
                if InDoubleMode then
                    self:x(64*2)
                end
            end;
            EnterGameplayMessageCommand=function(self)
                self:sleep(0.4):decelerate(0.4):diffusealpha(0.7)
            end;
        };
    end

    Judg[#Judg+1] = Def.Sprite{
        Texture=THEME:GetPathG("","PNumberBoard"),
        OnCommand=function(self)
            self:xy(22,150):zoom(1):pause():diffusealpha(0.3)
            self:setstate( string.sub( ToEnumShortString(player), 2 ) -1 )
            if InDoubleMode then
                self:x(22+(64*2))
            end
        end;
        EnterGameplayMessageCommand=function(self)
            self:decelerate(1.6):y(204)
        end;
    };

    local PInfo = Def.ActorFrame{
        OnCommand=function(self)
            self:y( -80 )

            local Items = {
                { n="PlayInfo",     y=-100, zoom=0.2  },
                { n="DiffList",     x=-80, y=-112, zoom=0.2  },
                { n="ProfileName",  y=280, zoom=0.8  },
                { n="Life",         x=46, y=-106 },
                { n="LFrame",       x=44, y=-110, zoom=0.55 },
                { n="LGlow",        x=44, y=-110, zoom=0.55  },
                { n="Score",        x=60, y=-96 },
            };

            for v in ivalues(Items) do
                self:GetChild( v.n ):xy( v.x and v.x or 0, v.y and v.y or 0 ):zoom( v.zoom and v.zoom or 1 )
            end
        end;
        EnterGameplayMessageCommand=function(self)
            self:sleep(1.6):decelerate(0.8):y(0)
        end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Name="PlayInfo";
        Texture=THEME:GetPathG("","PlayInfo"),
        -- I'm so sorry, but I cannot find another way of doing this without breaking sm.
        StartReceptorsMessageCommand=function(self)
            self:queuecommand("RecepFade")
        end;
        RecepFadeCommand=function(self)
            if RCount[player] <= GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() then
                iris_mod_internal(SMod[2]..RCount[player], player)
                RCount[player] = RCount[player] + 1
                self:finishtweening():sleep(SMod[1]):queuecommand("RecepFade")
            end
        end;
        OffCommand=function(self)
            RCount[player] = 1
            local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
            if stats then
                if stats:FullComboOfScore( 7 ) then
                    SMod = {1/9, "*12 dark"}
                    -- Ensure the sound is only played once.
                    if CSP == false then
                        SOUND:PlayOnce( THEME:GetPathS("","combo_achievement") )
                        CSP = true
                    end
                    MESSAGEMAN:Broadcast("FullComboAchieved", {Player=player} )
                    self:queuecommand("RecepFade")
                end
            end
        end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Name="DiffList";
        Texture=THEME:GetPathG("","DiffList"),
        OnCommand=function(self) self:pause():setstate( SetFrameDifficulty(player) ) end;
    };
    
    PInfo[#PInfo+1] = Def.BitmapText{
        Name="ProfileName";
        Font="handel gothic/20px",
        Text=PROFILEMAN:GetProfile(player):GetDisplayName(),
        EnterGameplayMessageCommand=function(self) self:diffusealpha(0):sleep(1.6+0.6):decelerate(0.4):diffusealpha(0.5) end;
    };

    -- Clone time
    PInfo[#PInfo+1] = Def.ActorProxy{
        Name="Life";
        BeginCommand=function(self)
            self:SetTarget( SCREENMAN:GetTopScreen():GetChild("Life"..ToEnumShortString(player)) )
        end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Name="LFrame";
        Texture=THEME:GetPathG("Lifebar","Frame"),
        OnCommand=function(self) self:cropbottom(0.25) end;
    };

    PInfo[#PInfo+1] = Def.Sprite{
        Name="LGlow";
        Texture=THEME:GetPathG("Lifebar","Glow"),
        OnCommand=function(self)
            self:cropbottom(0.25):diffusealpha(0):glowramp()
            :effectcolor1( 0,0,0,0 ):effectcolor2( color(1,1,1,1) )
            :effectperiod(0.00001):blend(Blend.Add)
        end;
        LifeChangedMessageCommand=function(self,params)
            if (params.Player == player) then
                local health = GAMESTATE:GetPlayerState(player):GetHealthState()
                self:diffusealpha( health == "HealthState_Hot" and 1 or 0 )
            end
        end;
    };

    PInfo[#PInfo+1] = Def.ActorProxy{
        Name="Score";
        BeginCommand=function(self)
            self:SetTarget( SCREENMAN:GetTopScreen():GetChild("Score"..ToEnumShortString(player)) )
        end;
    };

    Judg[#Judg+1] = PInfo

    local stpos = function(self)
        local sp = {
            ["double"] = {-64*4.5, 64},
            ["solo"] = {-58*3.5, 58},
        };
        return sp[GAMESTATE:GetCurrentStyle():GetName()] and sp[GAMESTATE:GetCurrentStyle():GetName()] or {-64*2.5, 64}
    end

    for i=1,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
        Judg[#Judg+1] = Def.Quad{
            OnCommand=function(self)
                self:zoomto(64,400):diffusealpha(0):x(stpos()[1]+(stpos()[2]*i)):vertalign(top):y( -36 )
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
                self:xy(stpos()[1]+(stpos()[2]*i), -64*1.3):zoom(0.3):pause():diffusealpha(0)
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
        };

        --[[
            Full Combo Particle actor set

            The method used to make this work goes like this:
            First, obtain the NoteSkin currently being used by the player, and deploy fake variants
            of the receptors. During gameplay, make them invisible since they'll only be used on Out.

            Once this screen transition is about to begin, we begin the GetPlayerState check, by using
            GAMESTATE:GetPlayerState(player):GetPlayerOptions(0):NoteSkin().
            This will get us the exact folder name of the noteskin being used by the player, and we can use
            said value on a NOTESKIN function called LoadActorForNoteSkin, which lets us load any kind of actor
            regardless of the current NoteSkin. NOTESKIN:LoadActor() wouldn't work because that only works inside the
            NoteSkin itself.

            After this is done, place them, within the 64x64 pixel range of StepMania's receptors and now hide.
            
            During OffCommand, we begin a check to verify the FullCombo state of the player.
            This FullCombo Animation will only play if the player has achieved an FC that is > Great ( > TapNoteScore_W3 ),
            and if it is confirmed, then start DeployParticles, which will send the command to start the animation on each
            column. Note the sleep command, this is used because the transition for the animation is 1>1>1>1 within around
            6/9's of a second in DDR PS3.

            The small zoom on the decoy receptors is a small touch I've added myself as most noteskins don't exactly feature
            a glow-esc receptor that can really glow using the command. Additionally, the Smoke is using a Additive blend to
            make sure fading isn't that intruisive and remains smooth.
        ]]
        if GAMESTATE:GetPlayerState(player) then
            local nskin = GAMESTATE:GetPlayerState(player):GetPlayerOptions(0):NoteSkin()
            Judg[#Judg+1] = NOTESKIN:LoadActorForNoteSkin( "Down", "Receptor", nskin )..{
                OnCommand=function(self)
                    local rotate = {90,0,180,-90}
                    self:xy(stpos()[1]+(stpos()[2]*i), -64*0.75):rotationz( rotate[i] ):diffusealpha(0)
                end;
                FullComboAchievedMessageCommand=function(self,params)
                    if params.Player == player then
                        self:finishtweening():sleep(SMod[1]*(i-1)):queuecommand("DeployParticles")
                    end
                end;
                DeployParticlesCommand=function(self)
                    local gglow = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
                    self:diffusealpha(1):glow( color("0,0,0,0") )
                    :linear(0.2):glow( GetFullComboEffectColor(gglow) ):diffuse( GetFullComboEffectColor(gglow) )
                    :linear(0.2):diffusealpha(0):glow( color("0,0,0,0") ):zoom(1.2)
                end;
            };
            for s=1,2 do
                Judg[#Judg+1] = Def.Sprite{
                    Texture=THEME:GetPathG("","Gameplay/Smoke");
                    OnCommand=function(self)
                        self:xy(stpos()[1]+(stpos()[2]*i), -64*0.75):diffusealpha(0):zoom(0.4):blend(Blend.Add)
                        :fadetop(1)
                    end;
                    FullComboAchievedMessageCommand=function(self,params)
                        if params.Player == player then
                            self:finishtweening():sleep(SMod[1]*(i-1)):queuecommand("DeployParticles")
                        end
                    end;
                    DeployParticlesCommand=function(self)
                        local gglow = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
                        self:linear(0.2):diffusealpha(1)
                        :linear(1):diffusealpha(0):addy(20*s)
                    end;
                };
            end
        end

        -- Special ending particles based on FullCombo.
        -- Same as the code above, but now it focuses on the quad particles that fall from the receptors.
        for e=1,10 do
            Judg[#Judg+1] = Def.Quad{
                OnCommand=function(self)
                    self:xy(stpos()[1]+(stpos()[2]*i), -64*0.75):zoom(8):spin()
                    :effectmagnitude(10*e,20*e,15*e):diffusealpha(0)
                end;
                FullComboAchievedMessageCommand=function(self,params)
                    if params.Player == player then
                        self:finishtweening():sleep(SMod[1]*(i-1)):queuecommand("DeployParticles")
                    end
                end;
                DeployParticlesCommand=function(self)
                    self:diffusealpha(1)
                    :decelerate(2):addy(50*(e/2))
                    :x( (stpos()[1]+(stpos()[2]*i))+(math.cos(e)*math.pi)*30 )
                    :diffusebottomedge( Color.Black ):diffusealpha(0)
                end;
            };
        end
    end
    t[#t+1] = Judg
end

-- Song Information
local SInfo = Def.ActorFrame{
    -- Do not start the actor if we're in Doubles or Versus.
    -- There's no space for it, and neither did the game allow this.
    Condition=not (GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2)) and not InDoubleMode,
    OnCommand=function(self)
        self:xy( SCREEN_RIGHT, SCREEN_BOTTOM-40 ):diffusealpha(0)
    end;
    EnterGameplayMessageCommand=function(self)
        -- Slowly fade in alongside everything else.
        self:sleep(2):decelerate(1.6):diffusealpha(0.5):x( SCREEN_CENTER_X+64*2.3 )
    end;
};

SInfo[#SInfo+1] = Def.Sprite{
    Texture=THEME:GetPathG("Gameplay","SongInfo"),
    OnCommand=function(self) self:halign(0) end;
};

-- Song and Artist Information actors.
-- MaxWidth is used to ensure that the text inside the Song Information ActorFrame doesn't cut off the screen.
SInfo[#SInfo+1] = Def.BitmapText{
    Font="Common Normal",
    OnCommand=function(self)
        self:halign(0):settext( GAMESTATE:GetCurrentSong():GetDisplayFullTitle() )
        :xy( 35, -6 ):zoom(0.7):maxwidth( IsUsingWideScreen() and SCREEN_WIDTH/2.8 or 160 )
    end;
};

SInfo[#SInfo+1] = Def.BitmapText{
    Font="Common Normal",
    OnCommand=function(self)
        self:halign(0):settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() )
        :xy( 35, 6 ):zoom(0.7):maxwidth( IsUsingWideScreen() and SCREEN_WIDTH/2.8 or 160 )
    end;
};

t[#t+1] = SInfo

return t;