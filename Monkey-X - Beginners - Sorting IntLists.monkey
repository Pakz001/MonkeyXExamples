Import mojo

Class MyGame Extends App

	Field mylist1:List<Int> = New IntList
	Field mylist2:List<Int> = New IntList
	
    Method OnCreate()
        SetUpdateRate(60)
        mylist1.AddLast(10)
        mylist1.AddLast(50)
        mylist1.AddLast(1)                
        mylist1.AddLast(31)
        mylist1.AddLast(93)
        mylist1.AddLast(12)
        'sort low>hight
        mylist1.Sort()
        'list 2
        mylist2.AddLast(10)
        mylist2.AddLast(50)
        mylist2.AddLast(1)                
        mylist2.AddLast(31)
        mylist2.AddLast(93)
        mylist2.AddLast(12)
        'sort high>low
        mylist2.Sort(False)

    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Sorting Lists",0,0
        Local cnt:Int=0
        For Local i:=Eachin mylist1
        	DrawText i,10,cnt*10+50
        	cnt+=1
        Next
        cnt=0
        For Local i:=Eachin mylist2
        	DrawText i,200,cnt*10+50
        	cnt+=1
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
