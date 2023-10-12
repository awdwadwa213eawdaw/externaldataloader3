return function(_p)
	local Utilities = _p.Utilities;
	local Tween = Utilities.Tween;
	local v3 = {}
	local NPCChat = _p.NPCChat;
	local v5 = Color3.fromRGB(171, 149, 230);
	local u1 = nil;
	local Create = Utilities.Create;
	local Write = Utilities.Write;
	local saying
	local selection
	local update
	function v3:buySelection()
		if saying or not selection then return end
		local item = selection.item
		--		local itemId = selection.encryptedId
		saying = true
		local max = _p.Connection:get('PDS', 'tMaxBuy', selection.index)
		if type(max) == 'string' and max:sub(1,2) == 'pk' then
			local split = string.split(max, '-')
			max = tonumber(split[2])
		end
		if max == 'ao' then
			_p.NPCChat:say('You already own this TM.')
			wait() wait()
			saying = false
			return
		elseif max == 'fb' then
			_p.NPCChat:say('You don\'t have any more room in your bag for this item.')
			wait() wait()
			saying = false
			return
		elseif max == 'nm' then
			_p.NPCChat:say('You don\'t have enough Tix.')
			wait() wait()
			saying = false
			return
		elseif max == 'aoh' then
			if _p.NPCChat:say('[y/n]Would you like to equip it?') then
				_p.Connection:get('PDS', 'setHoverboard', item.name)
			end
			wait() wait()
			saying = false
			return
		end
		local qty
		if max == 'hb' then
			qty = 1
		elseif max == 'tm' then
			qty = 1
		else
			qty = _p.Menu.bag:selectQuantity(max, selection.icon:Clone(), 'How many would you like?', '%d Tix', selection.price)
		end
		if not qty or not _p.NPCChat:say('[y/n]You want '..(max=='tm' and 'a' or qty)..' '..(item.tm and ('TM'..item.num) or item.name)..(qty>1 and 's' or '')..'. That will be '..(_p.PlayerData:formatTix(qty*selection.price))..' Tix. Is that OK?') then
			saying = false
			return
		end
		local s, newbp = _p.Connection:get('PDS', 'buyWithTix', selection.index, max~='tm' and qty or nil)
		if not s then
			_p.NPCChat:say('An error occurred.')
			saying = false
			return
		end
		if newbp then
			_p.PlayerData.tix = newbp
		end
		
		_p.NPCChat:say('Here you go. Thank you.')
		if max == 'hb' and _p.NPCChat:say('[y/n]Would you like to equip it now?') then
			_p.Connection:get('PDS', 'setHoverboard', item.name)
		end
		wait() wait()
		self:buildList()
		saying = false
	end
	function v3:buildList()
		local v6 = _p.Connection:get("PDS", "getShop", "arcade");
		local l__Scroller__7 = u1.Scroller;
		local l__ContentContainer__8 = l__Scroller__7.ContentContainer;
		l__ContentContainer__8:ClearAllChildren();
		l__Scroller__7.CanvasSize = UDim2.new(l__Scroller__7.Size.X.Scale, -1, (#v6 + 1) * 0.06 * l__ContentContainer__8.AbsoluteSize.X / l__Scroller__7.AbsoluteSize.Y * l__Scroller__7.Size.Y.Scale, 0);
		selection = nil
		
		for v9, thing in pairs(v6) do
			local v11 = {
				AutoButtonColor = false, 
				BackgroundColor3 = Color3.fromRGB(170, 149, 229)
			};
			local v12
			if v9 % 2 == 0 then
				v12 = 0;
			else
				v12 = 1;
			end;
			v11.BackgroundTransparency = v12;
			v11.BorderSizePixel = 0;
			v11.Size = UDim2.new(0.80*1.2, 0, 0.06, 0);
			v11.Position = UDim2.new(0.025, 0, 0.06 * (v9 - 1), 0);
			v11.ZIndex = 2;
			v11.Parent = l__ContentContainer__8;
			local u4 = Create("ImageButton")(v11);
			Utilities.fastSpawn(function()
				local tm
				local item, move, pknm, hover
				if thing[1]:sub(1, 2) == 'TM' then
					local moveName
					tm, moveName = thing[1]:match('^TM(%d+)%s(.+)$')
					move = _p.DataManager:getData('Movedex', Utilities.toId(moveName))
					if not move then print(moveName) end
				elseif thing[1]:sub(1, 4) == 'PKMN' then
					local mon = string.split(thing[1], ' ')[2]
					pknm = true
					if mon == 'Ditto' then
						item = {
							name = mon,
							desc = 'A unique Pokemon with the ability to reconstitute its cellular structure to transform into whatever it sees.',
							iconnumber = 140
						}
					elseif mon == 'Audino' then
						item = {
							name = mon,
							desc = 'A Pokemon that uses the feelers on its ears to sense others\' feelings.',
							iconnumber = 608
						}
					elseif mon == 'Chansey' then
						item = {
							name = mon,
							desc = 'A Pokemon that delivers happiness.',
							iconnumber = 118
						}
					end
				elseif thing[1]:sub(1, 5) == 'HOVER' then
					local hb = thing[1]:sub(7,#thing[1])
					hover = true
					if hb == 'Mega Salamence Board' then
						item = {
							name = hb,
							desc = 'A hoverboard that resembles Mega Salamence. It flies at the same speed as the deluxe boards from Hero\'s Hoverboards.',
						}
					elseif hb == 'Shiny M.Salamence Board' then
						item = {
							name = hb,
							desc = 'A hoverboard the exhibits extreme skill and dedication. To unlock this board, you had to achieve a score of 50 on the Alolan Adventure game.',
						}
					end
				else
					item = _p.DataManager:getData('Items', thing[1])
				end
				
				if not u4.Parent then return end
				local text = Create 'Frame' {
					BackgroundTransparency = 1.0,
					Size = UDim2.new(0.95, 0, 0.7, 0),
					Position = UDim2.new(0.025, 0, 0.15, 0),
					ZIndex = 3, Parent = u4,
				}
				Write((tm and thing[1]) or item.name) { Frame = text, Scaled = true, TextXAlignment = Enum.TextXAlignment.Left }
				Write(_p.PlayerData:formatTix(thing[2])..(' Tix')) { Frame = text, Scaled = true, TextXAlignment = Enum.TextXAlignment.Right }
				u4.MouseButton1Click:connect(function()
					if saying then return end
					local descContainer = u1.Details.DescContainer
					descContainer:ClearAllChildren()
					if tm then
						Write(move.category..', '..move.type..'-type, '..(move.basePower or 0)..' Power,\n'..(move.accuracy==true and '--' or ((move.accuracy or 0)..'%'))..' Accuracy'..((move.desc and move.desc~='') and ('. Effect: '..move.desc) or '')) {
							Frame = descContainer, Size = descContainer.AbsoluteSize.Y/5.8, Wraps = true
						}
					elseif item.desc then
						Write(item.desc) { Frame = descContainer, Size = descContainer.AbsoluteSize.Y/5.8, Wraps = true }
					end
					u1.Details.IconContainer:ClearAllChildren()
					if tm then
						item = {
							name = 'TM'..move.type,
							tm = true,
							num = tonumber(tm),
							--							encryptedId = encryptedId,
						}
					end
					
					local icon
					if pknm then
						icon = _p.Pokemon:getIcon(item.iconnumber, false)
					elseif not hover then
						icon = _p.Menu.bag:getItemIcon(item)
					end
					if not hover then
						icon.SizeConstraint = Enum.SizeConstraint.RelativeXY
						icon.Size = UDim2.new(1.0, 0, 1.0, 0)
						icon.Parent = u1.Details.IconContainer
					end
					selection = {item = item, price = thing[2], icon = icon, index = v9}--, encryptedId = encryptedId}
					-- Handle Changing Text for Hover
					if hover and _p.Connection:get('PDS', 'ownsHoverboard', item.name) then
						pcall(function() u1.Details.BuyButton.BuyText:Remove() end)
						Write("Equip")({
							Frame = Create("Frame")({
								BackgroundTransparency = 1, 
								Size = UDim2.new(1, 0, 0.6, 0), 
								Position = UDim2.new(0, 0, 0.2, 0),
								Name = 'BuyText',
								ZIndex = 5, 
								Parent = u1.Details.BuyButton
							}), 
							Scaled = true
						});
					else
						pcall(function() u1.Details.BuyButton.BuyText:Remove() end)
						Write("Buy")({
							Frame = Create("Frame")({
								BackgroundTransparency = 1, 
								Size = UDim2.new(1, 0, 0.6, 0), 
								Position = UDim2.new(0, 0, 0.2, 0),
								Name = 'BuyText',
								ZIndex = 5, 
								Parent = u1.Details.BuyButton
							}), 
							Scaled = true
						});
					end
					u1.Details.BuyButton.Visible = true
				end)
			end)
		end
	end
	local u5 = nil;
	local u6 = Color3.fromRGB(226, 136, 217);
	local u7 = Color3.fromRGB(95, 156, 227);
	local u8 = Color3.fromRGB(70, 122, 184);
	function v3:loadShop()
		local l__fadeGui__18 = Utilities.fadeGui;
		if not u1 then
			local v19 = Utilities.gui.AbsoluteSize.Y * 0.035;
			u5 = Utilities.Signal();
			local v20 = {
				Name = "ArcadeShopGUI", 
				BackgroundColor3 = u6, 
				SizeConstraint = Enum.SizeConstraint.RelativeYY, 
				Size = UDim2.new(1.2, 0, 0.9, 0), 
				Position = UDim2.new(0, Utilities.gui.AbsoluteSize.X *1.2, 0.05, 0), 
				Parent = Utilities.gui, 
				ZIndex = 2
			};
			local v21 = {
				Name = "Details", 
				BackgroundColor3 = u7, 
				Size = UDim2.new(1.05, 0, 0.2, 0), 
				Position = UDim2.new(-0.025, 0, 0.775, 0), 
				ZIndex = 3
			};
			local v22 = {
				Name = "BuyButton", 
				Button = true, 
				BackgroundColor3 = u8,
				Size = UDim2.new(0.2, 0, 0.425, 0), 
				Position = UDim2.new(0.0125, 0, 0.5, 0), 
				ZIndex = 4, 
				Visible = false
			};
			function v22.MouseButton1Click()
				self:buySelection();
			end;
			v21[1] = Create("Frame")({
				Name = "DescContainer", 
				BackgroundTransparency = 1, 
				Size = UDim2.new(0.75, 0, 0.85, 0), 
				Position = UDim2.new(0.225, 0, 0.075, 0), 
				ZIndex = 4
			});
			v21[2] = Create("Frame")({
				Name = "IconContainer", 
				BackgroundTransparency = 1, 
				SizeConstraint = Enum.SizeConstraint.RelativeYY, 
				Size = UDim2.new(0.5, 0, 0.5, 0), 
				Position = UDim2.new(0.06, 0, 0, 0)
			});
			v21[3] = _p.RoundedFrame:new(v22);
			v20[1] = _p.RoundedFrame:new({
				Name = "TitleBar", 
				BackgroundColor3 = u7, 
				Size = UDim2.new(1.05, 0, 0.1, 0), 
				Position = UDim2.new(-0.025, 0, 0.025, 0), 
				ZIndex = 3,
				Create("Frame")({
					Name = "TextContainer", 
					BackgroundTransparency = 1, 
					Size = UDim2.new(0.95, 0, 0.7, 0), 
					Position = UDim2.new(0.025, 0, 0.15, 0), 
					ZIndex = 4
				})
			});
			v20[2] = Create("ScrollingFrame")({
				Name = "Scroller", 
				BackgroundTransparency = 1, 
				BorderSizePixel = 0, 
				Size = UDim2.new(0.80*1.2, 0, 0.6, 0), 
				Position = UDim2.new(0.025, 0, 0.15, 0), 
				ScrollBarThickness = v19, 
				ZIndex = 3,
				Create("Frame")({
					BackgroundTransparency = 1, 
					Name = "ContentContainer", 
					Size = UDim2.new(1, -v19, 1, -v19), 
					SizeConstraint = Enum.SizeConstraint.RelativeXX
				})
			});
			v20[3] = _p.RoundedFrame:new(v21);
			u1 = _p.RoundedFrame:new(v20).gui;
			Write("Tix Shop")({
				Frame = u1.TitleBar.TextContainer, 
				Scaled = true, 
				TextXAlignment = Enum.TextXAlignment.Left
			});
			Write("Buy")({
				Frame = Create("Frame")({
					BackgroundTransparency = 1, 
					Size = UDim2.new(1, 0, 0.6, 0), 
					Position = UDim2.new(0, 0, 0.2, 0),
					Name = 'BuyText',
					ZIndex = 5, 
					Parent = u1.Details.BuyButton
				}), 
				Scaled = true
			});
			local v23 = {
				Button = true, 
				BackgroundColor3 = u8, 
				Size = UDim2.new(0.3, 0, 0.8, 0), 
				Position = UDim2.new(0.69, 0, 0.1, 0), 
				ZIndex = 4, 
				Parent = u1.TitleBar
			};
			local u9 = "off";
			function v23.MouseButton1Click()
				if u9 == "transition" then
					return;
				end;
				u9 = "transition";
				delay(0.3, function()
					u5:fire();
				end);
				local l__Offset__10 = u1.Position.X.Offset;
				local u11 = Utilities.gui.AbsoluteSize.X *1.2;
				Utilities.Tween(0.8, "easeOutCubic", function(p4)
					u1.Position = UDim2.new(0, l__Offset__10 + (u11 - l__Offset__10) * p4, 0.05, 0);
					l__fadeGui__18.BackgroundTransparency = 0.3 + p4 * 0.7;
				end);
				l__fadeGui__18.BackgroundTransparency = 1;
				u9 = "off";
			end;
			Write("Close")({
				Frame = Create("Frame")({
					BackgroundTransparency = 1, 
					Size = UDim2.new(1, 0, 0.7, 0), 
					Position = UDim2.new(0, 0, 0.15, 0), 
					ZIndex = 5, 
					Parent = _p.RoundedFrame:new(v23).gui
				}), 
				Scaled = true
			});
		end;
		self:buildList()
		u1.Details.BuyButton.Visible = false
		l__fadeGui__18.ZIndex = 1;
		l__fadeGui__18.BackgroundColor3 = Color3.new(0, 0, 0);
		local l__Offset__12 = u1.Position.X.Offset;
		local u13 = Utilities.gui.AbsoluteSize.X / 2 - u1.AbsoluteSize.X / 2;
		Utilities.Tween(0.8, "easeOutCubic", function(p5)
			u1.Position = UDim2.new(0, l__Offset__12 + (u13 - l__Offset__12) * p5, 0.05, 0);
			l__fadeGui__18.BackgroundTransparency = 1 - p5 * 0.7;
		end);
		u5:wait()
	end;
	local u14 = {
		["Alolan Adventure"] = require(script.AlolanAdventure)(_p), 
		["Whack-A-Diglett"] = require(script.WhackADiglett)(_p), 
		["Hammer Arm"] = require(script.HammerArm)(_p), 
		["Skeeball"] = require(script.Skeeball)(_p)
	};
	function v3:play(p7, p8)
		if self.busy then
			return false;
		end;
		self.busy = true;
		_p.Menu:disable();
		_p.MasterControl:Stop();
		_p.MasterControl.WalkEnabled = false;
		if p7:sub(1, 5) == "Whack" then
			local v24 = {};
			local l__next__25 = next;
			local v26, v27 = _p.player.Character:GetDescendants();
			while true do
				local v28, v29 = l__next__25(v26, v27);
				if not v28 then
					break;
				end;
				v27 = v28;
				pcall(function()
					v24[v29] = v29.Transparency;
				end);
				pcall(function()
					v29.Transparency = 1;
				end);			
			end;
			u14["Whack-A-Diglett"]:start(p8);
			self.busy = false;
			_p.Menu:enable();
			_p.MasterControl.WalkEnabled = true;
			local l__next__30 = next;
			local v31, v32 = _p.player.Character:GetDescendants();
			while true do
				local v33, v34 = l__next__30(v31, v32);
				if not v33 then
					break;
				end;
				v32 = v33;
				pcall(function()
					v34.Transparency = v24[v34];
				end);			
			end;
		end;
		if p7:sub(1, 5) == "Smonk" then
			local v35 = {};
			local l__next__36 = next;
			local v37, v38 = _p.player.Character:GetDescendants();
			while true do
				local v39, v40 = l__next__36(v37, v38);
				if not v39 then
					break;
				end;
				v38 = v39;
				pcall(function()
					v35[v40] = v40.Transparency;
				end);
				pcall(function()
					v40.Transparency = 1;
				end);			
			end;
			u14["Hammer Arm"]:start(p8);
			self.busy = false;
			_p.Menu:enable();
			_p.MasterControl.WalkEnabled = true;
			local l__next__41 = next;
			local v42, v43 = _p.player.Character:GetDescendants();
			while true do
				local v44, v45 = l__next__41(v42, v43);
				if not v44 then
					break;
				end;
				v43 = v44;
				pcall(function()
					v45.Transparency = v35[v45];
				end);			
			end;
		end;
		if p7:sub(1, 4) == "Skee" then
			local v46 = {};
			local l__next__47 = next;
			local v48, v49 = _p.player.Character:GetDescendants();
			while true do
				local v50, v51 = l__next__47(v48, v49);
				if not v50 then
					break;
				end;
				v49 = v50;
				pcall(function()
					v46[v51] = v51.Transparency;
				end);
				pcall(function()
					v51.Transparency = 1;
				end);			
			end;
			u14.Skeeball:start(p8);
			u14.Skeeball.GameEnded:wait();
			self.busy = false;
			_p.Menu:enable();
			_p.MasterControl.WalkEnabled = true;
			local l__next__52 = next;
			local v53, v54 = _p.player.Character:GetDescendants();
			while true do
				local v55, v56 = l__next__52(v53, v54);
				if not v55 then
					break;
				end;
				v54 = v55;
				pcall(function()
					v56.Transparency = v46[v56];
				end);			
			end;
		end;
		if p7:sub(1, 6) == "Flappy" then
			local v57 = {};
			local l__next__58 = next;
			local v59, v60 = _p.player.Character:GetDescendants();
			while true do
				local v61, v62 = l__next__58(v59, v60);
				if not v61 then
					break;
				end;
				v60 = v61;
				pcall(function()
					v57[v62] = v62.Transparency;
				end);
				pcall(function()
					v62.Transparency = 1;
				end);			
			end;
			spawn(function()
				u14["Alolan Adventure"]:start(p8);
			end);
			self.flappyConnection = _p.player:GetMouse().Button1Down:Connect(function()
				u14["Alolan Adventure"]:onSpaceClicked();
			end);
			u14["Alolan Adventure"].GameEnded:wait();
			self.flappyConnection = false;
			self.busy = false;
			local l__next__63 = next;
			local v64, v65 = _p.player.Character:GetDescendants();
			while true do
				local v66, v67 = l__next__63(v64, v65);
				if not v66 then
					break;
				end;
				v65 = v66;
				pcall(function()
					v67.Transparency = v57[v67];
				end);			
			end;
		end;
	end;
	local interact = NPCChat.interactableNPCs;
	local l__gui__16 = Utilities.gui;
	local u17 = {};
	function v3:onLoadChunk(_p0)
		update = true
		_p.DataManager.ignoreRegionChangeFlag = true;
		interact[_p0.npcs.TicketGuy.model] = function()
			NPCChat:say(_p0.npcs.TicketGuy, "Interested in exchanging your Tix for awesome prizes?");
			spawn(function() _p.Menu:disable() end)
			self:loadShop();
			_p.MasterControl.WalkEnabled = false
			_p.MasterControl:Stop()
			NPCChat:say(_p0.npcs.TicketGuy, "Come back any time!");
			_p.MasterControl.WalkEnabled = true
			_p.MasterControl:Stop()
			spawn(function() _p.Menu:enable() end)
		end;
		interact[_p0.npcs.TicketSeller.model] = function()
			if NPCChat:say(_p0.npcs.TicketSeller, "Want lots of Tix, but don't have time?", "I'll give you 5,000 of my Tix for 125 of your R$.", "[y/n]Does that sound like a fair deal?") then
				_p.Connection:post('PDS', 'TixPurchase')
			else
				NPCChat:say(_p0.npcs.TicketSeller, "Well, good luck then.")
			end
		end;
		local v68 = Create("ImageLabel")({
			Rotation = -30, 
			Size = UDim2.new(0.068, 0, 0.088, 0), 
			Position = UDim2.new(0.089, 0, 0.809, 0), 
			Image = "rbxassetid://6128857339", 
			BackgroundTransparency = 1, 
			Name = "TixImage", 
			Parent = l__gui__16
		});
		local lasttix = _p.PlayerData.tix
		Write(tostring(_p.PlayerData.tix))({
			Frame = Create("Frame")({
				Parent = l__gui__16, 
				Name = "TixFrame", 
				BackgroundTransparency = 1, 
				Size = UDim2.new(0.267, 0, 0.072, 0), 
				Position = UDim2.new(0.2, 0, 0.817, 0)
			}), 
			Scaled = true, 
			TextXAlignment = Enum.TextXAlignment.Left
		});
		spawn(function()
			while update do
				wait()
				if lasttix ~= _p.PlayerData.tix then
					lasttix = _p.PlayerData.tix
					pcall(function()
						l__gui__16.TixFrame:Remove();
					end);
					Write(tostring(_p.PlayerData.tix))({
						Frame = Create("Frame")({
							Parent = l__gui__16, 
							Name = "TixFrame", 
							BackgroundTransparency = 1, 
							Size = UDim2.new(0.267, 0, 0.072, 0), 
							Position = UDim2.new(0.2, 0, 0.817, 0)
						}), 
						Scaled = true, 
						TextXAlignment = Enum.TextXAlignment.Left
					});
				end
			end
		end)
		local l__next__69 = next;
		local v70, v71 = _p0.map:GetDescendants();
		while true do
			local v72, v73 = l__next__69(v70, v71);
			if not v72 then
				break;
			end;
			v71 = v72;
			if v73.Name == "PlayButtonNode" then
				local rf
				local v74 = {
					--CornerRadius = 20, 
					--ClipsDescendants = true,
					BackgroundColor3 = Color3.fromRGB(74, 164, 98), 
					Size = UDim2.new(0.135, 0, .073, 0), 
					--Size = UDim2.new(0.135, 0, 0.060, 0), 
					--Size = UDim2.new(.095, 0, .073, 0),
					Parent = Utilities.gui, 
					ZIndex = 3, 
					Visible = false, 
					Button = true
				};
				function v74.MouseButton1Click()
					rf.Visible = false;
					self:play(v73.Parent.Name, v73.Parent);
				end;
				rf = _p.RoundedFrame:new(v74);
				u17[v73] = rf;
				Write("Play")({
					Scaled = true, 
				    Font = 'Avenir'	,
					Frame = Create("Frame")({
						Parent = rf.gui, 
						ZIndex = 3, 
						BackgroundTransparency = 1, 
						Position = UDim2.new(0, 0, .2, 0), 
						Size = UDim2.new(1, 0,.6, 0)
					})
				});
			end;		
		end;
		local l__CurrentCamera__18 = workspace.CurrentCamera;
		spawn(function()
			while wait() do
				for v75, v76 in next, u17 do
					if ((v75.CFrame.p - _p.player.Character.HumanoidRootPart.CFrame.p) * Vector3.new(1, 0, 1)).magnitude <= 7 and not self.busy then
						local v77, v78 = l__CurrentCamera__18:WorldToScreenPoint(v75.Position);
						v76.Position = UDim2.new(0, v77.x, 0, v77.y);
						v76.Visible = true;
					else
						v76.Visible = false;
					end;
				end;			
			end;
		end);
	end;
	function v3:onUnload(_p1)
		update = false
		pcall(function()
			l__gui__16.TixFrame:Remove();
			l__gui__16.TixImage:Remove();
		end);
		_p.DataManager.ignoreRegionChangeFlag = false;
	end;
	return v3;
end;
