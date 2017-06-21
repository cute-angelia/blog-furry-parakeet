---
title: Go的50度灰：Golang新开发者要注意的陷阱和常见错误
tags: [go]
---

PDF -> [PDF](/assets/att/go-notice.pdf)


原文: [50 Shades of Go: Traps, Gotchas, and Common Mistakes for New Golang Devs](http://devs.cloudimmunity.com/gotchas-and-common-mistakes-in-go-golang/)
翻译: [Go的50度灰：新Golang开发者要注意的陷阱、技巧和常见错误](http://www.shwley.com/index.php/archives/80/), 译者: 影风LEY

Go是一门简单有趣的语言，但与其他语言类似，它会有一些技巧。。。这些技巧的绝大部分并不是Go的缺陷造成的。如果你以前使用的是其他语言，那么这其中的有些错误就是很自然的陷阱。其它的是由错误的假设和缺少细节造成的。

如果你花时间学习这门语言，阅读官方说明、wiki、邮件列表讨论、大量的优秀博文和Rob Pike的展示，以及源代码，这些技巧中的绝大多数都是显而易见的。尽管不是每个人都是以这种方式开始学习的，但也没关系。如果你是Go语言新人，那么这里的信息将会节约你大量的调试代码的时间。


筛选了几条

### 初级

1. 偶然的变量隐藏Accidental Variable Shadowing

短式变量声明的语法如此的方便（尤其对于那些使用过动态语言的开发者而言），很容易让人把它当成一个正常的分配操作。如果你在一个新的代码块中犯了这个错误，将不会出现编译错误，但你的应用将不会做你所期望的事情。

````
package main
import "fmt"
func main() {  
    x := 1
    fmt.Println(x)     //prints 1
    {
        fmt.Println(x) //prints 1
        x := 2
        fmt.Println(x) //prints 2
    }
    fmt.Println(x)     //prints 1 (bad if you need 2)
}
````

即使对于经验丰富的Go开发者而言，这也是一个非常常见的陷阱。这个坑很容易挖，但又很难发现。

你可以使用`vet`命令来发现一些这样的问题。 默认情况下， `vet`不会执行这样的检查，你需要设置`-shadow`参数：
`go tool vet -shadow your_file.go`。

2. 不使用显式类型，无法使用“nil”来初始化变量

`nil` 标志符用于表示`interface`、`函数`、`maps`、`slices`和`channels`的“零值”。如果你不指定变量的类型，编译器将无法编译你的代码，因为它猜不出具体的类型。

````
package main
func main() {  
    var x = nil //error
    _ = x
}
````

3. 使用“nil” Slices and Maps
   
在一个nil的slice中添加元素是没问题的，但对一个map做同样的事将会生成一个运行时的panic。

Works:

````
package main
func main() {  
    var s []int
    s = append(s,1)
}

````

Fails:

````
package main
func main() {  
    var m map[string]int
    m["one"] = 1 //error
}
````

4. Map的容量

你可以在map创建时指定它的容量，但你无法在map上使用cap()函数。

````
package main
func main() {  
    m := make(map[string]int,99)
    cap(m) //error
}
````

5. 字符串不会为nil

这对于经常使用nil分配字符串变量的开发者而言是个需要注意的地方。

````
package main
func main() {  
    var x string = nil //error
    if x == nil { //error -> right is ""
        x = "default"
    }
}
````

6. Array函数的参数

如果你是一个C或则C++开发者，那么数组对你而言就是指针。当你向函数中传递数组时，函数会参照相同的内存区域，这样它们就可以修改原始的数据。Go中的数组是数值，因此当你向函数中传递数组时，函数会得到原始数组数据的一份复制。如果你打算更新数组的数据，这将会是个问题。

````
package main
import "fmt"
func main() {  
    x := [3]int{1,2,3}
    func(arr [3]int) {
        arr[0] = 7
        fmt.Println(arr) //prints [7 2 3]
    }(x)
    fmt.Println(x) //prints [1 2 3] (not ok if you need [7 2 3])
}

````

如果你需要更新原始数组的数据，你可以使用数组指针类型。

````
package main
import "fmt"
func main() {  
    x := [3]int{1,2,3}
    func(arr *[3]int) {
        (*arr)[0] = 7
        fmt.Println(arr) //prints &[7 2 3]
    }(&x)
    fmt.Println(x) //prints [7 2 3]
}
````

另一个选择是使用slice。即使你的函数得到了slice变量的一份拷贝，它依旧会参照原始的数据。

````
package main
import "fmt"
func main() {  
    x := []int{1,2,3}
    func(arr []int) {
        arr[0] = 7
        fmt.Println(arr) //prints [7 2 3]
    }(x)
    fmt.Println(x) //prints [7 2 3]
}
````

7. 在Slice和Array使用“range”语句时的出现的不希望得到的值

如果你在其他的语言中使用“for-in”或者“foreach”语句时会发生这种情况。Go中的“range”语法不太一样。它会得到两个值：第一个值是元素的索引，而另一个值是元素的数据。

BAD:

````
package main
import "fmt"
func main() {  
    x := []string{"a","b","c"}
    for v := range x {
        fmt.Println(v) //prints 0, 1, 2
    }
}
````

Good:

````
package main
import "fmt"
func main() {  
    x := []string{"a","b","c"}
    for _, v := range x {
        fmt.Println(v) //prints a, b, c
    }
}
````

8. Slices和Arrays是一维的

看起来Go好像支持多维的Array和Slice，但不是这样的。尽管可以创建数组的数组或者切片的切片。对于依赖于动态多维数组的数值计算应用而言，Go在性能和复杂度上还相距甚远。

你可以使用纯一维数组、“独立”切片的切片，“共享数据”切片的切片来构建动态的多维数组。

如果你使用纯一维的数组，你需要处理索引、边界检查、当数组需要变大时的内存重新分配。

使用“独立”slice来创建一个动态的多维数组需要两步。首先，你需要创建一个外部的slice。然后，你需要分配每个内部的slice。内部的slice相互之间独立。你可以增加减少它们，而不会影响其他内部的slice。

````
package main
func main() {  
    x := 2
    y := 4
    table := make([][]int,x)
    for i:= range table {
        table[i] = make([]int,y)
    }
}
````

使用“共享数据”slice的slice来创建一个动态的多维数组需要三步。首先，你需要创建一个用于存放原始数据的数据“容器”。然后，你再创建外部的slice。最后，通过重新切片原始数据slice来初始化各个内部的slice。

````
package main
import "fmt"
func main() {  
    h, w := 2, 4
    raw := make([]int,h*w)
    for i := range raw {
        raw[i] = i
    }
    fmt.Println(raw,&raw[4])
    //prints: [0 1 2 3 4 5 6 7] <ptr_addr_x>
    table := make([][]int,h)
    for i:= range table {
        table[i] = raw[i*w:i*w + w]
    }
    fmt.Println(table,&table[1][0])
    //prints: [[0 1 2 3] [4 5 6 7]] <ptr_addr_x>
}
````

关于多维array和slice已经有了专门申请，但现在看起来这是个低优先级的特性。

9. 访问不存在的Map Keys

这对于那些希望得到“nil”标示符的开发者而言是个技巧（和其他语言中做的一样）。如果对应的数据类型的“零值”是“nil”，那返回的值将会是“nil”，但对于其他的数据类型是不一样的。检测对应的“零值”可以用于确定map中的记录是否存在，但这并不总是可信（比如，如果在二值的map中“零值”是false，这时你要怎么做）。检测给定map中的记录是否存在的最可信的方法是，通过map的访问操作，检查第二个返回的值。

bad:

````
package main
import "fmt"
func main() {  
    x := map[string]string{"one":"a","two":"","three":"c"}
    if v := x["two"]; v == "" { //incorrect
        fmt.Println("no entry")
    }
}
````

good:

````
package main
import "fmt"
func main() {  
    x := map[string]string{"one":"a","two":"","three":"c"}
    if _,ok := x["two"]; !ok {
        fmt.Println("no entry")
    }
}
````

10. Strings无法修改

尝试使用索引操作来更新字符串变量中的单个字符将会失败。string是只读的byte slice（和一些额外的属性）。如果你确实需要更新一个字符串，那么使用byte slice，并在需要时把它转换为string类型。

Fails:

````
package main

import "fmt"

func main() {  
    x := "text"
    x[0] = 'T'
    fmt.Println(x)
}
````

> main.go:7: cannot assign to x[0]

Works:

````
package main
import "fmt"
func main() {  
    x := "text"
    xbytes := []byte(x)
    xbytes[0] = 'T'
    fmt.Println(string(xbytes)) //prints Text
}
````

需要注意的是：这并不是在文字string中更新字符的正确方式，因为给定的字符可能会存储在多个byte中。如果你确实需要更新一个文字string，先把它转换为一个rune slice。即使使用rune slice，单个字符也可能会占据多个rune，比如当你的字符有特定的重音符号时就是这种情况。这种复杂又模糊的“字符”本质是Go字符串使用byte序列表示的原因。

11. String和Byte Slice之间的转换

当你把一个字符串转换为一个byte slice（或者反之）时，你就得到了一个原始数据的完整拷贝。这和其他语言中cast操作不同，也和新的slice变量指向原始byte slice使用的相同数组时的重新slice操作不同。

Go在[]byte到string和string到[]byte的转换中确实使用了一些优化来避免额外的分配（在todo列表中有更多的优化）。

第一个优化避免了当[]byte keys用于在map[string]集合中查询时的额外分配:m[string(key)]。

第二个优化避免了字符串转换为[]byte后在for range语句中的额外分配：for i,v := range []byte(str) {...}。

12. String和索引操作

字符串上的索引操作返回一个byte值，而不是一个字符（和其他语言中的做法一样）。

````
package main
import "fmt"
func main() {  
    x := "text"
    fmt.Println(x[0]) //print 116
    fmt.Printf("%T",x[0]) //prints uint8
}
````

如果你需要访问特定的字符串“字符”（unicode编码的points/runes），使用for range。官方的“unicode/utf8”包和实验中的utf8string包（golang.org/x/exp/utf8string）也可以用。utf8string包中包含了一个很方便的At()方法。把字符串转换为rune的切片也是一个选项。


13. 字符串不总是UTF8文本

字符串的值不需要是UTF8的文本。它们可以包含任意的字节。只有在string literal使用时，字符串才会是UTF8。即使之后它们可以使用转义序列来包含其他的数据。

为了知道字符串是否是UTF8，你可以使用“unicode/utf8”包中的ValidString()函数。

````
package main
import (  
    "fmt"
    "unicode/utf8"
)
func main() {  
    data1 := "ABC"
    fmt.Println(utf8.ValidString(data1)) //prints: true
    data2 := "A\xfeC"
    fmt.Println(utf8.ValidString(data2)) //prints: false
}
````

14. 字符串的长度

让我们假设你是Python开发者，你有下面这段代码：

````
data = u'♥'  
print(len(data)) #prints: 1
````

````
package main
import "fmt"
func main() {  
    data := "♥"
    fmt.Println(len(data)) //prints: 3
}
````

建的len()函数返回byte的数量，而不是像Python中计算好的unicode字符串中字符的数量。

要在Go中得到相同的结果，可以使用“unicode/utf8”包中的RuneCountInString()函数。

````
package main
import (  
    "fmt"
    "unicode/utf8"
)
func main() {  
    data := "♥"
    fmt.Println(utf8.RuneCountInString(data)) //prints: 1
}
````
理论上说RuneCountInString()函数并不返回字符的数量，因为单个字符可能占用多个rune。

````
package main
import (  
    "fmt"
    "unicode/utf8"
)
func main() {  
    data := "é"
    fmt.Println(len(data))                    //prints: 3
    fmt.Println(utf8.RuneCountInString(data)) //prints: 2
}
````

15. log.Fatal和log.Panic不仅仅是Log

Logging库一般提供不同的log等级。与这些logging库不同，Go中log包在你调用它的Fatal*()和Panic*()函数时，可以做的不仅仅是log。当你的应用调用这些函数时，Go也将会终止应用 :-)

````
package main
import "log"
func main() {  
    log.Fatalln("Fatal Level: log entry") //app exits here
    log.Println("Normal Level: log entry")
}
````

16. 内建的数据结构操作不是同步的

即使Go本身有很多特性来支持并发，并发安全的数据集合并不是其中之一 :-)确保数据集合以原子的方式更新是你的职责。Goroutines和channels是实现这些原子操作的推荐方式，但你也可以使用“sync”包，如果它对你的应用有意义的话。

17. String在“range”语句中的迭代值

索引值（“range”操作返回的第一个值）是返回的第二个值的当前“字符”（unicode编码的point/rune）的第一个byte的索引。它不是当前“字符”的索引，这与其他语言不同。注意真实的字符可能会由多个rune表示。如果你需要处理字符，确保你使用了“norm”包（golang.org/x/text/unicode/norm）。

string变量的for range语句将会尝试把数据翻译为UTF8文本。对于它无法理解的任何byte序列，它将返回0xfffd runes（即unicode替换字符），而不是真实的数据。如果你任意（非UTF8文本）的数据保存在string变量中，确保把它们转换为byte slice，以得到所有保存的数据。

````
package main
import "fmt"
func main() {  
    data := "A\xfe\x02\xff\x04"
    for _,v := range data {
        fmt.Printf("%#x ",v)
    }
    //prints: 0x41 0xfffd 0x2 0xfffd 0x4 (not ok)
    fmt.Println()
    for _,v := range []byte(data) {
        fmt.Printf("%#x ",v)
    }
    //prints: 0x41 0xfe 0x2 0xff 0x4 (good)
}
````

18. 对Map使用“for range”语句迭代

如果你希望以某个顺序（比如，按key值排序）的方式得到元素，就需要这个技巧。每次的map迭代将会生成不同的结果。Go的runtime有心尝试随机化迭代顺序，但并不总会成功，这样你可能得到一些相同的map迭代结果。所以如果连续看到5个相同的迭代结果，不要惊讶。

````
package main
import "fmt"
func main() {  
    m := map[string]int{"one":1,"two":2,"three":3,"four":4}
    for k,v := range m {
        fmt.Println(k,v)
    }
}
````

19. "switch"声明中的失效行为

在“switch”声明语句中的“case”语句块在默认情况下会break。这和其他语言中的进入下一个“next”代码块的默认行为不同

````
package main
import "fmt"
func main() {  
    isSpace := func(ch byte) bool {
        switch(ch) {
        case ' ': //error
        case '\t':
            return true
        }
        return false
    }
    fmt.Println(isSpace('\t')) //prints true (ok)
    fmt.Println(isSpace(' '))  //prints false (not ok)
}
````

你可以通过在每个“case”块的结尾使用“fallthrough”，来强制“case”代码块进入。你也可以重写switch语句，来使用“case”块中的表达式列表。

````
package main
import "fmt"
func main() {  
    isSpace := func(ch byte) bool {
        switch(ch) {
        case ' ', '\t':
            return true
        }
        return false
    }
    fmt.Println(isSpace('\t')) //prints true (ok)
    fmt.Println(isSpace(' '))  //prints true (ok)
}
````

20. 自增和自减

许多语言都有自增和自减操作。不像其他语言，Go不支持前置版本的操作。你也无法在表达式中使用这两个操作符。

````
package main
import "fmt"
func main() {  
    data := []int{1,2,3}
    i := 0
    ++i //error
    fmt.Println(data[i++]) //error
}
````

works:

````
package main
import "fmt"
func main() {  
    data := []int{1,2,3}
    i := 0
    i++
    fmt.Println(data[i])
}
````

21. 按位NOT操作

许多语言使用 ~作为一元的NOT操作符（即按位补足），但Go为了这个重用了XOR操作符（^）。

````
package main
import "fmt"
func main() {  
    var d uint8 = 2
    fmt.Printf("%08b\n",^d)
}
````

Go依旧使用^作为XOR的操作符，这可能会让一些人迷惑。

如果你愿意，你可以使用一个二元的XOR操作（如， 0x02 XOR 0xff）来表示一个一元的NOT操作（如，NOT 0x02）。这可以解释为什么^被重用来表示一元的NOT操作。

Go也有特殊的‘AND NOT’按位操作（&^），这也让NOT操作更加的让人迷惑。这看起来需要特殊的特性/hack来支持 A AND (NOT B)，而无需括号。

````
package main
import "fmt"
func main() {  
    var a uint8 = 0x82
    var b uint8 = 0x02
    fmt.Printf("%08b [A]\n",a)
    fmt.Printf("%08b [B]\n",b)
    fmt.Printf("%08b (NOT B)\n",^b)
    fmt.Printf("%08b ^ %08b = %08b [B XOR 0xff]\n",b,0xff,b ^ 0xff)
    fmt.Printf("%08b ^ %08b = %08b [A XOR B]\n",a,b,a ^ b)
    fmt.Printf("%08b & %08b = %08b [A AND B]\n",a,b,a & b)
    fmt.Printf("%08b &^%08b = %08b [A 'AND NOT' B]\n",a,b,a &^ b)
    fmt.Printf("%08b&(^%08b)= %08b [A AND (NOT B)]\n",a,b,a & (^b))
}
````

22. 操作优先级的差异
    
除了”bit clear“操作（&^），Go也一个与许多其他语言共享的标准操作符的集合。尽管操作优先级并不总是一样。

````
package main
import "fmt"
func main() {  
    fmt.Printf("0x2 & 0x2 + 0x4 -> %#x\n",0x2 & 0x2 + 0x4)
    //prints: 0x2 & 0x2 + 0x4 -> 0x6
    //Go:    (0x2 & 0x2) + 0x4
    //C++:    0x2 & (0x2 + 0x4) -> 0x2
    fmt.Printf("0x2 + 0x2 << 0x1 -> %#x\n",0x2 + 0x2 << 0x1)
    //prints: 0x2 + 0x2 << 0x1 -> 0x6
    //Go:     0x2 + (0x2 << 0x1)
    //C++:   (0x2 + 0x2) << 0x1 -> 0x8
    fmt.Printf("0xf | 0x2 ^ 0x2 -> %#x\n",0xf | 0x2 ^ 0x2)
    //prints: 0xf | 0x2 ^ 0x2 -> 0xd
    //Go:    (0xf | 0x2) ^ 0x2
    //C++:    0xf | (0x2 ^ 0x2) -> 0xf
}
````

23. 未导出的结构体不会被编码

以小写字母开头的结构体将不会被（json、xml、gob等）编码，因此当你编码这些未导出的结构体时，你将会得到零值

````
package main
import (  
    "fmt"
    "encoding/json"
)
type MyData struct {  
    One int
    two string
}
func main() {  
    in := MyData{1,"two"}
    fmt.Printf("%#v\n",in) //prints main.MyData{One:1, two:"two"}
    encoded,_ := json.Marshal(in)
    fmt.Println(string(encoded)) //prints {"One":1}
    var out MyData
    json.Unmarshal(encoded,&out)
    fmt.Printf("%#v\n",out) //prints main.MyData{One:1, two:""}
}
````

24. 有活动的Goroutines下的应用退出
    
应用将不会等待所有的goroutines完成。这对于初学者而言是个很常见的错误。每个人都是以某个程度开始，因此如果犯了初学者的错误也没神马好丢脸的 :-)

````
package main
import (  
    "fmt"
    "time"
)
func main() {  
    workerCount := 2
    for i := 0; i < workerCount; i++ {
        go doit(i)
    }
    time.Sleep(1 * time.Second)
    fmt.Println("all done!")
}
func doit(workerId int) {  
    fmt.Printf("[%v] is running\n",workerId)
    time.Sleep(3 * time.Second)
    fmt.Printf("[%v] is done\n",workerId)
}
````

一个最常见的解决方法是使用“WaitGroup”变量。它将会让主goroutine等待所有的worker goroutine完成。如果你的应用有长时运行的消息处理循环的worker，你也将需要一个方法向这些goroutine发送信号，让它们退出。你可以给各个worker发送一个“kill”消息。另一个选项是关闭一个所有worker都接收的channel。这是一次向所有goroutine发送信号的简单方式。


````
package main
import (  
    "fmt"
    "sync"
)
func main() {  
    var wg sync.WaitGroup
    done := make(chan struct{})
    workerCount := 2
    for i := 0; i < workerCount; i++ {
        wg.Add(1)
        go doit(i,done,wg)
    }
    close(done)
    wg.Wait()
    fmt.Println("all done!")
}
func doit(workerId int,done <-chan struct{},wg sync.WaitGroup) {  
    fmt.Printf("[%v] is running\n",workerId)
    defer wg.Done()
    <- done
    fmt.Printf("[%v] is done\n",workerId)
}
````

	
fatal error: all goroutines are asleep - deadlock!
这可不太好 :-) 发送了神马？为什么会出现死锁？worker退出了，它们也执行了wg.Done()。应用应该没问题啊。

死锁发生是因为各个worker都得到了原始的“WaitGroup”变量的一个拷贝。当worker执行wg.Done()时，并没有在主goroutine上的“WaitGroup”变量上生效。

````
package main
import (  
    "fmt"
    "sync"
)
func main() {  
    var wg sync.WaitGroup
    done := make(chan struct{})
    wq := make(chan interface{})
    workerCount := 2
    for i := 0; i < workerCount; i++ {
        wg.Add(1)
        go doit(i,wq,done,&wg)
    }
    for i := 0; i < workerCount; i++ {
        wq <- i
    }
    close(done)
    wg.Wait()
    fmt.Println("all done!")
}
func doit(workerId int, wq <-chan interface{},done <-chan struct{},wg *sync.WaitGroup) {  
    fmt.Printf("[%v] is running\n",workerId)
    defer wg.Done()
    for {
        select {
        case m := <- wq:
            fmt.Printf("[%v] m => %v\n",workerId,m)
        case <- done:
            fmt.Printf("[%v] is done\n",workerId)
            return
        }
    }
}
````

25. 向无缓存的Channel发送消息，只要目标接收者准备好就会立即返回

发送者将不会被阻塞，除非消息正在被接收者处理。根据你运行代码的机器的不同，接收者的goroutine可能会或者不会有足够的时间，在发送者继续执行前处理消息。

````
package main
import "fmt"
func main() {  
    ch := make(chan string)
    go func() {
        for m := range ch {
            fmt.Println("processed:",m)
        }
    }()
    ch <- "cmd.1"
    ch <- "cmd.2" //won't be processed
}
````

26. 向已关闭的Channel发送会引起Panic

从一个关闭的channel接收是安全的。在接收状态下的ok的返回值将被设置为false，这意味着没有数据被接收。如果你从一个有缓存的channel接收，你将会首先得到缓存的数据，一旦它为空，返回的ok值将变为false。

向关闭的channel中发送数据会引起panic。这个行为有文档说明，但对于新的Go开发者的直觉不同，他们可能希望发送行为与接收行为很像。

````
package main
import (  
    "fmt"
    "time"
)
func main() {  
    ch := make(chan int)
    for i := 0; i < 3; i++ {
        go func(idx int) {
            ch <- (idx + 1) * 2
        }(i)
    }
    
    //get the first result
    fmt.Println(<-ch)
    close(ch) //not ok (you still have other senders)
    //do other work
    time.Sleep(2 * time.Second)
}
````

根据不同的应用，修复方法也将不同。可能是很小的代码修改，也可能需要修改应用的设计。无论是哪种方法，你都需要确保你的应用不会向关闭的channel中发送数据。

上面那个有bug的例子可以通过使用一个特殊的废弃的channel来向剩余的worker发送不再需要它们的结果的信号来修复。

````
package main
import (  
    "fmt"
    "time"
)
func main() {  
    ch := make(chan int)
    done := make(chan struct{})
    for i := 0; i < 3; i++ {
        go func(idx int) {
            select {
            case ch <- (idx + 1) * 2: fmt.Println(idx,"sent result")
            case <- done: fmt.Println(idx,"exiting")
            }
        }(i)
    }
    //get first result
    fmt.Println("result:",<-ch)
    close(done)
    //do other work
    time.Sleep(3 * time.Second)
}
````

27. 使用"nil" Channels

在一个nil的channel上发送和接收操作会被永久阻塞。这个行为有详细的文档解释，但它对于新的Go开发者而言是个惊喜。

````
package main
import (  
    "fmt"
    "time"
)
func main() {  
    var ch chan int
    for i := 0; i < 3; i++ {
        go func(idx int) {
            ch <- (idx + 1) * 2
        }(i)
    }
    //get first result
    fmt.Println("result:",<-ch)
    //do other work
    time.Sleep(2 * time.Second)
}
````
如果运行代码你将会看到一个runtime错误：

	
fatal error: all goroutines are asleep - deadlock!


这个行为可以在select声明中用于动态开启和关闭case代码块的方法。

````
package main
import "fmt"  
import "time"
func main() {  
    inch := make(chan int)
    outch := make(chan int)
    go func() {
        var in <- chan int = inch
        var out chan <- int
        var val int
        for {
           select {
            case out <- val:
                out = nil
                in = inch
            case val = <- in:
                out = outch
                in = nil
            }
        }
    }()
    go func() {
        for r := range outch {
            fmt.Println("result:",r)
        }
    }()
    time.Sleep(0)
    inch <- 1
    inch <- 2
    time.Sleep(3 * time.Second)
}
````

28. 传值方法的接收者无法修改原有的值
    
方法的接收者就像常规的函数参数。如果声明为值，那么你的函数/方法得到的是接收者参数的拷贝。这意味着对接收者所做的修改将不会影响原有的值，除非接收者是一个map或者slice变量，而你更新了集合中的元素，或者你更新的域的接收者是指针。

````
package main
import "fmt"
type data struct {  
    num int
    key *string
    items map[string]bool
}
func (this *data) pmethod() {  
    this.num = 7
}
func (this data) vmethod() {  
    this.num = 8
    *this.key = "v.key"
    this.items["vmethod"] = true
}
func main() {  
    key := "key.1"
    d := data{1,&key,make(map[string]bool)}
    fmt.Printf("num=%v key=%v items=%v\n",d.num,*d.key,d.items)
    //prints num=1 key=key.1 items=map[]
    d.pmethod()
    fmt.Printf("num=%v key=%v items=%v\n",d.num,*d.key,d.items) 
    //prints num=7 key=key.1 items=map[]
    d.vmethod()
    fmt.Printf("num=%v key=%v items=%v\n",d.num,*d.key,d.items)
    //prints num=7 key=v.key items=map[vmethod:true]
}
````

### 中级

1. 关闭HTTP的响应

当你使用标准http库发起请求时，你得到一个http的响应变量。如果你不读取响应主体，你依旧需要关闭它。注意对于空的响应你也一定要这么做。对于新的Go开发者而言，这个很容易就会忘掉。

一些新的Go开发者确实尝试关闭响应主体，但他们在错误的地方做。

````
package main
import (  
    "fmt"
    "net/http"
    "io/ioutil"
)
func main() {  
    resp, err := http.Get("https://api.ipify.org?format=json")
    defer resp.Body.Close()//not ok
    if err != nil {
        fmt.Println(err)
        return
    }
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(string(body))
}
````

这段代码对于成功的请求没问题，但如果http的请求失败，resp变量可能会是nil，这将导致一个runtime panic。

最常见的关闭响应主体的方法是在http响应的错误检查后调用defer。

````
package main
import (  
    "fmt"
    "net/http"
    "io/ioutil"
)
func main() {  
    resp, err := http.Get("https://api.ipify.org?format=json")
    if err != nil {
        fmt.Println(err)
        return
    }
    defer resp.Body.Close()//ok, most of the time :-)
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(string(body))
}
````

大多数情况下，当你的http响应失败时，resp变量将为nil，而err变量将是non-nil。然而，当你得到一个重定向的错误时，两个变量都将是non-nil。这意味着你最后依然会内存泄露。

通过在http响应错误处理中添加一个关闭non-nil响应主体的的调用来修复这个问题。另一个方法是使用一个defer调用来关闭所有失败和成功的请求的响应主体。

````
package main
import (  
    "fmt"
    "net/http"
    "io/ioutil"
)
func main() {  
    resp, err := http.Get("https://api.ipify.org?format=json")
    if resp != nil {
        defer resp.Body.Close()
    }
    if err != nil {
        fmt.Println(err)
        return
    }
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(string(body))
}
````

resp.Body.Close()的原始实现也会读取并丢弃剩余的响应主体数据。这确保了http的链接在keepalive http连接行为开启的情况下，可以被另一个请求复用。最新的http客户端的行为是不同的。现在读取并丢弃剩余的响应数据是你的职责。如果你不这么做，http的连接可能会关闭，而无法被重用。这个小技巧应该会写在Go 1.5的文档中。

如果http连接的重用对你的应用很重要，你可能需要在响应处理逻辑的后面添加像下面的代码：

	
_, err = io.Copy(ioutil.Discard, resp.Body)

如果你不立即读取整个响应将是必要的，这可能在你处理json API响应时会发生：

json.NewDecoder(resp.Body).Decode(&data)

2. 关闭HTTP的连接
   
一些HTTP服务器保持会保持一段时间的网络连接（根据HTTP 1.1的说明和服务器端的“keep-alive”配置）。默认情况下，标准http库只在目标HTTP服务器要求关闭时才会关闭网络连接。这意味着你的应用在某些条件下消耗完sockets/file的描述符。

你可以通过设置请求变量中的Close域的值为true，来让http库在请求完成时关闭连接。

另一个选项是添加一个Connection的请求头，并设置为close。目标HTTP服务器应该也会响应一个Connection: close的头。当http库看到这个响应头时，它也将会关闭连接。

````
package main
import (  
    "fmt"
    "net/http"
    "io/ioutil"
)
func main() {  
    req, err := http.NewRequest("GET","http://golang.org",nil)
    if err != nil {
        fmt.Println(err)
        return
    }
    req.Close = true
    //or do this:
    //req.Header.Add("Connection", "close")
    resp, err := http.DefaultClient.Do(req)
    if resp != nil {
        defer resp.Body.Close()
    }
    if err != nil {
        fmt.Println(err)
        return
    }
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(len(string(body)))
}
````

你也可以取消http的全局连接复用。你将需要为此创建一个自定义的http传输配置。

````
package main
import (  
    "fmt"
    "net/http"
    "io/ioutil"
)
func main() {  
    tr := &http.Transport{DisableKeepAlives: true}
    client := &http.Client{Transport: tr}
    resp, err := client.Get("http://golang.org")
    if resp != nil {
        defer resp.Body.Close()
    }
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(resp.StatusCode)
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(len(string(body)))
}
````

如果你向同一个HTTP服务器发送大量的请求，那么把保持网络连接的打开是没问题的。然而，如果你的应用在短时间内向大量不同的HTTP服务器发送一两个请求，那么在引用收到响应后立刻关闭网络连接是一个好主意。增加打开文件的限制数可能也是个好主意。当然，正确的选择源自于应用。

3. 比较Structs, Arrays, Slices, and Maps
   
如果结构体中的各个元素都可以用你可以使用等号来比较的话，那就可以使用相号, ==，来比较结构体变量。

````
package main
import "fmt"
type data struct {  
    num int
    fp float32
    complex complex64
    str string
    char rune
    yes bool
    events <-chan string
    handler interface{}
    ref *byte
    raw [10]byte
}
func main() {  
    v1 := data{}
    v2 := data{}
    fmt.Println("v1 == v2:",v1 == v2) //prints: v1 == v2: true
}
````

如果结构体中的元素无法比较，那使用等号将导致编译错误。注意数组仅在它们的数据元素可比较的情况下才可以比较。

````
package main
import "fmt"
type data struct {  
    num int                //ok
    checks [10]func() bool //not comparable
    doit func() bool       //not comparable
    m map[string] string   //not comparable
    bytes []byte           //not comparable
}
func main() {  
    v1 := data{}
    v2 := data{}
    fmt.Println("v1 == v2:",v1 == v2)
}
````

最常用的方法是使用reflect包中的DeepEqual()函数。


````
package main
import (  
    "fmt"
    "reflect"
)
type data struct {  
    num int                //ok
    checks [10]func() bool //not comparable
    doit func() bool       //not comparable
    m map[string] string   //not comparable
    bytes []byte           //not comparable
}
func main() {  
    v1 := data{}
    v2 := data{}
    fmt.Println("v1 == v2:",reflect.DeepEqual(v1,v2)) //prints: v1 == v2: true
    m1 := map[string]string{"one": "a","two": "b"}
    m2 := map[string]string{"two": "b", "one": "a"}
    fmt.Println("m1 == m2:",reflect.DeepEqual(m1, m2)) //prints: m1 == m2: true
    s1 := []int{1, 2, 3}
    s2 := []int{1, 2, 3}
    fmt.Println("s1 == s2:",reflect.DeepEqual(s1, s2)) //prints: s1 == s2: true
}

````

除了很慢（这个可能会也可能不会影响你的应用），DeepEqual()也有其他自身的技巧。

````
package main
import (  
    "fmt"
    "reflect"
)
func main() {  
    var b1 []byte = nil
    b2 := []byte{}
    fmt.Println("b1 == b2:",reflect.DeepEqual(b1, b2)) //prints: b1 == b2: false
}
````

DeepEqual()不会认为空的slice与“nil”的slice相等。这个行为与你使用bytes.Equal()函数的行为不同。bytes.Equal()认为“nil”和空的slice是相等的。


````
package main
import (  
    "fmt"
    "bytes"
)
func main() {  
    var b1 []byte = nil
    b2 := []byte{}
    fmt.Println("b1 == b2:",bytes.Equal(b1, b2)) //prints: b1 == b2: true
}
````

DeepEqual()在比较slice时并不总是完美的。

````
package main
import (  
    "fmt"
    "reflect"
    "encoding/json"
)
func main() {  
    var str string = "one"
    var in interface{} = "one"
    fmt.Println("str == in:",str == in,reflect.DeepEqual(str, in)) 
    //prints: str == in: true true
    v1 := []string{"one","two"}
    v2 := []interface{}{"one","two"}
    fmt.Println("v1 == v2:",reflect.DeepEqual(v1, v2)) 
    //prints: v1 == v2: false (not ok)
    data := map[string]interface{}{
        "code": 200,
        "value": []string{"one","two"},
    }
    encoded, _ := json.Marshal(data)
    var decoded map[string]interface{}
    json.Unmarshal(encoded, &decoded)
    fmt.Println("data == decoded:",reflect.DeepEqual(data, decoded)) 
    //prints: data == decoded: false (not ok)
}
````

如果你的byte slice（或者字符串）中包含文字数据，而当你要不区分大小写形式的值时（在使用==，bytes.Equal()，或者bytes.Compare()），你可能会尝试使用“bytes”和“string”包中的ToUpper()或者ToLower()函数。对于英语文本，这么做是没问题的，但对于许多其他的语言来说就不行了。这时应该使用strings.EqualFold()和bytes.EqualFold()。

如果你的byte slice中包含需要验证用户数据的隐私信息（比如，加密哈希、tokens等），不要使用reflect.DeepEqual()、bytes.Equal()，或者bytes.Compare()，因为这些函数将会让你的应用易于被定时攻击。为了避免泄露时间信息，使用'crypto/subtle'包中的函数（即，subtle.ConstantTimeCompare()）。

4. 从Panic中恢复

recover()函数可以用于获取/拦截panic。仅当在一个defer函数中被完成时，调用recover()将会完成这个小技巧。

Incorrect:

````
package main
import "fmt"
func main() {  
    recover() //doesn't do anything
    panic("not good")
    recover() //won't be executed :)
    fmt.Println("ok")
}
````

Works:

````
package main
import "fmt"
func main() {  
    defer func() {
        fmt.Println("recovered:",recover())
    }()
    panic("not good")
}
````
recover()的调用仅当它在defer函数中被直接调用时才有效。

Fails:

````
package main
import "fmt"
func doRecover() {  
    fmt.Println("recovered =>",recover()) //prints: recovered => <nil>
}
func main() {  
    defer func() {
        doRecover() //panic is not recovered
    }()
    panic("not good")
}
````




