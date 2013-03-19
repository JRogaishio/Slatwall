<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfparam name="rc.orderSmartList" type="any" />

<cfoutput>
	<cf_HibachiEntityActionBar type="listing" object="#rc.orderSmartList#" showCreate="false">
		<!--- Create --->
		<cf_HibachiEntityActionBarButtonGroup>
			<cf_HibachiProcessCaller action="admin:entity.preprocessorder" entity="order" processContext="create" class="btn btn-primary" icon="plus icon-white" text="#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.order')#" modal="true" />
		</cf_HibachiEntityActionBarButtonGroup>
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiListingDisplay smartList="#rc.orderSmartList#" 
							  recordDetailAction="admin:entity.detailorder"
							  recordEditAction="admin:entity.editorder">
		<cf_HibachiListingColumn propertyIdentifier="orderNumber" search="true" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="account.company" search="true"/>
		<cf_HibachiListingColumn propertyIdentifier="account.firstName" search="true" />
		<cf_HibachiListingColumn propertyIdentifier="account.lastName" search="true" />
		<cf_HibachiListingColumn propertyIdentifier="orderType.type" filter=true />
		<cf_HibachiListingColumn propertyIdentifier="orderStatusType.type" title="#$.slatwall.rbKey('define.status')#" filter="true" />
		<cf_HibachiListingColumn propertyIdentifier="orderOrigin.orderOriginName" filter="true" />
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime"  range=true />
		<cf_HibachiListingColumn propertyIdentifier="orderOpenDateTime"  range=true />
		<cf_HibachiListingColumn propertyIdentifier="calculatedTotal" range=true />
	</cf_HibachiListingDisplay>
</cfoutput>