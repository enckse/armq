extern crate libc;

use std::ffi::CStr;
use std::ffi::CString;
use libc::c_char;
use libc::size_t;
use libc::strncpy;

fn write_string(output: *mut c_char, src: &str, output_size: size_t) {
    let c_str = CString::new(src).unwrap();
    unsafe { strncpy(output, c_str.as_ptr(), output_size) };
}

#[allow(non_snake_case)]
#[no_mangle]
#[cfg_attr(all(target_os = "windows", target_arch = "x86"), export_name = "_RVExtension@12")]
pub extern "C" fn RVExtension(output: *mut c_char, output_size: size_t, function: *const c_char) {
    let f_str = unsafe { CStr::from_ptr(function).to_str().unwrap() };
    let o_str: String;
    if f_str == "version" {
        o_str = String::from("0.0.1");
    } else {
        o_str = String::from("done");
    }

    write_string(output, &o_str, output_size);
}
