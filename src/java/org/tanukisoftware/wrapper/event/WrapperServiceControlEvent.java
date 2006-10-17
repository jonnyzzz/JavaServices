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
 * WrapperServiceControlEvents are used to notify the listener whenever a
 *  Service Control Event is received by the service.   These events will
 *  only be fired on Windows platforms when the Wrapper is running as a
 *  service.
 *
 * <dl>
 *   <dt>WrapperManager.SERVICE_CONTROL_CODE_STOP (1)</dt>
 *   <dd>The service was requested to stop.</dd>
 *   <dt>WrapperManager.SERVICE_CONTROL_CODE_PAUSE (2)</dt>
 *   <dd>The system requested that the service be paused.</dd>
 *   <dt>WrapperManager.SERVICE_CONTROL_CODE_CONTINUE (3)</dt>
 *   <dd>The system requested that the paused service be resumed.</dd>
 *   <dt>WrapperManager.SERVICE_CONTROL_CODE_INTERROGATE (4)</dt>
 *   <dd>The service manager queried the service to make sure it is still alive.</dd>
 *   <dt>WrapperManager.SERVICE_CONTROL_CODE_SHUTDOWN (5)</dt>
 *   <dd>The system is shutting down.</dd>
 *   <dt>User code (128-255)</dt>
 *   <dd>User defined code.</dd>
 * </dl>
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public class WrapperServiceControlEvent
    extends WrapperServiceEvent
{
    /** The event code of the Service Control Code. */ 
    private int m_serviceControlCode;
    
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    /**
     * Creates a new WrapperServiceControlEvent.
     *
     * @param serviceControlCode Service Control Code.
     */
    public WrapperServiceControlEvent( int serviceControlCode )
    {
        m_serviceControlCode = serviceControlCode;
    }
    
    /*---------------------------------------------------------------
     * Methods
     *-------------------------------------------------------------*/
    /**
     * Returns the event code of the Service Control Code.
     *
     * @return The event code of the Service Control Code.
     */
    public int getServiceControlCode()
    {
        return m_serviceControlCode;
    }
    
    /**
     * Returns a string representation of the event.
     *
     * @return A string representation of the event.
     */
    public String toString()
    {
        return "WrapperServiceControlEvent[serviceControlCode=" + getServiceControlCode() + "]";
    }
}