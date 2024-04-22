// SPDX-FileCopyrightText: 2023 Jade Lovelace
//
// SPDX-License-Identifier: MIT

#import "algorithmic.typ"
#import algorithmic: algorithm

#algorithm({
  import algorithmic: *
  Function("Binary-Search", args: ("A", "n", "v"), {
    Cmt[Initialize the search range]
    Tc(AssignI[$l$][$1$])[comment comment comment did you know i cannot write tersely this is a long comment that goes on forever]
    Assign[$r$][$n$]
    State[]
    While(cond: $l <= r$, {
      Assign([mid], FnI[floor][$(l + r)/2$])
      If(cond: $A ["mid"] < v$, {
        Assign[$l$][$m + 1$]
      })
      ElsIf(cond: [$A ["mid"] > v$], {
        Assign[$r$][$m - 1$]
      })
      Else({
        Return[$m$]
      })
    })
    Return[*null*]
  })
})
