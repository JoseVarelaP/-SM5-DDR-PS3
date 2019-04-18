local t = Def.ActorFrame{};

local Wrapper;

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture="../Wheel/Item",
		OnCommand=function(self)
			self:zoomx(0.3):zoomy(0.26)
		end;
	},

	Def.Sprite{
		Texture="../Wheel/BPMDisplay label",
		OnCommand=function(self)
			self:zoom(0.15):xy(-120,-16)
		end;
	},

	Def.ActorFrame{
		SetMessageCommand=function(self,params)
			local song = params.Song;
			self:visible( (song and PROFILEMAN:IsSongNew(song)) and true or false )
		end;

		Def.Sprite{
			Texture="../Wheel/New/eff07",
			OnCommand=function(self)
				self:zoom(0.6):xy(70,-18)
			end;
		},
	
		Def.Sprite{
			Texture="../Wheel/New/mc_star02",
			OnCommand=function(self)
				self:zoom(0.6):xy(55,-16)
			end;
		},
	
		Def.Sprite{
			Texture="../Wheel/New/selNew",
			OnCommand=function(self)
				self:zoom(0.6):xy(80,-20)
			end;
		},

		Def.ActorFrame{
			OnCommand=function(self)
				self:thump(4):xy(80,-20)
				:effectmagnitude(1.3,1,0)
			end;
			Def.ActorFrame{
				OnCommand=function(self)
					self:glowshift():effectperiod(4)
					:effectcolor1( color("1,1,1,0") ):effectcolor2( color("1,1,1,0.5") )
				end;
				Def.Sprite{
					Texture="../Wheel/New/selNew",
					OnCommand=function(self)
						self:zoom(0.6):diffusealpha(1):blend(Blend.Add)
						:diffuseshift():effectperiod(4)
						:effectcolor1( color("1,1,1,0") ):effectcolor2( color("1,1,1,1") )
					end;
				},
			}
		}
	};

	Def.BitmapText{
		Font="bold handel gothic/25px",
		OnCommand=function(self)
			self:zoom(0.65):halign(0):xy(-160,-1)
		end;
		SetMessageCommand=function(self,params)
			local song = params.Song;
			if song then
				self:settext( song:GetDisplayFullTitle() ):maxwidth(500)
			end;
		end;
	};
	Def.BitmapText{
		Font="bold handel gothic/25px",
		OnCommand=function(self)
			self:zoom(0.5):halign(0):xy(-155,12)
		end;
		SetMessageCommand=function(self,params)
			local song = params.Song;
			if song then
				self:settext( song:GetDisplayArtist() ):maxwidth(500)
			end;
		end;
	};
	Def.BitmapText{
		Font="bold handel gothic/25px",
		OnCommand=function(self)
			self:zoom(0.6):halign(0):xy(-100,-16)
		end;
		SetMessageCommand=function(self,params)
			local song = params.Song;
			if song then
				local bpms = song:GetDisplayBpms()
				self:settext( (bpms[1] == bpms[2]) and bpms[1] or bpms[1] ):maxwidth(500)
			end;
		end;
	};
};

return t;
