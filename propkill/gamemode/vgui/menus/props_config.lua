--[[
				  _________.__    .__                                  
				 /   _____/|  |__ |__| ____ ___.__. ____  ______  _  __
				 \_____  \ |  |  \|  |/    <   |  |/ ___\/  _ \ \/ \/ /
				 /        \|   Y  \  |   |  \___  \  \__(  <_> )     / 
				/_______  /|___|  /__|___|  / ____|\___  >____/ \/\_/  
						\/      \/        \/\/         \/              

		Clientside menu for changing gamemode configuration
]]--

local PANEL = {}

function PANEL:Init()
	
	self:SetPos( 15, 15 )
	self:SetSize( self:GetParent():GetWide() - 30, self:GetParent():GetTall() - 30 )
	
	self.configCategories = {}
	
	local function createCategoryContent( config_id, category )
		
		local k = config_id
		local v = PROPKILL.Config[ k ]
		
		surface.SetFont( "props_HUDTextTiny" )
		local panelTextSize_w, panelTextSize_h = surface.GetTextSize( v.desc )
			
		self.configCategories[ category ].Panel[ k ].Text = self.configCategories[ category ].Panel[ k ]:Add( "DLabel" )
		self.configCategories[ category ].Panel[ k ].Text:SetPos( self.configCategories[ category ].Panel[ k ]:GetWide() / 2 - panelTextSize_w / 2, 3 )
		self.configCategories[ category ].Panel[ k ].Text:SetFont( "props_HUDTextTiny" )
		self.configCategories[ category ].Panel[ k ].Text:SetText( v.desc )
		self.configCategories[ category ].Panel[ k ].Text:SetTextColor( Color( 230, 230, 230, 255 ) )
		self.configCategories[ category ].Panel[ k ].Text:SizeToContents()
		
		if v.type == "boolean" then
			self.configCategories[ category ].Panel[ k ].Content = self.configCategories[ category ].Panel[ k ]:Add( "DCheckBoxLabel" )
			self.configCategories[ category ].Panel[ k ].Content:SetText( v.Name )
			self.configCategories[ category ].Panel[ k ].Content:SetValue( v.default )
			self.configCategories[ category ].Panel[ k ].Content.Label:SetFont( "props_HUDTextTiny" )
			self.configCategories[ category ].Panel[ k ].Content.Label:SetTextColor( Color( 45, 45, 45, 255 ) )
			--self.configCategories[ category ].Panel[ k ].Content:SetSize( 30, 30 )
			self.configCategories[ category ].Panel[ k ].Content:SizeToContents()
			--local panelContentSize_w, panelContentSize_h = self.configCategories[ category ].Panel[ k ].Content:GetSize()
			--self.configCategories[ category ].Panel[ k ].Content:SetPos( self.configCategories[ category ].Panel[ k ].Text:GetParent():GetWide() / 2 - panelContentSize_w, 3 + panelTextSize_h + 5 )
			self.configCategories[ category ].Panel[ k ].Content:SetPos( (400 / 2) + 3, 25 )
			self.configCategories[ category ].Panel[ k ].Content.Button.Toggle = function( pnl )
				if not pnl:GetChecked() then
					pnl:SetValue( true )
				else
					pnl:SetValue( false )
				end
				RunConsoleCommand( "props_changesetting", k, tostring( pnl:GetChecked() ) )
				PROPKILL.Config[ k ].default = pnl:GetChecked()
			end	
		elseif v.type == "integer" then
					self.configCategories[ category ].Panel[ k ].Content = self.configCategories[ category ].Panel[ k ]:Add( "DNumSlider" )
					--self.configCategories[ category ].Panel[ k ].Content:SetPos( 195, 15 )
					--self.configCategories[ category ].Panel[ k ].Content:SetWide( 300 )
					--self.configCategories[ category ].Panel[ k ].Content:SetText( v.Name )
					self.configCategories[ category ].Panel[ k ].Content:SetPos( 135, 15 )
					self.configCategories[ category ].Panel[ k ].Content:SetWide( 400 )
					self.configCategories[ category ].Panel[ k ].Content:SetMin( v.min or 1 )
					self.configCategories[ category ].Panel[ k ].Content:SetMax( v.max or 50 )
					self.configCategories[ category ].Panel[ k ].Content:SetDecimals( v.decimals or 0 )
					self.configCategories[ category ].Panel[ k ].Content.Scratch:SetDecimals( v.decimals or 0 )
					self.configCategories[ category ].Panel[ k ].Content:SetValue( v.default )
					--self.configCategories[ category ].Panel[ k ].Content.Label:Remove()
					self.configCategories[ category ].Panel[ k ].Content.Slider:SetSlideX( v.default / ( v.max or 50 ) )
					self.configCategories[ category ].Panel[ k ].Content.Slider.OnMouseReleased = function( pnl )
						pnl:SetDragging( false )
						pnl:MouseCapture( false )
						
						RunConsoleCommand( "props_changesetting", k, math.Round( self.configCategories[ category ].Panel[ k ].Content:GetValue(), v.decimals or 0 ) )
						PROPKILL.Config[ k ].default = math.Round( self.configCategories[ category ].Panel[ k ].Content:GetValue(), v.decimals or 0 )
					end
					self.configCategories[ category ].Panel[ k ].Content.Slider.Knob.OnMouseReleased = function( pnl, mousecode )
						RunConsoleCommand( "props_changesetting", k, math.Round( self.configCategories[ category ].Panel[ k ].Content:GetValue(), v.decimals or 0 ) )
						PROPKILL.Config[ k ].default = math.Round( self.configCategories[ category ].Panel[ k ].Content:GetValue(), v.decimals or 0 )
						
						return DLabel.OnMouseReleased( pnl, mousecode )
					end
					self.configCategories[ category ].Panel[ k ].Content.TextArea.OnEnter = function( pnl )
						RunConsoleCommand( "props_changesetting", k, math.Round( pnl:GetValue(), v.decimals or 0 ) )
						PROPKILL.Config[ k ].default = math.Round( self.configCategories[ category ].Panel[ k ].Content:GetValue(), v.decimals or 0 )
					end
					--print( self.configCategories[ category ].Panel[ k ].Content.Scratch and "scratch found" or "no scratch" )
					self.configCategories[ category ].Panel[ k ].Content.PerformLayout = function( pnl )
						--pnl.Label:SetWide( pnl:GetWide() / 2.4 )
					end
				elseif v.type == "button" then
					self.configCategories[ category ].Panel[ k ].Content = self.configCategories[ category ].Panel[ k ]:Add( "DButton" )
					self.configCategories[ category ].Panel[ k ].Content:SetPos( 200 + 3, 30 )
					self.configCategories[ category ].Panel[ k ].Content:SetWide( 300 )
					self.configCategories[ category ].Panel[ k ].Content:SetTall( 20 )
					self.configCategories[ category ].Panel[ k ].Content:SetText( v.Name )
					self.configCategories[ category ].Panel[ k ].Content.DoClick = function( pnl )
						RunConsoleCommand( "props_changesetting", k )
					end
					
				end
	end

	for k,v in SortedPairs( PROPKILL.Config ) do
		
		--print( k )
		local category = PROPKILL.Config[ k ].Category
		if not self.configCategories[ category ] then
			self.configCategories[ category ] = self:Add( "DCollapsibleCategory" )
			self.configCategories[ category ]:SetLabel( category )
			self.configCategories[ category ]:SetExpanded( false )
			--self.configCategories[ category ]:
			self.configCategories[ category ]:Dock( TOP )
			--self.configCategories[ category ].Paint = function( pnl, w, h )
			--end
			
			--self.configCategories[ category ].Header:SetSize( 30, 40 )--SetTall( 20 )
			self.configCategories[ category ].Header:SetFont( "props_HUDTextSmall" )
			self.configCategories[ category ].Header:SetContentAlignment( 1 )
			self.configCategories[ category ].Header:SetTextInset( 8, 0 )
			self.configCategories[ category ].Header:SetTextColor( Color( 230, 230, 230, 255 ) )
			--self.configCategories[ category ].Header:
			
			--[[self.configCategories[ category ].PerformLayout = function( self2 )
				local Padding = self2:GetPadding() or 0

				if ( self2.Contents ) then
					
					if ( self2:GetExpanded() ) then
						self2.Contents:InvalidateLayout( true )
						self2.Contents:SetVisible( true )
					else
						self2.Contents:SetVisible( false )
					end
					
				end
				
				if ( self2:GetExpanded() ) then

					self2:SizeToChildren( false, true )
				
				else
					
					self2:SetTall( self2.Header:GetTall() )
				
				end	
				
				-- Make sure the color of header text is set
				self2.Header:ApplySchemeSettings()
				
				self2.animSlide:Run()
				self2:UpdateAltLines();
			end]]
			
				-- for referencing
			self.configCategories.CatNames = self.configCategories.CatNames or {}
			self.configCategories.CatNames[ #self.configCategories.CatNames + 1 ] = category
			self.configCategories[ category ].CatName = category
			self.configCategories[ category ].Header.DoClick = function( pnl )
				self.configCategories[ category ]:Toggle()
				
				for k,v in pairs( self.configCategories.CatNames ) do
					if v == pnl:GetParent().CatName then continue end
					
					self.configCategories[ v ]:SetExpanded( false )
					self.configCategories[ v ].animSlide:Start( self.configCategories[ v ]:GetAnimTime(), { From = self.configCategories[ v ]:GetTall() } )
					self.configCategories[ v ]:InvalidateLayout( true )
					self.configCategories[ v ]:GetParent():InvalidateLayout()
					self.configCategories[ v ]:GetParent():GetParent():InvalidateLayout()
					
					self.configCategories[ v ]:SetCookie( "Open", "0" )
				end
			end
			
			self.configCategories[ category ].Panel = vgui.Create( "DPanelList", self.configCategories[ category ] )--self.configCategories[ category ]:Add( "DPanelList" )
			self.configCategories[ category ].Panel:SetWide( self:GetWide() )
				-- make it so all categories can still be shown, but auto size it based on
				-- how many items there are.
				-- but clamp it so that it won't go over how many categories can be shown
			--self.configCategories[ category ].Panel:SetTall( math.Clamp( self:GetTall() * 0.7, self:GetTall )
			self.configCategories[ category ].Panel:SetTall( self:GetTall() * 0.6 )
			self.configCategories[ category ].Panel:SetSpacing( 5 )
			self.configCategories[ category ].Panel:EnableHorizontal( false )
			self.configCategories[ category ].Panel:EnableVerticalScrollbar( true )
			self.configCategories[ category ].Panel:Dock( TOP )
			--self.configCategories[ category ]:AddItem( self.configCategories[ category].Panel )
			
			local panelPos_x, panelPos_y = self.configCategories[ category ].Panel:GetPos()
			
			self.configCategories[ category ].Panel[ k ] = self.configCategories[ category ].Panel:Add( "DPanel" )
			self.configCategories[ category ].Panel[ k ]:SetPos( 40, 0 )
			--self.configCategories[ category ].Panel[ k ]:SetWide( self.configCategories[ category ].Panel:GetWide() - 60 )
			self.configCategories[ category ].Panel[ k ]:SetWide( self.configCategories[ category ].Panel:GetWide() )
			self.configCategories[ category ].Panel[ k ]:SetTall( 50 )
			self.configCategories[ category ].Panel[ k ].Paint = function( pnl, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 90, 90, 90, 105 ) )
			end
			
			createCategoryContent( k, category )
			
			self.configCategories[ category ].Panel:AddItem( self.configCategories[ category ].Panel[ k ] )
		
		else
		
			self.configCategories[ category ].Panel[ k ] = self.configCategories[ category ].Panel:Add( "DPanel" )
			self.configCategories[ category ].Panel[ k ]:SetPos( 40, 0 )
			--self.configCategories[ category ].Panel[ k ]:SetWide( self.configCategories[ category ].Panel:GetWide() - 60 )
			self.configCategories[ category ].Panel[ k ]:SetWide( self.configCategories[ category ].Panel:GetWide() )
			self.configCategories[ category ].Panel[ k ]:SetTall( 60 )
			self.configCategories[ category ].Panel[ k ].Paint = function( pnl, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 90, 90, 90, 105 ) )
			end
			
			createCategoryContent( k, category )
			
			self.configCategories[ category ].Panel:AddItem( self.configCategories[ category ].Panel[ k ] )
			
		end
			
		
	end

end

vgui.Register( "props_ConfigMenu", PANEL )