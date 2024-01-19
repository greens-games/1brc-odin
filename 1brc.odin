package main

import "core:fmt"
import "core:strconv"
import "core:io"
import "core:os"
import "core:strings"
import "core:bufio"
import "core:math"

Stats :: struct {

    min: f64,
    max: f64,
    sum: f64,
    count: i32


}

main :: proc() {

    buf_reading()
}


/*
1mrc (1 million rows) takes ~1second
1brc (1 billion rows) will take roughlt 10-15mins

This is not optimal also there's more memory safety we could probably do 
*/
buf_reading :: proc() {
    
    file_handle,err := os.open("input-data/1mrc.txt")
    defer os.close(file_handle)

    m := make(map[string]Stats)
    defer delete(m)

    r: bufio.Reader
    buff: [1024]byte
    bufio.reader_init_with_buf(&r, os.stream_from_handle(file_handle), buff[:])
    defer bufio.reader_destroy(&r)

    for {
        line, err := bufio.reader_read_string(&r, '\n')
        if err != nil {
            break
        }

        defer delete(line)
        tokens := strings.split(line, ";")
        if m[tokens[0]].count == 0 {

        }
        k := tokens[0] 
        v := m[k]
        if v.count != 0 {
            v.max = max(m[k].max, strconv.atof(tokens[1]))
            v.min = min(m[k].min, strconv.atof(tokens[1]))
        } else { 
            v.max = strconv.atof(tokens[1])
            v.min = strconv.atof(tokens[1])
        }
        v.sum += strconv.atof(tokens[1])
        v.count += 1

        m[k] = v
    }



    for k,v in m {
        fmt.printf("%s: min_value = %f64, max_value = %f64, mean = %f64 \n", k, v.min, v.max, v.sum/f64(v.count))
    }

}


/*
THIS IS WIP

Intention is to read in a chunk of some size
Check if the last value in that chunk is a new line
If it is not we will move the pointer for the file back to the last found new line and use that chunk

Issue currently:
    How do I move that pointer back maybe implement my own reader?
*/
buf_reading_read :: proc() {

    file_handle,err := os.open("input-data/input.txt")
    defer os.close(file_handle)

    b: bufio.Reader
    buff: [1024]byte
    bufio.reader_init_with_buf(&b, os.stream_from_handle(file_handle), buff[:])
    defer bufio.reader_destroy(&b)

/*

	b.r += n
	b.last_byte = int(b.buf[b.r-1])
	b.last_rune_size = -1
*/
    for {
        n, err := bufio.reader_read(&b, buff[:])
        if err != nil {
            break
        }


        // grab last char, if it is \n then we are ok to keep chunk
        //if it is not \n we want to go backwards until we hit \n and change b values to that where b from bufio = r in my world
        if buff[n-1] != 10 {
            for buff[n-1] != 10 {
                n -= 1
            }
            //save buff so we can do something with it
//            fmt.printf("%s\n",buff)
            //make it so we can move the pointer for the reader back

            fmt.printf("%i\n",b.r)
        } else {
//            fmt.printf("%s\n",buff)
            fmt.printf("%i\n",b.r)
        }
    }


}
