########################################################################
##
## Copyright (C) 2012-2021 The Octave Project Developers
##
## See the file COPYRIGHT.md in the top-level directory of this
## distribution or <https://octave.org/copyright/>.
##
## This file is part of Octave.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.
##
########################################################################

## -*- texinfo -*-
## @deftypefn {} {[@var{fname}, @var{fpath}, @var{fltidx}] =} __uigetfile_fltk__ (@var{filters}, @var{title}, @var{defval}, @var{multiselect}, @var{defdir})
## Undocumented internal function.
## @end deftypefn

function [retval, retpath, retindex] = __uigetfile_fltk__ (filters, title, defval, multiselect, defdir)

  if (exist ("__fltk_uigetfile__") != 3)
    error ("uigetfile: fltk graphics toolkit required");
  endif

  filters = __fltk_file_filter__ (filters);
  if (length (defdir) > 0)
    defval = fullfile (defdir, defval);
  endif
  [retval, retpath, retindex] = ...
    __fltk_uigetfile__ (filters, title, defval, multiselect);

endfunction
