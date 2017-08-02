Import mojo

Global screenwidth:Int,screenheight:Int

' This is a class that holds x and y variables.
Class pathnode
    Field x:Int,y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Class bullet
    ' bullet x and y and radius
    Field bx:Float,by:Float,br:Int=4
    Field angle:Int
    Field bulletspeed:Float=3
    Field bulletmaxdist:Int=1200
    Field bullettraveled:Int
    Field deleteme:Bool=False
    ' start location and target location for getting angle
    Method New(x1:Int,y1:Int,x2:Int,y2:Int)
        bx = x1
        by = y1
        angle = getangle(x1,y1,x2,y2)
    End Method
    Method update()
        ' update the bullet position
        bx += Cos(angle)*bulletspeed
        by += Sin(angle)*bulletspeed
        ' if distance to long then flag bullet for removal
        bullettraveled+=1
        If bullettraveled > bulletmaxdist Then deleteme = True
        ' check collision with zombies
        For Local i:=Eachin myzombie
            If circleoverlap(bx,by,br,i.zx,i.zy,i.zr)
                deleteme = True
                i.hitpoints-=1
                ' Bounce them a bit back
                i.zx += Cos(angle+Rnd(-20,20))*Rnd(5,13)
                i.zy += Sin(angle+Rnd(-20,20))*Rnd(5,13)
                i.flash = True
                ' If they are dead then flag them
                If i.hitpoints<=0 Then
                    i.deleteme = True
                End If
            End If
        Next
    End Method
    Method draw()
        SetColor 255,255,0
        DrawCircle bx,by,br
    End Method
End Class

Class turret
	Field id:Int
    ' turret x and y and radius
    Field tx:Int,ty:Int,tr:Int=16
    Field targetx:Int,targety:Int
    Field deleteme:Bool=False
    Field shootdelay:Int
    Field maxshootdelay:Int=10
    Field currentangle:Int,shootangle:Int
    Field notarget:Bool=True
    Field turnspeed:Int=3 'turn speed of the turret
    Field shakex:Int,shakey:Int
    Field shaketime:Int
    Field pathmap:Int[][] 	
    Method New(x:Int,y:Int)

    	'give the turret a unique id number
    	Repeat
    		Local nid:Int=Rnd(18972313)
    		Local change:Bool=True
    		For Local i:=Eachin myzombie
    			If nid = id Then change=False
    		Next
    		If change = True
    			Self.id = nid
    			Exit
    		End If
    	Forever

        tx = x*mymap.tw
        ty = y*mymap.th
        turnspeed = Rnd(1,10)
        '
        pathmap = New Int[mymap.mw][]
        For Local i:=0 Until mymap.mw
        	pathmap[i] = New Int[mymap.mh]
        Next
        '
        createpathmap()
    End Method
    Method update()
        shootdelay += 1
        ' shooting here
        ' check if there are zombies on the map
        If Not myzombie.IsEmpty             
            Local ntx:Int,nty:Int  ' New target x And y
            Local sdist:Int=1000 'shortest distance
            ' find zombie closest to turret
            For Local i:=Eachin myzombie
                Local d:Int=distance(tx,ty,i.zx,i.zy)
                If d<sdist Then
                    sdist = d
                    ntx = i.zx
                    nty = i.zy
                End If
            Next
            shootangle = getangle(tx,ty,ntx,nty)            
            targetx = ntx
            targety = nty
            notarget = False
            Else
            notarget = True
        End If

        'if we have a target
        If notarget = False Then
            'turn the turrent to target
            For Local i:=0 Until turnspeed
                If currentangle <> shootangle
                    currentangle += turndirection(shootangle)
                    If currentangle>180 Then currentangle = -180
                    If currentangle<-180 Then currentangle = 180
                End If
            Next
            ' if we are aimed and reloaded then shoot
            If shootdelay > maxshootdelay
                shootdelay = 0 
                If currentangle = shootangle
                    ' add a shake in the opposite direction
                    ' of the barrel.
                    shakex = -Cos(currentangle)*2
                    shakey = -Sin(currentangle)*2
                    shaketime = 4
                    mybullet.AddLast(New bullet(tx+Cos(shootangle)*16,ty+Sin(shootangle)*16,targetx,targety))
                End If
            End If
        End If
    End Method
    ' returns -1(left) or 1 right to turn towards the closest turn
    Method turndirection(destangle:Int)
        Local myangle:Int=currentangle
        Local d1:Int
        'turn left
        While myangle <> destangle
            myangle-=1
            If myangle<-180 Then myangle = 180
            d1+=1
        Wend
        myangle = currentangle
        Local d2:Int
        While myangle <> destangle
            myangle+=1
            If myangle>180 Then myangle = -180
            d2+=1
        Wend
        If d2>d1 Then Return -1 Else Return 1
    End Method
    ' Here we create a floodfill map for pathfinding
    Method createpathmap()
		Local sx:Int=tx/mymap.tw
		Local sy:Int=ty/mymap.th	
         'flood the map with distance from
         'sx and sy
         ' Create a list with a class inside it (the class has
         ' the x and y variables)
         Local ol:List<pathnode> = New List<pathnode>
         ' Add the start position on the list
         ol.AddLast(New pathnode(sx,sy))
         ' set the cloes map at the start position to distance 1
         pathmap[sx][sy] = 1
         ' some helper arrays. We can determine the top,right,and bottom
         ' and left position cells with these numbers.
         Local dx:Int[] = [0,1,0,-1]
         Local dy:Int[] = [-1,0,1,0]
         ' While there is contents in the list
         While ol.Count <> 0
             ' Get the current location
             Local x1:Int=ol.First.x
             Local y1:Int=ol.First.y
             ' Remove the current location from the list
             ol.RemoveFirst
             ' Get 4 new positions around the current positions
            For Local i:=0 Until 4
                ' Set new x and y
                Local nx:Int=x1+dx[i]
                Local ny:Int=y1+dy[i]
                ' If the coordinates are inside the map
                If nx>=0 And ny>=0 And nx<mymap.mw And ny<mymap.mh
                ' If the closedmap is not written to yet
                 If pathmap[nx][ny] = 0 And mymap.map[nx][ny] = 1
                     ' Set the new distance based on the current distance
                     pathmap[nx][ny] = pathmap[x1][y1] + 1
                     ' Add new position to the list
                     ol.AddLast(New pathnode(nx,ny))
                 End If
                 End If
            Next
         Wend    	
    End Method
    Method draw()
        Local tx:Int = tx+shakex
        Local ty:Int = ty+shakey
        shaketime-=1
        If shaketime < 0 Then shakex = 0 ; shakey = 0
        SetColor 0,255,255
        DrawCircle tx,ty,tr
        Local x2:Int,y2:Int
        x2 = Cos(currentangle)*20
        y2 = Sin(currentangle)*20
        DrawCircle tx+x2,ty+y2,10
        
        For Local y:=0 Until mymap.mh
        For Local x:=0 Until mymap.mw
        	If pathmap[x][y]>0 Then
        		SetColor 255,255,255
        		DrawText pathmap[x][y],x*mymap.tw,y*mymap.th
        	End If
        Next
        Next
        
    End Method
End Class

Class zombie
	Field id:Int
    ' zombie x and y and radius
    Field zx:Float,zy:Float,zr:Int=16
    Field tx:Int,ty:Int
    Field angle:Int
    Field movementspeed:Float=.5
    Field deleteme:Bool=False
    Field hitpoints:Int
    Field flash:Bool=False
    Field flashtime:Int
    Field pathmap:Int[][]
    Method New(x:Int,y:Int)
        zx = x*mymap.tw
        zy = y*mymap.th
        hitpoints = Rnd(1,4)
        If Rnd(100)<2 Then hitpoints*=5
        movementspeed = Rnd(0.1,0.3)
        ' This holds the path for the zombie (he 
        ' moves towards the smaller number
        pathmap = New Int[mymap.mw][]
        For Local i:=0 Until mymap.mw
        	pathmap[i] = New Int[mymap.mh]
        Next
    End Method
    Method update()
        If Not myturret.IsEmpty 
        	Local targetid:Int=-1
            Local ntx:Int,nty:Int
            Local cdist:Int=1000
            For Local i:=Eachin myturret
                Local d:Int=distance(zx,zy,i.tx,i.ty)
                If d<cdist
                    d = cdist
                    targetid = i.id
                    ntx = i.tx
                    nty = i.ty
                End If
            Next
            For Local i:=Eachin myturret
            	If targetid = i.id
            		For Local y:=0 Until mymap.mh
            		For Local x:=0 Until mymap.mw
            			pathmap[x][y] = i.pathmap[x][y]
            		Next
            		Next
            	End If
            Next
            
           tx = zx
           ty = zy
'          angle = getangle(zx,zy,ntx,nty)             
        End If
        
        'move the zombie
        If circleoverlap(zx,zy,4,tx,ty,4)
        	Local cn:Int=pathmap[zx/mymap.tw][zy/mymap.th]
        	Local nn:Int
        	For Local y2:=-1 To 1
        	For Local x2:=-1 To 1
        		If pathmap[zx/mymap.tw+x2][zy/mymap.th+y2] <> 0
        		If pathmap[zx/mymap.tw+x2][zy/mymap.th+y2] <= cn
        			cn = pathmap[zx/mymap.tw+x2][zy/mymap.th+y2]
        			nn = pathmap[zx/mymap.tw+x2][zy/mymap.th+y2]
        			tx = zx+(x2*mymap.tw)
        			ty = zy+(y2*mymap.th)
        		End If        		
        		End if
        	Next        	
        	Next
        	angle = getangle(zx,zy,tx,ty)
        End If
        zx += Cos(angle) * movementspeed
        zy += Sin(angle) * movementspeed
    End Method
    Method draw()
        If flash = False
            SetColor 255,0,0
            flashtime = 4
            Else
            SetColor 255,255,255
            flashtime -= 1
            If flashtime < 0 Then flash = False
        End If
        DrawCircle zx,zy,zr
    End Method
End Class

Class map
	Field map:Int[][]
	Field mw:Int,mh:Int,tw:Float,th:Float
	Method New(mw:Int,mh:Int)
		Self.mw = mw
		Self.mh = mh
		tw = Float(screenwidth) / Float(mw)
		th = Float(screenheight) / Float(mh)
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		newmap()
	End Method
    Method newmap()
        For Local y=0 Until mh
        For Local x=0 Until mw
            map[x][y] = 0
        Next
        Next
        drawrectinmap(Rnd(10,mw-10),Rnd(10,mh-10),5,3)
        For Local i=0 Until 50
            makeroom()
        Next
        makewalls()
    
    End Method
    Method makewalls()
        ' put walls on the map
        For Local y=1 Until mh-1
        For Local x=1 Until mw-1
            If map[x][y] = 0
                If map[x+1][y] = 1
                    map[x+1][y] = 2
                End If                
            End If
            If map[x][y] = 1
                If map[x+1][y] = 0
                    map[x][y] = 2
                End If
            End If
            If map[x][y] = 1
                If map[x][y+1] = 0
                    map[x][y] = 2
                End If
            End If
            If map[x][y] = 0
                If map[x][y+1] = 1
                    map[x][y+1] = 2
                End If
            End If
        Next
        Next
    End Method
    Method makeroom:Bool()
        'find suitable place to make room
        Local exitloop:Bool=False
        Local cnt:Int=0
        While exitloop = False
            cnt+=1
            If cnt>8000 Then exitloop=True
            Local x:Int=Rnd(5,mw-8)
            Local y:Int=Rnd(5,mh-8)
            Local roomw:Int=Rnd(4,8)
            Local roomh:Int=Rnd(4,8)
            Local pass1:Bool=True
            For Local y1=0 Until roomh
            For Local x1=0 Until roomh
                If map[x1+x][y1+y] = 1 Then pass1=False
            Next
            Next
            Local pass2:Bool=False
            If pass1=True Then
                For Local y1=3 To roomh-3
                    If map[x-1][y+y1] = 1 Then pass2=True
                    If map[x+roomw][y+y1] = 1 Then pass2=True
                Next
                 For Local x1=3 To roomw-3
                    If map[x+x1][y-1] = 1 Then pass2 = True
                    If map[x+x1][y+roomh] = 1 Then pass2 = True
                Next
            End If
            If pass2 = True Then
                drawrectinmap(x,y,roomw,roomh)
                Return
            End If
        Wend
    End Method
    Method issuitable:Bool(x:Int,y:Int,w:Int,h:Int)
        For Local y1=0 Until h
        For Local x1=0 Until w
            If map[x+x1][y+y1] = 1 Then Return False
        Next
        Next
        Return True
    End Method
    Method drawrectinmap(x:Int,y:Int,w:Int,h:Int)
        For Local y1=0 Until h
        For Local x1=0 Until w
            map[x+x1][y+y1] = 1
        Next
        Next
    End Method
	Method draw()
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 0 Then 
				SetColor 100,100,100
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
	End Method
End Class

Global mymap:map
Global myturret:List<turret>
Global myzombie:List<zombie>
Global mybullet:List<bullet>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        screenwidth = DeviceWidth
        screenheight = DeviceHeight
        mymap = New map(30,30)
        myturret = New List<turret>
        myzombie = New List<zombie>
        mybullet = New List<bullet>  
        placeturret()
        placezombie()

    End Method
    Method OnUpdate()        
        For Local i:=Eachin myzombie
        	i.update()
        Next

    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.draw()
        For Local i:=Eachin myturret
        	i.draw()
        Next
        For Local i:=Eachin myzombie
        	i.draw()
        Next
        SetColor 255,255,255
    End Method
End Class

Function placezombie()
	Repeat
		Local x:Int=Rnd(mymap.mw)
		Local y:Int=Rnd(mymap.mh)
		If mymap.map[x][y] = 1
	        myzombie.AddLast(New zombie(x,y))
	        Exit
		End If
	Forever
End Function

Function placeturret()
	Repeat
		Local x:Int=Rnd(mymap.mw)
		Local y:Int=Rnd(mymap.mh)
		If mymap.map[x][y] = 1
	        myturret.AddLast(New turret(x,y))
	        Exit
		End If
	Forever
End Function



Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Local dx = x2 - x1
    Local dy = y2 - y1
    Return ATan2(dy,dx)+360 Mod 360
End Function 

Function circleoverlap:Bool(x1:Int,y1:Int,r1:Int,x2:Int,y2:Int,r2:Int)
    Local dx:Int = x1-x2
    Local dy:Int = y1-y2
    Local r:Int = r1+r2
    If dx*dx+dy*dy <= r*r Then Return True Else Return False
End
Function Main()
    New MyGame()
End Function
