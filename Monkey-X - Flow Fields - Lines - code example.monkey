Import mojo

Class flowfield
    Field mapwidth:Int,mapheight:Int
    Field tilewidth:Float,tileheight:Float
    Field screenwidth:Int,screenheight:Int
    Field map:Int[][]
    Field flowlinestartx:Int
    Field flowlinestarty:Int

    Method New(screenwidth:Int,screenheight:Int,mapwidth:Int,mapheight:Int)
        Self.screenwidth = screenwidth
        Self.screenheight = screenheight
        Self.tilewidth = Float(screenwidth)/Float(mapwidth)
        Self.tileheight = Float(screenheight)/Float(mapheight)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        ' make a array
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next    
		' -1 if no direction
        For Local y:=0 Until mapheight
        For Local x:=0 Until mapheight
        	map[x][y] = -1
        Next
        Next
		'
		' Here we create a number of points
		' with which we draw the lines in between.
		'
		Seed = GetDate[5]
		Local lastx:Int=Rnd(2,mapwidth-2)
		Local lasty:Int=Rnd(2,mapheight-2)
		flowlinestartx = lastx
		flowlinestarty = lasty
		For Local i:=0 Until 5
			Local newx:Int=Rnd(2,mapwidth-2)
			Local newy:Int=Rnd(2,mapheight-2)
			flowline(lastx,lasty,newx,newy)
			lastx=newx
			lasty=newy
		Next
    End Method
    ' Make a flowfield(line) between two points
    Method flowline(x1:Int,y1:Int,x2:Int,y2:Int)
    	Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
      	dx = Abs(x2 - x1)
      	sx = -1
      	If x1 < x2 Then sx = 1      
      	dy = Abs(y2 - y1)
      	sy = -1
      	If y1 < y2 Then sy = 1
      	If dx < dy Then 
         	e = dx / 2 
      	Else 
         	e = dy / 2          
      	End If
      	Local exitloop:Bool=False
      	While exitloop = False
        	'SetColor 255,255,255
        	'DrawPoint x1,y1
        	If x1 = x2 
            	If y1 = y2
                	exitloop = True
            	End If
        	End If
        	For Local y:=-1 To 1
        	For Local x:=-1 To 1
        		map[x1+x][y1+y] = pointto(x1+x,y1+y,x1,y1)
        	Next
        	Next
			map[x1][y1] = pointto(x1,y1,x2,y2)
        	If dx > dy Then
            	x1 += sx ; e -= dy 
              	If e < 0 Then e += dx ; y1 += sy
        	Else
            	y1 += sy ; e -= dx 
            	If e < 0 Then e += dy ; x1 += sx
        	Endif
      	Wend
 	End Method
	' point the flow field direction to the x2,y2 from x1,y1
 	Function pointto:Int(x1:Int,y1:Int,x2:Int,y2:Int)
		Local nd:Int=-1
		If x1<x2 Then nd=0
		If x1>x2 Then nd=4
		If y1<y2 Then nd=2
		If y1>y2 Then nd=6		            
		If x1<x2 And y1<y2 Then nd=1
		If x1>x2 And y1<y2 Then nd=3
		If x1<x2 And y1>y2 Then nd=7
		If x1>x2 And y1>y2 Then nd=5
		Return nd
 	End Function

    Method draw()
        SetColor 255,255,255
        For Local y:=0 Until mapheight
        For Local x:=0 Until mapwidth
            Local direction:Int = map[x][y]
            If direction=-1 Then Continue
            Local x1:Float=Float(x)*tilewidth+tilewidth/2
            Local y1:Float=Float(y)*tileheight+tileheight/2
            Local ang:Int= (360/8*direction)
            Local x2:Float=x1+(Cos(ang)*tilewidth/2)
            Local y2:Float=y1+(Sin(ang)*tileheight/2)        
            Local x3:Float=x1+(Cos(ang+150)*tilewidth/4)
            Local y3:Float=y1+(Sin(ang+150)*tileheight/4)        
            Local x4:Float=x1+(Cos(ang-150)*tilewidth/4)
            Local y4:Float=y1+(Sin(ang-150)*tileheight/4)        
            
            DrawPoly([x2,y2,x3,y3,x4,y4])
        Next
        Next
    End Method
End Class

Class MyGame Extends App
    Field myflowfield:flowfield
    Field alienx:Int=200,alieny:Int=200
    Field lastx:Int,lasty:Int
    Method OnCreate()
        SetUpdateRate(60)
        myflowfield = New flowfield(DeviceWidth(),DeviceHeight(),50,50)
        alienx = myflowfield.flowlinestartx * myflowfield.tilewidth
        alieny = myflowfield.flowlinestarty * myflowfield.tileheight
    End Method
    Method OnUpdate()    
        Local d:Int=myflowfield.map[alienx/myflowfield.tilewidth][alieny/myflowfield.tileheight]
        ' Move the alien based on the flowfield array's direction 0=right 1=rightdown 7=rightup
        Select d
            Case 0
            alienx+=1
            Case 1
            alienx+=1;alieny+=1
            Case 2
            alieny+=1
            Case 3
            alienx-=1
            alieny+=1
            Case 4
            alienx-=1
            Case 5
            alienx-=1
            alieny-=1
            Case 6
            alieny-=1
            Case 7
            alieny-=1
            alienx+=1
        End Select
	
		' stay inside array(screen)
		If alienx+10>DeviceWidth() Then alienx = DeviceWidth()-10
		If alienx-10<0 Then alienx = 10
		If alieny+10>DeviceHeight() Then alieny = DeviceHeight()-10
		If alieny-10<0 Then alieny = 10

		' if we press the left mouse then move the alien to mouse position
        If MouseHit(MOUSE_LEFT) Then
            alienx = MouseX
            alieny = MouseY
        End If
		
		' if pressed space or no move by alien then new flowfield
		If KeyHit(KEY_SPACE) Or lastx = alienx And lasty = alieny
	        myflowfield = New flowfield(DeviceWidth(),DeviceHeight(),50,50)
    	    alienx = myflowfield.flowlinestartx * myflowfield.tilewidth
        	alieny = myflowfield.flowlinestarty * myflowfield.tileheight
		End If	
		
		lastx = alienx
		lasty = alieny
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        myflowfield.draw()
        SetColor 255,0,0
        DrawCircle(alienx,alieny,20)
        SetColor 255,255,255
        DrawText("Flow Fields (lines)- Press lmb to place alien - space new map.",0,0)
    End Method
End Class

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End Function
