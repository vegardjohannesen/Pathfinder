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
    Q_PROPERTY(int rows READ rows WRITE setRows NOTIFY rowsChanged)
    Q_PROPERTY(int columns READ columns WRITE setColumns NOTIFY columnsChanged)

public:
    explicit MapImage(QQuickItem *parent = 0);
    Q_INVOKABLE double cost(int i, int j) const;
    Q_INVOKABLE bool inBounds(int i, int j) const;
    Q_INVOKABLE void setTraveled(int i, int j);

signals:
    void traversableChanged(bool arg);
    void rowsChanged(int arg);
    void columnsChanged(int arg);

public slots:
    // QQuickPaintedItem interface
    void setTraversable(bool arg);
    void clearMap();
    void clearPath();
    void randomizeMap();
    void setRows(int arg);

    void setColumns(int arg);

public:
    void paint(QPainter *painter);
    bool traversable() const;
    void findPath();
    int rows() const;
    int columns() const;

protected:
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);

private:
    bool m_traversable;
    QVector<int> m_mapMatrix;
    QVector<int> m_travelMatrix;
    int m_rows;
    int m_columns;

    void changeTraversable(QMouseEvent *event);
};

#endif // MAPIMAGE_H
