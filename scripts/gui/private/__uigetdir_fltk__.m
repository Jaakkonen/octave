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
## @deftypefn {} {@var{dirname} =} __uigetdir_fltk__ (@var{start_path}, @var{dialog_title})
## Undocumented internal function.
## @end deftypefn

function dirname = __uigetdir_fltk__ (start_path, dialog_title)

  if (exist ("__fltk_uigetfile__") != 3)
    error ("uigetdir: fltk graphics toolkit required");
  endif

  dirname = __fltk_uigetfile__ ("", dialog_title, start_path, "dir");

endfunction
