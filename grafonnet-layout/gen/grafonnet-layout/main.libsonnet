local render = {
  row(row, x=0, y=0, w=0, h=0): std.foldl(
    function(acc, child)
      local renderedChild = self.dispatch(child, acc.x, acc.y, 0, acc.h);
      {
        panels: acc.panels + renderedChild.panels,
        x: acc.x + renderedChild.w,
        y: acc.y,
        w: acc.w + renderedChild.w,
        h: acc.h,
      },
    row.children,
    {
      panels: [],
      x: x,
      y: y,
      w: w,
      h: row.height,
    },
  ),
  column(column, x=0, y=0, w=0, h=0): std.foldl(
    function(acc, child)
      local renderedChild = self.dispatch(child, acc.x, acc.y, acc.w, 0);
      {
        panels: acc.panels + renderedChild.panels,
        x: acc.x,
        y: acc.y + renderedChild.h,
        w: acc.w,
        h: acc.h + renderedChild.h,
      },
    column.children,
    {
      panels: [],
      x: x,
      y: y,
      w: column.width,
      h: h,
    },
  ),
  panel(panel, x=0, y=0, w=0, h=0): {
    local width = if (w != 0) then w else panel.size,
    local height = if (h != 0) then h else panel.size,
    panels: [panel.panel {
      gridPos: {
        x: x,
        y: y,
        w: width,
        h: height,
      },
    }],
    x: x + width,
    y: y + height,
    w: width,
    h: height,
  },
  space(space, x=0, y=0, w=0, h=0): {
    local width = if (w != 0) then w else space.size,
    local height = if (h != 0) then h else space.size,
    panels: [],
    x: x + width,
    y: y + height,
    w: width,
    h: height,
  },
  mixin(mixin, x=0, y=0, w=0, h=0):
    local renderedChild = self.dispatch(mixin.child, x, y, w, h);
    renderedChild {
      panels: [panel + mixin.mixin for panel in super.panels],
    },
  raw(panel, x=0, y=0, w=0, h=0): {
    panels: [panel {
      gridPos: {
        x: x,
        y: y,
        w: w,
        h: h,
      },
    }],
    x: x + w,
    y: y + h,
    w: w,
    h: h,
  },
  dispatch(elem, x=0, y=0, w=0, h=0):
    if std.get(elem, 'type', '') == 'layout-row' then
      self.row(elem, x, y, w, h)
    else if std.get(elem, 'type', '') == 'layout-column' then
      self.column(elem, x, y, w, h)
    else if std.get(elem, 'type', '') == 'layout-space' then
      self.space(elem, x, y, w, h)
    else if std.get(elem, 'type', '') == 'layout-panel' then
      self.panel(elem, x, y, w, h)
    else if std.get(elem, 'type', '') == 'layout-mixin' then
      self.mixin(elem, x, y, w, h)
    else
      self.raw(elem, x, y, w, h),
};

local layout(elem) = render.dispatch(elem).panels;

local row(height, children) = {
  type: 'layout-row',
  height: height,
  children: children,
};

local column(width, children) = {
  type: 'layout-column',
  width: width,
  children: children,
};

local panel(size, panel) = {
  type: 'layout-panel',
  size: size,
  panel: std.get(panel, 'panel', panel),
};

local space(size) = {
  type: 'layout-space',
  size: size,
};

local mixin(mixin, child) = {
  type: 'layout-mixin',
  mixin: mixin,
  child: child,
};

local withLayout = {
  lt: {
    row: row,
    column: column,
    panel: panel,
    space: space,
    mixin: mixin,
  },
  local layoutMixin = {
    withLayout(lt): super.withPanels(layout(lt)),
    withColumn(width, children): self.withLayout(column(width, children)),
    withRow(height, children): self.withLayout(row(height, children)),
  },
  dashboard+: layoutMixin,
  panel+: {
    row+: layoutMixin,
  },
};

{
  layout: layout,
  row: row,
  column: column,
  panel: panel,
  space: space,
  mixin: mixin,
  withLayout: withLayout,
}
