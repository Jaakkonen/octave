////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2011-2021 The Octave Project Developers
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

#if ! defined (octave_ContextMenu_h)
#define octave_ContextMenu_h 1

#include <QPoint>

#include "MenuContainer.h"
#include "Object.h"

class QMenu;

namespace octave
{
  class base_qobject;
  class interpreter;
}

namespace octave
{

  class ContextMenu : public Object, public MenuContainer
  {
    Q_OBJECT

  public:
    ContextMenu (octave::base_qobject& oct_qobj, octave::interpreter& interp,
                 const graphics_object& go, QMenu *menu);
    ~ContextMenu (void);

    static ContextMenu *
    create (octave::base_qobject& oct_qobj, octave::interpreter& interp,
            const graphics_object& go);

    static void executeAt (octave::interpreter& interp,
                           const base_properties& props, const QPoint& pt);

    Container * innerContainer (void) { return nullptr; }

    QWidget * menu (void);

  protected:
    void update (int pId);

  private slots:
    void aboutToShow (void);
    void aboutToHide (void);
  };

}

#endif
