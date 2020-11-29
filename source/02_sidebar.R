sidebar = bs4DashSidebar(
  title = "bs4Dash Demo",
  status = "secondary",
  brandColor = "warning",
  skin = "light",
  src = "main.png",
  
  # menu (Menu > MenuItem > MenuSubItem)
  bs4SidebarMenu(
    bs4SidebarMenuItem("Examples", tabName = "item1", icon = "calendar-check"),
    bs4SidebarMenuItem("Profile", tabName = "item2", icon = "sticky-note"),
    bs4SidebarMenuItem("About", tabName = "about", icon = "info-circle")
  )
)