#include "mapimage.h"

MapImage::MapImage(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
    m_rows=10;
    m_columns=10;
    clearMap();

    setAcceptedMouseButtons(Qt::AllButtons);
}

double MapImage::cost(int i, int j) const
{
    if(i < 0 || j < 0 || i > m_rows || j > m_columns) {
        qWarning() << "Requested cost for index out of bounds (" << i << "," << j << ")";
        return 99999;
    } else {
        return 1 + m_mapMatrix[i*m_columns + j];
    }
}

bool MapImage::inBounds(int i, int j) const
{
    return !(i < 0 || i >= m_rows || j < 0 || j >= m_columns);
}

void MapImage::setTraveled(int i, int j)
{
    m_travelMatrix[i*m_columns + j] = 1;
    update();
}

void MapImage::setTraversable(bool arg)
{
    if (m_traversable != arg) {
        m_traversable = arg;
        emit traversableChanged(arg);
    }
}

void MapImage::clearMap()
{
    m_mapMatrix.fill(0,m_rows*m_columns);
    m_travelMatrix.fill(0,m_rows*m_columns);
    update();
}

void MapImage::clearPath()
{
    m_travelMatrix.fill(0,m_rows*m_columns);
    update();
}

void MapImage::randomizeMap()
{
    for (int i=0; i<m_rows;i++) {
        for (int j=0; j<m_columns;j++) {
            if ((double)qrand()/RAND_MAX>0.5) {
                m_mapMatrix[j*m_columns + i]=0;
            } else {
                 m_mapMatrix[j*m_columns + i]=1;
            }
        }
    }
    update();
}

void MapImage::setRows(int arg)
{
    if (m_rows == arg) {
        return;
    }

    m_rows = arg;
    clearMap();
    emit rowsChanged(arg);
}

void MapImage::setColumns(int arg)
{
    if (m_columns == arg) {
        return;
    }

    m_columns = arg;
    clearMap();
    emit columnsChanged(arg);
}


void MapImage::paint(QPainter *painter)
{
    QImage image(m_rows,m_columns,QImage::Format_ARGB32);
    QColor red(255,0,0);
    QColor green(0,255,0);
    QColor white(255,255,255);
    for (int i=0; i<m_rows;i++) {
        for (int j=0; j<m_columns;j++) {
            if (m_mapMatrix[i*m_columns + j]>0) {
                image.setPixel(j,i,red.rgba());
            } else if (m_travelMatrix[i*m_columns + j]>0) {
                image.setPixel(j,i,green.rgba());
            } else {
                image.setPixel(j,i,white.rgba());
            }
        }
    }
    painter->drawImage(contentsBoundingRect(),image);
}

bool MapImage::traversable() const
{
    return m_traversable;
}

int MapImage::rows() const
{
    return m_rows;
}

int MapImage::columns() const
{
    return m_columns;
}

void MapImage::changeTraversable(int i, int j) {
//    int i = m_rows * ( (double) event->pos().y() / contentsBoundingRect().size().height() );
//    int j = m_columns * ( (double) event->pos().x() / contentsBoundingRect().size().width() );

    if (!inBounds(i,j)) {
        return;
    }

    m_mapMatrix[i*m_columns + j] = !m_traversable;
    update();
}
