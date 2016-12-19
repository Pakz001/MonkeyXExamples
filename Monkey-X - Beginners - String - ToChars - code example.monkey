Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        ' create a array with array with the character codes of each
        ' character in a string.
		Local a:Int[]
		Local b:String="abcdefghijklmnopqrstuvwxyz"
		a = b.ToChars()
		Local deb:String
		For Local i=0 Until a.Length
			deb+=b[i..i+1]+"="+a[i]+","
		Next
		DebugLog deb
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
