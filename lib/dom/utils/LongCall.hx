package dom.utils;

import js.Browser;
import js.Syntax;
import js.html.PointerEvent;
import tools.NativeJS;

/**
 * Утилиты для отложенных вызовов.  
 * Статический класс.
 */
@:dce
class LongCall
{
    /**
     * Задержка перед первым вызовом. (mc)
     */
    static private inline var DEFAY_START:Int = 200;

    /**
     * Задержка между вызовами. (mc)
     */
    static private inline var DEFAY_CALL:Int = 50;

    /**
     * Мапа всех вызовов.  
     * Не может быть: `null`
     */
    static private var map(default, null):Dynamic;

    /**
     * Инициализировать `LongCall`  
     * Используется для подписки на отмену вызовов и прочего.
     * Вызывается автоматически при первом обращении к методам класса.
     */
    static private function init():Void {
        map = {};
        Browser.window.addEventListener("pointerup", onPointerUp);
        Browser.window.addEventListener("pointercancel", onPointerUp);
    }

    /**
     * Вызов для счётчика.  
     * Небольшая задержка вначале, затем бесконечные, быстрые
     * вызовы пока не будет вызвана отмена: `LongCall.stop()`
     * @param id ID Вызывающего объекта для исключения повторных
     *           вызовов одним и тем же объектом.
     * @param callback Функция для обратного вызова.
     */
    static public function stepper(id:Int, callback:Void->Void):Void {
        stop(id);

        if (callback == null)
            return;
        
        var p:StepperCall = {
            id: id,
            type: LongCallType.STEPPER,
            removed: false,
            timeoutID: 0,
            intervalID: 0,
        }
        map[id] = p;

        p.timeoutID = Browser.window.setTimeout(function() {
            p.timeoutID = 0;
            if (p.removed)
                return;
            p.intervalID = Browser.window.setInterval(function() {
                callback();
            }, DEFAY_CALL);
        }, DEFAY_START);
    }

    /**
     * Прекратить вызовы.
     * @param id ID Вызывающего объекта.
     * @return Если `true`, вызовы были прекращены.
     *         Если `false`, для этого ID вызовов не зарегистрировано.
     */
    static public function stop(id:Int):Bool {
        if (map == null)
            init();

        var p:Call = map[id];
        if (p != null) {
            if (p.type == LongCallType.STEPPER) stopStepper(untyped p);
            p.removed = true;
            NativeJS.delete(map, id);
            return true;
        }

        return false;
    }

    /**
     * Событие отжатия мышки/указателя.
     * @param e Нативное событие.
     */
    static private function onPointerUp(e:PointerEvent):Void {
        var key:Dynamic = null;
        Syntax.code('for ({0} in {1}) {', key, map);
            var p:Call = map[key];
            if (p.type == LongCallType.STEPPER) stop(key);
        Syntax.code('}');
    }

    /**
     * Прекратить вызовы для счётчика.
     * @param p Параметры вызова.
     */
    static private function stopStepper(p:StepperCall):Void {
        if (p.intervalID != 0)   Browser.window.clearInterval(p.intervalID);
        if (p.timeoutID != 0)    Browser.window.clearTimeout(p.timeoutID);
        p.intervalID = 0;
        p.timeoutID = 0;
    }
}

/**
 * Тип вызова.
 */
@:noCompletion
private enum abstract LongCallType(Int) to Int from Int
{
    /**
     * Счётчик.
     */
    var STEPPER = 1;
}

/**
 * Общие данные для всех вызовов.
 */
@:noCompletion
private typedef Call =
{
    /**
     * ID Вызывающего объекта.
     */
    var id:Int;

    /**
     * Тип вызова.
     */
    var type:LongCallType;

    /**
     * Этот вызов был удалён.
     */
    var removed:Bool;
}

/**
 * Данные для вызова: `LongCall.stepper()`
 */
@:noCompletion
private typedef StepperCall =
{
    >Call,

    /**
     * ID Нативного таймаута.
     */
    var timeoutID:Int;

    /**
     * ID Нативного интервала.
     */
    var intervalID:Int;
}