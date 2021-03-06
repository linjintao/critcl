# -*- tcl -*-
# -------------------------------------------------------------------------
# critcl::cproc
# -- Core tests.
#    Used via cproc.test and cproc-trace.test
# -- Parameters
#    (1) suffix  ('' | '-trace')
#        This parameter affects test naming and directory holding the
#        expected results.
# -------------------------------------------------------------------------
# Parameter validation

global suffix
if {![info exists suffix]} {
    error "Missing parameter 'suffix'. Please define as either empty string, or '-trace'"
} elseif {($suffix ne "") && ($suffix ne "-trace")} {
    error "Bad value '$suffix' for parameter 'suffix'. Please define as either empty string, or '-trace'"
}

# -------------------------------------------------------------------------
# Setup

source [file join \
            [file dirname [file dirname [file join [pwd] [info script]]]] \
            testutilities.tcl]

testsNeedTcl     8.4
testsNeedTcltest 2

support {
    useLocal lib/util84/lassign.tcl     lassign84
    useLocal lib/util84/dict.tcl        dict84

    useLocal lib/stubs/container.tcl    stubs::container
    useLocal lib/stubs/reader.tcl       stubs::reader
    useLocal lib/stubs/genframe.tcl     stubs::gen

    useLocalFile test/support.tcl
}
testing {
    useLocal lib/critcl/critcl.tcl      critcl

    # Note: The next command does not influence the standard argument-
    # and result-types.
    critcl::config lines 0
    on-traced-on
}

# -------------------------------------------------------------------------
## cproc syntax

test critcl-cproc${suffix}-1.0.6 {cproc, wrong\#args} -constraints tcl86plus -body {
    critcl::cproc
} -returnCodes error -result {wrong # args: should be "critcl::cproc name adefs rtype ?body? ?arg ...?"}

test critcl-cproc${suffix}-1.0.5 {cproc, wrong\#args} -constraints tcl85 -body {
    critcl::cproc
} -returnCodes error -result {wrong # args: should be "critcl::cproc name adefs rtype ?body? ..."}

test critcl-cproc${suffix}-1.0.4 {cproc, wrong\#args} -constraints tcl84 -body {
    critcl::cproc
} -returnCodes error -result {wrong # args: should be "critcl::cproc name adefs rtype ?body? args"}

# -------------------------------------------------------------------------
## Go through the various knobs we can use to configure the definition and output

test critcl-cproc${suffix}-2.0 {cproc, simple name} -body {
    get critcl::cproc aproc {} void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.0]]

test critcl-cproc${suffix}-2.1 {cproc, namespaced name} -body {
    get critcl::cproc the::aproc {} void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.1]]

test critcl-cproc${suffix}-2.2 {cproc, Tcl vs C identifiers} -body {
    get critcl::cproc aproc+beta {} void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.2]]

test critcl-cproc${suffix}-2.3 {cproc, custom C name} -body {
    get critcl::cproc snafu {} void {} -cname 1
} -result [viewFile [localPath test/support/cproc${suffix}/2.3]]

test critcl-cproc${suffix}-2.4 {cproc, client data} -body {
    get critcl::cproc aproc {} void {} -pass-cdata 1
} -result [viewFile [localPath test/support/cproc${suffix}/2.4]]

test critcl-cproc${suffix}-2.5 {cproc, client data} -body {
    get critcl::cproc aproc {} void {} -arg-offset 3
} -result [viewFile [localPath test/support/cproc${suffix}/2.5]]

test critcl-cproc${suffix}-2.6 {cproc, int argument} -body {
    get critcl::cproc aproc {
        int anargument
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.6]]

test critcl-cproc${suffix}-2.7 {cproc, optional int argument} -body {
    get critcl::cproc aproc {
        int {anargument -1}
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.7]]

test critcl-cproc${suffix}-2.8 {cproc, optional args, freely mixed} -body {
    get critcl::cproc aproc {
        int {x -1}
        int y
        int {z -1}
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.8]]

test critcl-cproc${suffix}-2.9 {cproc, int result} -body {
    get critcl::cproc aproc {} int {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.9]]

test critcl-cproc${suffix}-2.10 {cproc, optional args} -body {
    get critcl::cproc aproc {
        int {x -1}
        int y
        int z
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.10]]

test critcl-cproc${suffix}-2.11 {cproc, optional args} -body {
    get critcl::cproc aproc {
        int x
        int y
        int {z -1}
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.11]]

test critcl-cproc${suffix}-2.12 {cproc, optional args} -body {
    get critcl::cproc aproc {
        int x
        int {y -1}
        int z
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.12]]

test critcl-cproc${suffix}-2.13 {cproc, variadic int argument} -body {
    get critcl::cproc aproc {
        int args
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.13]]

test critcl-cproc${suffix}-2.14 {cproc, variadic Tcl_Obj* argument} -body {
    get critcl::cproc aproc {
        object args
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.14]]

test critcl-cproc${suffix}-2.15 {cproc, variadic int argument, required in front} -body {
    get critcl::cproc aproc {
        int x
        int y
        int args
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.15]]

test critcl-cproc${suffix}-2.16 {cproc, variadic int argument, optional in front} -body {
    get critcl::cproc aproc {
        int {x -1}
        int {y -1}
        int args
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.16]]

test critcl-cproc${suffix}-2.17 {cproc, variadic int argument, mix required/optional in front} -body {
    get critcl::cproc aproc {
        int x
        int {y -1}
        int args
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.17]]

test critcl-cproc${suffix}-2.18 {cproc, variadic int argument, mix optional/required in front} -body {
    get critcl::cproc aproc {
        int {x -1}
        int y
        int args
    } void {}
} -result [viewFile [localPath test/support/cproc${suffix}/2.18]]

# -------------------------------------------------------------------------
# Vary the result type of the function. Covers all builtin result types.

test critcl-cproc${suffix}-3.0 {cproc, void result} -body {
    get critcl::cproc aproc {} void { }
} -result [viewFile [localPath test/support/cproc${suffix}/3.0]]

test critcl-cproc${suffix}-3.1 {cproc, Tcl-code result} -body {
    get critcl::cproc aproc {} ok { return TCL_OK; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.1]]

test critcl-cproc${suffix}-3.2 {cproc, int result} -body {
    get critcl::cproc aproc {} int { return 0; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.2]]

test critcl-cproc${suffix}-3.3 {cproc, bool result} -body {
    get critcl::cproc aproc {} bool { return 1; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.3]]

test critcl-cproc${suffix}-3.4 {cproc, boolean result} -body {
    get critcl::cproc aproc {} boolean { return 1; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.4]]

test critcl-cproc${suffix}-3.5 {cproc, long result} -body {
    get critcl::cproc aproc {} long { return 1; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.5]]

test critcl-cproc${suffix}-3.6 {cproc, wideint result} -body {
    get critcl::cproc aproc {} wideint { return 1; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.6]]

test critcl-cproc${suffix}-3.7 {cproc, double result} -body {
    get critcl::cproc aproc {} double { return 0.; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.7]]

test critcl-cproc${suffix}-3.8 {cproc, float result} -body {
    get critcl::cproc aproc {} float { return 0.; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.8]]

test critcl-cproc${suffix}-3.9 {cproc, vstring result} -body {
    get critcl::cproc aproc {} vstring { return "foo"; }
} -result [viewFile [localPath test/support/cproc${suffix}/3.9]]

test critcl-cproc${suffix}-3.10 {cproc, dstring result} -body {
    get critcl::cproc aproc {} dstring { return alloc_string("bar"); }
} -result [viewFile [localPath test/support/cproc${suffix}/3.10]]

test critcl-cproc${suffix}-3.11 {cproc, object result} -body {
    get critcl::cproc aproc {} object { return Tcl_NewIntObj(0); }
} -result [viewFile [localPath test/support/cproc${suffix}/3.11]]

# -------------------------------------------------------------------------
## XXX TODO one to multiple arguments
## XXX TODO optional arguments
## XXX TODO various argument types
## XXX TODO various result types
## XXX TODO ...

testsuiteCleanup

# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End:
