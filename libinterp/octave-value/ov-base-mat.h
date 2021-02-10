////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 1998-2021 The Octave Project Developers
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

#if ! defined (octave_ov_base_mat_h)
#define octave_ov_base_mat_h 1

#include "octave-config.h"

#include <cstdlib>

#include <iosfwd>
#include <string>

#include "mx-base.h"
#include "str-vec.h"
#include "MatrixType.h"

#include "error.h"
#include "ovl.h"
#include "ov-base.h"
#include "ov-typeinfo.h"

// Real matrix values.

template <typename MT>
class
OCTINTERP_API
octave_base_matrix : public octave_base_value
{
public:

  typedef MT object_type;

  octave_base_matrix (void)
    : octave_base_value (), matrix (), typ (), idx_cache () { }

  octave_base_matrix (const MT& m, const MatrixType& t = MatrixType ())
    : octave_base_value (), matrix (m),
      typ (t.is_known () ? new MatrixType (t) : nullptr), idx_cache ()
  {
    if (matrix.ndims () == 0)
      matrix.resize (dim_vector (0, 0));
  }

  octave_base_matrix (const octave_base_matrix& m)
    : octave_base_value (), matrix (m.matrix),
      typ (m.typ ? new MatrixType (*m.typ) : nullptr),
      idx_cache (m.idx_cache ? new idx_vector (*m.idx_cache) : nullptr)
  { }

  ~octave_base_matrix (void) { clear_cached_info (); }

  size_t byte_size (void) const { return matrix.byte_size (); }

  octave_value squeeze (void) const { return MT (matrix.squeeze ()); }

  octave_value full_value (void) const { return matrix; }

  void maybe_economize (void) { matrix.maybe_economize (); }

  // We don't need to override all three forms of subsref.  The using
  // declaration will avoid warnings about partially-overloaded virtual
  // functions.
  using octave_base_value::subsref;

  OCTINTERP_API octave_value
  subsref (const std::string& type, const std::list<octave_value_list>& idx);

  octave_value_list subsref (const std::string& type,
                             const std::list<octave_value_list>& idx, int)
  { return subsref (type, idx); }

  OCTINTERP_API octave_value
  subsasgn (const std::string& type, const std::list<octave_value_list>& idx,
            const octave_value& rhs);

  OCTINTERP_API octave_value
  do_index_op (const octave_value_list& idx,  bool resize_ok = false);

  // FIXME: should we import the functions from the base class and
  // overload them here, or should we use a different name so we don't
  // have to do this?  Without the using declaration or a name change,
  // the base class functions will be hidden.  That may be OK, but it
  // can also cause some confusion.
  using octave_base_value::assign;

  OCTINTERP_API void assign (const octave_value_list& idx, const MT& rhs);

  OCTINTERP_API void
  assign (const octave_value_list& idx, typename MT::element_type rhs);

  OCTINTERP_API void delete_elements (const octave_value_list& idx);

  dim_vector dims (void) const { return matrix.dims (); }

  octave_idx_type numel (void) const { return matrix.numel (); }

  int ndims (void) const { return matrix.ndims (); }

  octave_idx_type nnz (void) const { return matrix.nnz (); }

  octave_value reshape (const dim_vector& new_dims) const
  { return MT (matrix.reshape (new_dims)); }

  octave_value permute (const Array<int>& vec, bool inv = false) const
  { return MT (matrix.permute (vec, inv)); }

  octave_value resize (const dim_vector& dv, bool fill = false) const;

  octave_value all (int dim = 0) const { return matrix.all (dim); }
  octave_value any (int dim = 0) const { return matrix.any (dim); }

  MatrixType matrix_type (void) const { return typ ? *typ : MatrixType (); }
  MatrixType matrix_type (const MatrixType& _typ) const;

  octave_value diag (octave_idx_type k = 0) const
  { return octave_value (matrix.diag (k)); }

  octave_value diag (octave_idx_type m, octave_idx_type n) const
  { return octave_value (matrix.diag (m, n)); }

  octave_value sort (octave_idx_type dim = 0, sortmode mode = ASCENDING) const
  { return octave_value (matrix.sort (dim, mode)); }
  octave_value sort (Array<octave_idx_type> &sidx, octave_idx_type dim = 0,
                     sortmode mode = ASCENDING) const
  { return octave_value (matrix.sort (sidx, dim, mode)); }

  sortmode issorted (sortmode mode = UNSORTED) const
  { return matrix.issorted (mode); }

  Array<octave_idx_type> sort_rows_idx (sortmode mode = ASCENDING) const
  { return matrix.sort_rows_idx (mode); }

  sortmode is_sorted_rows (sortmode mode = UNSORTED) const
  { return matrix.is_sorted_rows (mode); }

  bool is_matrix_type (void) const { return true; }

  bool isnumeric (void) const { return true; }

  bool is_defined (void) const { return true; }

  bool is_constant (void) const { return true; }

  OCTINTERP_API bool is_true (void) const;

  OCTINTERP_API bool print_as_scalar (void) const;

  OCTINTERP_API void print (std::ostream& os, bool pr_as_read_syntax = false);

  OCTINTERP_API void
  print_info (std::ostream& os, const std::string& prefix) const;

  OCTINTERP_API void short_disp (std::ostream& os) const;

  OCTINTERP_API float_display_format get_edit_display_format (void) const;

  OCTINTERP_API std::string
  edit_display (const float_display_format& fmt,
                octave_idx_type i, octave_idx_type j) const;

  MT& matrix_ref (void)
  {
    clear_cached_info ();
    return matrix;
  }

  const MT& matrix_ref (void) const
  {
    return matrix;
  }

  OCTINTERP_API octave_value
  fast_elem_extract (octave_idx_type n) const;

  OCTINTERP_API bool
  fast_elem_insert (octave_idx_type n, const octave_value& x);

protected:

  MT matrix;

  idx_vector set_idx_cache (const idx_vector& idx) const
  {
    delete idx_cache;
    idx_cache = (idx ? new idx_vector (idx) : nullptr);
    return idx;
  }

  void clear_cached_info (void) const
  {
    delete typ; typ = nullptr;
    delete idx_cache; idx_cache = nullptr;
  }

  mutable MatrixType *typ;
  mutable idx_vector *idx_cache;

private:

  // No assignment.

  OCTINTERP_API octave_base_matrix& operator = (const octave_base_matrix&);
};

#endif
