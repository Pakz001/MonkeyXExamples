Import mojo

Class s
    Field txt:Int
    Method New(val)
        txt = val
    End Method
End Class

Class MyGame Extends App
    Field st:=New Stack<s>

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        If KeyHit(KEY_1)
            If st.Length() < 10
                st.Push New s(Rnd(100))
            End If
        End If
        If KeyHit(KEY_2)
            If Not st.IsEmpty()
                st.Pop                        
            End If
        End If
    End Method
    Method OnRender()
        Local h:Int = 0
        Cls(0,0,0)
        SetColor(255,255,255)

        For Local i:=Eachin st
            DrawText "Value in Stack : "+i.txt,10,40+h*10
            h+=1
        Next
        DrawText "Press 1 to add to the stack",10,10
        DrawText "Press 2 to remove from the stack",10,20
        DrawText st.Length()+" items in stack",320,10
    End
End

Function Main()
    New MyGame()
End
