.ifndef _MACRO_INC_GUARD
.internal _MACRO_INC_GUARD
.set _MACRO_INC_GUARD, 1

.macro glabel label, visibility=global
    .\visibility "\label"
    "\label":
.endm

.macro endlabel label
.endm

.macro nonmatching label, size=1
.endm

.macro alabel label, visibility=global
    .\visibility "\label"
    "\label":
.endm

.macro jlabel label, visibility=global
    .\visibility "\label"
    "\label":
.endm

.macro dlabel label, visibility=global
    .\visibility "\label"
    .type "\label", @object
    "\label":
.endm

.macro enddlabel label
    .size "\label", . - "\label"
.endm

.endif
