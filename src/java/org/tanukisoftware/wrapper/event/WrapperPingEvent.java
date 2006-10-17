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
public class WrapperPingEvent
    extends WrapperCoreEvent
{
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    /**
     * Creates a new WrapperPingEvent.
     */
    public WrapperPingEvent()
    {
    }
    
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
        return "WrapperPingEvent";
    }
}