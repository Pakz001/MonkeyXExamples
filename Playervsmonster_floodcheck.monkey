Import mojo

Class bullet
	Field x:Float,y:Float
	Field w:Int,h:Int
	Field mx:Float
	Field my:Float
	Field speed:Int 'how many updates per call
	Field hpdamage:Int=3
	Field deleteme:Bool=False 'when remove from game
	Method New(x:Int,y:Int,direction:String)
		speed = 2  'set movement speed
		w = myplayer.w / 4
		h = myplayer.h / 4
		If w<2 Then w = 2
		If h<2 Then h = 2
		Self.x = x
		Self.y = y 
		Select direction 
			Case "left"
			mx=-1
			my+=Rnd(-.04,.04)
			Case "right"
			mx=1
			my+=Rnd(-.04,.04)
			Case "up"
			my=-1
			mx+=Rnd(-.04,.04)
			Case "down"
			my=1
			mx+=Rnd(-.04,.04)
		End Select
	End Method
	Method update()
		For Local i:Int=0 Until speed
			x+=mx
			y+=my
			If mymap.mapcollide(x,y,w,h) Then deleteme = True
			For Local ii:=Eachin myenemy
				If ii.donotupdate = False
					If distance(x,y,ii.x,ii.y)<8 Then 
						deleteme = True
						ii.hp -= hpdamage
						If ii.hp<0 Then ii.hp=0
					End If
				End If
			Next	
		Next
	End Method
	Method draw()
		SetColor 255,255,0
		DrawOval x,y,w,h
	End Method
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Return Abs(x2-x1)+Abs(y2-y1)
	End Function	
End Class

Class hud
	Field screenwidth:Int,screenheight:Int
	Field weapons:String[]=["Spear","gun"]
	Method New(screenwidth:Int,screenheight:Int)
		Self.screenwidth = screenwidth
		Self.screenheight = screenheight
	End Method
	Method update()
		If KeyHit(KEY_1)
			myplayer.weapon = 1
		End If
		If KeyHit(KEY_2)
			myplayer.weapon = 2
		End If
	End Method
	Method draw()
		Local x:Int=50
		For Local i:Int=0 Until weapons.Length
			If myplayer.weapon = i+1
				SetColor 50,50,50
				DrawRect x,screenheight-42,TextWidth(weapons[i])+48,20		
			End If
			SetColor 255,255,255
			DrawText i+1+" - "+weapons[i],x,screenheight-40
			'SetColor 0,0,0
			x+=TextWidth(weapons[i])+48
		Next
	End Method
End Class

Class map
    Field tilewidth:Float
    Field tileheight:Float
    Field mapwidth:Int
    Field mapheight:Int
    Field screenwidth:Int
    Field screenheight:Int
    Field map:Int[][]
    Method New(    screenwidth:Int,
                screenheight:Int,
                mapwidth:Int,
                mapheight:Int)
        Self.screenwidth = screenwidth
        Self.screenheight = screenheight
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        Self.tilewidth = Float(screenwidth)/Float(mapwidth)
        Self.tileheight = Float(screenheight)/Float(mapheight)
        map = New Int[mapwidth][]
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        map[mapwidth/2][mapheight/2] = 3 ' 3 is a door
        makemap
    End Method
    Method makemap()
        Local timeout:Int
        While timeout<(mapwidth*mapheight)*20
            timeout+=1
            Local x:Int=Rnd(11,mapwidth-11)
            Local y:Int=Rnd(11,mapheight-11)
            If map[x][y] = 3
                makeroom(x,y)
            End If
        Wend    
        'here we turn doors into walls
        'if they should be walls
        For Local y1=1 Until mapheight-1
        For Local x1=1 Until mapwidth-1
            If map[x1][y1] = 3
            Local cnt:Int=0
            For Local y2=y1-1 To y1+1
            For Local x2=x1-1 To x1+1
                If map[x2][y2] = 2 Then cnt+=1
            Next
            Next
            If cnt>3 Then map[x1][y1] = 2
            End If
        Next
        Next
        'here we turn doors into walls if they
        ' touch tiles that are nothing (0)
        For Local y1=1 Until mapheight-1
        For Local x1=1 Until mapwidth-1
            If map[x1][y1] = 3
            Local cnt:Int=0
            For Local y2=y1-1 To y1+1
            For Local x2=x1-1 To x1+1
                If map[x2][y2] = 0 Then cnt+=1
            Next
            Next
            If cnt>0 Then map[x1][y1] = 2
            End If
        Next
        Next        
        'here we turn the doors into floors
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            If map[x1][y1] = 3 Then map[x1][y1] = 1
        Next
        Next
    End Method
    Method makeroom(x:Int,y:Int)
        Local side:String
        If map[x][y-1] = 0
            side="up"
        Elseif map[x+1][y] = 0
            side="right"
        Elseif map[x][y+1] = 0
            side="down"
        Elseif map[x-1][y] = 0
            side="left"
        End If        
        Local w:Int=Rnd(5,10)
        Local h:Int=Rnd(5,10)
        If side="up"
            Local x1:Int=x-w/2
            Local y1:Int=y-h
            If roomfits(x1,y1,w,h)
                insertroom(x1,y1,w,h+1)
                'door up
                map[x1+Rnd(2,w-2)][y1] = 3
                ' door right
                map[x1+w-1][y1+Rnd(2,h-2)] = 3
                'door left
                map[x1][y1+Rnd(2,h-2)] = 3
            End If                        
            
        End If
        If side="right"
            Local x1:Int=x+1
            Local y1:Int=y-h/2
            If roomfits(x1,y1,w,h)
                insertroom(x1-1,y1,w,h)
                'door up
                map[x1+Rnd(2,w-2)][y1] = 3
                'door down
                map[x1+Rnd(2,w-2)][y1+h-1] = 3
                ' door right
                map[x1+w-2][y1+Rnd(2,h-2)] = 3                
            End If
        End If
        If side="left"
            Local x1:Int=x-w
            Local y1:Int=y-h/2
            If roomfits(x1,y1,w,h)
                insertroom(x1,y1,w+1,h)
                'door up
                map[x1+Rnd(2,w-2)][y1] = 3
                'door down
                map[x1+Rnd(2,w-2)][y1+h-1] = 3                
                'door left
                map[x1][y1+Rnd(2,h-2)] = 3

            End If            
        End If
        If side="down"
            Local x1:Int=x-w/2
            Local y1:Int=y+1
            If roomfits(x1,y1,w,h)
                insertroom(x1,y1-1,w,h)
                'door down
                map[x1+Rnd(2,w-2)][y1+h-2] = 3                
                'door left
                map[x1][y1+Rnd(2,h-2)] = 3                
                ' door right
                map[x1+w-1][y1+Rnd(2,h-2)] = 3                

            End If                        
        End If
    End Method
    Method insertroom(x,y,w,h)
        For Local y2=y Until y+h
        For Local x2=x Until x+w
            If map[x2][y2] <> 3 Then map[x2][y2] = 2
        Next
        Next

        For Local y2=y+1 Until y+h-1
        For Local x2=x+1 Until x+w-1
            map[x2][y2] = 1
        Next
        Next
    End Method
    Method roomfits(x:Int,y:Int,w:Int,h:Int)
        For Local y1=y Until y+h
        For Local x1=x Until x+w
            If map[x1][y1] = 1 Then Return False
        Next
        Next
        Return True
    End Method
    'simple map collide (4 corners)
	Method mapcollide:Bool(x:Int,y:Int,w:Int,h:Int)
		Local lefttopx:Int		=((x)/tilewidth)
		Local lefttopy:Int		=((y)/tileheight)
		Local righttopx:Int		=((x+w)/tilewidth)
		Local righttopy:Int		=((y)/tileheight)
		Local leftbottomx:Int	=((x)/tilewidth)
		Local leftbottomy:Int	=((y+h)/tileheight)
		Local rightbottomx:Int	=((x+w)/tilewidth)												
		Local rightbottomy:Int	=((y+h)/tileheight)
		If map[lefttopx][lefttopy] <> 1 Then Return True
		If map[righttopx][righttopy] <> 1 Then Return True
		If map[leftbottomx][leftbottomy] <> 1 Then Return True
		If map[rightbottomx][rightbottomy] <> 1 Then Return True						
		Return False
	End Method
    Method draw()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Select map[x][y]
                Case 0
                Case 1'floor
                SetColor 100,100,100
                DrawRect     x*tilewidth,
                            y*tileheight,
                            tilewidth+1,
                            tileheight+1
                Case 2'wall
                SetColor 200,200,200
                DrawRect     x*tilewidth,
                            y*tileheight,
                            tilewidth+1,
                            tileheight+1
                Case 3'wall
                SetColor 244,244,0
                DrawRect     x*tilewidth,
                            y*tileheight,
                            tilewidth+1,
                            tileheight+1

            End Select
        Next
        Next
    End Method
End Class

Class enemy
	Field x:Float,y:Float
	Field ms:Float 'movement speed
	Field w:Int=mymap.tilewidth-8
	Field h:Int=mymap.tileheight-8
	Field hp:Int
	Field hpceil:Int
	Field direction:String="up" ' left/right/up/down
	'Field current:Bool=False 'if being updated
	Field deleteme:Bool=False
	Field state:String="roam"
	Field donotupdate:Bool=False 'if to far away
	Field roamdestx:Int,roamdesty:Int
	Field roamcountdown:Int=Rnd(200)
	Method New()
		' find a spot to place the new enemy
		Local exitloop:Bool=False
		Local cnt:Float=0
		While exitloop=False
			exitloop = True
			Local nx:Int,ny:Int
			nx = Rnd(50,640-50)
			ny = Rnd(50,480-50)	
			If mymap.mapcollide(nx,ny,w,h) = True Then exitloop=False 
			If distance(myplayer.x,myplayer.y,nx,ny) < (250-cnt)
				exitloop = False	
			End If
			For Local i:=Eachin myenemy				
				If distance(nx,ny,i.x,i.y) < w*2 
					exitloop = False
					Exit
				End If
			Next
			If exitloop = True Then
				x = nx
				y = ny
			End If
			cnt+=.5
		Wend
		' Here we set the movement speed
		ms = Rnd(.1,.5)
		' Here we set the hitpoints
		hp = Rnd(1,50)
		' the ceiling is what he has or had at start (powerbar)
		hpceil = hp
		setstate("roam")
	End Method
	Method update()
		' If the distance between the player and the ai
		' is to large then do not update the ai
		If Rnd(60)<2 Then
			If distance(x,y,myplayer.x,myplayer.y) > 420 Then 
				donotupdate = True
			Else
				donotupdate = False
			End If
		End If
		If donotupdate = True Then Return
		'
		' If hp below 0 then remove
		If hp<=0 Then deleteme = true
		
		
		' ai States
		Select state
			Case "roam"
				roam()
				If Rnd(30)<2 And playerinrange() Then state="approach"
			Case "approach"
				approach()
				If Rnd(60)<2 And Not playerinrange() Then setstate("roam")
		End Select
	End Method
	Method setstate(newstate:String)
		Select newstate
			Case "roam"
				roamdestx = x
				roamdesty = y
				state = "roam"
		End Select
	End Method
	' This method lets the ai walk around the nearby area
	Method roam()
		If roamcountdown>0 Then roamcountdown-=1
		If roamcountdown > 0 Then Return
		Local x2:Int=roamdestx
		Local y2:Int=roamdesty
		Local oldx:Int=x
		Local oldy:Int=y
		If x<x2 Then x+=ms
		If x>x2 Then x-=ms
		If y<y2 Then y+=ms
		If y>y2 Then y-=ms
		If mymap.mapcollide(x,y,w,h) Then
			x = oldx
			y = oldy
			roamdestx = x
			roamdesty = y
		
		End If
		untangle
		' if enemy touches enemy then stop
		For Local i:=Eachin myenemy
			If i<>Self And i.donotupdate = False
				If distance(x,y,i.x,i.y) < w*2 Then
					untangle 
					roamdestx = x
					roamdesty = y
					roamcountdown = Rnd(50,100)
					Return
				End If
			End If
		Next
		' if nearby destination then find new location to roam towards
		If distance(x,y,roamdestx,roamdesty) < w*2 Then 
			roamdestx = x
			roamdesty = y
			If Rnd(10)>2 Then roamcountdown = Rnd(100) ; Return
			Local exitloop:Bool=False
			Local failcount:Int=0
			While exitloop = False
				failcount+=1
				If failcount>200 Then return
				Local angle:Int=Rnd(0,360)
				Local dist:Int=Rnd(w*3,w*8)
				Local nx:Float=x,ny:Float=y
				Local go:Bool=True
				For Local i:Int=0 Until dist
					nx+=Cos(angle)*1
					ny+=Sin(angle)*1
					If mymap.mapcollide(nx,ny,w,h) = True
						go=False						
						Exit
					End If
					For Local ii:=Eachin myenemy
						If ii<>Self And ii.donotupdate = False
							If distance(nx,ny,ii.x,ii.y) < w*2 Then 
								go=False
								Exit
							End If
						End If
					Next
				Next
				' if we can move into this direction
				If go=True
					roamdestx = nx
					roamdesty = ny
					exitloop = True
				End If
			Wend
		End If
	End Method
	' Here we check if the player is nearby and then return true
	Method playerinrange()
		' Floodfill
	  	Local mx:Int[] = [0,1,0,-1] 'expand up/right/down/left
	    Local my:Int[] = [-1,0,1,0]
	    'open list
		Local olx:Stack<Int> = New Stack<Int>
		Local oly:Stack<Int> = New Stack<Int>
		'closed list
		Local clx:Stack<Int> = New Stack<Int>
		Local cly:Stack<Int> = New Stack<Int>
		olx.Push(x/mymap.tilewidth)		
		oly.Push(y/mymap.tileheight)
		Local pcx:Int=myplayer.x/mymap.tilewidth
		Local pcy:Int=myplayer.y/mymap.tileheight
		While olx.Length >= 1
			Local cx:Int = olx.Top
			Local cy:Int = oly.Top
			olx.Pop
			oly.Pop
			clx.Push(cx)
			cly.Push(cy)
            For Local i=0 Until 4
            	Local x2:Int=cx+mx[i]
            	Local y2:Int=cy+my[i]
            	If x2>=0 And x2<mymap.mapwidth And y2>=0 And y2<mymap.mapheight
            		If mymap.map[x2][y2] = 1
	            		If clx.Length>0
		            		For Local ii:Int=0 Until clx.Length
	        					If clx.Get(ii) = x2 And cly.Get(ii) = y2 Then Exit
	    	        		Next
	            		End If
	            		olx.Insert(0,x2)
	            		oly.Insert(0,y2)
	            		If pcx = x2 And pcy = y2 Then 
							Return True
	            		End If
            		End If
            	End If
            Next
            'If to far away then exit the loop
            If clx.Length>15*15 Then Exit			
		Wend
		Return False
	End Method
	' This moves the zombie towards the player
	Method approach()
		' store the old location
		Local oldx:Float=x
		Local oldy:Float=y
		' move the enemy towards the player
		If collide(x+1,y) = False And x < myplayer.x Then 
			x+=ms
			direction = "right"
		End If
		If collide(x-1,y) = False And x > myplayer.x Then 
			x-=ms
			direction = "left"
		End If
		If collide(x,y+1) = False And y < myplayer.y Then 
			y+=ms
			direction = "down"
		End If
		If collide(x,y-1) = False And y > myplayer.y Then 
			y-=ms
			direction = "up"
		End If
		untangle()

	End Method

	' if the enemies are inside of each other
	' then move them apart
	Method untangle()
		For Local i:=Eachin myenemy
			If i<>Self And i.donotupdate=false
				If distance(i.x,i.y,x,y) < w
					Local a:Int
					a = getangle(i.x,i.y,x,y)
					Local nx:Float=x
					Local ny:Float=y
					nx += Cos(a)*1
					ny += Sin(a)*1
					If mymap.mapcollide(nx,ny,w,h) = False
						x=nx
						y=ny
					End If
'					Local mx:Int=nx/mymap.tilewidth
'					Local my:Int=ny/mymap.tileheight
'					If mymap.map[mx][my] = 1
'						x = nx
'						y = ny
'					End If
				End If
			End If
		Next
	End Method
	Method draw()
		SetColor 255,255,0
		DrawOval x,y,w,h
		'powerbar
		Local current:Float=(Float(w)/Float(hpceil))*hp
		
		SetColor 0,0,0
		DrawRect x,y+h,w,5
		SetColor 255,0,0
		DrawRect x,y+h,current,3
	End Method
	Method collide:Bool(xx:Int,yy:Int)
		For Local i:=Eachin myenemy
			If i<>Self
				If distance(xx,yy,i.x,i.y) < w Then Return True
			End If
		Next
		Return mymap.mapcollide(xx,yy,w+1,h+1)
	End Method
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Return Abs(x2-x1)+Abs(y2-y1)
	End Function	
	Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Local dx = x2 - x1
    	Local dy = y2 - y1
    	Return ATan2(dy,dx)+360 Mod 360
	End Function		
End Class


Class player
	Field x:Float,y:Float
	Field w:Int=mymap.tilewidth-8
	Field h:Int=mymap.tileheight-8
	Field wx:Int,wy:Int
	Field direction:String="up" ' up/left/down/right
	Field weapondamage:Int=3
	Field swing:Bool=False
	Field swingcountdown:Int=0
	Field weapon:Int=1
	Field shootcountdown:Int
	Method New()
		Local exitloop:Bool=False
		While exitloop = False
			x = Rnd(640)
			y = Rnd(480)
			If mymap.mapcollide(x,y,w,h) = False Then exitloop = True
		Wend
		direction = "up"
	End Method
	Method update()
		updatecontrols()
		weaponenemies()
	End Method
	Method weaponenemies()
		If weapon=2 Then
			If shootcountdown>0 Then shootcountdown-=1
			If KeyDown(KEY_SPACE)
				If shootcountdown < 1 Then
					shootcountdown = 10
					mybullet.AddLast(New bullet(x,y,direction))
				End If
			End If
		End If
		If weapon=1 Then
			If swing = False Then Return
			For Local i:=Eachin myenemy
				If distance(i.x,i.y,wx,wy) < w+5
					'make sure the weapon does not fly through
					' walls
					Local mx:Int=wx/mymap.tilewidth
					Local my:Int=wy/mymap.tileheight
					If mymap.map[mx][my] <> 1 Then Exit
					'distance with the enemy
					Local a:Int=getangle(wx,wy ,i.x,i.y)
					For Local ww:Int=0 Until w
						Local nx:Float=i.x
						Local ny:Float=i.y					
						nx += Cos(a) * 1
						ny += Sin(a) * 1
						If mymap.mapcollide(nx,ny,w,h) = False
							i.x = nx
							i.y = ny
						Else
							Exit
						End If
					Next
					i.hp -= weapondamage
					If i.hp<1 Then i.deleteme = True
				End If			
			Next
		End If
	End Method
	Method updatecontrols()
	    ' store the location of the player
		Local oldx:Int=x
		Local oldy:Int=y
		'handle the movement
		If collide(x+1,y)=False And KeyDown(KEY_RIGHT) Then 
			x+=1
			direction = "right"
			swing=False
		End If
		If collide(x-1,y)=False And KeyDown(KEY_LEFT) Then 
			x-=1
			direction = "left"
			swing=False
		End If
		If collide(x,y-1)=False And KeyDown(KEY_UP) Then 
			y-=1
			direction = "up"
			swing=False
		End If
		If collide(x,y+1)=False And KeyDown(KEY_DOWN) Then 
			y+=1
			direction = "down"
			swing=False
		End If
		'Handle the weapon
		If weapon = 1
			If swing = False
				If KeyDown(KEY_SPACE) Then 
					swing=True
					If direction = "left" Then wx=x-w ; wy=y
					If direction = "right" Then wx=x+w ; wy=y
					If direction = "up" Then wx=x ; wy=y-h
					If direction = "down" Then wx=x ; wy=y+h				
					swingcountdown = 20
				End If
			Else
				swingcountdown-=1
				If swingcountdown<0 Then swing=False
			End If
		End if
	End Method
	' collide with map
	Method collide:Bool(xx:Int,yy:Int)
		Return mymap.mapcollide(xx,yy,w,h)
	End Method
	Method draw()
		SetColor 255,255,255
		DrawOval x,y,w,h
		If swing = True
			'where does the swing graphic get drawn
			DrawOval wx,wy,w,h
		End If
	End Method
	Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Local dx = x2 - x1
    	Local dy = y2 - y1
    	Return ATan2(dy,dx)+360 Mod 360
	End Function		
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    	Return Abs(x2-x1)+Abs(y2-y1)
	End Function	

End Class


Global myplayer:player
Global myenemy:List<enemy> = New List<enemy>
Global mymap:map
Global myhud:hud
Global mybullet:List<bullet> = New List<bullet>

Class MyGame Extends App

    Method OnCreate()
    	Seed = GetDate[5] + GetDate[4]
        SetUpdateRate(60)
    	mymap = New map(640,480,30,30)
        myplayer = New player()        
        For Local i:=0 Until 10
        	myenemy.AddLast(New enemy())
        Next
		myhud = New hud(DeviceWidth,DeviceHeight)
    End Method
    Method OnUpdate()       	
    	myplayer.update() 
    	' update the enemies
    	For Local i:=Eachin myenemy
    		i.update()
    	Next
    	' if enemy hitpoint below 1 then remove him from list
    	For Local i:=Eachin myenemy
    		If i.deleteme = True Then myenemy.Remove(i)
    	Next
	
		' if the map is empty of all zombies
		' or keyhit f1 then new map
		If myenemy.IsEmpty Or KeyHit(KEY_F1)
			Local ms:Int=Rnd(30,40)
	    	mymap = New map(640,480,ms,ms)
			myenemy = New List<enemy>	    	
	        myplayer = New player() 
			mybullet = New List<bullet>	        		
			Local ecnt:Int=Rnd(2,ms/2)
	        For Local i:=0 Until ecnt
    	    	myenemy.AddLast(New enemy())
        	Next
		End If

		'update the hud
		myhud.update()

		'update the bullets
		For Local i:=Eachin mybullet
			i.update()
		Next
		'remove dead bullets
		For Local i:=Eachin mybullet
			If i.deleteme Then mybullet.Remove(i)
		Next
	
    End Method
    Method OnRender()
        Cls 0,0,0
            
        mymap.draw()    
                
        For Local i:=Eachin myenemy
        	i.draw()
        Next
        myplayer.draw()
        ' draw the bullets
        For Local i:=Eachin mybullet
        	i.draw()
        Next
        
        'draw the hud
		myhud.draw()

        SetColor 255,255,255
        DrawText "Player vs Monsters on Random map",0,0
        DrawText "Space = Weapon , Cursor l/r/u/d = movement",0,20        
    End Method
End Class


Function Main()
    New MyGame()
End Function
