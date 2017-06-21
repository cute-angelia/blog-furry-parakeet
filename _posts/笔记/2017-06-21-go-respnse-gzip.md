---
title: go http response decode gzip
tags: [go]
---

### 方法一 

````
if response.StatusCode == 200 {
    var body []byte
    
    switch response.Header.Get("Content-Encoding") {
    		case "gzip":
    			reader, _ := gzip.NewReader(response.Body)
    			buf := make([]byte, 1024)
    			for {
    				read_len, err := reader.Read(buf)
    			
    				if err != nil && err != io.EOF {
    					panic(err)
    				}
    			
    				if read_len == 0 {
    					break
    				}
    				body = append(body, buf[:read_len]...)
    			}
    		default:
    			body, _ = ioutil.ReadAll(response.Body)
    		}
}
````

### 方法二

````

	if response.StatusCode == 200 {
		var body []byte
		buffer := bytes.NewBuffer(nil)
		switch response.Header.Get("Content-Encoding") {
		case "gzip":
			reader, _ := gzip.NewReader(response.Body)
			io.Copy(buffer, reader)
			body = buffer.Bytes()
		default:
			body, _ = ioutil.ReadAll(response.Body)
		}
	}
````