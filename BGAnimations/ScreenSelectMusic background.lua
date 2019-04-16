local t = Def.ActorFrame{}

t[#t+1] = LoadActor( THEME:GetPathG("","Videos/Intro") )..{
    OnCommand=function(self)
        self:FullScreen()
    end;
}

return t;