Import mojo

Global smooth1:Int=10
Global smooth2:Int=20
Global myseed:Int=300
Global size:Int=50

Class MyGame Extends App
	
    Method OnCreate()
        SetUpdateRate(30)
    End Method
    Method OnUpdate()
		If KeyDown(KEY_RIGHT) Then smooth1+=1
		If KeyDown(KEY_LEFT) Then smooth1-=1
		If smooth1 <1 Then smooth1 = 2
		If smooth1 >100 Then smooth1 = 100
		If KeyDown(KEY_UP) Then smooth2+=1
		If KeyDown(KEY_DOWN) Then smooth2-=1
		If smooth2 <1 Then smooth2 = 2
		If smooth2 >100 Then smooth2 = 100
		If KeyDown(KEY_EQUALS) Then myseed+=1
		If KeyDown(KEY_MINUS) Then myseed-=1
		If KeyDown(KEY_9) Then size-=1
		If KeyDown(KEY_0) Then size+=1
		If size<5 Then size = 5
		If size>200 Then size=200
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        '
        Local sx:Int
        Local sy:Int
        Local ex:Int
        Local ey:Int
        Local ang:Int=0
        Local x:Int=320
        Local y:Int=240
        Local d:Int=size
        Local x1:Int=x+Cos(ang)*d
        Local y1:Int=y+Sin(ang)*d
        sx=x1
        sy=y1
        Seed = myseed

        While ang<(360-smooth2)
        	ang+=smooth2
        	d = size
        	Local x2:Int=x+Cos(ang)*d
        	Local y2:Int=y+Sin(ang)*d
        	Local d2:Int=d+Rnd(-d/smooth1,d/smooth1)
        	Local x3:Int=x+Cos(ang-10)*d2
        	Local y3:Int=y+Sin(ang-10)*d2
	       	DrawLine x1,y1,x3,y3
        	DrawLine x3,y3,x2,y2
'        	DrawLine x1,y1,x3,y3
        	x1=x2
        	y1=y2
		Wend
		DrawLine x1,y1,sx,sy
        '
        DrawText "Press Cursor Up and Cursor Down - Cursor Left and Cursor Down",0,0
        DrawText "Press + and -",0,20
        DrawText "Press 9 and 0",0,40
    End Method
End Class


Function Main()
    New MyGame()
End Function
