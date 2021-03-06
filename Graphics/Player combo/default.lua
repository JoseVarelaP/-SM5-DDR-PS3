local c;
local player = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local Pulse = THEME:GetMetric("Combo", "PulseCommand");
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand");

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local t = Def.ActorFrame {
	Name="CMain";
	LoadFont( "bold handel", "gothic/25px" ) .. {
		Name="Number";
		OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
	};
	Def.Sprite{
		Name="Label";
		Texture=THEME:GetPathG("","clabel");
		OnCommand = THEME:GetMetric("Combo", "LabelOnCommand");
	};
	
	InitCommand = function(self)
		c = self:GetChildren();
		c.Number:visible(false);
		c.Label:visible(false);
	end;
	-- Milestones:
	-- 25,50,100,250,600 Multiples;
--[[ 		if (iCombo % 100) == 0 then
			c.OneHundredMilestone:playcommand("Milestone");
		elseif (iCombo % 250) == 0 then
			-- It should really be 1000 but thats slightly unattainable, since
			-- combo doesnt save over now.
			c.OneThousandMilestone:playcommand("Milestone");
		else
			return
		end; --]]
	TwentyFiveMilestoneCommand=function(self,parent)
		-- (cmd(skewy,-0.125;decelerate,0.325;skewy,0))(self);
	end;
	ToastyAchievedMessageCommand=function(self,params)
	end;
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false);
			c.Label:visible(false);
			return;
		end

		local labeltext = "";
		if param.Combo then
			labeltext = "COMBO";
-- 			c.Number:playcommand("Reset");
		else
			labeltext = "MISSES";
-- 			c.Number:playcommand("Miss");
		end
		c.Label:visible(false);
		
		c.Number:visible(true);
		c.Label:visible(true);
		c.Number:settext( string.format("%i", iCombo) );
		-- FullCombo Rewards
		c.Number:diffuse(Color("White"));
		c.Label:diffuse(Color("White"));
		if param.FullComboW1 then
			c.Number:diffusebottomedge(color("0,1,1,1"));
			c.Label:diffusebottomedge(color("0,1,1,1"));
		elseif param.FullComboW2 then
			c.Number:diffusebottomedge(color("1,1,0,1"));
			c.Label:diffusebottomedge(color("1,1,0,1"));
		elseif param.FullComboW3 then
			c.Number:diffusebottomedge(color("0,1,0,1"));
			c.Label:diffusebottomedge(color("0,1,0,1"));
		elseif param.Combo then
			c.Number:diffusebottomedge(color("0,1,0,1"))
			c.Label:diffusebottomedge(color("0,1,0,1"));
		else
			c.Number:diffuse(color("#ff0000"));
			c.Number:stopeffect();
			(cmd(diffuse,Color("Red");diffusebottomedge,color("0.5,0,0,1")))(c.Label);
		end
		-- Pulse
		Pulse( c.Number, param );
		PulseLabel( c.Label, param );
		-- Milestone Logic
	end;
--[[ 	ScoreChangedMessageCommand=function(self,param)
		local iToastyCombo = param.ToastyCombo;
		if iToastyCombo and (iToastyCombo > 0) then
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
		else
-- 			c.Number:stopeffect();
		end;
	end; --]]
};

return t;
