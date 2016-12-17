Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480
Global tilewidth:Int=32
Global tileheight:Int=32

Class enemy
	Field ex:Float,ey:Float,er:Int
	Field thrust:Float,ang:Int
	Field deleteme:Bool=False
	Field targetx:Int,targety:Int
	Field targetset:Bool=False
	Field state:String
	Field ishome:Bool=False
	Field roaming:Bool=False
	Field homex:Int,homey:Int
	Field firedelay:Int=20,firetime:Int
	Field hitpoint:Int=3
	Field gothit:Bool=False
	Field gothittime:Int=20
	Method New(x:Int,y:Int)
		ex=x
		ey=y
		er=12

		homex = x
		homey = y
		thrust=3.3
		state="roam"
	End Method
	Method update()
		'collision with player bullets		
		If gothit = True Then gothittime-=1
		For Local i:=Eachin mybullet
			If i.owner = "player"
				If rectsoverlap(i.bx,i.by,i.bradius,i.bradius,
								ex,ey,er,er)
					hitpoint-=1
					gothit=True
					gothittime=20
					If hitpoint<1 Then deleteme = True
					i.deleteme = True
				End If
			End If
		Next
		' states of the enemy
		Select state
			Case "attack"
				If Rnd() < .0005
					state = "roam"
					Print "done attacking"
					ishome=False
					roaming=False
				End If
				If Rnd()<.1 Then fireatplayer()
				settarget
				movein
				turn
			Case "roam"	
				If Rnd()<.002					
					state="attack"
					Print "going to attack"
				End If
				roam
				movein
				turn
		End Select
	End Method
	Method fireatplayer()
		Local d:Int=distance(ex,ey,screenwidth/2,screenheight/2)		
		firetime+=1
		If d<250 And firetime > firedelay
			firetime = 0
			mybullet.AddLast(New bullet("enemy",ex,ey,ang))
		End If
	End Method
	Method roam()
		Local dtohome = distance(ex,ey,homex,homey)
		Local dtotarget = distance(ex,ey,targetx,targety)
		If dtohome > 300 And ishome = False And roaming=False
			ishome=True			
			targetx = homex
			targety = homey				
		End If
		If dtohome < 50 And ishome = True And roaming = False
			roaming = True
			targetx = homex+Rnd(-100,100)
			targety = homey+Rnd(-100,100)
		End If
		If dtotarget < 50 And roaming = True
			targetx = homex+Rnd(-100,100)
			targety = homey+Rnd(-100,100)
		End If
		If dtotarget > 300 And roaming=True
			roaming=False
			ishome=False
		End If
	End Method
	Method turn()
		'turn
		Local pangle:Int = getangle(ex,ey,targetx,targety)
		If leftangle(ang,pangle) = True Then ang+=3 Else ang-=3
		If ang>180 Then ang=-180
		If ang<-180 Then ang=180
	End Method

	Method movein()
		'move in
		ex -= Cos(myplayer.ang)*myplayer.thrust
        ey -= Sin(myplayer.ang)*myplayer.thrust        
		ex += Cos(ang)*thrust
		ey += Sin(ang)*thrust
	End Method

	Method settarget()		
		'set target
		Local d:Int=distance(ex,ey,screenwidth/2,screenheight/2)
		If d > 550
			targetx = screenwidth/2
			targety = screenheight/2
			targetset = False
		Else
			If targetset = False
				targetx = (screenwidth/2)+Rnd(-90,90)
				targety = (screenheight/2)+Rnd(-90,90)				
				targetset = True
			End If
		End If
	End Method

	Method draw()
		SetColor 255,0,0
		If gothit = True		
			If gothittime<0 Then gothit=False
			SetColor 255,255,255
		End If
		DrawCircle ex,ey,er
	End Method
	Function leftangle:Bool(_angle:Int,_destinationangle:Int)
	    Local cnt1 = 0    
	    Local a1 = _angle
	    While a1<>_destinationangle    
	        a1+=1
	        If a1>180 Then a1=-180
	        cnt1+=1
	    Wend
	    If cnt1<180 Then Return True Else Return False
	End Function	
	Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
         Local dx = x2 - x1
         Local dy = y2 - y1
	     Return ATan2(dy,dx)+360 Mod 360
	End Function    
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function	
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    	Return True
	End Function    
End Class

Class bullet
	Field deleteme:Bool=False
	Field bx:Float,by:Float,bradius:Float
	Field ang:Int,thrust:Float
	Field time:Int,timeout:Int=100
	Field alpha:Float
	Field owner:String
	Method New(owner:String,x:Int,y:Int,angle:Int)
		Self.owner = owner
		Self.ang = angle
		Self.bx = x
		Self.by = y
		bradius = 6
		thrust = 4
	End Method
	Method update()
		time+=1
		bx += Cos(ang)*thrust
		by += Sin(ang)*thrust
		If time > timeout Then deleteme = True
		alpha = 1-(.5/Float(timeout))*time
	End Method
	Method draw()
		Select owner
			Case "player"
			SetColor 255,0,255		
			Case "enemy"
			SetColor 255,255,0
		End Select
		SetAlpha alpha
		DrawCircle bx,by,bradius
		SetAlpha 1
	End Method
End Class

Class player
	Field ang:Float
	Field thrust:Float=2
	Field turninc:Float
	Field turnincmax:Float=3
	Field turnincmin:Float=-3
	Field maxthrust:Float = 4
	Field firedelay:Int=20
	Field firetime:Int
	Field ship:Float[]=[    -5.0,-5.0,
                         5.0,0.0,
                         -5.0,5.0] 
	Method New()	
	End Method
	Method update()
		'shoot
		firetime+=1
		If KeyDown(KEY_SPACE) And firetime > firedelay
			firetime = 0
			mybullet.AddFirst(New bullet("player",screenwidth/2,screenheight/2,ang))
		End If
		'turn
		If KeyDown(KEY_LEFT) Then turninc-=.2
		If KeyDown(KEY_RIGHT) Then turninc+=.2
		turninc = Clamp(turninc,turnincmin,turnincmax)
		If turninc > .1 Then turninc -= .1
		If turninc < -.1 Then turninc += .1
		If turninc >-.1 And turninc <.1 Then turninc=0
		ang+=turninc
		If ang>359 Then ang=0
		If ang<0 Then ang=359
		'thrust
		If KeyDown(KEY_UP) Then thrust += .1
		If KeyDown(KEY_DOWN) Then thrust -= .1
		If thrust < 0 Then thrust = 0
		If thrust > maxthrust Then thrust = maxthrust		
	End Method
	Method draw()
        PushMatrix()
        Translate screenwidth/2,screenheight/2
        Rotate(-ang)
        Scale(4,4)
        SetColor 255,255,255
        DrawPoly(ship)        
        Translate 0,0
        PopMatrix()  
        SetColor 255,0,0
        DrawLine    screenwidth/2,
                    screenheight/2,
                    screenwidth/2+Cos(ang)*(tilewidth*2),
                    screenheight/2+Sin(ang)*(tileheight*2)
	
	End Method
End Class

Class map
    Field mapx:Float=0
    Field mapy:Float=0
    Field map:Int[][] = [    [0,0,0,1,0,1,0,1,0,1,0,1,0,0,0],
                            [0,0,0,0,1,0,0,0,0,0,1,0,0,0,0],
                            [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
                            [0,1,0,0,0,0,1,1,1,0,0,0,0,1,0],
                            [0,1,0,1,0,0,1,0,1,0,0,1,0,1,0],
                            [0,1,0,0,0,0,1,1,1,0,0,0,0,1,0],
                            [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
                            [0,1,0,0,1,0,0,0,0,0,1,0,0,1,0],
                            [0,0,0,1,0,1,0,1,0,1,0,1,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]    
	Field starimage:Image 
    Field starimagew:Int=screenwidth*2
    Field starimageh:Int=screenheight*2
    Field starimagepixels:Int[]                                                                                                                                                                                                                            
    Method New()        
    	' create the background starfield
    	starimagepixels = New Int[starimagew*starimageh]
    	starimage = CreateImage(starimagew,starimageh)
		createstarimage()    	
    End Method
    Method update() 
    	' update the tilemap with the player movement
		mymap.mapx -= Cos(myplayer.ang)*myplayer.thrust
        mymap.mapy -= Sin(myplayer.ang)*myplayer.thrust        
    End Method
	Method createstarimage()
		For Local i=0 Until starimagew*starimageh
			starimagepixels[i] = argb(0,0,0)
		Next
		For Local i=0 Until 1000
			Local c:Int=Rnd(10,255)
			Local pos:Int=Rnd(starimagew*starimageh)
			starimagepixels[pos] = argb(c,c,c)
			If Rnd()<.2 Then starimagepixels[pos-1] = argb(c,c,c)
		Next
		starimage.WritePixels(starimagepixels, 0, 0, starimagew, starimageh, 0)
	End Method
    Method draw()	
    	DrawImage starimage,(-screenwidth/2)+(mapx/15),(-screenheight/2)+(mapy/15)
        SetColor 155,155,155
        For Local y=0 Until 10
        For Local x=0 Until 15
            If map[y][x] = 1
                DrawRect     x*tilewidth+mapx,
                            y*tileheight+mapy,
                            tilewidth,
                            tileheight
            End If
        Next
        Next
    End Method
	Function argb:Int(r:Int, g:Int, b:Int ,alpha:Int=255)
	   Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b          
	End Function
	Function getred:Int(rgba:Int)    
	    Return((rgba Shr 16) & $FF)    
	End Function              
	Function getgreen:Int(rgba:Int)    
	    Return((rgba Shr 8) & $FF)    
	End Function    
	Function getblue:Int(rgba:Int)    
	    Return(rgba & $FF)    
	End Function    
	Function getalpha:Int(rgba:Int)    
	    Return ((rgba Shr 24) & $FF)    
	End Function	    
End Class

Global myplayer:player
Global mymap:map
Global mybullet:List<bullet> = New List<bullet>
Global myenemy:List<enemy> = New List<enemy>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        myplayer = New player()
        mymap = New map()        
		For Local i=0 Until 5	
	        myenemy.AddLast(New enemy(Rnd(-screenwidth*2,screenwidth*2),Rnd(-screenheight*2,screenheight*2)))
		Next
    End Method
    Method OnUpdate() 
		myplayer.update()
        mymap.update()
        For Local i:=Eachin mybullet
        	i.update
        Next
        For Local i:=Eachin mybullet
        	If i.deleteme = True Then mybullet.Remove(i)
        Next
        For Local i:=Eachin myenemy
        	i.update
        Next
        For Local i:=Eachin myenemy
        	If i.deleteme = True Then myenemy.Remove(i)
        Next

    End Method
    Method OnRender()
        'Cls 0,0,0  
        mymap.draw()
        For Local i:=Eachin myenemy
        	i.draw
        Next           
        For Local i:=Eachin mybullet
        	i.draw
        Next           
        myplayer.draw()
        SetColor 255,255,255
        DrawText "Cursor Left/Right/Up/Down/Space",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
