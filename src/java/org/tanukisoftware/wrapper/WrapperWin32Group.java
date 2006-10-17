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
 * A WrapperGroup contains information about a group which a user
 *  belongs to.  A WrapperGroup is obtained via a WrapperUser.
 *
 * @author Leif Mortenson <leif@tanukisoftware.com>
 */
public class WrapperWin32Group
    extends WrapperGroup
{
    /** The current SID of the Group. */
    private String m_sid;
    
    /** The domain of the User Account. */
    private String m_domain;
    
    /*---------------------------------------------------------------
     * Constructors
     *-------------------------------------------------------------*/
    WrapperWin32Group( byte[] sid, byte[] user, byte[] domain )
    {
        super( user );
        
        // Decode the parameters using the default system encoding.
        m_sid = new String( sid );
        m_domain = new String( domain );
    }
    
    /*---------------------------------------------------------------
     * Methods
     *-------------------------------------------------------------*/
    /**
     * Returns the current Security Identifier (SID) of the user account.
     *
     * @return The SID of the user account.
     */
    public String getSID()
    {
        return m_sid;
    }
    
    /**
     * Returns the domain name of the user account.
     *
     * @return The domain name of the user account.
     */
    public String getDomain()
    {
        return m_domain;
    }
    
    /**
     * Returns the full name of the group.
     *
     * @return The full name of the group.
     */
    public String getAccount()
    {
        return m_domain + "/" + getGroup();
    }
    
    public String toString()
    {
        return "WrapperWin32Group[" + getAccount() + "]";
    }
}

