Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
		Local a:String[]
		Local b:String="This is a test man"
		a = b.Split(" ")
		DebugLog "variable b is : "+b
		DebugLog "We split variable b at the ' ' character"
		For Local i=0 Until a.Length
			DebugLog a[i]
		Next
		a = New String[1]
		b="0,1,2,3,4,5"
		a = b.Split(",")
		DebugLog "variable b is : "+b
		DebugLog "We split the variable b at the ',' character"
		For Local i=0 Until a.Length
			DebugLog a[i]
		next
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
