#ifndef MAPIMAGE_H
#define MAPIMAGE_H

#include <QQuickPaintedItem>
#include <QImage>
#include <QPainter>
#include <QList>

#include "cell.h"

class MapImage : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(bool traversable READ traversable WRITE setTraversable NOTIFY traversableChanged)

private:
    bool m_traversable;
    QVector<Cell> m_mapMatrix;
    int m_rows;
    int m_columns;

    void changeTraversable(QMouseEvent *event);
public:
    explicit MapImage(QQuickItem *parent = 0);

signals:

    void traversableChanged(bool arg);

public slots:


    // QQuickPaintedItem interface
    void setTraversable(bool arg);
    void clearMap();
    void randomizeMap();
public:
    void paint(QPainter *painter);
    bool traversable() const;
protected:
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
};

#endif // MAPIMAGE_H
