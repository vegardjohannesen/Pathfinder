#include "cell.h"


int Cell::traverable() const
{
    return m_traversable;
}

void Cell::setTraverable(int traverable)
{
    m_traversable = traverable;
}
Cell::Cell()
{
    //m_traverable = 0;
}

Cell::Cell(int traversable)
{
    m_traversable=traversable;
}
