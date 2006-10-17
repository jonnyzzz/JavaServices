package org.tanukisoftware.wrapper.test;

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

import org.tanukisoftware.wrapper.WrapperManager;

/**
 *
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public class OnExit {
    /*---------------------------------------------------------------
     * Main Method
     *-------------------------------------------------------------*/
    public static void main(String[] args) {
        System.out.println("Test the handling of on exit handlers.");
        System.out.println("The Wrapper should restart the JVM when it detects and exit code of ");
        System.out.println("  1, 2, or any code except 3.  It will then shutdown if it detects ");
        System.out.println("  an exit code of 3.");
        System.out.println();
        
        int exitCode = WrapperManager.getJVMId();
        switch ( exitCode )
        {
        case 1:
        case 2:
            System.out.println( "Stopping the JVM with an exit code of " + exitCode + ", the " );
            System.out.println( " Wrapper should restart." );
            break;
            
        case 3:
            System.out.println( "Stopping the JVM with an exit code of " + exitCode + ", the " );
            System.out.println( " Wrapper should stop." );
            break;
            
        default:
            System.out.println( "The Wrapper should have stopped on the previous exitCode 3." );
            System.out.println( " We should not be here." );
            break;
        }
        WrapperManager.stop( exitCode );
    }
}

