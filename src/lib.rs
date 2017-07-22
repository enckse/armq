extern crate libc;

use std::ffi::CStr;
use std::ffi::CString;
use libc::c_char;
use libc::c_int;
use libc::strncpy;
use std::io::prelude::*;
use std::net::TcpStream;

fn write_string(output: *mut c_char, src: &str) {
    let c_str = CString::new(src).unwrap();
    unsafe {strncpy(output, c_str.as_ptr(), src.len()) };
}

#[no_mangle]
#[cfg_attr(all(target_os="windows", target_arch = "x86"),export_name="_RVExtension@12")]
pub extern "C" fn RVExtension(output: *mut c_char, output_size: c_int, function: *const c_char) {
    let f_str = unsafe { CStr::from_ptr(function).to_str().unwrap() };
    let o_str: String;
    if f_str == "version" {
        o_str = String::from("0.0.1");
    }
    else {
        let mut stream = TcpStream::connect("127.0.0.1:34254").unwrap();
        let _ = stream.write(f_str.as_bytes());
        o_str = String::from("done");
    }

    write_string(output, &o_str);
}
