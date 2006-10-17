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

import java.io.InputStream;
import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

/**
 * Provides a Properties object which can be locked to prevent modification
 *  by the user.
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
class WrapperProperties
    extends Properties
{
    boolean m_locked = false;
    
    /**
     * Locks the Properties object against future modification.
     */
    public void lock()
    {
        m_locked = true;
    }
    
    public void load( InputStream inStream )
        throws IOException
    {
        if ( m_locked )
        {
            throw new IllegalStateException( "Read Only" );
        }
        super.load( inStream );
    }
    
    public Object setProperty( String key, String value )
    {
        if ( m_locked )
        {
            throw new IllegalStateException( "Read Only" );
        }
        return super.setProperty( key, value );
    }
    
    public void clear()
    {
        if ( m_locked )
        {
            throw new IllegalStateException( "Read Only" );
        }
        super.clear();
    }
    
    public Set entrySet()
    {
        if ( m_locked )
        {
            return Collections.unmodifiableSet( super.entrySet() );
        }
        else
        {
            return super.entrySet();
        }
    }
    
    public Set keySet()
    {
        if ( m_locked )
        {
            return Collections.unmodifiableSet( super.keySet() );
        }
        else
        {
            return super.keySet();
        }
    }
    
    public Object put( Object key, Object value )
    {
        if ( m_locked )
        {
            throw new IllegalStateException( "Read Only" );
        }
        return super.put( key, value );
    }
    
    public void putAll( Map map )
    {
        if ( m_locked )
        {
            throw new IllegalStateException( "Read Only" );
        }
        super.putAll( map );
    }
    
    public Object remove( Object key )
    {
        if ( m_locked )
        {
            throw new IllegalStateException( "Read Only" );
        }
        return super.remove( key );
    }
    
    public Collection values()
    {
        if ( m_locked )
        {
            return Collections.unmodifiableCollection( super.values() );
        }
        else
        {
            return super.values();
        }
    }
}

