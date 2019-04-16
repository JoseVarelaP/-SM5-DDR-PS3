local t = Def.ActorFrame {
	StartTransitioningCommand=function(self)
		MESSAGEMAN:Broadcast("EnterGameplay")
	end;
};

return t