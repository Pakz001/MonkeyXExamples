 
 '
 ' Math Fishing
 '
 ' Fishes swim top of the screen. They appear as a SUM (10+10) the can be selected and then
 ' at the bottom right of the screen 3 answers appear. By selecting the right one then the fish is
 ' added to the inventory(score). Each fish has a timeout. If this time gets to zero then the fish 
 ' dissapears. At a wrong answer the fish also dissapears.
 ' New fish gets added when a fish dissapears.
 
 ' Add - swim, -*/, select answers,


Import mojo

Class fish
	Field liststr:Stack<String>	'the sum to catch
	Field listx:Stack<Float>  'x And y
	Field listy:Stack<Float> 
	Field lists:Stack<Bool> ' selected
	Field listt:Stack<Int> ' time left on screen
	Field listoption1:Stack<Int>
	Field listoption2:Stack<Int>
	Field listoption3:Stack<Int>
	Field listca:Stack<Int> 'correct answer
	Field listmx:Stack<Float>
	Field listmy:Stack<Float>
		'
	Field selected:Int=-1
	Method New()
	liststr = New Stack<String>
	listx = New Stack<Float>
	listy = New Stack<Float>
	lists = New Stack<Bool>
	listt = New Stack<Int>
	listoption1 = New Stack<Int>
	listoption2 = New Stack<Int>
	listoption3 = New Stack<Int>
	listca = New Stack<Int> 'correct answer	
	listmx = New Stack<Float>
	listmy = New Stack<Float>

	newfish()
	newfish()	
	End Method
	Method newfish()
		Local a:Int=Rnd(10)
		Local b:Int=Rnd(10)
		Local t:Int=Rnd(3)
		Local answer:Int
		Select t
			Case 0
			liststr.Push(String(a)+"+"+String(b))
			answer = a+b
			Case 1
			liststr.Push(String(a)+"-"+String(b))
			answer = a-b
			Case 2
			liststr.Push(String(a)+"*"+String(b))
			answer = a*b
		End Select
		listx.Push(Rnd(100,400))
		listy.Push(Rnd(100,200))
		lists.Push(False)
		listt.Push(250)+Rnd(250)
		listmx.Push(Rnd(-.4,.4))
		listmy.Push(Rnd(-.4,.4))
		listoption1.Push(Rnd(100))
		listoption2.Push(Rnd(100))
		listoption3.Push(Rnd(100))
		Select Int(Rnd(3))
			Case 0
				listoption1.Set(liststr.Length-1,answer)
				listca.Push(answer)
			Case 1
				listoption2.Set(liststr.Length-1,answer)
				listca.Push(answer)
			Case 2
				listoption3.Set(liststr.Length-1,answer)
				listca.Push(answer)				
		End Select
	End Method
	Method update()
		' Select fishes
		If MouseDown(MOUSE_LEFT) Then
		For Local i:Int=0 Until liststr.Length
			If rectsoverlap(listx.Get(i)-10,listy.Get(i)-10,70,25,MouseX(),MouseY(),1,1)
				'erase other selected flags
				For Local j:Int=0 Until liststr.Length
					lists.Set(j,False)
				Next
				' set new selected
				lists.Set(i,True)	
				selected = i
			End If	
		Next
		End If

		'Select answers
		If MouseDown(MOUSE_LEFT) And selected <> -1 Then		
			If rectsoverlap(400,300,50,15,MouseX(),MouseY(),1,1)'option 1
				If listca.Get(selected) = listoption1.Get(selected) Then 
					Print "answer1"
					remove(selected)
					selected = -1
					newfish()
				Else
					'remove(selected)
					Print "wrong"
					listmx.Set(selected,listmx.Get(selected)*15)
					listmy.Set(selected,listmy.Get(selected)*15)
					lists.Set(selected,False)
					selected=-1
					'newfish()
				End If
			Endif
			If rectsoverlap(500,300,50,15,MouseX(),MouseY(),1,1)'option 2
				If listca.Get(selected) = listoption2.Get(selected) Then 
				Print "answer2";remove(selected);newfish();selected=-1
				Else

'					remove(selected)
					Print "wrong"
					listmx.Set(selected,listmx.Get(selected)*15)
					listmy.Set(selected,listmy.Get(selected)*15)
					lists.Set(selected,False)
					selected=-1
'					newfish()
				End If
			End If
			If rectsoverlap(450,400,50,15,MouseX(),MouseY(),1,1)'option 3
				If listca.Get(selected) = listoption3.Get(selected) Then 
				Print "answer3";remove(selected);newfish();selected=-1
				Else
'					remove(selected)
					Print "wrong"
					listmx.Set(selected,listmx.Get(selected)*15)
					listmy.Set(selected,listmy.Get(selected)*15)
					lists.Set(selected,False)					
					selected=-1
'					newfish()

				End If
			End If
		
		End If
		
		
		'move fish
		For Local i:Int=0 Until liststr.Length
			listx.Set(i,listx.Get(i)+listmx.Get(i))
			listy.Set(i,listy.Get(i)+listmy.Get(i))
		Next
		' timeoutfish
		For Local i:Int=0 Until liststr.Length
			listt.Set(i,listt.Get(i)-1)
		Next
		For Local i:Int=0 Until liststr.Length
			If listt.Get(i) < 0 Then 
				remove(i) 
				newfish()
				If i = selected Then selected = -1
				If selected>i Then selected-=1
			End If
		Next		
	End Method
	Method remove(num:Int)
		liststr.Remove(num)
		listx.Remove(num)
		listy.Remove(num)
		lists.Remove(num)
		listt.Remove(num)
		listca.Remove(num)
		listmx.Remove(num)
		listmy.Remove(num)
		listoption1.Remove(num)
		listoption2.Remove(num)
		listoption3.Remove(num)				
	End Method
	Method drawtext2(s:String,x:Float,y:Float)
		Local sw:Int=TextWidth(s)
		DrawText(s,x,y)
		x-=16
		y-=5
		DrawPoly([Float(x),Float(y),Float(x)+Float(10),Float(y)+Float(10),Float(x),Float(y)+Float(20)])
		x+=sw+20
		DrawPoly([Float(x),Float(y)+7.0,Float(x)+Float(10),Float(y)+Float(14),Float(x),Float(y)+Float(17)])		
	End Method
	Method draw()
		If selected <> -1
		DrawText(listoption1.Get(selected),400,300)
		DrawText(listoption2.Get(selected),500,300)
		DrawText(listoption3.Get(selected),450,400)
		End If
		For Local i:Int=0 Until liststr.Length
			' If the fish is selected then color the SUM yellow else white
			If lists.Get(i) = True Then
				SetColor 255,255,0
			Else	
				SetColor 255,255,255
			End If
			' Draw the fish
			drawtext2(liststr.Get(i),listx.Get(i),listy.Get(i))
		Next
	End Method
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	
End Class

Global myfish:fish

Class MyGame Extends App
	
    Method OnCreate()
        SetUpdateRate(60)
        myfish = New fish()
    End Method
    Method OnUpdate()        
    	myfish.update()
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        myfish.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
