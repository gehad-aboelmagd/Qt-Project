#ifndef PAGENAVIGATOR_H
#define PAGENAVIGATOR_H

#include <QObject>

class PageNavigator: public QObject
{
    Q_OBJECT
public:
    explicit PageNavigator(QObject *parent = nullptr): QObject(parent) {}

signals:
    void navigateToPage(int index);
};

#endif // PAGENAVIGATOR_H
