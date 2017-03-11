' version 7-12-2015.
' Template.
' Scrolling platformer with RPG features.
' Based on the scrolling platformer with vines
' template on my Monkey-X blog.
'
' The mapwidth variables can be set to large(200+) or 
' small(100*100) maps. There will be multiple mines
' placed and populated if there is enough space for them
' on the map. (This version runs fast enough on low
' end laptops with maps up to 320*240 - there currently
' is no LOD implemented.)
'
' Game :
' Travel down/explore the mine.
' Has mining eggs feature. Hunting for meat.
' Monsters lay eggs. Only one monster hatches from a egg
' if there are no other monsters nearby.
' Monsters/breeders do not attack.
' You can pick up the eggs. Kill the monsters for meat.
' You can place an egg on the ground and a monster could be
' hatched.
' Eggs can also spawn Deathwings and they attack/hurt you.
' You have health and if zero restarts the game.
' p - Place egg on the ground.
' t - Pick up egg from the ground.
' Space - Attack with spear.
' curs left/right/up - move and jump.
' 
' Thinking of adding automated machine gun nests that you 
' can place/move around and they kill the flying monsters.
'
' Mood of the game at the moment is : 
' Monsters live in an old abandoned mining area. You can 
' mine meat/eggs to make a profit. Monsters
' have been seen flying nearby mines attacking people.
'
'
Import mojo

Global gamestate:String="select"
Global mapwidth:Int=100
Global mapheight:Int=100
Const tilewidth:Int=32
Const tileheight:Int=32
Global mapx:Int=0
Global mapy:Int=0
Global mapsx:Int=0
Global mapsy:Int=0
Global maxdeathwings:Int=10

Class menuselect
	Field go:Bool=False
	Field m:maptest
	Field index:Int = 0
	Method New()

	End Method
	Method update()
		If KeyHit(KEY_LEFT) Then index -= 1
		If KeyHit(KEY_RIGHT) Then index += 1
		If KeyHit(KEY_ENTER) Then go=True
		If index < 0 Then index = 0
		If index > 2 Then index = 2
		Select index
			Case 0
			mapwidth = 100
			mapheight = 100
			maxdeathwings = 10
			Case 1
			mapwidth = 150
			mapheight = 150
			maxdeathwings = 20
			Case 2
			mapwidth = 200
			mapheight = 200
			maxdeathwings = 40
		End Select
	End Method
	Method draw()
		Local w:Int,h:Int
		Local x:Int,y:Int
		SetColor 255,255,255
		DrawText "Cursor keys to select - Enter = start",0,0	
		PushMatrix()	
		Scale 3,3
		DrawText "Select Difficulty",320/3,280/3,.5,.5
		Local mystring:String
		Select index
			Case 0
				mystring="Easy"
			Case 1
				mystring="Normal"
			Case 2
				mystring="Difficult" 
		End Select
		DrawText mystring,320/3,320/3,.5,.5		
		PopMatrix()

		Seed = 1
		x = 0+50
		y = 50
		w = 100
		h = 100
		m = New maptest(w,h,640,480)		
		drawmap(x,y,1,1)
		If index = 0
			SetColor 255,255,255
			mydrawrect x,y,w,h			
			mydrawrect x+1,y+1,w-2,h-2
		End If
		Seed = 1
		x = 150+50
		y = 50
		w = 150
		h = 150
		m = New maptest(w,h,640,480)		
		drawmap(x,y,1,1)
		If index = 1
			SetColor 255,255,255
			mydrawrect x,y,w,h			
			mydrawrect x+1,y+1,w-2,h-2
		End If		
		Seed = 1
		x = 320+50
		y = 50
		w = 200
		h = 200
		m = New maptest(w,h,640,480)		
		If index = 2
			SetColor 255,255,255
			mydrawrect x,y,w,h			
			mydrawrect x+1,y+1,w-2,h-2
		End If		
		drawmap(x,y,1,1)

		
	End Method
    Method drawmap(x1:Int,y1:Int,tw:Int,th:Int)
        For Local y=0 Until m.h
        For Local x=0 Until m.w
            If m.map[x][y] = 1
                SetColor 255,255,255
                DrawRect (x*tw)+x1,(y*th)+y1,tw,th
            End If
            If m.map[x][y] = 3
                SetColor 200,200,10
                DrawOval (x*tw)+x1,(y*th)+y1,tw,th
            End If            
        Next
        Next
    End Method	
    Method mydrawrect(x:Int,y:Int,w:Int,h:Int)
    	SetColor 255,255,255
    	DrawLine x,y,x+w,y
    	DrawLine x,y,x,y+h
    	DrawLine x,y+h,x+w,y+h
    	DrawLine x+w,y,x+w,y+h
    End Method
End Class

Class maptest
	Field sw:Int,sh:Int
    Field tw:Int,th:Int
    Field w:Int,h:Int
    Field map:Int[][]
    Method New(w:Int,h:Int,sw:Int,sh:Int)
    	Self.sw = sw
    	Self.sh = sh
        Self.w = w
        Self.h = h
        tw = sw/w
        th = sh/h
        map = New Int[w][]
        For Local i=0 Until w
            map[i] = New Int[h]
        Next
        drawmaprect(0,0,w-1,15)
        For Local i=0 Until h
            map[1][i] = 0
            map[w-2][i] = 0
        Next
        Local x:Int=32
        While x<w-48
            makemine(x,15,Rnd(4,h/15))
            x+=Rnd(48,64)
        Wend
    End Method
    Method makemine(x:Int,y:Int,depth:Int)
        For Local mydepth=0 Until depth
        Local d1:Int=Rnd(8,16)'depth
        tunneldown(x,y,d1)
        y+=d1
        Local d2:Int=Rnd(1,4)'direction
        If d2=1 Then sidetunnel(x,y,"left")
           If d2=2 Then sidetunnel(x,y,"right")
           If d2=3 Then 
            sidetunnel(x,y,"left")
               sidetunnel(x,y,"right")
           End If
           Next
           For Local y1=0 Until y
               map[x][y1] = 2
           Next
    End Method
    Method sidetunnel(x:Int,y:Int,d:String)
        If d="left"
            Local width:Int=Rnd(5,10)
            drawmaprect(x-width+2,y,width,3)
            Local roomw:Int=Rnd(5,15)
            drawmaprect(x-width+2-roomw,y-1,roomw,5)
            For Local x1=0 Until roomw/3
                map[(x-width+2-roomw)+x1][y+4] = 3
                eggs.AddLast( New egg((x-width+2-roomw)+x1,y+4) )
            Next
'            a.AddLast(    New agent(    ((x-width+2-roomw))*tilewidth,
'                                    (y+4)*tileheight) )
        End If
        If d="right"
            Local width:Int=Rnd(5,10)
            drawmaprect(x-1,y,width,3)
            Local roomw:Int=Rnd(5,15)
            drawmaprect(x+width,y-1,roomw,5)        
            For Local x1=roomw Until roomw/1.5 Step -1
                map[(x+width)+x1][y+4] = 3
                eggs.AddLast( New egg((x+width)+x1,y+4) )
            Next            
'            a.AddLast( New agent(     (x+width+2)*tilewidth,
'                                     (y+4)*tileheight ))
        End If
    End Method
    Method tunneldown(x:Int,y:Int,d:Int)
        drawmaprect(x-2,y,4,d)
    End Method
    Method drawmaprect(x:Int,y:Int,w:Int,h:Int)
        For Local y1=y To y+h
        For Local x1=x To x+w
            map[x1][y1] = 1
        Next
        Next        
    End Method
    Method draw()
        For Local y=0 Until h
        For Local x=0 Until w
            If map[x][y] = 1
                SetColor 255,255,255
                DrawRect x*tw,y*th,tw,th
            End If
            If map[x][y] = 3
                SetColor 200,200,10
                DrawOval x*tw,y*th,tw,th
            End If            
        Next
        Next
    End Method
End Class

Class spear
    Field x:Float,y:Float
    Field w:Int=20
    Field h:Int=4
    Field d:String
    Field incx:Float
    Field active:Bool    
    Method New(x:Int,y:Int,d:String)
        Self.x = x
        Self.y = y
        Self.d = d
        incx = 3
        active = True
    End Method
    Method update()
        If active = False Then Return
        w+=incx
        incx-=0.5
        If     incx > 0
            killcreature
        End If
        If incx < -3 Then active = False
    End Method
    Method killcreature()
        For Local i:=Eachin dw
            If d="left" 
                If rectsoverlap(    i.x,i.y,32,32,
                                    x-32,y,32,32)
                    i.remove = True
                    myinven.meat+=1
                End If
            Else
                If rectsoverlap(    i.x,i.y,32,32,
                                    x+32,y,32,32)
                    i.remove = True
                    myinven.meat+=1
                End If
            End If
        Next

        For Local i:=Eachin a            
            If d="left" 
                If rectsoverlap(    i.x,i.y,32,32,
                                    x-32,y,32,32)
                    i.remove = True
                    myinven.meat+=1
                End If
            Else
                If rectsoverlap(    i.x,i.y,32,32,
                                    x+32,y,32,32)
                    i.remove = True
                    myinven.meat+=1
                End If
            End If
        Next
        For Local i:=Eachin a
            If i.remove=True
                a.Remove i
            End If
        Next
    End Method
    Method draw()
        If active = True
            SetColor 200,100,0
            If d = "right"
                DrawRect x+32,y+8,w,h
            Else
                DrawRect x-w,y+8,w,h    
            End If
        End If
    End Method
End Class

Class player    
    Field x:Float=0
    Field y:Float=0
    Field w:Int=32
    Field h:Int=32
    Field incy:Float=0
    Field isjumping:Bool = False
    Field facing:Int '0 = left , 1 = right
    Field jumpofvine:Bool=False
    Field jumpofvinetimeout:Int
    Field health:Int=10
    Method update()
        Local ox:Int=x
        Local oy:Int=y
        If pvc(0,0) = False Or jumpofvine = True Then regularmode
        If pvc(0,0) = True 
            If jumpofvine = False
                vinemode
            End If
        End If
        If KeyHit(KEY_SPACE)
            Local md:String
            If facing = 0 Then 
                md="left" 
            Else
                md="right"
            End If
            myspear = New spear(p.x,p.y,md)
        End If
        If KeyHit(KEY_T)
            Local offx:Int
            If p.facing=0 Then 
                offx=0
            Else
                offx=32
            End If
               Local cx = (p.x+offx)/tilewidth+mapx
            Local cy = (p.y)/tileheight+mapy
            If mymaptest.map[cx][cy] = 3
                mymaptest.map[cx][cy] = 1
                myinven.eggs+=1
                For Local i:=Eachin eggs
                    If i.x = cx And
                        i.y = cy
                        i.remove = True
                    End If
                Next
                For Local i:=Eachin eggs
                    If i.remove=True
                        eggs.Remove i
                    End If
                Next
            End If
        End If
        If KeyHit(KEY_P)
            If myinven.eggs > 0
               Local cx = (p.x)/tilewidth+mapx
            Local cy = (p.y)/tileheight+mapy
            If mymaptest.map[cx][cy] = 1
                mymaptest.map[cx][cy] = 3
                eggs.AddLast(New egg(cx,cy))
            End If            
            End If
            myinven.eggs-=1
        End If
    End Method
    Method movea(x1:Int,y1:Int)
        For Local i:=Eachin a
            i.x+=x1
            i.y+=y1
        Next
        For Local i:=Eachin dw
            i.x+=x1
            i.y+=y1
        Next        
    End Method
    Method vinemode()
        isjumping = False
        incy=0
        If KeyDown(KEY_J)
            jumpofvine = True
            jumpofvinetimeout = Millisecs() + 1000
            isjumping = True
            incy=-4
        End If
        If KeyDown(KEY_UP)
            For Local i=0 Until 4
                If pvc(0,0) = True And ptc(0,-1) = False
                    y-=1
                End If
            Next
        End If
        If KeyDown(KEY_DOWN)
            For Local i=0 Until 4
                If pvc(0,0) = True And ptc(0,1) = False
                    y+=1
                End If
            Next
        End If
        If KeyDown(KEY_LEFT)
            For Local i=0 Until 4
                If pvc(0,0) = True And ptc(-1,0) = False
                    x-=1
                    facing=0
                End If
            Next
        End If
        If KeyDown(KEY_RIGHT)
            For Local i=0 Until 4
                If pvc(0,0) = True And ptc(1,0) = False
                    x+=1
                    facing = 1
                End If
            Next
        End If
    End Method
    Method regularmode()        
        If jumpofvine = True
            If Millisecs() > jumpofvinetimeout Then jumpofvine=False
        End If
        'Left and Right movement
        If KeyDown(KEY_RIGHT)
            For Local i=0 Until 4 ' move with 4 pixels at a time
                If ptc(1,0) = False
                    x+=1
                    facing = 1
                End If
            Next
        End If
        If KeyDown(KEY_LEFT)
            For Local i=0 Until 4
                If ptc(-1,0) = False
                    x-=1
                    facing = 0
                End If
            Next
        End If
        'player gravity part
        'if in the air and not in jump
        If isjumping = False
            If ptc(0,1) = False
                isjumping=True
                incy=0
            End If
        End If
        ' jump
        If KeyDown(KEY_UP)
            If isjumping = False
                isjumping = True
                incy=-4
            End If
        End If
        ' if we are in a jump/falling down
        If isjumping=True
            If incy>=0 'if we are going down
                If incy<4 Then incy+=.1
                For Local i=0 Until(incy)
                    If ptc(0,1) = False
                        y+=1
                    Else
                        isjumping = False
                    End If
                Next
            End If
            If incy<0 'if we are going up
                incy+=.1
                For Local i=0 Until Abs(incy)
                    If ptc(0,-1) = False
                        y-=1
                    Else
                        incy=0
                    End If
                Next
            End If
        End If    
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x,y,w,h
    End Method
End Class

Class deathwing
    Field x:Int,y:Int
    Field w:Int,h:Int
    Field state:String
    Field remove:Bool=False
    Field lasthurt:Int=Millisecs()
    
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
        w = 32
        h = 32
        state = "flyup"
    End Method
    Method update()    
        hurtplayer    
        Local x1:Int = ((Self.x-mapsx+16)/tilewidth)+mapx
        Local y1:Int = ((Self.y)/tileheight)+mapy
        Local x1r:Int = (((Self.x+1)-mapsx+16)/tilewidth)+mapx
        Local x1l:Int = (((Self.x-1)-mapsx+16)/tilewidth)+mapx
        Local y1u:Int = (((Self.y-1))/tileheight)+mapy
        Local y1d:Int = (((Self.y+1))/tileheight)+mapy

        canattack
        Select state
            Case "attack"
                If p.x < x And mymaptest.map[x1l][y1] = 1 Then x-=1
                If p.y < y And mymaptest.map[x1][y1u] = 1 Then y-=1
                If p.x > x And mymaptest.map[x1r][y1] = 1 Then x+=1
                If p.y > y And mymaptest.map[x1][y1d] = 1 Then y+=1
            Case "flyup"                
                ' if high enough
                If y1<12 Then 
                    If Rnd(10)<5                    
                        state="flyleft"                        
                        Else
                        state="flyright"
                    End If                
                End If
                'if can fly up
                If mymaptest.map[x1][y1-2] = 1
                    y-=1
                Else
                    If Rnd(10)<5
                        state="flyleft"
                        Else
                        state="flyright"
                    End If                
                End If                
            Case "flyleft"
                If mymaptest.map[x1][y1] = 1
                    x-=1
                Else
                    state="flyright"
                End If
                If Rnd(150)<5
                    If canflyup(x1+2,y1) = True
                        state="flyup"
                    End If
                Elseif Rnd(150)>140
                    If canflydown(x1+2,y1) = True
                        state="flydown"
                    End If
                End If
            Case "flyright"
                If mymaptest.map[x1+2][y1] = 1
                    x+=1
                Else                
                    state="flyleft"
                End If
                If Rnd(150)<5 Then
                    If canflyup(x1,y1) = True
                        state="flyup"
                    End If
                Elseif Rnd(150)>140
                    If canflydown(x1,y1) = True
                        state="flydown"
                    End If
                End If
            Case "flydown"
                If mymaptest.map[x1][y1+1] = 1
                    y+=1
                    Else
                    state="flyup"
                End If
        End Select
    End Method
    Method hurtplayer()
        If lasthurt<Millisecs()
            lasthurt = Millisecs()+600
            If rectsoverlap(p.x,p.y,32,32,x,y,32,32)
                p.health-=1
            End If
        End If
    End Method
    Method canattack()
        If state="attack"
        If distance(p.x,p.y,x,y) > 128
            If Rnd(10)<5 Then
                state="flyright"
            Else
                state="flyleft"
            End    If            
        End If
        End If
        If rectsoverlap(p.x-48,p.y-48,96,96,x-48,y-48,96,96)
            state="attack"
        End If
    End Method
    Method canflydown:Bool(x1:Int,y1:Int)
        For Local y2=y1 To y1+5
            If mymaptest.map[x1][y2] <> 1 Then
                Return False
            End If
        Next
        Return True        
    End Method
    Method canflyup:Bool(x1:Int,y1:Int)
        If y1<14 Then Return False
        For Local y2=y1 To y1-5 Step -1
            If mymaptest.map[x1][y2] <> 1 Then
                Return False
            End If
        Next
        Return True        
    End Method

    Method draw()
        SetColor 0,250,20
        DrawOval x,y,w,h
        SetColor 255,255,255
    End Method
End Class

Class agent
    Field x:Int,y:Int
    Field w:Int,h:Int
    Field state:String
    Field remove:Bool=False
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
        w = 32
        h = 32
        state="right"
    End Method
    Method update()
        Local x1:Int = ((Self.x-mapsx+16)/tilewidth)+mapx
        Local y1:Int = ((Self.y)/tileheight)+mapy
        Select state
            Case "right"
            If mymaptest.map[x1+2][y1] = 0 Or
                mymaptest.map[x1+2][y1+1] = 1 Then
                state="left"
                Else
                x+=1
            End If
            Case "left"
            If mymaptest.map[x1][y1] = 0 Or
                mymaptest.map[x1][y1+1] = 1 Then
                state="right"
                Else 
                x-=1
            End If
        End Select
        If Rnd(1500)<2
            Local placeegg:Bool=True
            For Local i:=Eachin eggs
                If i.x = x1 And i.y = y1
                    placeegg=False
                End If
            Next
            If placeegg = True
                If mymaptest.map[x1][y1] = 1
                mymaptest.map[x1][y1] = 3
                eggs.AddLast(New egg(x1,y1) )
                End If
            End If
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x,y,w,h
        SetColor 255,255,255
    End Method
End Class

Class egg
    Field x:Int,y:Int
    Field hatch:Bool=False
    Field remove:Bool=False
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Class inventory
    Field eggs:Int=0
    Field meat:Int=0
    Method New()
    End Method
    Method draw()
        SetColor 0,0,0
        DrawRect     0,DeviceHeight()-64,
                    DeviceWidth(),64
        SetColor 255,255,255
        DrawText "Eggs :"+eggs,10,DeviceHeight()-40
        DrawText "Meat :"+meat,10,DeviceHeight()-20
        DrawText "Health :"+p.health,100,DeviceHeight()-40
        DrawText "This game template might be updated if I get inspired",DeviceWidth()/3,DeviceHeight()-60
        DrawText "or if there are lots of hits on it. So check this",DeviceWidth()/3,DeviceHeight()-40
        DrawText "link in the future.",DeviceWidth()/3,DeviceHeight()-20
    End Method
End Class

' -----------------------------------------------------------------------------------------------

Global mymenuselect:menuselect = New menuselect
Global myinven:inventory = New inventory
Global mymaptest:maptest
Global p:player
Global a:List<agent> = New List<agent>
Global dw:List<deathwing> = New List<deathwing>
Global eggs:List<egg> = New List<egg>
Global myspear:spear = New spear

Class MyGame Extends App
	
    Method OnCreate()
        SetUpdateRate(60)
'        restartgame
    End Method
    Method OnUpdate()    
    	
    	Select gamestate
    	Case "select"
    		mymenuselect.update
    		If mymenuselect.go = True
    			mymenuselect.go = False
    			gamestate = "play"
    			Seed = Millisecs()
    			restartgame
    		End If
    	Case "play"
	        If p.health < 0 Or KeyHit(KEY_ESCAPE)
	            'banana
	            gamestate = "select"
	            
	            'restartgame
	        End If
	        p.update    
	        alignmap
	        For Local i:=Eachin a
	            i.update
	        Next
	        For Local i:=Eachin dw
	            i.update
	            If i.remove = True 
	                dw.Remove i
	            End If
	        Next        
	        egghatch()
	        myspear.update
	 	End Select
    End Method
    Method OnRender()
        Cls 0,0,0 
        Select gamestate
        Case "select"
    		mymenuselect.draw        
        Case "play"
	        drawmap
	        For Local i:=Eachin a
	            i.draw
	        Next
	        For Local i:=Eachin dw
	            i.draw
	        Next
	        myspear.draw
	        p.draw        
	        SetColor 0,0,0
	        DrawRect 0,0,DeviceWidth(),50
	        SetColor 255,255,255
	        myinven.draw
	        DrawText "Use Cursor left/right to move, cursor up to jump. Travel down the mine and mine eggs/meat.",0,0
	        DrawText "Space to attack. t to take egg. p to place egg. Monsters spawn from eggs.",0,16
	        DrawText "Monsters lay eggs. M - Show map.",0,32
	        If KeyDown(KEY_M) Then
	            Cls 0,0,0
	            mymaptest.draw
	        End If
        End Select
    End Method
End Class



Function Main()
    New MyGame()
End Function

Function egghatch()
    'hatch deathwing
    For Local z=0 Until 2                    
        Local ax:Int=Rnd(mapwidth)
        Local ay:Int=Rnd(mapheight)
        If mymaptest.map[ax][ay] = 3
        If countdeathwings()<maxdeathwings    
            dw.AddLast( New deathwing(    (ax*tilewidth)-
                                        (mapx*tilewidth),
                                        (ay*tileheight)-
                                        (mapy*tileheight)+
                                        (mapsy) ) )        
            For Local i:=Eachin eggs
                If i.x = ax
                If i.y = ay
                    i.remove = True
                End If
                End If
            Next
            mymaptest.map[ax][ay]  = 1
            For Local i:=Eachin eggs
                If i.remove = True
                    eggs.Remove i
                End If
            Next                
            Exit
        End If
        End If
    Next
    'hatch breeder
    For Local z=0 Until mapwidth/2
        Local ax:Int=Rnd(mapwidth)
        Local ay:Int=Rnd(mapheight)
        If mymaptest.map[ax][ay] = 3
            For Local i:=Eachin eggs
            If i.x = ax And i.y = ay
                i.hatch = True
                For Local ii:=Eachin a
                    Local x1:Int = ((ii.x-mapsx+16)/tilewidth)+mapx
                    Local y1:Int = ((ii.y)/tileheight)+mapy

                    If distance(i.x,i.y,x1,y1) < 15 
                        i.hatch = False            
                    End If
                Next
            End If
            Next            
        End If        
    Next
    For Local i:=Eachin eggs
        If i.hatch = True
            mymaptest.map[i.x][i.y] = 1
            If Rnd(10) > 3  'hatch monster
                a.AddLast( New     agent(     (i.x*tilewidth)-
                                        (mapx*tilewidth),
                                        (i.y*tileheight)-
                                        (mapy*tileheight)+
                                        (mapsy) ) )
            End If
            i.remove = True
            For Local ii:=Eachin eggs
            If i<>ii
                If distance(i.x,i.y,ii.x,ii.y) < 10
                    ii.hatch=False
                End If
            End If
            Next
        End If
    Next
    For Local i:=Eachin eggs
        If i.remove = True Then
            eggs.Remove i
        End If
    Next
End Function

Function countdeathwings:Int()
    Local cnt:Int=0
    For Local i:=Eachin dw
        cnt+=1
    Next
    Return cnt
End Function

Function alignmap:Bool()
        For Local i=0 Until 4
        If p.x > DeviceWidth / 2
            If mapx+20 < mapwidth-1
                mapsx-=1
                If mapsx < 0 Then 
                    mapsx = 31
                    mapx += 1
                Endif
                p.x-=1
                p.movea(-1,0)
            End If
        End If
        Next

        For Local i=0 Until 4
        If p.x < DeviceWidth / 2
            If mapx > 0
                mapsx+=1
                If mapsx > 31 Then 
                    mapsx = 0
                    mapx -= 1
                Endif
                p.x+=1
                p.movea(1,0)
            End If
        End If
        Next
        ' scrolling down
        For Local i=0 Until 16
        If p.y > DeviceHeight / 2
            If mapy+14 < mapheight-1
                mapsy-=1
                If mapsy < 0 Then 
                    mapsy = 31
                    mapy += 1
                Endif
                p.y-=1
                p.movea(0,-1)
            End If
        End If
        Next
        ' scrolling up
        For Local i=0 Until 16
        If p.y < DeviceHeight / 2
            If mapy > 0
                mapsy+=1
                If mapsy > 31 Then 
                    mapsy = 0
                    mapy -= 1
                Endif
                p.y+=1
                p.movea(0,1)
            End If
        End If
        Next
End Function

'player collide with solid blocks true/false
Function ptc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight+mapy
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If mymaptest.map[x2][y2] = 0
                Local x3 = (x2-mapx)*tilewidth-32+mapsx
                Local y3 = (y2-mapy)*tileheight+mapsy
                If rectsoverlap(p.x+offsetx,p.y+offsety,p.w,p.h,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function

'player collide with vines blocks true/false
Function pvc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight+mapy
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If mymaptest.map[x2][y2] = 2
                Local x3 = (x2-mapx)*tilewidth-32+mapsx
                Local y3 = (y2-mapy)*tileheight+mapsy
                If rectsoverlap(p.x+offsetx,p.y+offsety,p.w,p.h,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function

Function drawmap:Void()
    For Local y=0 To 14
    For Local x=0 To 20
        Local x1 = ((x*tilewidth)+mapsx)-tilewidth
        Local y1 = ((y*tileheight)+mapsy)
        Select mymaptest.map[x+mapx][y+mapy]
            Case 0'Wall
            SetColor 100,100,100
            DrawRect x1,y1,tilewidth,tileheight
            Case 2'vine
            SetColor 10,100,10
            DrawRect x1,y1,tilewidth,tileheight
            Case 3'coin
            SetColor 200,200,10
            DrawOval x1+4,y1+4,tilewidth-8,tileheight-4
          End Select
     Next
     Next
     
End Function

Function restartgame()
    a.Clear()
    dw.Clear()
    eggs.Clear()
    mapx=0
    mapy=0
    mapsx=0
    mapsy=0
    mymaptest = New maptest(mapwidth,mapheight,640,480)
    p = New player
    p.x+=64
    p.movea(64,0)

End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function 
    
Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function
