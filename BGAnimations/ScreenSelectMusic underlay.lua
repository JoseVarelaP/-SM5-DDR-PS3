local t = Def.ActorFrame{}

t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/SongBall") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-200, SCREEN_CENTER_Y-30):zoom(0.4)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:finishtweening():zoom(0.4):accelerate(0.1):zoom(0.43):decelerate(0.1):zoom(0.4)
    end;
};
t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/OuterBall") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-200, SCREEN_CENTER_Y-30):zoom(0.4):diffusealpha(0)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:finishtweening():zoom(0.4):diffusealpha(1):decelerate(0.2):zoom(0.5):diffusealpha(0)
    end;
};
t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/BorderBall") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-200, SCREEN_CENTER_Y-30):zoom(0.145):spin():effectmagnitude(0,0,50)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:finishtweening():diffusealpha(0):sleep(0.2):linear(0.1):diffusealpha(1)
    end;
};

t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/Group") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-300, SCREEN_CENTER_Y+150):zoom(0.115)
        :thump():effectclock("bgm"):effectmagnitude(1,1.1,0):effectoffset(0.2)
    end;
};

t[#t+1] = Def.BitmapText{
    Font="bold handel gothic/25px",
    Text=string.upper("Group"),
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-300, SCREEN_CENTER_Y+150):zoom(0.6)
        :wrapwidthpixels(300)
    end;
    SortOrderChangedMessageCommand=function(self)
        self:settext( string.upper( SortOrderToLocalizedString( GAMESTATE:GetSortOrder() ) ) )
    end;
};

t[#t+1] = Def.StepsDisplayList{
	Name="StepsDisplayList";
	OnCommand=function(self)
		self:zoom(1):xy( SCREEN_CENTER_X-200,SCREEN_CENTER_Y-10 ):diffusealpha(1)
	end;
	StartSelectingStepsMessageCommand=function(self)
		self:stoptweening():sleep(0.5):diffusealpha(1)
	end;
	SongUnchosenMessageCommand=function(self)
		self:stoptweening():diffusealpha(0)
	end;

	CursorP1=Def.ActorFrame{};
	CursorP1Frame=Def.ActorFrame{};
	CursorP2=Def.ActorFrame{};
	CursorP2Frame=Def.ActorFrame{};
};

t[#t+1] = Def.Banner{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-200, SCREEN_CENTER_Y-95):scaletoclipped(130,130)
    end;
    CurrentSongChangedMessageCommand=function(self)
        if GAMESTATE:GetCurrentSong() then
            if (Sprite.LoadFromCached ~= nil) then
    			self:LoadFromCached("Background", GAMESTATE:GetCurrentSong():GetBackgroundPath())
			else
    			self:Load(GAMESTATE:GetCurrentSong():GetBackgroundPath())
			end
        end
    end;
};

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","SelectMusic/InnerGlow"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X+200, SCREEN_CENTER_Y ):zoom(0.303)
    end;
};

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Wheel/BGRed"),
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X+200, SCREEN_CENTER_Y ):zoom(0.3):zoomy(0.26)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:diffusealpha(0)
        if GAMESTATE:GetCurrentSong() then
            self:stoptweening():sleep(0.2):linear(0.1):diffusealpha(1)
        end
    end;
};

collectgarbage();

return t;