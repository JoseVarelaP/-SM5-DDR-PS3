local t = Def.ActorFrame{}

t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/SongBall") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-180, SCREEN_CENTER_Y-30):zoom(0.4)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:finishtweening():zoom(0.4):accelerate(0.1):zoom(0.43):decelerate(0.1):zoom(0.4)
    end;
}
t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/OuterBall") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-180, SCREEN_CENTER_Y-30):zoom(0.4):diffusealpha(0)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:finishtweening():zoom(0.4):diffusealpha(1):decelerate(0.2):zoom(0.5):diffusealpha(0)
    end;
}
t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/BorderBall") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X-180, SCREEN_CENTER_Y-30):zoom(0.145):spin():effectmagnitude(0,0,50)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:finishtweening():diffusealpha(0):sleep(0.2):linear(0.1):diffusealpha(1)
    end;
}

collectgarbage();

return t;