local t = Def.ActorFrame{
    StartTransitioningCommand=function(self)
        self:sleep(5)
    end;
}

return t;