package org.tanukisoftware.wrapper.jmx;

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
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public class WrapperManagerTesting
    implements WrapperManagerTestingMBean
{
    /*---------------------------------------------------------------
     * WrapperManagerTestingMBean Methods
     *-------------------------------------------------------------*/
    /**
     * Causes the WrapperManager to go into a state which makes the JVM appear
     *  to be hung when viewed from the native Wrapper code.  Does not have
     *  any effect when the JVM is not being controlled from the native
     *  Wrapper.
     */
    public void appearHung()
    {
        org.tanukisoftware.wrapper.WrapperManager.appearHung();
    }
    
    /**
     * Cause an access violation within native JNI code.  This currently causes
     *  the access violation by attempting to write to a null pointer.
     */
    public void accessViolationNative()
    {
        // This action normally will not return, so launch it in a background
        //  thread giving JMX a chance to return a response to its client.
        new Thread()
        {
            public void run()
            {
                try
                {
                    Thread.sleep( 1000 );
                }
                catch ( InterruptedException e )
                {
                }
                
                org.tanukisoftware.wrapper.WrapperManager.accessViolationNative();
            }
        }.start();
    }
    
    /**
     * Tells the native wrapper that the JVM wants to shut down and then
     *  promptly halts.  Be careful when using this method as an application
     *  will not be given a chance to shutdown cleanly.
     *
     * @param exitCode The exit code that the Wrapper will return when it exits.
     */
    public void stopImmediate( final int exitCode )
    {
        // This action normally will not return, so launch it in a background
        //  thread giving JMX a chance to return a response to its client.
        new Thread()
        {
            public void run()
            {
                try
                {
                    Thread.sleep( 1000 );
                }
                catch ( InterruptedException e )
                {
                }
                
                org.tanukisoftware.wrapper.WrapperManager.stopImmediate( exitCode );
            }
        }.start();
    }
}