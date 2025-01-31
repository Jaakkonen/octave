////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2016-2021 The Octave Project Developers
//
// See the file COPYRIGHT.md in the top-level directory of this
// distribution or <https://octave.org/copyright/>.
//
// This file is part of Octave.
//
// Octave is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Octave is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Octave; see the file COPYING.  If not, see
// <https://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////

#if ! defined (octave_oct_hdf5_types_h)
#define octave_oct_hdf5_types_h 1

#include "octave-config.h"

#if defined (__cplusplus)

// This function only needs to be defined for C++.

OCTAVE_NAMESPACE_BEGIN

extern bool check_hdf5_types (bool warn = true);

OCTAVE_NAMESPACE_END

#if defined (OCTAVE_PROVIDE_DEPRECATED_SYMBOLS)

OCTAVE_DEPRECATED (7, "use 'octave::check_hdf5_types' instead")
inline bool check_hdf5_types (bool warn = true)
{
  return octave::check_hdf5_types (warn);
}

#endif

#endif

// Available for C and C++.

typedef int64_t octave_hdf5_id;
typedef int octave_hdf5_err;

#if defined (__cplusplus)
extern "C" {
#endif

// These are defined in a C file, so they should have C-linkage in
// both C and C++ source files.

extern const octave_hdf5_id octave_H5E_DEFAULT;
extern const octave_hdf5_id octave_H5P_DEFAULT;
extern const octave_hdf5_id octave_H5S_ALL;

#if defined (__cplusplus)
}
#endif

#endif
