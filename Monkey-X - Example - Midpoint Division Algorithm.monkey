Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480

Class midpoint
	Field mw:Int,mh:Int
	Field tw:Float,th:Float
	Field map:Int[][]
	Method New(w:Int,h:Int)
		mw = w
		mh = h
		tw = Float(screenwidth)/Float(mw)
		th = Float(screenheight)/Float(mh)
		map = New Int[w][]
        For Local i = 0 Until mw
            map[i] = New Int[mh]
        Next		
 		map[0][0] = 128
  		map[mw-1][0] = 128
  		map[mw-1][mh-1] = 128
  		map[0][mh-1] = 128
 	 	midpoint(0,0,mw-1,mh-1)
	End Method
	Method midpoint(x1:Int,y1:Int,x2:Int,y2:Int)
   		If(x2-x1<2 And y2-y1<2) Return False
	    	Local dist:Int=(x2-x1+y2-y1)
    		Local hdist:Int=dist / 2
   	 		Local midx:Int=(x1+x2) / 2
    		Local midy:Int=(y1+y2) / 2
   		 	Local c1:Int=map[x1][y1]
    		Local c2:Int=map[x2][y1]
    		Local c3:Int=map[x2][y2]
    		Local c4:Int=map[x1][y2]
    		If(map[midx][y1]=0) Then map[midx][y1]=((c1+c2+Rnd(dist)-hdist) / 2)
    		If(map[midx][y2]=0) Then map[midx][y2]=((c4+c3+Rnd(dist)-hdist) / 2)
    		If(map[x1][midy]=0) Then map[x1][midy]=((c1+c4+Rnd(dist)-hdist) / 2)
    		If(map[x2][midy]=0) Then map[x2][midy]=((c2+c3+Rnd(dist)-hdist) / 2)
 		   	
 		   	map[midx][midy] = ((c1+c2+c3+c4+Rnd(dist)-hdist) / 4)
	  	 	midpoint(x1,y1,midx,midy)
    		midpoint(midx,y1,x2,midy)
    		midpoint(x1,midy,midx,y2)
    		midpoint(midx,midy,x2,y2)

	End Method 
	Method draw()
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			Local c:Int=map[x][y]
			SetColor c,c,c
			DrawRect x*tw,y*th,tw+1,th+1
		Next
		Next
	End Method
End Class

Global mymidpoint:midpoint

Class MyGame Extends App
    field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(1)
        mymidpoint = New midpoint(256,256)
    End Method
    Method OnUpdate() 
    	cnt+=1
    	If cnt>2 Then
    		mymidpoint = New midpoint(256,256)
    		cnt=0
    	End If	       
    End Method
    Method OnRender()
        'Cls 0,0,0 
        mymidpoint.draw
        'SetColor 255,255,255
    End Method
End Class


Function Main()
    New MyGame()
End Function
