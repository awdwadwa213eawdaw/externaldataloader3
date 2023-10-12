-- Decompiled with the Synapse X Luau decompiler.

return function(p1)
	local v1 = {};
	local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
	local l__Stepped__3 = game:GetService("RunService").Stepped;
	local l__UserInputService__4 = game:GetService("UserInputService");
	local l__Utilities__5 = p1.Utilities;
	function v1.animFlap(p2)
		if p2.ended then
			return;
		end;
		p2.currentFlap = (p2.currentFlap + 1 + 1) % 3 * 64;
		p2.bird.ImageRectOffset = Vector2.new(p2.currentFlap, 0);
	end;
	local l__Create__1 = l__Utilities__5.Create;
	local u2 = nil;
	local u3 = nil;
	local u4 = nil;
	function v1.getBird(p3)
		if p3.bird then
			return p3.bird;
		end;
		p3.currentFlap = 0;
		p3.bird = l__Create__1("ImageLabel")({
			Name = "Bird", 
			Parent = u2, 
			Image = "rbxassetid://785167181", 
			BackgroundTransparency = 1, 
			AnchorPoint = Vector2.new(0.5, 0.5), 
			Position = UDim2.new(0, u3, 0, u4.y), 
			Size = UDim2.new(0, 42.666666666666664, 0, 42.666666666666664), 
			ImageRectOffset = Vector2.new(8, 9), 
			ImageRectSize = Vector2.new(58, 58), 
			LayoutOrder = 2, 
			ZIndex = 999
		});
		spawn(function()
			while wait(0.15) do
				p3:animFlap();			
			end;
		end);
		return p3.bird;
	end;
	local function u5(p4, p5)
		local l__AbsolutePosition__6 = p4.AbsolutePosition;
		local v7 = l__AbsolutePosition__6 + p4.AbsoluteSize;
		local l__AbsolutePosition__8 = p5.AbsolutePosition;
		local v9 = l__AbsolutePosition__8 + p5.AbsoluteSize;
		local v10 = false;
		if l__AbsolutePosition__6.x < v9.x then
			v10 = false;
			if l__AbsolutePosition__8.x < v7.x then
				v10 = false;
				if l__AbsolutePosition__6.y < v9.y then
					v10 = l__AbsolutePosition__8.y < v7.y;
				end;
			end;
		end;
		return v10;
	end;
	local u6 = tick();
	local u7 = {
		velocity = {
			x = 0, 
			y = 0
		}
	};
	local u8 = {
		GRAVITY = -0.6867000000000001, 
		time = 0
	};
	function v1.step(p6, p7)
		if u5(p6.bird, u2.Floor) then
			if not p6.ended then
				v1:die();
			end;
			return;
		end;
		local v11 = tick() - u6;
		u7.velocity.y = u7.velocity.y + u8.GRAVITY;
		p7.Position = UDim2.new(0, p7.Position.X.Offset, 0, p7.Position.Y.Offset - u7.velocity.y);
		p7.Rotation = -math.deg(math.atan2(math.rad(u7.velocity.y), 1)) * 5;
	end;
	function v1.onSpaceClicked(p8)
		if p8.ended then
			return;
		end;
		if not p8.started then
			p8.started = true;
		end;
		u7.velocity.y = 9;
	end;
	local u9 = nil;
	local l__Tween__10 = l__Utilities__5.Tween;
	local l__MasterControl__11 = p1.MasterControl;
	function v1.die(p9)
		if not p9.ended then
			p1.Connection:get("PDS", "ArcadeReward", "alolan", p9.points)
			p1.PlayerData.money = p1.PlayerData.money + p9.points
			p1.PlayerData.money = p1.PlayerData.money + p9.points
			p9.ended = true;
			local l__Color__12 = u9.Color;
			l__Tween__10(0.1, nil, function(p10)
				u9.Color = l__Color__12:Lerp(Color3.new(1, 1, 1), p10);
			end);
			l__Tween__10(0.1, nil, function(p11)
				u9.Color = Color3.new(1, 1, 1):Lerp(l__Color__12, p11);
			end);
			for v12 = 1, 3 do
				u2.points.Visible = false;
				wait(0.3);
				u2.points.Visible = true;
				wait(1.5);
			end;
			u2.points.Visible = false;
			u9.Transparency = 1;
			u9.Color = Color3.fromRGB(27, 42, 53);
			l__Utilities__5.lookBackAtMe();
			u2:Remove();
			l__MasterControl__11.WalkEnabled = true;
			p1.Menu:enable();
			p9.GameEnded:fire();
		end;
	end;
	function v1.boundaryCheck(p12, p13, p14)
		local l__AbsolutePosition__13 = p13.AbsolutePosition;
		local l__AbsoluteSize__14 = p13.AbsoluteSize;
		local l__AbsolutePosition__15 = p14.AbsolutePosition;
		local l__AbsoluteSize__16 = p14.AbsoluteSize;
		if l__AbsolutePosition__15.Y - l__AbsolutePosition__13.Y > 0 then
			return false;
		end;
		if l__AbsolutePosition__15.Y + l__AbsoluteSize__16.Y - (l__AbsolutePosition__13.Y + l__AbsoluteSize__14.Y) < 0 then
			return false;
		end;
		if l__AbsolutePosition__15.X - l__AbsolutePosition__13.X > 0 then
			return false;
		end;
		if l__AbsolutePosition__15.X + l__AbsoluteSize__16.X - (l__AbsolutePosition__13.X + l__AbsoluteSize__14.X) < 0 then
			return false;
		end;
		return true;
	end;
	function v1.spawnPipe(p15, p16)
		local v17 = u2:FindFirstChild("TreeBottom"):Clone();
		v17.Parent = u2;
		v17.Visible = true;
		local v18 = u2:FindFirstChild("TreeTop"):Clone();
		v18.Parent = u2;
		v18.Visible = true;
		v17.Position = v17.Position - UDim2.new(0, 0, p16 / 10, 0);
		v18.Position = v18.Position - UDim2.new(0, 0, p16 / 10, 0);
		p15.pipes[#p15.pipes + 0.5] = v17;
		p15.pipes[#p15.pipes + 0.5] = v18;
		local v19 = p15:getBird();
		local v20 = false;
		while v17.AbsolutePosition.X > -100 do
			if v17.AbsolutePosition.X < v19.AbsolutePosition.X and not v20 then
				v20 = true;
				p15.points = p15.points + 1;
				p15:updatePoints();
			end;
			if p15:boundaryCheck(v19, v17) then
				p15:die();
			end;
			if p15:boundaryCheck(v19, v18) then
				p15:die();
			end;
			if not p15.ended then
				v17.Position = v17.Position - UDim2.new(0.008, 0, 0, 0);
				v18.Position = v18.Position - UDim2.new(0.008, 0, 0, 0);
			end;
			game:GetService("RunService").RenderStepped:Wait();		
		end;
		v17:Remove();
		v18:Remove();
	end;
	function v1.updatePoints(p17)
		u2.points.Text = tostring(p17.points);
	end;
	function v1.getPipeSpawnTimeMultiplier(p18)
		return 1.5;
	end;
	local u13 = Color3.fromRGB(68, 149, 245);
	local l__CurrentCamera__14 = workspace.CurrentCamera;
	function v1.start(p19, p20)
		p19.ended = false;
		p19.started = false;
		p19.bird = nil;
		u7 = {
			velocity = {
				x = 0, 
				y = 0
			}
		};
		u9 = p20:WaitForChild("Screen");
		u2 = u9.SurfaceGui:Clone();
		u2.Parent = u9;
		u2.Enabled = true;
		local v21 = l__Utilities__5.Create("Frame")({
			BackgroundTransparency = 1, 
			Parent = u2, 
			BorderSizePixel = 1, 
			BorderColor3 = Color3.fromRGB(u13), 
			Size = UDim2.new(1, 0, 0.001, 0), 
			Position = UDim2.new(0, 0, 0.99, 0), 
			Name = "Floor"
		});
		local v22 = l__Utilities__5.Create("Frame")({
			BackgroundTransparency = 1, 
			Parent = u2, 
			BorderSizePixel = 1, 
			BorderColor3 = Color3.fromRGB(u13), 
			Size = UDim2.new(1, 0, 0.001, 0), 
			Position = UDim2.new(0, 0, 0, 0), 
			Name = "Ceiling"
		});
		u3 = 0.3333333333333333 * u2.AbsoluteSize.X;
		u4 = Vector2.new(u2.AbsoluteSize.X / 2, u2.AbsoluteSize.Y / 2);
		l__CurrentCamera__14.CameraType = Enum.CameraType.Scriptable;
		local l__CFrame__15 = workspace.CurrentCamera.CFrame;
		l__Tween__10(1, "easeOutCubic", function(p21)
			l__CurrentCamera__14.CFrame = l__CFrame__15:Lerp(CFrame.new((u9.CFrame * CFrame.new(0, 0, -3)).p, u9.Position), p21);
		end);
		u9.Color = u13;
		u9.Transparency = 0;
		u2.points.Visible = true;
		local v23 = p19:getBird();
		p19.pipes = {};
		while not p19.started do
			l__Tween__10(0.65, nil, function(p22)
				if p19.started then
					return false;
				end;
				v23.Position = UDim2.new(0, u3, 0, u4.y + p22 * 30, 0);
			end);
			l__Tween__10(0.65, nil, function(p23)
				if p19.started then
					return false;
				end;
				v23.Position = UDim2.new(0, u3, 0, u4.y + 30 - p23 * 30, 0);
			end);		
		end;
		p19.points = 0;
		u2.ClipsDescendants = true;
		spawn(function()
			while game:GetService("RunService").RenderStepped:Wait() and v23.Parent do
				if u5(p19.bird, v22) and not p19.ended then
					spawn(function()
						v1:die();
					end);
				end;
				p19:step(p19:getBird());			
			end;
		end);
		while not p19.ended do
			wait(p19:getPipeSpawnTimeMultiplier());
			local u16 = math.random(-4, -1);
			spawn(function()
				p19:spawnPipe(u16);
			end);		
		end;
	end;
	v1.GameEnded = l__Utilities__5.Signal();
	return v1;
end;
