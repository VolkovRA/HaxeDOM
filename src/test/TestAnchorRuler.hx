package test;

import dom.geom.AnchorRuler;

/**
 * Автоматическое тестирование класса: AnchorRuler.  
 * Эта собака слишком сложная!
 */
class TestAnchorRuler
{
    /**
     * Запустить тестирование.
     */
    static public function start() {
        var a = new AnchorRuler();
        a.dist = 1;

        // Тесты:
        trace("Автотест: AnchorRuler");
        trace(a.testPoint(0) == null        ? "OK" : "ERROR");
        trace(a.testMove(0, 1) == null      ? "OK" : "ERROR");
        a.add(1);
        trace(a.testPoint(-1) == null       ? "OK" : "ERROR");
        trace(a.testPoint(0) == 1           ? "OK" : "ERROR");
        trace(a.testPoint(1) == 1           ? "OK" : "ERROR");
        trace(a.testPoint(2) == 1           ? "OK" : "ERROR");
        trace(a.testPoint(3) == null        ? "OK" : "ERROR");
        trace(a.testMove(-2, -2) == null    ? "OK" : "ERROR");
        trace(a.testMove(-2, -1) == null    ? "OK" : "ERROR");
        trace(a.testMove(-1, -2) == null    ? "OK" : "ERROR");
        trace(a.testMove(-1, 0) == 1        ? "OK" : "ERROR");
        trace(a.testMove(0, -1) == 1        ? "OK" : "ERROR");
        trace(a.testMove(0, 1) == 1         ? "OK" : "ERROR");
        trace(a.testMove(1, 0) == 1         ? "OK" : "ERROR");
        trace(a.testMove(1, 1) == 1         ? "OK" : "ERROR");
        trace(a.testMove(0, 0) == 1         ? "OK" : "ERROR");
        trace(a.testMove(1, 2) == 1         ? "OK" : "ERROR");
        trace(a.testMove(2, 1) == 1         ? "OK" : "ERROR");
        trace(a.testMove(3, 2) == 1         ? "OK" : "ERROR");
        trace(a.testMove(2, 3) == 1         ? "OK" : "ERROR");
        trace(a.testMove(3, 5) == null      ? "OK" : "ERROR");
        trace(a.testMove(5, 3) == null      ? "OK" : "ERROR");
        trace(a.testMove(0, 2) == 1         ? "OK" : "ERROR");
        trace(a.testMove(2, 0) == 1         ? "OK" : "ERROR");
        trace(a.testMove(-1, 5) == 1        ? "OK" : "ERROR");
        trace(a.testMove(5, -2) == 1        ? "OK" : "ERROR");
        a.add(0);
        trace(a.testPoint(-1) == 0          ? "OK" : "ERROR");
        trace(a.testPoint(-2) == null       ? "OK" : "ERROR");
        trace(a.testPoint(0.5) == 0         ? "OK" : "ERROR");
        trace(a.testPoint(0.6) == 1         ? "OK" : "ERROR");
        trace(a.testPoint(1) == 1           ? "OK" : "ERROR");
        trace(a.testPoint(0) == 0           ? "OK" : "ERROR");
        trace(a.testPoint(1.1) == 1         ? "OK" : "ERROR");
        trace(a.testPoint(2) == 1           ? "OK" : "ERROR");
        trace(a.testPoint(2.1) == null      ? "OK" : "ERROR");
        trace(a.testMove(-5, -2) == null    ? "OK" : "ERROR");
        trace(a.testMove(-2, -5) == null    ? "OK" : "ERROR");
        trace(a.testMove(-2, -2) == null    ? "OK" : "ERROR");
        trace(a.testMove(-1, 10) == 0       ? "OK" : "ERROR");
        trace(a.testMove(10, -10) == 1      ? "OK" : "ERROR");
        trace(a.testMove(1, 1) == 1         ? "OK" : "ERROR");
        trace(a.testMove(0, 0) == 0         ? "OK" : "ERROR");
        trace(a.testMove(-0.9, 0.2) == 0    ? "OK" : "ERROR");
        trace(a.testMove(3, 8) == null      ? "OK" : "ERROR");
        trace(a.testMove(8, 3) == null      ? "OK" : "ERROR");
        a.add(5);
        trace(a.testPoint(3) == null        ? "OK" : "ERROR");
        trace(a.testPoint(4.8) == 5         ? "OK" : "ERROR");
        trace(a.testMove(2.1, 4.9) == 5     ? "OK" : "ERROR");
        trace(a.testMove(2.1, 7.9) == 5     ? "OK" : "ERROR");
        trace(a.testMove(1.9, 7.9) == 1     ? "OK" : "ERROR");
        trace(a.testMove(3, 3.5) == null    ? "OK" : "ERROR");
        trace(a.testMove(3.5, 3) == null    ? "OK" : "ERROR");
        trace(a.testMove(6, 9) == 5         ? "OK" : "ERROR");
        trace(a.testMove(6.1, 9) == null    ? "OK" : "ERROR");
        trace(a.testMove(3, 0) == 1         ? "OK" : "ERROR");
        trace(a.testMove(3, 3.9) == null    ? "OK" : "ERROR");
        trace(a.testMove(3, 4) == 5         ? "OK" : "ERROR");
    }
}