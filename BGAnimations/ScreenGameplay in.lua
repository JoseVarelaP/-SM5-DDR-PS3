local t = Def.ActorFrame{}
local ttime = THEME:GetMetric("ScreenGameplay","MinSecondsToMusic")

t[#t+1] = Def.Quad{
    OnCommand=function(self)
        self:zoomto(800,600):diffuse( color("0,0,0,1") )
        :Center():linear(ttime):diffusealpha(0)
    end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","StageInfo/Wall") )..{
    OnCommand=function(self)
        self:FullScreen():linear(ttime):diffusealpha(0)
    end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","StageInfo/B01") )..{
    OnCommand=function(self)
        self:Center():zoom(0.3):linear(ttime):diffusealpha(0)
    end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","StageInfo/circulo_negro") )..{
    OnCommand=function(self)
        self:Center():zoom(0):diffusealpha(0):linear(ttime/3):diffusealpha(1):zoom(2):linear(ttime/3):diffusealpha(0):zoom(4)
    end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","StageInfo/destello") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X+(300-230), SCREEN_CENTER_Y+(250-240)):rotationz(25)
        :decelerate(ttime):zoom(1):blend(Blend.Add)
        self:xy(SCREEN_CENTER_X+(410-230), SCREEN_CENTER_Y+(330-240))
        :diffusealpha(0)
    end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","StageInfo/2destello") )..{
    OnCommand=function(self)
        self:xy(SCREEN_CENTER_X+(300-230), SCREEN_CENTER_Y+(250-240)):rotationz(25)
        :decelerate(ttime):zoom(1):blend(Blend.Add)
        self:xy(SCREEN_CENTER_X+(70-230), SCREEN_CENTER_Y+(60-240))
        :diffusealpha(0)
    end;
}
return t;