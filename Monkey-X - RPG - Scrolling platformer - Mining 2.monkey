Import mojo

Global egghatchspeed:Float = 0.1 'how fast eggs hatch
Global egglayingfreq:Float = 0.1 ' lay lots of eggs 1 lay less eggs 0 '0 to 1
Global startingeggfreq:Float = 0.2 '0 to 1 0 is none 1 is full
Global maxflyingmonsters:Int=30
Global mapwidth:Int=320
Global mapheight:Int=240

Class theflyingmonster
	Field x:Int,y:Int
	Field w:Float,h:Float
	Field state:String
	Field tx:Float
	Field ty:Float
	Field substate:String
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
		Self.w = 3
		Self.h = 3
		state="hatched"
	End Method
	Method update()
		Select state
			Case "hatched"
				state="takeoff"
				ty=3 'move distance
			Case "takeoff"
				takeoff
			Case "roam"				
				Select substate
					Case "left"
						x-=1
						If mymaptest.map[x-1][y] = 0 Then substate="right"
						If x<3 Then substate="right"
						' if flying on the ground level then move up 1 tile
						If mymaptest.map[x][y+1] = 0 Then y-=1
						If mymaptest.map[x][y-1] = 0 Then y+=1
					Case "right"
						x+=1
						If mymaptest.map[x+1][y] = 0 Then substate="left"
						If x>mapwidth-3 Then substate="left"
						' if flying on the ground level then move up 1 tile						
						If mymaptest.map[x][y+1] = 0 Then y-=1
						If mymaptest.map[x][y-1] = 0 Then y+=1
					Case "up"
						y-=1						
						If mymaptest.map[x][y-2] = 0 Then 
							If Rnd()<.5
								substate="left"
								Else
								substate="right"
							Endif							
						Endif
						If y<3 Then 
							If Rnd() < .5
								substate="right"
							Else
								substate="left"
							Endif
						End If
					Case "down"
						y+=1
						If mymaptest.map[x][y+2] = 0 
							If Rnd() < .5
								substate="left"						
								Else
								substate="right"
							End If
						Endif
				End Select
				' Change direction to up or down if possible
				' sometimes
				gorandupordown()
				gorandleftorright
				'change direction sometimes to left or right
				landandlayegg
			Case "landlayegg"
				y+=1
				If mymaptest.map[x][y+1] = 0
					state="layegg"
				End If
			Case "layegg"
				If mymaptest.map[x][y] = 1 Then
				mymaptest.map[x][y] = 3
				Else
				
				End If
				state="takeoff"
				ty=3
		End Select
	End Method
	Method landandlayegg()
		' Sometimes land and lay egg
		If Rnd() < (egglayingfreq/10)
			Local exitloop:Bool=False
			Local y1:Int=y
			Local egghere:Bool=False
			While exitloop = False
				If mymaptest.map[x][y1] = 3 Then 
					Return
				End If
				If mymaptest.map[x][y1] = 0 Then exitloop = True
				y1+=1
			Wend
			Local cnt:Int=0
			For Local i:=Eachin myflyingmonster
				cnt+=1
			Next
			'if more then max monsters no lay egg
			If cnt<maxflyingmonsters Then		
				state="landlayegg"
			End If
		End If	
	End Method
	Method gorandleftorright()
		If substate="up" Or substate="down"
			If Rnd() < 0.1
				Local exitloop:Bool=False
				Local x1:Int=x
				Local cnt:Int=0
				While exitloop = False
					x1-=1
					cnt+=1
					If mymaptest.map[x1][y] = 0 Or x1<3
						exitloop = True
					End If
				Wend				
				If cnt>8 Then substate = "left"
			End If
			If Rnd() < 0.1
				Local exitloop:Bool=False
				Local x1:Int=x
				Local cnt:Int=0
				While exitloop = False
					x1+=1
					cnt+=1
					If mymaptest.map[x1][y] = 0 Or x1>mapwidth-3
						exitloop = True
					End If
				Wend				
				If cnt>8 Then substate = "right"					
			Endif
		Endif			
	End Method
	Method gorandupordown()
		If substate="left" Or substate="right"
			If Rnd() < .1
				Local exitloop:Bool=False
				Local y1:Int=y
				Local cnt:Int=0
				While exitloop=False
					y1-=1
					cnt+=1
					If mymaptest.map[x][y1] = 0
						exitloop = True
					Endif
					If y1<3 Then exitloop = True
				Wend			
				If cnt>8 Then substate="up"					
			End If
			If Rnd() < .13 And substate<>"up"					
				Local exitloop:Bool=False
				Local y1:Int=y
				Local cnt:Int=0
				While exitloop=False
					y1+=1
					cnt+=1
					If mymaptest.map[x][y1] = 0
						exitloop = True
					Endif
				Wend
				If cnt>8 Then substate="down"
			End If
		End If	
	End Method
	Method takeoff()
		y-=1
		ty-=1
		If ty<0 Or mymaptest.map[x][y-1] = 0 Then 
		state="roam"
		If Rnd(0,1) < 0.5 
			substate="left"
		Else
			substate="right"
		Endif
		Endif
	End Method
	Method draw()
	    Local x1:Float=DeviceWidth()/Float(mapwidth)*Float(x)
    	Local y1:Float=DeviceHeight/Float(mapheight)*Float(y)
    	SetColor 255,255,255
		DrawRect x1,y1,w+2,h+2
    	SetColor 255,0,0
		DrawRect x1+1,y1+1,w,h

	End Method
End Class

Class maptest
    Field tw:Float,th:Float
    Field w:Int,h:Int
    'bottom x and y contain the coords of the next
    'shaft to be created. center of room last pass
    Field bottomy:Int
    Field bottomx:Int
    Field map:Int[][]
    Method New(w:Int,h:Int)
        Self.w = w
        Self.h = h
        tw = DeviceWidth()/w
        th = DeviceHeight()/h
        map = New Int[w][]
        For Local i=0 Until w
            map[i] = New Int[h]
        Next
        drawmaprect(0,0,w-1,15)
        For Local i=0 Until h
            map[1][i] = 0
            map[w-2][i] = 0
        Next
        ' x,y,number of tunnels>>
        makemine(w/2,15,Rnd(1,3))        
        makemine(bottomx,bottomy,Rnd(1,3))        
        While bottomy<mapheight-40
           makemine(bottomx,bottomy,Rnd(1,3))
        Wend

    End Method
    Method makemine(x:Int,y:Int,depth:Int)
        Local vy:Int=y
        For Local mydepth=0 Until depth
            Local d1:Int=Rnd(8,16)'depth
            tunneldown(x,y,d1)
            y+=d1
            Local d2:Int=Rnd(1,4)'direction
            If d2=1 Then 
                sidetunnel(x,y,"left")
            End If
            If d2=2 Then 
                sidetunnel(x,y,"right")
            End If
            If d2=3 Then 
                sidetunnel(x,y,"left")
                sidetunnel(x,y,"right")
            End If
        Next
        For Local y1=vy Until bottomy+2
            map[x][y1] = 2
        Next
    End Method
    Method sidetunnel(x:Int,y:Int,d:String)
        If d="left" And x>30
            Local width:Int=Rnd(5,15)
            drawmaprect(x-width+2,y,width,3)
            Local roomw:Int=Rnd(5,15)
            drawmaprect(x-width+2-roomw,y-1,roomw,5)
            ' place eggs
            For Local x1=0 Until roomw/3            
                If Rnd()<startingeggfreq Then map[(x-width+2-roomw)+x1][y+4] = 3
            Next
            bottomx = x-width-(roomw/2)
            bottomy = y
        End If
        If d="right" And x<mapwidth-30
            Local width:Int=Rnd(5,15)
            drawmaprect(x-1,y,width,3)
            Local roomw:Int=Rnd(5,15)
            drawmaprect(x+width,y-1,roomw,5)        
            'place eggs
            For Local x1=roomw Until roomw/1.5 Step -1
                If Rnd()<startingeggfreq Then map[(x+width)+x1][y+4] = 3
            Next
            bottomx = x+width+(roomw/2)            
            bottomy = y
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
            Local x1:Float=DeviceWidth()/Float(mapwidth)*Float(x)
            Local y1:Float=DeviceHeight/Float(mapheight)*Float(y)
            If map[x][y] = 1 'walkable
                SetColor 55,15,5
                DrawRect x1,y1,Ceil(tw),Ceil(th)
            End If
            If map[x][y] = 2 'rope/ladder
                SetColor 255,100,25                
                DrawRect x1,y1,tw+1,th+1
            End If            
            If map[x][y] = 3 'egg
                SetColor 200,200,10
                DrawOval x1,y1,tw,th
            End If            
        Next
        Next
    End Method
End Class

' -----------------------------------------------------------------------------------------------

Global mymaptest:maptest
Global myflyingmonster:List<theflyingmonster> = New List<theflyingmonster>


Class MyGame Extends App
    Field nmap:Int=0
    Method OnCreate()
        Local date := GetDate()
        Seed = date[5]
        SetUpdateRate(10)
        restartgame
    End Method
    Method OnUpdate()
    	addflyingmonster()
    	For Local i:=Eachin myflyingmonster
    		i.update
    	Next
        nmap+=1
        If KeyHit(KEY_SPACE)=True Or MouseHit(MOUSE_LEFT)
            restartgame
            nmap=0
        End If
    End Method
    Method OnRender()
        Cls 100,40,10 
        mymaptest.draw
        For Local i:=Eachin myflyingmonster
        	i.draw
        Next
        SetColor 255,255,0
        DrawText "Hold Spacebar or press lmb(tab) new map",20,DeviceHeight()-15
        DrawText "MonkeyX Sideview - Mining map Example",20,0
        DrawText "mapwidth:"+mapwidth+",mapheight:"+mapheight,20,20
        DrawText "Egghatchspeed:"+egghatchspeed,DeviceWidth()-130,0
        DrawText "Egglayingfreq:"+egglayingfreq,DeviceWidth()-130,20
        DrawText "startingeggfreq:"+startingeggfreq,DeviceWidth()-150,40
        DrawText "Maxflyingmonsters:"+maxflyingmonsters,DeviceWidth()-150,60
    End Method
End Class



Function Main()
    New MyGame()
End Function


Function addflyingmonster() 'hatch
	Local cnt:Int=0
	For Local i:=Eachin myflyingmonster
		cnt+=1
	Next
	If cnt<maxflyingmonsters
		'DebugLog (mapwidth+mapheight)/10
		For Local i=0 Until (mapwidth+mapheight)/10
			If Rnd() < egghatchspeed
				Local x:Int=Rnd(mapwidth)
				Local y:Int=Rnd(mapheight)
				If mymaptest.map[x][y] = 3
					mymaptest.map[x][y] = 1
					myflyingmonster.AddLast(New theflyingmonster(x,y))
				End If
			End If
		Next
	End If
End Function

Function restartgame()
	egghatchspeed= Rnd() 'how fast eggs hatch
	egglayingfreq= Rnd() ' lay lots of eggs 1 lay less eggs 0 '0 to 1
	startingeggfreq= Rnd() '0 to 1 0 is none 1 is full
	maxflyingmonsters=Rnd(10,100)
	mapwidth=Rnd(80,150)
	mapheight=Rnd(80,350)
	myflyingmonster.Clear
    mymaptest = New maptest(mapwidth,mapheight)
End Function

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function 
    
Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function
