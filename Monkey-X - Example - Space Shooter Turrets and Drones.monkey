Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480
Global tilewidth:Int=32
Global tileheight:Int=32

Class bullet
	Field deleteme:Bool=False
	Field bx:Float,by:Float,bradius:Float
	Method New()
	End Method
	Method update()
	End Method
	Method draw()
	End Method
End Class

Class player
	Field ang:Float
	Field thrust:Float=2
	Field turninc:Float
	Field turnincmax:Float=3
	Field turnincmin:Float=-3
	Field maxthrust:Float = 4
	Field ship:Float[]=[    -5.0,-5.0,
                         5.0,0.0,
                         -5.0,5.0] 
	Method New()	
	End Method
	Method update()
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

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        myplayer = New player()
        mymap = New map()        
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
    End Method
    Method OnRender()
        'Cls 0,0,0  
        mymap.draw()
        For Local i:=Eachin mybullet
        	i.draw
        Next           
        myplayer.draw()
        SetColor 255,255,255
        DrawText "MonkeyX - Space game ship/map/scrolling example",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
