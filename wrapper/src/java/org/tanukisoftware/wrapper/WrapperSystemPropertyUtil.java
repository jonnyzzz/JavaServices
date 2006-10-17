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
 * A collection of utility methods which make it easy to work with System
 *  Properties without littering code with error handling.
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public final class WrapperSystemPropertyUtil
{
    /*---------------------------------------------------------------
     * Static Methods
     *-------------------------------------------------------------*/
    /**
     * Resolves a boolean property.
     *
     * @param name The name of the property to lookup.
     * @param defaultValue The value to return if it is not set or is invalid.
     *
     * @return The requested property value.
     */
    public static boolean getBooleanProperty( String name, boolean defaultValue )
    {
        String val = System.getProperty( name );
        if ( val != null )
        {
            if ( val.equalsIgnoreCase( "TRUE" ) )
            {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Resolves an integer property.
     *
     * @param name The name of the property to lookup.
     * @param defaultValue The value to return if it is not set or is invalid.
     *
     * @return The requested property value.
     */
    public static int getIntProperty( String name, int defaultValue )
    {
        String val = System.getProperty( name );
        if ( val != null )
        {
            try
            {
                return Integer.parseInt( val );
            }
            catch ( NumberFormatException e )
            {
                return defaultValue;
            }
        }
        else
        {
            return defaultValue;
        }
    }
    
    /**
     * Resolves a long property.
     *
     * @param name The name of the property to lookup.
     * @param defaultValue The value to return if it is not set or is invalid.
     *
     * @return The requested property value.
     */
    public static long getLongProperty( String name, long defaultValue )
    {
        String val = System.getProperty( name );
        if ( val != null )
        {
            try
            {
                return Long.parseLong( val );
            }
            catch ( NumberFormatException e )
            {
                return defaultValue;
            }
        }
        else
        {
            return defaultValue;
        }
    }
    
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    /**
     * Not instantiable.
     */
    private WrapperSystemPropertyUtil()
    {
    }
}

