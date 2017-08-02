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
    Field bulletmaxdist:Int
    Field bullettraveled:Int
    Field deleteme:Bool=False
    ' start location and target location for getting angle
    Method New(x1:Int,y1:Int,x2:Int,y2:Int)
        bx = x1
        by = y1
        'set the bullet radius
        br = mymap.tw/4
        ' set the max bullet distance
        bulletmaxdist = mymap.tw*3
        angle = getangle(x1,y1,x2,y2)
    End Method
    Method update()
        ' update the bullet position
        bx += Cos(angle)*bulletspeed
        by += Sin(angle)*bulletspeed
        ' If the bullet hits a wall then delete the bullet
        If mymap.map[bx/mymap.tw][by/mymap.th] = 0 Then deleteme = True
        
        ' if distance to long then flag bullet for removal
        bullettraveled+=1
        If bullettraveled > bulletmaxdist Then deleteme = True
        ' check collision with zombies
        For Local i:=Eachin myzombie
            If circleoverlap(bx,by,br,i.zx,i.zy,i.zr)
                deleteme = True
                i.hitpoints-=1
                ' Bounce them a bit back
                'i.zx += Cos(angle+Rnd(-20,20))*Rnd(5,13)
                'i.zy += Sin(angle+Rnd(-20,20))*Rnd(5,13)
                i.flash = True
                ' If they are dead then flag them
                If i.hitpoints<=0 Then
                    i.deleteme = True
                    ' increase our counter
                    zombieskilled+=1
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
	'our target x and y
    Field targetx:Int,targety:Int
    ' if to be deleted on the next run
    Field deleteme:Bool=False
    ' delay counter between shots
    Field shootdelay:Int
    ' maximum shoot delay
    Field maxshootdelay:Int
    ' Our current angle and the angle where we want to shoot
    Field currentangle:Int,shootangle:Int
    ' if we have no target
    Field notarget:Bool=True
    ' how fast can we turn
    Field turnspeed:Int
    ' Shaking variables
    Field shakex:Int,shakey:Int
    Field shaketime:Int
    ' The path towards the turret
    Field pathmap:Int[][] 	
    Field maxrange:Int=10 'turrent tile range
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
        ' set the turret radius
        tr = mymap.tw/2
        ' a random turnspeed
        turnspeed = Rnd(1,10)
        ' How fast can we shoot
        maxshootdelay = Rnd(3,15)
        
        pathmap = New Int[mymap.mw][]
        For Local i:=0 Until mymap.mw
        	pathmap[i] = New Int[mymap.mh]
        Next

        ' create the path towards the turret
        createpathmap()
    End Method
    Method update()
        shootdelay += 1
        ' shooting here
        ' check if there are zombies on the map
        If Not myzombie.IsEmpty             
            Local ntx:Int=-1,nty:Int=-1  ' New target x And y
            Local sdist:Int=1000 'shortest distance
            ' find zombie closest to turret
            For Local i:=Eachin myzombie
                Local d:Int=distance(tx,ty,i.zx,i.zy)
                ' if within the turret range
                If d<mymap.tw*maxrange
                If d<sdist And clearshot(i.zx,i.zy) Then
                    sdist = d
                    ntx = i.zx
                    nty = i.zy
                End If
                End If
            Next
            If ntx<>-1
            shootangle = getangle(tx,ty,ntx,nty)+Rnd(-5,5)            
            targetx = ntx
            targety = nty
            notarget = False
            Else
            notarget = True
            End If
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
                    mybullet.AddLast(New bullet(tx+Cos(shootangle)*tr,ty+Sin(shootangle)*tr,targetx,targety))
                End If
            End If
        End If
    End Method
    ' Do we have a clear shot at the zombie
    ' no walls in the way...
    Method clearshot:Bool(x2:Int,y2:Int)
    	Local x1:Float=tx
    	Local y1:Float=ty
    	Local angle:Int = getangle(x1,y1,x2,y2)
    	For Local i:=0 Until 320
    		x1+=Cos(angle)*1
    		y1+=Sin(angle)*1
    		Local x3:Int=x1/mymap.tw
    		Local y3:Int=y1/mymap.th
    		' if outside map then skip
    		If x3<0 Or y3<0 Or x3>=mymap.mw Or y3>=mymap.mh Then Continue
    		' if we touch a wall then return false
    		If mymap.map[x3][y3] = 0 Then Return False
    		' if we touch the zombie then return true
    		If circleoverlap(x1,y1,4,x2,y2,4) Then Return True
    		'??
    		If i>200 Then Return True
    	Next
    	Return False
    End Method
    ' returns -1(left) or 1 right to turn towards the closest turn
    Method turndirection(destangle:Int)
    	If destangle<-180 Then destangle=-180
    	If destangle>180 Then destangle=180
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
 		'draw the turret
        SetColor 0,255,255
        DrawCircle tx,ty,tr
        'draw the barrel
        Local x2:Int,y2:Int
        x2 = Cos(currentangle)*tr
        y2 = Sin(currentangle)*tr
        DrawCircle tx+x2,ty+y2,tr/2
        
    End Method
End Class

Class zombie
	Field id:Int
	Field hastarget:Bool=False 'is he heading towards a target
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
        'set the zombie radius
        zr = mymap.tw/3

        hitpoints = Rnd(1,4)
        If Rnd(100)<2 Then hitpoints*=5
        movementspeed = Rnd(0.15,0.35)
        ' This holds the path for the zombie (he 
        ' moves towards the smaller number
        pathmap = New Int[mymap.mw][]
        For Local i:=0 Until mymap.mw
        	pathmap[i] = New Int[mymap.mh]
        Next
    End Method
    Method update()
    	' if there is a turret on the map or more
        If Not myturret.IsEmpty And hastarget=False
        	Local targetid:Int=-1
            Local ntx:Int,nty:Int
            Local cdist:Int=1000
            ' find the closest
            For Local i:=Eachin myturret
                Local d:Int=distance(zx,zy,i.tx,i.ty)
                If d<cdist
                    cdist = d
                    targetid = i.id
                    hastarget = True
                    ntx = i.tx
                    nty = i.ty
                End If
            Next
            ' copy the pathmap from this turrent to 
            ' the pathmap of the zombie
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
        
        'move the zombie to new grid if he arived 
        'at the current grid
        If circleoverlap(zx,zy,2,tx,ty,2)
        	Local cn:Int=pathmap[zx/mymap.tw][zy/mymap.th]
        	' above/right/bottom/left (4 directions)
        	Local mx:Int[] = [0,1,0,-1]
        	Local my:Int[] = [-1,0,1,0]     	        	
			' store the floodvalues around the zombie
        	Local myx:Stack<Int> = New Stack<Int>
        	Local myy:Stack<Int> = New Stack<Int>
        	Local myv:Stack<Int> = New Stack<Int>        	        	
        	' read around the zombie for direction (pathmapflood)
        	For Local i:=0 Until 4
        		Local x3:Int=(zx/mymap.tw)+mx[i]
        		Local y3:Int=(zy/mymap.th)+my[i]
				If x3<0 Or y3<0 Or x3>=mymap.mw Or y3>=mymap.mh Then Continue
       			Local d:Int=pathmap[x3][y3]        		
       			If d>0 Then 
       				myx.Push(zx+(mx[i]*mymap.tw))
        			myy.Push(zy+(my[i]*mymap.th))
        			myv.Push(d)
       			End If
        	Next
			'choose lowest new direction
			Local lowest:Int=1414
			For Local i:=0 Until myx.Length()
				If myv.Get(i)<lowest Then
					lowest = myv.Get(i)
					tx = myx.Get(i)
					ty = myy.Get(i)
				End If
			Next
			' set the angle we are going to head in
        	angle = getangle(zx,zy,tx,ty)
        End If
        zx += Cos(angle) * movementspeed
        zy += Sin(angle) * movementspeed
        
        'if the zombie collides with a turrent then
        ' flag turret for deletion
        For Local i:=Eachin myturret
        	If circleoverlap(zx,zy,zr,i.tx,i.ty,i.tr)
        		i.deleteme = True
        		' move the turret far away so the zombies can pick
        		' the next nearest target
 				i.tx = -1000
 				i.ty = -1000
 				For Local ii:=Eachin myzombie
 					ii.hastarget = False
 				Next
        	End If
        Next
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

Global zombieskilled:Int=0
Global mymap:map
Global myturret:List<turret>
Global myzombie:List<zombie>
Global mybullet:List<bullet>

Class MyGame Extends App
	Field difficulty:Int=2
    Method OnCreate()
        SetUpdateRate(60) 'speed of the refresh
        Seed = GetDate[4]+GetDate[5] ' random values based on the date
        screenwidth = DeviceWidth
        screenheight = DeviceHeight
		newmap() 'create a new map
    End Method
    Method OnUpdate()
    	' update the zombie and bullet and turrets        
        For Local i:=Eachin myzombie
        	i.update()
        Next
        For Local i:=Eachin mybullet
        	i.update()
        Next

        For Local i:=Eachin myturret
        	i.update()
        Next
        ' delete from the lists those that were destroyed
        For Local i:=Eachin myzombie
        	If i.deleteme = True Then myzombie.Remove(i)
        Next
        For Local i:=Eachin mybullet
        	If i.deleteme = True Then mybullet.Remove(i)
        Next
        For Local i:=Eachin myturret
        	If i.deleteme = True Then myturret.Remove(i)
        Next
		' if pressed mouse or space then reset difficulty
		' and create new map
		If MouseHit(MOUSE_LEFT) Or KeyHit(KEY_SPACE) Then 
			difficulty = 2 
			newmap
		End If
		' spawn new zombie
		If Rnd(200)<difficulty Then placezombie()
		' Increase difficulty
		If Rnd(500)<2 Then difficulty+=1
		' if there are no more turrets then start new map
		If myturret.IsEmpty Then difficulty = 2 ; newmap()

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
        For Local i:=Eachin mybullet
        	i.draw()
        Next

        SetColor 255,255,255
        DrawText "Zombies and Turrets on random maps - Press Space or Mouse to create new map",0,0
        DrawText "Zombies Killed : "+zombieskilled,0,20
    End Method
End Class

Function newmap()
	' reset our variable that holds track 
	' of the zombies killed
	zombieskilled = 0
	' create a variable with a value to create map with
	Local s:Int=Rnd(30,60)
	mymap = New map(s,s)
	' (re)create the turret zombie and bullet classes
	myturret = New List<turret>
	myzombie = New List<zombie>
	mybullet = New List<bullet>  
	' add a number of turrets
	Local numturrets:Int=Rnd(3,s/5)
	For Local i:=0 Until numturrets
		placeturret()
	Next

End Function
' Here we place a new zombie on the map
Function placezombie()
	Repeat
		' create a x and y value
		Local x:Int=Rnd(mymap.mw)
		Local y:Int=Rnd(mymap.mh)
		' if on the map under these new
		' coordinates there is no wall
		If mymap.map[x][y] = 1
			' be sure it is not placed to near
			' a turret.
			Local notnearturret:Bool=True
			For Local i:=Eachin myturret
				If distance(i.tx,i.ty,x*mymap.tw,y*mymap.th) < mymap.tw*6 Then notnearturret=False
			Next
			If notnearturret = True
	        	myzombie.AddLast(New zombie(x,y))
	        	Exit
	        End If
		End If
	Forever
End Function

''
' Place a turret on the map
Function placeturret()
	Repeat
		
		Local x:Int=Rnd(mymap.mw)
		Local y:Int=Rnd(mymap.mh)
		' if not on a wall then make him
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
