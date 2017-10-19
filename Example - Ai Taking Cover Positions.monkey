
Import mojo

Class bullet
	Field x:Float,y:Float
	Field w:Int,h:Int
	Field mx:Int,my:Int
	Field direction:String
	Field deleteme:Bool=False
	Field speed:Int=2
	Method New(x:Int,y:Int,direction:String)
		Self.x = x
		Self.y = y
		Self.w = myplayer.w/3
		Self.h = myplayer.h/3
		Self.direction = direction
		If direction = "left" Then mx = -1
		If direction = "right" Then mx = 1
		If direction = "up" Then my = -1
		If direction = "down" Then my = 1
		If direction = "leftup" Then mx = -1 ; my = -1
		If direction = "rightup" Then mx = 1 ; my = -1
		If direction = "leftdown" Then mx = -1 ; my = 1
		If direction = "rightdown" Then mx = 1 ; my = 1
	End Method
	Method update()
		For Local i:Int=0 Until speed
			x += mx
			y += my
			If x < 0 Or x > mymap.screenwidth Then deleteme = True
			If y < 0 Or y > mymap.screenheight Then deleteme = True
			If mymap.mapcollide(x,y,w,h) Then deleteme = true
		Next
	End Method
	Method draw()
		SetColor 255,255,0
		DrawOval x,y,w,h
	End Method
End Class

Class player
	Field x:Float,y:Float
	Field w:Int,h:Int
	Field direction:String="up"
	Method New()
		w = mymap.tilewidth
		h = mymap.tileheight
		findstartingpos()
	End Method
	Method update()
		playercontrols()
		makecovermap()
	End Method
    Method playercontrols()
    	' movement	
    	If KeyDown(KEY_UP) And Not mymap.mapcollide(x,y-1,w,h)
    		y-=1
			direction = "up"
    	End If
    	If KeyDown(KEY_LEFT) And Not mymap.mapcollide(x-1,y,w,h)
    		x-=1
    		direction = "left"
    	End If
    	If KeyDown(KEY_RIGHT) And Not mymap.mapcollide(x+1,y,w,h)
    		x+=1
    		direction = "right"
    	End If
    	If KeyDown(KEY_DOWN) And Not mymap.mapcollide(x,y+1,w,h)
    		y+=1
    		direction = "down"
    	End If
		If KeyDown(KEY_LEFT) And KeyDown(KEY_UP) Then direction = "leftup"
		If KeyDown(KEY_RIGHT) And KeyDown(KEY_UP) Then direction = "rightup"
		If KeyDown(KEY_LEFT) And KeyDown(KEY_DOWN) Then direction = "leftdown"
		If KeyDown(KEY_RIGHT) And KeyDown(KEY_DOWN) Then direction = "rightdown"	
		' shooting
		If KeyHit(KEY_F)
			mybullet.AddLast(New bullet(x,y,direction))
		End If
    End Method
	Method makecovermap()
		If Rnd(60)>2 Then Return
		For Local y:Int=0 Until mymap.mapheight
		For Local x:Int=0 Until mymap.mapwidth
			mymap.covermap[x][y] = 1
			If mymap.map[x][y] <> 0 Then mymap.covermap[x][y] = 2
		Next
		Next
		' shoot bullets into random directions around
		' the player and see if any position is a cover position
		For Local i:Int=0 Until 600
			Local x2:Float=x
			Local y2:Float=y
			Local xa:Float=Rnd(-1,1)
			Local ya:Float=Rnd(-1,1)
			For Local d:Int=0 Until 40
				x2+=xa*Float(mymap.tilewidth/2)
				y2+=ya*Float(mymap.tileheight/2)
				Local mx:Int=x2/mymap.tilewidth
				Local my:Int=y2/mymap.tileheight
				If mx>=0 And my>=0 And mx<mymap.mapwidth And my<mymap.mapheight
				mymap.covermap[mx][my] = 0
				Else
				Exit
				End If
				If mymap.mapcollide(x2,y2,w/3,h/3) Then Exit
				
			Next
		Next
		'
		' Remove every coverpoint except if they
		' are near a wall. 
		For Local y2:Int=0 Until mymap.mapheight
		For Local x2:Int=0 Until mymap.mapwidth
			Local remove:Bool=True
			For Local y3:Int=y2-1 To y2+1
			For Local x3:Int=x2-1 To x2+1
				If x3<0 Or y3<0 Or x3>=mymap.mapwidth Or y3>=mymap.mapheight Then Continue
				If mymap.map[x3][y3] <> 0 Then remove = False ; Exit
			Next
			Next
			If remove = True Then
				mymap.covermap[x2][y2] = 0
			End If
		Next
		Next
	End Method
	Method findstartingpos()
		Repeat
			Local x1:Int = Rnd(0,mymap.mapwidth)
			Local y1:Int = Rnd(0,mymap.mapheight)
			Local istaken:Bool=False
			For Local x2:Int=x1-4 To x1+4
			For Local y2:Int=y1-4 To y1+4
				If x2<0 Or y2<0 Or x2>=mymap.mapwidth Or y2>=mymap.mapheight Then Continue
				If mymap.map[x2][y2] <> 0 Then istaken = True ; Exit				
			Next
			Next
			If istaken=False Then 
				x = x1*mymap.tilewidth
				y = y1*mymap.tileheight
				Exit
			End If			
		Forever
	End Method
	Method draw()
		SetColor 255,255,255
		DrawOval x,y,w,h
	End Method
End Class

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
	Field covermap:Int[][]
	Method New(screenwidth:Int,screenheight:Int,mapwidth:Int,mapheight:Int)
		Self.screenheight = screenheight
		Self.screenwidth = screenwidth
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		tilewidth = Float(screenwidth) / Float(mapwidth)
		tileheight = Float(screenheight) / Float(mapheight)
		map = New Int[mapwidth][]
		covermap = New Int[mapwidth][]
		For Local i:Int=0 Until mapwidth
			map[i] = New Int[mapheight]
			covermap[i] = New Int[mapheight]
		Next
		makemap(10)
	End Method

	Method makemap:Void(numobstacles:Int)
	    For Local y=0 Until mapheight
	    For Local x=0 Until mapwidth
	        map[x][y] = 0
	    Next
	    Next
		' Here we create short lines on the map
		' and sometimes draw some random blocks near them.
		For Local i:Int=0 Until numobstacles
			Local x1:Int=Rnd(4,mapwidth-4)
			Local y1:Int=Rnd(4,mapheight-4)
			Local dist:Int=Rnd(3,5)
			Local angle:Int=Rnd(0,360)
			Local x2:Float=x1
			Local y2:Float=y1
			While dist >= 0
				x2 += Cos(angle) * 1
				y2 += Sin(angle) * 1
				dist -= 1
				map[x2][y2] = 10
				If Rnd(10) < 2 Then
					map[x2+Rnd(-1,1)][y2+Rnd(-1,1)] = 10
				End If
			Wend			
		Next
	End Method

	Method mapcollide:Bool(x:Int,y:Int,w:Int,h:Int)
		Local lefttopx:Int		=((x)/tilewidth)
		Local lefttopy:Int		=((y)/tileheight)
		Local righttopx:Int		=((x+w)/tilewidth)
		Local righttopy:Int		=((y)/tileheight)
		Local leftbottomx:Int	=((x)/tilewidth)
		Local leftbottomy:Int	=((y+h)/tileheight)
		Local rightbottomx:Int	=((x+w)/tilewidth)												
		Local rightbottomy:Int	=((y+h)/tileheight)
		If lefttopx < 0 Or lefttopx >= mapwidth Then Return True
		If lefttopy < 0 Or lefttopy >= mapheight Then Return True
		If righttopx < 0 Or righttopx >= mapwidth Then Return True
		If righttopy < 0 Or righttopy >= mapheight Then Return True
		If leftbottomx < 0 Or leftbottomx >= mapwidth Then Return True
		If leftbottomy < 0 Or leftbottomy >= mapheight Then Return True
		If rightbottomx < 0 Or rightbottomx >= mapwidth Then Return True
		If rightbottomy < 0 Or rightbottomy >= mapheight Then Return True
		
		If map[lefttopx][lefttopy] <> 0 Then Return True
		If map[righttopx][righttopy] <> 0 Then Return True
		If map[leftbottomx][leftbottomy] <> 0 Then Return True
		If map[rightbottomx][rightbottomy] <> 0 Then Return True						
		Return False
	End Method

	Method drawmap:Void()
	    For Local y=0 Until mapheight
	    For Local x=0 Until mapwidth
	        SetColor 0,map[x][y]*10,0
	        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
	    Next
	    Next
	End Method

	Method drawcovermap:Void()
	    For Local y=0 Until mapheight
	    For Local x=0 Until mapwidth
			If covermap[x][y] = 1
				SetColor 0,15,0
				DrawOval x*mymap.tilewidth,y*mymap.tileheight,tilewidth,tileheight
			End If
	    Next
	    Next		
	End Method

	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
	    Return Abs(x2-x1)+Abs(y2-y1)
	End Function

	
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
Global myplayer:player
Global mybullet:List<bullet> = New List<bullet>

Class MyGame Extends App

    Method OnCreate()
    	Seed = GetDate[4] * GetDate[5]
        SetUpdateRate(60)
        ' Create a new map
		mymap = New map(DeviceWidth(),DeviceHeight(),30,30)
    	myastar = New astar()
		myplayer = New player()
    End Method
    Method OnUpdate()        
    	myplayer.update()
    	For Local i:=Eachin mybullet
    		i.update()
    	Next
    	For Local i:=Eachin mybullet
    		If i.deleteme = True Then mybullet.Remove(i)
    	Next

    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.drawmap()        
        mymap.drawcovermap()
        For Local i:=Eachin mybullet
        	i.draw()
        Next
        myplayer.draw()
        SetColor 255,255,255
        DrawText "AI - taking Cover Locations Example.",0,0
        DrawText "Controls - cursor u/d/l/r and F - fire",0,20
    End Method
End Class

Function Main()
    New MyGame()
End Function
