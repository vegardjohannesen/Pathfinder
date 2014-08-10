#include "mapimage.h"

MapImage::MapImage(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
    m_rows=10;
    m_columns=10;
    clearMap();

    setAcceptedMouseButtons(Qt::AllButtons);
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


void MapImage::paint(QPainter *painter)
{
    QImage test(m_rows,m_columns,QImage::Format_ARGB32);
    QColor red(255,0,0);
    QColor white(255,255,255);
    for (int i=0; i<m_rows;i++) {
        for (int j=0; j<m_columns;j++) {
            if (m_mapMatrix[j*m_columns + i]>0) {
                test.setPixel(i,j,red.rgba());
            } else {
                test.setPixel(i,j,white.rgba());
            }
        }
    }
    painter->drawImage(contentsBoundingRect(),test);
}

bool MapImage::traversable() const
{
    return m_traversable;
}

void MapImage::changeTraversable(QMouseEvent *event) {
    int i = m_columns * ( (double) event->pos().x() / contentsBoundingRect().size().width() );
    int j = m_rows * ( (double) event->pos().y() / contentsBoundingRect().size().height() );

    if (i < 0 || i >= m_rows || j < 0 || j >= m_columns) {
        return;
    }

    m_mapMatrix[j*m_columns + i]=!m_traversable;
    update();
}

void MapImage::mousePressEvent(QMouseEvent *event)
{
    changeTraversable(event);
}

void MapImage::mouseMoveEvent(QMouseEvent *event)
{
    changeTraversable(event);
}
