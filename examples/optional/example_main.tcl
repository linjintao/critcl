#!/usr/bin/env tclsh

package require Tcl 8.5
package require optional

foreach a {
    {}
    {6}
    {6 7}
    {6 7 8}
    {6 7 8 9}
    {6 7 8 9 0}
} {
    puts ___($a)_________

    catch {
	fixed {*}$a
    } msg ; puts $msg
    catch {
	optional_head {*}$a
    } msg ; puts $msg
    catch {
	optional_middle {*}$a
    } msg ; puts $msg
    catch {
	optional_tail {*}$a
    } msg ; puts $msg
}
