Import mojo

Class colorspread16
	Field r:Float[16]
	Field g:Float[16]
	Field b:Float[16]
	Method New(	r1:Int,g1:Int,b1:Int,
				r2:Int,g2:Int,b2:Int)
		Local sr:Float
		Local sg:Float
		Local sb:Float
		If r1>r2
			sr = (r1-r2)/16
			For Local i:Float=0 Until 16 Step 1
				r[i] = r1-(i*sr)
			Next
			Else
			sr = (r2-r1)/16
			For Local i:Float=0 Until 16 Step 1
				r[i] = r1+i*sr
			Next
		End If
		If g1>g2
			sg = (g1-g2)/16
			For Local i:Float=0 Until 16 Step 1
				g[i] = g1-(i*sg)
			Next
			Else
			sg = (g2-g1)/16
			For Local i:Float=0 Until 16 Step 1
				g[i] = g1+i*sg
			Next
		End If
		If b1>b2
			sb = (b1-b2)/16
			For Local i:Float=0 Until 16 Step 1
				b[i] = b1-(i*sb)
			Next
			Else
			sb = (b2-b1)/16
			For Local i:Float=0 Until 16 Step 1
				b[i] = b1+i*sb
			Next
		End If

	End Method
End Class

Global spread:colorspread16

Class MyGame Extends App
	Field cnt:Int
	Field r:Int[2]
	Field g:Int[2]
	Field b:Int[2]
    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[5]
    	For Local i=0 To 1
    		r[i] = Rnd(0,255)
    		g[i] = Rnd(0,255)
    		b[i] = Rnd(0,255)
    	Next
        spread = New colorspread16(	r[0],g[0],b[0],
        							r[1],g[1],b[1])    		
    End Method
    Method OnUpdate()        
    	cnt+=1
    	If cnt>200
    		cnt=0
    		For Local i=0 To 1
    			r[i] = Rnd(0,255)
    			g[i] = Rnd(0,255)
    			b[i] = Rnd(0,255)
    		Next
        	spread = New colorspread16(	r[0],g[0],b[0],
        								r[1],g[1],b[1])    		
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        ' Draw the background
        For Local i=0 Until 16
        	SetColor 	spread.r[i],
        				spread.g[i],
        				spread.b[i]
        	DrawRect i*(DeviceWidth/16),0,
        			(DeviceWidth/16),DeviceHeight
        Next
        ' Draw the gui part
        Local c:Int=0
        For Local y=0 Until 8
        For Local x=0 To 1
        	SetColor 0,0,0
			DrawRect 	x*34+100,
						y*34+100,
						34,34        	
        	SetColor 	spread.r[c],
        				spread.g[c],
        				spread.b[c]
			DrawRect 	x*34+101,
						y*34+101,
						32,32
        	c+=1
        Next
        Next
        ' Draw the text
       	SetColor 255,255,255
       	DrawText 	"Monkey-X - Spreading 2 colors "+
       				"out into 16 colors - Example",0,0
		DrawText 	"R1:"+r[0]+
					" G1:"+g[0]+
					" B1:"+b[0],100,50
		DrawText	"R2:"+r[1]+
					" G2:"+g[1]+
					" B2:"+b[1],100,70       				
    End Method
End Class


Function Main()
    New MyGame()
End Function
