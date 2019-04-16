local t = Def.ActorFrame{}

t[#t+1] = LoadActor( THEME:GetPathG("","Videos/intro") )..{
    OnCommand=function(self) self:FullScreen() end;
};

t[#t+1] = LoadActor( "Group" )..{
    OnCommand=function(self) self:xy( SCREEN_CENTER_X+(229-320), SCREEN_CENTER_Y+(423-240) ):zoom(0.11)
        :thump():effectclock("bgm"):effectmagnitude(1.1,1,0):effectperiod(1)
    end;
};

t[#t+1] = LoadActor( "Group" )..{
    OnCommand=function(self) self:xy( SCREEN_CENTER_X+(229-320), SCREEN_CENTER_Y+(423-240) ):zoom(0.11)
        :thump():effectclock("bgm"):effectmagnitude(1.1,1,0):effectperiod(1)
    end;
};

t[#t+1] = LoadActor( "MainLines" )..{
    OnCommand=function(self) self:xy( SCREEN_CENTER_X+(225-320), SCREEN_CENTER_Y ):zoom(0.32)
    end;
};

t[#t+1] = LoadActor( "Group" )..{
    OnCommand=function(self) self:xy( SCREEN_CENTER_X+(510-320), SCREEN_CENTER_Y+(110-240) ):zoom(0.11)
        :thump():effectclock("bgm"):effectmagnitude(1.1,1,0):effectperiod(1)
    end;
};

t[#t+1] = LoadActor( "B1" )..{
    OnCommand=function(self) self:xy( SCREEN_CENTER_X+(90-320), SCREEN_CENTER_Y+(108-240) ):zoom(0.26)
        :thump():effectclock("bgm"):effectmagnitude(1.1,1,0):effectperiod(1)
    end;
};

t[#t+1] = Def.BitmapText{
    Font="bold handel gothic/25px",
    Text=GAMESTATE:GetCurrentSong():GetDisplayMainTitle(),
    OnCommand=function(self) self:xy( SCREEN_CENTER_X+(140-320), SCREEN_CENTER_Y+(108-240) ):halign(0):zoom(0.8)
    end;
};

return t;