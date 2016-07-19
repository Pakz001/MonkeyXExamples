Import mojo

Class MyGame Extends App

	Field mylist1:List<String> = New StringList
	Field mylist2:List<String> = New StringList
	
    Method OnCreate()
        SetUpdateRate(60)
        mylist1.AddLast("hello")
        mylist1.AddLast("this")
        mylist1.AddLast("is")                
        mylist1.AddLast("a")
        mylist1.AddLast("test")
        mylist1.AddLast("mkay")
        'sort alphabetically
        mylist1.Sort()
        'list 2
        mylist2.AddLast("hello")
        mylist2.AddLast("this")
        mylist2.AddLast("is")                
        mylist2.AddLast("a")
        mylist2.AddLast("test")
        mylist2.AddLast("mkay")
        'sort reversed alhabetically
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
