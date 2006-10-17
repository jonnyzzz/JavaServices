package org.tanukisoftware.wrapper.event;

/*
 * Copyright (c) 1999, 2006 Tanuki Software Inc.
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of the Java Service Wrapper and associated
 * documentation files (the "Software"), to deal in the Software
 * without  restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sub-license,
 * and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the
 * following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 * NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * WrapperEventListeners can be registered with the WrapperManager class
 *  to receive WrapperEvents.
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public interface WrapperEventListener
{
    /**
     * Enabling service events will cause the listener to receive
     *  WrapperServiceEvents.  These events pertain to the Wrapper as a
     *  service.
     */
    static long EVENT_FLAG_SERVICE = 0x1;
    
    /**
     * Enabling control events will cause the listener to receive
     *  WrapperControlEvents.  There events are thrown whenever the
     *  Java process receives control events from the system.  These
     *  include CTRL-C, HALT, TERM signals etc.
     */
    static long EVENT_FLAG_CONTROL = 0x2;
    
    /**
     * Enabling core events will cause the listener to receive
     *  WrapperCoreEvents. These events provide information on the internal
     *  timing of the Wrapper.
     * <p>
     * WARNING - Great care should be taken when receiving events of this type.
     *  They are sent from within the Wrapper's internal timing thread.  If the
     *  listner takes too much time working with the event, Wrapper performance
     *  could be adversely affected.  If unsure, it is recommended that events
     *  of this type not be included.
     */
    static long EVENT_FLAG_CORE = 0xf000000000000000L;
    
    /**
     * Called whenever a WrapperEvent is fired.  The exact set of events that a
     *  listener will receive will depend on the mask supplied when
     *  WrapperManager.addWrapperEventListener was called to register the
     *  listener.
     * <p>
     * Listener implementations should never assume that they will only receive
     *  events of a particular type.   To assure that events added to future
     *  versions of the Wrapper do not cause problems with user code, events
     *  should always be tested with "if ( event instanceof {EventClass} )"
     *  before casting it to a specific event type.
     *
     * @param event WrapperEvent which was fired.
     */
    void fired( WrapperEvent event );
}