' New Object oriented version of my Astar Code.

Import mojo

Class astar
	Field mapwidth:Int,mapheight:Int
	Field sx:Int,sy:Int
	Field ex:Int,ey:Int
	Field olmap:Int[][]
	Field clmap:Int[][]
	Field map:Int[][]
	Field ol:List<openlist> = New List<openlist>
	Field cl:List<closedlist> = New List<closedlist>
	Field path:List<pathnode> = New List<pathnode>
	Method New()
		mapwidth = mymap.mapwidth
		mapheight = mymap.mapheight
		olmap = New Int[mapwidth][]
		clmap = New Int[mapwidth][]
		map = New Int[mapwidth][]
		For Local i:Int=0 Until mapwidth
			olmap[i] = New Int[mapheight]
			clmap[i] = New Int[mapheight]
			map[i] = New Int[mapheight]
		Next
		' Copy the map into the astar class map
		For Local y:=0 Until mapheight
		For Local x:=0 Until mapwidth
			map[x][y] = mymap.map[x][y]
		Next
		Next
	End Method
	' This creates the map and copies the 
	' path in the path list
	Method findpath:Bool(sx:Int,sy:Int,ex:Int,ey:Int)
	    If sx = ex And sy = ey Then Return False
	    Self.sx = sx
	    Self.sy = sy
	    Self.ex = ex
	    Self.ey = ey
	    For Local y=0 Until mapheight
	    For Local x=0 Until mapwidth
	        olmap[x][y] = 0
	        clmap[x][y] = 0
	    Next
	    Next
	    ol.Clear
	    cl.Clear
	    path.Clear
	    ol.AddFirst(New openlist(sx,sy))
	    Local tx:Int
	    Local ty:Int
	    Local tf:Int
	    Local tg:Int
	    Local th:Int
	    Local tpx:Int
	    Local tpy:Int
	    Local newx:Int
	    Local newy:Int
	    Local lowestf:Int
	    olmap[sx][sy] = 1
	    While ol.IsEmpty() = False
	        lowestf = 100000
	        For Local i:=Eachin ol
	            If i.f < lowestf
	                lowestf = i.f
	                tx = i.x
	                ty = i.y
	                tf = i.f
	                tg = i.g
	                th = i.h
	                tpx = i.px
	                tpy = i.py
	            End If
	        Next
	        If tx = ex And ty = ey
	            cl.AddLast(New closedlist(tx,ty,tpx,tpy))
	            findpathback
	            Return True
	        Else
	            removefromopenlist(tx,ty)
	            olmap[tx][ty] = 0
	            clmap[tx][ty] = 1
	            cl.AddLast(New closedlist(tx,ty,tpx,tpy))
	            For Local y=-1 To 1
	            For Local x=-1 To 1
	                newx = tx+x
	                newy = ty+y
	                If newx>=0 And newy>=0 And newx<mapwidth And newy<mapheight
	                If olmap[newx][newy] = 0
	                If clmap[newx][newy] = 0
	                    olmap[newx][newy] = 1
	                    Local gg = map[newx][newy]+1
	                    Local hh = distance(newx,newy,ex,ey)
	                    Local ff = gg+hh
	                    ol.AddLast(New openlist(newx,newy,ff,gg,hh,tx,ty))
	                End If
	                End If
	                End If
	            Next
	            Next
	        End If
	    Wend
	    Return False
	End Method

	Method drawpath:Void()
	    Local cnt:Int=1
	    For Local i:=Eachin path
	        SetColor 255,255,0
	        DrawOval i.x*mymap.tilewidth,i.y*mymap.tileheight,4,4
	        SetColor 255,255,255
	        DrawText cnt,i.x*mymap.tilewidth,i.y*mymap.tileheight
	        cnt+=1
	    Next
	End Method
	' Here we calculate back from the end back to the
	' start and create the path list.
	Method findpathback:Bool()
	    Local x=ex
	    Local y=ey
	    path.AddFirst(New pathnode(x,y))
	    Repeat
	        For Local i:=Eachin cl
	            If i.x = x And i.y = y
	                x = i.px
	                y = i.py
	                path.AddFirst(New pathnode(x,y))
	            End If
	        Next
	        If x = sx And y = sy Then Return True
	    Forever    
	End Method


	Method removefromopenlist:Void(x1:Int,y1:Int)
    	For Local i:=Eachin ol
        	If i.x = x1 And i.y = y1
            	ol.Remove i
            	Exit	
        	End If
    	Next
	End Method
	
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
	    Return Abs(x2-x1)+Abs(y2-y1)
	End Function


End Class

Class map
	Field mapwidth:Int
	Field mapheight:Int
	Field screenwidth:Int
	Field screenheight:Int
	Field tilewidth:Float
	Field tileheight:Float
	Field map:Int[][]
	Method New(screenwidth:Int,screenheight:Int,mapwidth:Int,mapheight:Int)
		Self.screenheight = screenheight
		Self.screenwidth = screenwidth
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		tilewidth = Float(screenwidth) / Float(mapwidth)
		tileheight = Float(screenheight) / Float(mapheight)
		map = New Int[mapwidth][]
		For Local i:Int=0 Until mapwidth
			map[i] = New Int[mapheight]
		Next
		makemap()
	End Method

	Method makemap:Void()
	    For Local y=0 Until mapheight
	    For Local x=0 Until mapwidth
	        map[x][y] = 0
	    Next
	    Next
	    Local lowest = 0
	    While lowest < 13
	        Local x1 = Rnd(mapwidth)
	        Local y1 = Rnd(mapheight)
	        Local radius = Rnd(3,6)
	        For Local y2=-radius To radius
	        For Local x2=-radius To radius
	            If ((x2*x2)+(y2*y2)) <= radius*radius+radius*0.8
	                Local x3 = x1+x2
	                Local y3 = y1+y2
	                If x3>=0 And y3>=0 And x3<mapwidth And y3<mapheight
	                    map[x3][y3]=map[x3][y3]+1
	                    If map[x3][y3] > lowest Then lowest = map[x3][y3]
	                End If
	            End If
	        Next
	        Next
	    Wend
	End Method

	Method drawmap:Void()
	    For Local y=0 Until mapheight
	    For Local x=0 Until mapwidth
	        SetColor 0,map[x][y]*10,0
	        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
	    Next
	    Next
	End Method
	
End Class

' The open list used by the astar
Class openlist
    Field x:Int
    Field y:Int
    Field f:Int
    Field g:Int
    Field h:Int
    Field px:Int
    Field py:Int
    Method New(    x:Int=0,y:Int=0,f:Int=0,
                g:Int=0,h:Int=0,px:Int=0,py:Int=0)
        Self.x=x
        Self.y=y
        Self.f=f
        Self.g=g
        Self.h=h
        Self.px=px
        Self.py=py
    End Method
End Class

' The closed list used by the astar
Class closedlist
    Field x:Int
    Field y:Int
    Field px:Int
    Field py:Int 
    Method New(x:Int,y:Int,px:Int,py:Int)
        Self.x = x
        Self.y = y
        Self.px = px
        Self.py = py
    End Method
End Class
' the pathnodes (x and y variables)
' used by the astar
Class pathnode
    Field x:Int
    Field y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Global mymap:map
Global myastar:astar

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(1)
        ' Create a new map
		mymap = New map(DeviceWidth(),DeviceHeight(),30,30)
		' Initiate the astar. Here the map from the mymap
		' is copied into. Recreate this everytime the map is 
		' modified..
		' the map from the mymap should contain the heights/terrain
		' costs. A tile with a high value is less likely to be chosen.
    	myastar = New astar()
    End Method
    Method OnUpdate()        
		' create 2 unique start and end coordinates
		Local exitloop:Bool=False
		Local sx:Int,sy:Int,ex:Int,ey:Int
		While exitloop = False	
			sx = Rnd(mymap.mapwidth)
			sy = Rnd(mymap.mapheight)
			ex = Rnd(mymap.mapwidth)
			ey = Rnd(mymap.mapheight)
			If sx <> ex And sy <> ey
				exitloop = True
			End If
		Wend
		' Find/create the path
		myastar.findpath(sx,sy,ex,ey)
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.drawmap()        
        myastar.drawpath()
        SetColor 255,255,255
        DrawText "a Star Pathfinding example",0,0
    End Method
End Class

Function Main()
    New MyGame()
End Function
