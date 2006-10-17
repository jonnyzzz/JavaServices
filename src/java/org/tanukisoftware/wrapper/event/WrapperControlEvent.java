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
 * WrapperControlEvent are used to notify the listener whenever the native
 *  wrapper code traps a system control signal against the Java process.
 *  It is up to the listener to take any actions necessary.
 * <p>
 * The Wrapper will send this event to any registered listeners first,
 *  then it will pass the control code to the WrapperListener.controlEvent
 *  method.   If the consume method is called, it will still be passed to
 *  other WrapperEventListeners, but will not be passed to the
 *  WrapperListener.controlEvent method.   Other WrapperEventListeners should
 *  check the isConsumed method to decide whether or not the even has already
 *  been handled.
 * <p>
 * If the wrapper.ignore_signals property is set to true then the event will
 *  still be fired, but its isConsumed() method will return true initially.
 * <p>
 * Possible values are:
 * <dl>
 *   <dt>WrapperManager.WRAPPER_CTRL_C_EVENT</dt>
 *   <dd>The user pressed CTRL-C in a command windown (Windows or UNIX).
 *     Or the kill INT signal was received (UNIX).</dd>
 *   <dt>WRAPPER_CTRL_CLOSE_EVENT</dt>
 *   <dd>The user is trying to close the console in which the Wrapper is
 *     running (Windows).</dd>
 *   <dt>WRAPPER_CTRL_LOGOFF_EVENT</dt>
 *   <dd>The user logged off (Windows).</dd>
 *   <dt>WRAPPER_CTRL_SHUTDOWN_EVENT</dt>
 *   <dd>The system is being shutdown (Windows).</dd>
 *   <dt>WRAPPER_CTRL_TERM_EVENT</td>
 *   <dd>The kill TERM signal was received (UNIX).</dd>
 *   <dt>WRAPPER_CTRL_HUP_EVENT</td>
 *   <dd>The kill HUP signal was received (UNIX).</dd>
 * </dl>
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public class WrapperControlEvent
    extends WrapperEvent
{
    /** The system control event. */ 
    private int m_controlEvent;
    
    /** The name of the event. */
    private String m_controlEventName;
    
    /** True if the event has been consumed. */
    private boolean m_consumed;
    
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    /**
     * Creates a new WrapperControlEvent.
     *
     * @param controlEvent Service control event.
     * @param controlEventName The name of the event.
     */
    public WrapperControlEvent( int controlEvent, String controlEventName )
    {
        m_controlEvent = controlEvent;
        m_controlEventName = controlEventName;
    }
    
    /*---------------------------------------------------------------
     * WrapperEvent Methods
     *-------------------------------------------------------------*/
    /**
     * Returns a set of event flags for which the event should be fired.
     *  This value is compared with the mask supplied when when a
     *  WrapperEventListener is registered to decide which listeners should
     *  receive the event.
     * <p>
     * If a subclassed, the return value of the super class should usually
     *  be ORed with any additional flags.
     *
     * @return a set of event flags.
     */
    public long getFlags()
    {
        return super.getFlags() | WrapperEventListener.EVENT_FLAG_CONTROL;
    }
    
    /*---------------------------------------------------------------
     * Methods
     *-------------------------------------------------------------*/
    /**
     * Returns the system control event.
     * <p>
     * Possible values are: WrapperManager.WRAPPER_CTRL_C_EVENT, 
     *    WRAPPER_CTRL_CLOSE_EVENT, WRAPPER_CTRL_LOGOFF_EVENT, 
     *    WRAPPER_CTRL_SHUTDOWN_EVENT, WRAPPER_CTRL_TERM_EVENT, or
     *    WRAPPER_CTRL_HUP_EVENT.
     *
     * @return The system control event.
     */
    public int getControlEvent()
    {
        return m_controlEvent;
    }
    
    /**
     * Returns the name of the control event.
     *
     * @return The name of the control event.
     */
    public String getControlEventName()
    {
        return m_controlEventName;
    }
    
    /**
     * Mark the event as consumed.  This should be done if the event
     *  has been handled.
     * <p>
     * On Windows, some events are sent both to the JVM and Wrapper processes.
     *  Event if the CTRL-C event is ignored within the JVM, the Wrapper
     *  process may still initiate a shutdown.
     */
    public void consume()
    {
        m_consumed = true;
    }
    
    /**
     * Returns true if the event has been consumed.
     *
     * @return True if the event has been consumed.
     */
    public boolean isConsumed()
    {
        return m_consumed;
    }
    
    /**
     * Returns a string representation of the event.
     *
     * @return A string representation of the event.
     */
    public String toString()
    {
        return "WrapperControlEvent[controlEvent=" + getControlEvent()
            + ", controlEventName=" + getControlEventName() + ", consumed=" + isConsumed() + "]";
    }
}