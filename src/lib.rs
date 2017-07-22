extern crate libc;

use std::ffi::CStr;
use std::ffi::CString;
use libc::c_char;
use libc::size_t;
use libc::strncpy;

fn write_string(output: *mut c_char, src: &str, output_size: size_t) {
    let c_str = CString::new(src);
    if c_str.is_err() {
        return
    } else {
        unsafe { strncpy(output, c_str.unwrap().as_ptr(), output_size) };
    }
}

#[allow(non_snake_case)]
#[no_mangle]
#[cfg_attr(all(target_os = "windows", target_arch = "x86"), export_name = "_RVExtension@12")]
pub extern "C" fn RVExtension(output: *mut c_char, output_size: size_t, function: *const c_char) {
    let function_result = unsafe { CStr::from_ptr(function).to_str() };
    let o_str: String;
    if function_result.is_err() {
        o_str = String::from("no_function");
    } else {
        let f_str = function_result.unwrap();
        if f_str == "version" {
            o_str = String::from(env!("CARGO_PKG_VERSION"));
        } else {
            o_str = String::from("done");
        }
    }

    write_string(output, &o_str, output_size);
}
