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
 * WrapperPingEvent are fired each time a ping is received from the Wrapper
 *  process.   This event is mainly useful for debugging and statistic
 *  collection purposes.
 * <p>
 * WARNING - Great care should be taken when receiving events of this type.
 *  They are sent from within the Wrapper's internal timing thread.  If the
 *  listner takes too much time working with the event, Wrapper performance
 *  could be adversely affected.  If unsure, it is recommended that events
 *  of this type not be included.
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public abstract class WrapperTickEvent
    extends WrapperCoreEvent
{
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    /**
     * Creates a new WrapperTickEvent.
     */
    protected WrapperTickEvent()
    {
    }
    
    /*---------------------------------------------------------------
     * Methods
     *-------------------------------------------------------------*/
    /**
     * Returns the tick count at the point the event is fired.
     *
     * @return The tick count at the point the event is fired.
     */
    public abstract int getTicks();
    
    /**
     * Returns the offset between the tick count used by the Wrapper for time
     *  keeping and the tick count generated directly from the system time.
     * <p>
     * This will be 0 in most cases.  But will be a positive value if the
     *  system time is ever set back for any reason.  It will be a negative
     *  value if the system time is set forward or if the system is under
     *  heavy load.  If the wrapper.use_system_time property is set to TRUE
     *  then the Wrapper will be using the system tick count for internal
     *  timing and this value will always be 0.
     *
     * @return The tick count offset.
     */
    public abstract int getTickOffset();
    
    /*---------------------------------------------------------------
     * Method
     *-------------------------------------------------------------*/
    /**
     * Returns a string representation of the event.
     *
     * @return A string representation of the event.
     */
    public String toString()
    {
        return "WrapperTickEvent[ticks=" + getTicks() + ", tickOffset=" + getTickOffset() + "]";
    }
}