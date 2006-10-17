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

import java.util.Vector;

/**
 * A WrapperUser contains information about a user account on the platform
 *  running the Wrapper.  A WrapperUser is obtained by calling
 *  WrapperManager.getUser() or WrapperManager.getInteractiveUser().
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public abstract class WrapperUser
{
    /* The name of the user. */
    private String m_user;
    
    /** A list of the groups that this user is registered with.
     *   This uses a Vector to be compatable with 1.2.x JVMs. */
    private Vector m_groups = new Vector();
    
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    WrapperUser( byte[] user )
    {
        // Decode the parameters using the default system encoding.
        m_user = new String( user );
    }
    
    /*---------------------------------------------------------------
     * Methods
     *-------------------------------------------------------------*/
    /**
     * Returns the name of the user.
     *
     * @return The name of the user.
     */
    public String getUser()
    {
        return m_user;
    }
    
    /**
     * Adds a group to the user.
     *
     * @param group WrapperGroup to be added.
     */
    void addGroup( WrapperGroup group )
    {
        m_groups.addElement( group );
    }
    
    /**
     * Returns an array of WrapperGroup instances which define the groups that
     *  the user belongs to.
     *
     * @return An array of WrapperGroups.
     */
    public WrapperGroup[] getGroups()
    {
        WrapperGroup[] groups = new WrapperGroup[m_groups.size()];
        m_groups.toArray( groups );
        
        return groups;
    }
}

