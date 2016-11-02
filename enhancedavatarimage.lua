local PANEL = {}
PANEL.hexagonData = nil;
PANEL.triangleData = nil;
PANEL.circleData = nil;
PANEL.squareData = nil;
PANEL.pentagonData = nil;

function PANEL:CalculateHexagon(w, h)
  if (self.avatar.direction) then
    self.hexagonData = {
      { x = w/2, y = 0 },
      { x = w, y = h/2 - h/4 },
      { x = w, y = h/2 + h/4 },
      { x = w/2, y = h },
      { x = 0, y = h/2 + h/4 },
      { x = 0, y = h/2 - h/4 }
    };
  else
    self.hexagonData = {
      { x = w/2 - w/4, y = 0 },
      { x = w/2 + w/4, y = 0 },
      { x = w, y = h/2 },
      { x = w/2 + w/4, y = h },
      { x = w/2 - w/4, y = h },
      { x = 0, y = h/2 }
    };
  end
end

function PANEL:DrawHexagon(w, h)
  if (self.hexagonData == nil) then
    self:CalculateHexagon(w, h);
  end

  surface.DrawPoly(self.hexagonData);
end

function PANEL:CalculateTriangle(w, h)
  if (self.avatar.direction) then
    self.triangleData = {
      { x = 0, y = 0 },
      { x = w, y = 0 },
      { x = w/2, y = h }
    };
  else
    self.triangleData = {
      { x = w/2, y = 0 },
      { x = w, y = h },
      { x = 0, y = h }
    };
  end
end

function PANEL:DrawTriangle(w, h)
  if (self.triangleData == nil) then
    self:CalculateTriangle(w, h);
  end

  surface.DrawPoly(self.triangleData);
end

function PANEL:CalculateCircle(w, h)
  local x = w/2;
  local y = h/2;
  local radius = h/2;
  local seg = 360;

  table.insert( self.circleData, { x = x, y = y } )
  for i = 0, seg do
    local a = math.rad( ( i / seg ) * -360 )
    table.insert( self.circleData, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
  end
  local a = math.rad( 0 )
  table.insert( self.circleData, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
end

function PANEL:DrawCircle(w, h)
  if (self.circleData == nil) then
    self:CalculateCircle(w, h);
  end

  surface.DrawPoly(self.circleData);
end

function PANEL:CalculateSquare(w, h)
  self.squareData = {
    { x = 0, y = 0 },
    { x = w, y = 0 },
    { x = w, y = h },
    { x = 0, y = h }
  };
end

function PANEL:DrawSquare(w, h)
  if (self.squareData == nil) then
    self:CalculateSquare(w, h);
  end

  surface.DrawPoly(self.squareData);
end

function PANEL:CalculatePentagon(w, h)
  self.pentagonData = {
    { x = w/2, y = 0 },
    { x = w, y = h * 0.4 },
    { x = w - w/5, y = h },
    { x = 0 + w/5, y = h },
    { x = 0, y = h * 0.4 }
  };
end

function PANEL:DrawPentagon(w, h)
  if (self.pentagonData == nil) then
    self:CalculatePentagon(w, h);
  end

  surface.DrawPoly(self.pentagonData);
end

function PANEL:Init()
  self.avatar = vgui.Create( "AvatarImage", self )
  self.avatar:SetPaintedManually( true )
  self.avatar.type = 4; -- default to square
  self.avatar.direction = false;
end

function PANEL:CalculatePanel()
  local type, direction = self:GetType();

  if (type == 1) then self.hexagonData = nil; end
  if (type == 2) then self.triangleData = nil; end
  if (type == 3) then self.circleData = nil; end
  if (type == 4) then self.squareData = nil; end
  if (type == 5) then self.pentagonData = nil; end
end

function PANEL:PerformLayout()
  self.avatar:SetSize( self:GetWide(), self:GetTall() )
  self:CalculatePanel();
end

function PANEL:SetPlayer( ply, size )
  self.avatar:SetPlayer( ply, size )
end

function PANEL:SetType(type, direction)
  self.avatar.type = type;
  self.avatar.direction = direction;
end

function PANEL:GetType()
  local type = self.avatar.type;
  local direction = self.avatar.direction;

  return type, direction;
end

function PANEL:DrawPolygon(w, h)
  local type, direction = self:GetType();

  if (type == 1) then self:DrawHexagon(w, h); end
  if (type == 2) then self:DrawTriangle(w, h); end
  if (type == 3) then self:DrawCircle(w, h); end
  if (type == 4) then self:DrawSquare(w, h); end
  if (type == 5) then self:DrawPentagon(w, h); end
end

function PANEL:Paint( w, h )
  render.ClearStencil()
  render.SetStencilEnable( true )

  render.SetStencilWriteMask( 1 )
  render.SetStencilTestMask( 1 )

  render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
  render.SetStencilPassOperation( STENCILOPERATION_ZERO )
  render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
  render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
  render.SetStencilReferenceValue( 1 )

  draw.NoTexture()
  surface.SetDrawColor(color_white)
  self:DrawPolygon(w, h);

  render.SetStencilFailOperation( STENCILOPERATION_ZERO )
  render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
  render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
  render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
  render.SetStencilReferenceValue( 1 )

  self.avatar:PaintManual()

  render.SetStencilEnable( false )
  render.ClearStencil()
end
vgui.Register( "EnhancedAvatarImage", PANEL )
