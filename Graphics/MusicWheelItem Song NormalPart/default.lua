local t = Def.ActorFrame{};


t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture="../Wheel/Item",
		OnCommand=function(self)
			self:zoomx(0.3):zoomy(0.26)
		end;
	},
	Def.BitmapText{
		Font="bold handel gothic/25px",
		OnCommand=function(self)
			self:zoom(0.65):halign(0):xy(-155,-1)
		end;
		SetMessageCommand=function(self,params)
			local song = params.Song;
			if song then
				self:settext( song:GetDisplayMainTitle() ):maxwidth(500)
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
			self:zoom(0.6):halign(0):xy(-125,-16)
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
