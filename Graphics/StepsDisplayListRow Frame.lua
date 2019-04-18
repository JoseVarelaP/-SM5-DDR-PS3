local t = Def.ActorFrame{};

local diffs = {
    Beginner = 0,
    Easy = 1,
    Medium = 2,
    Hard = 3,
    Challenge = 4,
    Edit = 5,
}

t[#t+1] = Def.ActorFrame{
    Def.Sprite{
        Texture="SelectMusic/DiffBar";
        OnCommand=function(self) self:zoom(0.3) end;
    };
    Def.Sprite{
        Texture="BWSideDiffList";
        OnCommand=function(self)
            self:halign(0):xy(-80,-3.5):zoom(0.2):pause()
        end;
        SetMessageCommand=function(self,param)
            local diff = param.CustomDifficulty
            self:setstate( diffs[diff] )
        end;
    };
};

return t;