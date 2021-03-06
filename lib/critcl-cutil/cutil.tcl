## -*- tcl -*-
# # ## ### ##### ######## ############# #####################
# Pragmas for MetaData Scanner.
# n/a

# CriTcl Utility Commands To Provide Common C-level utility functions.

package provide critcl::cutil 0.1

# # ## ### ##### ######## ############# #####################
## Requirements.

package require Tcl    8.4   ; # Min supported version.

if {[catch {
    package require critcl 3
}]} {
    package require critcl 2.1 ; # Only this and higher has the enhanced check, and checklink.
}

namespace eval ::critcl::cutil {}

# # ## ### ##### ######## ############# #####################
## Implementation -- API: Embed C Code

# # ## ### ##### ######## ############# #####################

proc critcl::cutil::alloc {} {
    variable selfdir
    critcl::cheaders -I$selfdir/allocs
    critcl::include critcl_alloc.h 
    return
}

proc critcl::cutil::assertions {} {
    variable selfdir
    critcl::cheaders -I$selfdir/asserts
    critcl::include critcl_assert.h
    return
}

proc critcl::cutil::tracer {} {
    variable selfdir
    alloc ;# Tracer uses the allocation utilities in its implementation
    critcl::cheaders -I$selfdir/trace
    critcl::include  critcl_trace.h
    critcl::csources $selfdir/trace/trace.c
    return
}

if 0 {proc critcl::cutil::tracer {} {
    variable selfdir
    alloc ;# Tracer uses the allocation utilities in its implementation
    critcl::cheaders -I$selfdir/trace
    critcl::include critcl_trace.h
    critcl::csources $selfdir/trace/trace.c
    return
}}

# # ## ### ##### ######## ############# #####################
## State

namespace eval ::critcl::cutil {
    variable selfdir [file dirname [file normalize [info script]]]
}

# # ## ### ##### ######## ############# #####################
## Export API

namespace eval ::critcl::cutil {
    namespace export alloc assert tracer
    catch { namespace ensemble create }
}

# # ## ### ##### ######## ############# #####################
## Ready
return
