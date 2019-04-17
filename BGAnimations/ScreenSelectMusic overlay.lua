local t = Def.ActorFrame{}

t[#t+1] = LoadActor( THEME:GetPathG("","SelectMusic/red.txt") )..{
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X+200, SCREEN_CENTER_Y ):zoom(4.45):zoomy(5)
        :rate(2)
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:diffusealpha(0):position(0)
        if GAMESTATE:GetCurrentSong() then
            self:stoptweening():sleep(0.2):linear(0.1):diffusealpha(1)
        end
    end;
};

return t;