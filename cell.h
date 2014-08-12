#ifndef CELL_H
#define CELL_H

class Cell
{
    int m_traversable;
public:
    Cell();
    Cell(int traversable);
    int traverable() const;
    void setTraverable(int traverable);
};

#endif // CELL_H
