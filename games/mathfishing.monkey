 
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
	Field listx:Stack<Int>  'x And y
	Field listy:Stack<Int> 
	Field lists:Stack<Bool> ' selected
	Field listt:Stack<Int> ' time left on screen
	Field listoption1:Stack<Int>
	Field listoption2:Stack<Int>
	Field listoption3:Stack<Int>
	Field listca:Stack<Int>
		'
	Field selected:Int=-1
	Method New()
	liststr = New Stack<String>
	listx = New Stack<Int>
	listy = New Stack<Int>
	lists = New Stack<Bool>
	listt = New Stack<Int>
	listoption1 = New Stack<Int>
	listoption2 = New Stack<Int>
	listoption3 = New Stack<Int>
	listca = New Stack<Int> 'correct answer	
	newfish()
	newfish()	
	End Method
	Method newfish()
		Local a:Int=Rnd(10)
		Local b:Int=Rnd(10)
		liststr.Push(String(a)+"+"+String(b))
		listx.Push(Rnd(100,400))
		listy.Push(Rnd(100,200))
		lists.Push(False)
		listt.Push(100)
		listoption1.Push(Rnd(100))
		listoption2.Push(Rnd(100))
		listoption3.Push(Rnd(100))
		Select Int(Rnd(3))
			Case 0
				listoption1.Set(liststr.Length-1,a+b)
				listca.Push(a+b)
			Case 1
				listoption2.Set(liststr.Length-1,a+b)
				listca.Push(a+b)
			Case 2
				listoption3.Set(liststr.Length-1,a+b)
				listca.Push(a+b)				
		End Select
	End Method
	Method update()
		' Select fishes
		If MouseDown(MOUSE_LEFT) Then
		For Local i:Int=0 Until liststr.Length
			If rectsoverlap(listx.Get(i),listy.Get(i),50,15,MouseX(),MouseY(),1,1)
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
				If listca.Get(selected) = listoption1.Get(selected) Then Print "answer1"
			Endif
			If rectsoverlap(500,300,50,15,MouseX(),MouseY(),1,1)'option 2
				If listca.Get(selected) = listoption2.Get(selected) Then Print "answer2"
			End If
			If rectsoverlap(450,400,50,15,MouseX(),MouseY(),1,1)'option 3
				If listca.Get(selected) = listoption3.Get(selected) Then Print "answer3"
			End If
		
		End If
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
			DrawText(liststr.Get(i),listx.Get(i),listy.Get(i))
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
