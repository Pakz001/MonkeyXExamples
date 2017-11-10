Import mojo

Class tree
	Field px:Int,py:Int
	Field pw:Float,ph:Float
	Field mapone:Int[][]
	Field treecolor1:Int=255
	Field treecolor2:Int=230
	Field treecolor3:Int=200
	Field treecolor4:Int=155
	Field basecolor1:Int=100
	Method New(x:Int,y:Int,w:Int,h:Int)
		px = x
		py = y
		pw = w
		ph = h
		mapone = New Int[w][]
		For Local i:Int=0 Until w
			mapone[i] = New Int[h]
		Next
		maketree()
	End Method
	Method maketree()
		Local mx:Float=0.05
		Local my:Float=.1
		Local y:Float=1
		Local x:Float=pw/2+1
		Local base:Float=0
		Local bounce:Float=.1
		Local col:Int
		Local num:Float=2
		Local stap:Float=Rnd(0.001,0.005)
		Local stap2:Float=Rnd(0.01,0.2)
		While (y+5)<=(ph-(ph/20)) 

			y+=my
			x+=mx
			If x>=pw Then x=pw-2
			If x<=0 Then x=0
			If y<ph/1.4 Then col = treecolor4										
			If y<ph/1.6 Then col = treecolor3
			If y<ph/1.9 Then col = treecolor2
			If y<ph/4 Then col = treecolor1

			filltoleft(x,y,pw-x,col)
			mapone[x][y] = 1
			mapone[pw-x][y] = 1				


			mx-=stap
			If y<ph/1.45 Then 
				If mx<0 
					If x < ((pw/2)+num) Then mx=bounce ; bounce+=stap2 ; num+=1
				End If
				
			Else	
				If mx<0	
				If x<((pw/2)+num) Then bounce=.1 ; mx=bounce ; num-=1
				Endif
			End If
		Wend
		filltoleft(x,y,pw-x,1)
		
		maketreebase()
	End Method

	Method filltoleft(x:Int,y:Int,tox:Int,col:Int)
		Local ls:Int=(pw/2)
		Local len1:Int=(x-ls)/2
		Local len2:Int=(x-ls)/1.7		
		For Local x2:Int=x To tox Step -1
			mapone[x2][y] = col
			If col = treecolor2 Then
			If Rnd(4) < 1 And distance(x2,0,tox,0) < len1 And y<ph/2 Then mapone[x2][y] = treecolor1
			If Rnd(4) < 1 And distance(x2,0,x,0)< len1 And y<ph/2 Then mapone[x2][y] = treecolor1
			If Rnd(2)<1.3 And distance(x2,0,ls-len1,0) < 2 And y<ph/2 Then mapone[x2][y] = treecolor1
			If Rnd(2)<1.3 And distance(x2,0,ls+len1,0) < 2 And y<ph/2 Then mapone[x2][y] = treecolor1
			End If
			If col=treecolor1
			If Rnd(2) < 1 And y>5 And distance(x2,0,ls,0) < 3 Then mapone[x2][y] = treecolor2
			End If
			If col=treecolor3
			If Rnd(2)<1.3 And distance(x2,0,ls,0) < len2 And y<ph/1.8 Then mapone[x2][y] = treecolor2
			End If
			If col=treecolor4
			If Rnd(2)<1.3 And distance(x2,0,ls,0) < len2 And y<ph/1.5 Then mapone[x2][y] = treecolor3
			End If

		Next
	End Method
   Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)  
     Return Abs(x2-x1)+Abs(y2-y1)  
   End Function 
	Method maketreebase()
		For Local y:Int=ph-(ph/5) Until ph
		For Local x:Int=(pw/2)-(pw/8) Until (pw/2)+(pw/8)
			If x<0 Or y<0 Or x>=pw Or y>= ph Then Continue
			mapone[x][y] = basecolor1
		Next
		Next
	End Method
	
	Method draw()
		For Local y:Int=0 Until ph
		For Local x:Int=0 Until pw
			If mapone[x][y] = 0 Then Continue
			Select mapone[x][y]
				Case 1
					SetColor 0,0,0					
				Case treecolor1
					SetColor 0,treecolor1,0
				Case treecolor2
					SetColor 0,treecolor2,0
				Case treecolor3
					SetColor 0,treecolor3,0
				Case treecolor4
					SetColor 0,treecolor4,0
				Case basecolor1
					SetColor basecolor1,basecolor1/2,0
			End Select
			DrawRect px+(x*1),py+(y*1),1,1
		Next
		Next
	End Method
End Class

Class MyGame Extends App
	Field mytree:List<tree>
	Field time:Int=Millisecs()
	Field hw:Int=48,hh:Int=64
    Method OnCreate()
    	Seed = GetDate[4]*GetDate[5]
        SetUpdateRate(2)
		maketrees()
    End Method
    Method OnUpdate()        
		If KeyHit(KEY_SPACE) Or Millisecs() > time
			time=Millisecs()+2000
			maketrees
		End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 50,125,235        
        DrawRect 0,0,DeviceWidth,150+hh
		SetColor 50,155,255
        DrawRect 0,100,DeviceWidth,(150+hh)-100

        SetColor 5,250,5
        DrawRect 0,150+hh,DeviceWidth,DeviceHeight-(150+hh)
        SetColor 125,250,125
        DrawRect 0,150+hh,DeviceWidth,2
		
		For Local i:=Eachin mytree
        	i.draw()
        Next
             
    End Method
    Method maketrees()    	
    	mytree = New List<tree>
    	Local sy:Int=0
		For Local i:Int=0 Until 40
	        mytree.AddLast(New tree(Rnd(DeviceWidth),150+sy,48,64))			
	        sy+=10
		Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
