function Actor:TickSet(param)
    if param.CustomDifficulty then
        self:diffuse(CustomDifficultyToColor(param.CustomDifficulty));
    end

    return self,param
end