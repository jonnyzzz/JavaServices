package org.tanukisoftware.wrapper;

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
 * A WrapperWin32Service contains information about an individual service
 *  registered with the current system.
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public class WrapperWin32Service
{
    public static final int SERVICE_STATE_STOPPED          = 0x00000001;
    public static final int SERVICE_STATE_START_PENDING    = 0x00000002;
    public static final int SERVICE_STATE_STOP_PENDING     = 0x00000003;
    public static final int SERVICE_STATE_RUNNING          = 0x00000004;
    public static final int SERVICE_STATE_CONTINUE_PENDING = 0x00000005;
    public static final int SERVICE_STATE_PAUSE_PENDING    = 0x00000006;
    public static final int SERVICE_STATE_PAUSED           = 0x00000007;
    
    /** The name of the service. */
    private String m_name;
    
    /** The display name of the service. */
    private String m_displayName;
    
    /** The last known state of the service. */
    private int m_serviceState;
    
    /** The exit of the service. */
    private int m_exitCode;
    
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    WrapperWin32Service( byte[] name, byte[] displayName, int serviceState, int exitCode )
    {
        // Decode the parameters using the default system encoding.
        m_name = new String( name );
        m_displayName = new String( displayName );
        
        m_serviceState = serviceState;
        m_exitCode = exitCode;
    }
    
    /*---------------------------------------------------------------
     * Methods
     *-------------------------------------------------------------*/
    /**
     * Returns the name of the service.
     *
     * @return The name of the service.
     */
    public String getName()
    {
        return m_name;
    }
    
    /**
     * Returns the display name of the service.
     *
     * @return The display name of the service.
     */
    public String getDisplayName()
    {
        return m_displayName;
    }
    
    /**
     * Returns the last known state name of the service.
     *
     * @return The last known state name of the service.
     */
    public String getServiceStateName()
    {
        int serviceState = getServiceState();
        switch( serviceState )
        {
        case SERVICE_STATE_STOPPED:
            return "STOPPED";
            
        case SERVICE_STATE_START_PENDING:
            return "START_PENDING";
            
        case SERVICE_STATE_STOP_PENDING:
            return "STOP_PENDING";
            
        case SERVICE_STATE_RUNNING:
            return "RUNNING";
            
        case SERVICE_STATE_CONTINUE_PENDING:
            return "CONTINUE_PENDING";
            
        case SERVICE_STATE_PAUSE_PENDING:
            return "PAUSE_PENDING";
            
        case SERVICE_STATE_PAUSED:
            return "PAUSED";
            
        default:
            return "UNKNOWN(" + serviceState + ")";
        }
    }
    
    /**
     * Returns the last known state of the service.
     *
     * @return The last known state of the service.
     */
    public int getServiceState()
    {
        return m_serviceState;
    }
    
    /**
     * Returns the exit of the service, or 0 if it is still running.
     *
     * @return The exit of the service.
     */
    public int getExitCode()
    {
        return m_exitCode;
    }
    
    /**
     * Returns a string representation of the user.
     *
     * @return A string representation of the user.
     */
    public String toString()
    {
        StringBuffer sb = new StringBuffer();
        sb.append( "WrapperWin32Service[name=\"" );
        sb.append( getName() );
        sb.append( "\", displayName=\"" );
        sb.append( getDisplayName() );
        
        sb.append( "\", state=" );
        sb.append( getServiceStateName() );
        sb.append( ", exitCode=" );
        sb.append( getExitCode() );
        sb.append( "]" );
        return sb.toString();
    }
}

