/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderDelivery";
	
	// Data Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="orderDeliveryItems" type="array" hb_populateArray="true";
	
	property name="trackingNumber";
	property name="captureAuthorizedPaymentsFlag" hb_formFieldType="yesno";
	property name="capturableAmount" hb_formatType="currency";
	
	variables.orderDeliveryItems = [];
	
	public numeric function getCapturableAmount() {
		if(!structKeyExists(variables, "capturableAmount")) {
			
			variables.capturableAmount = 0;
			
			for(var i=1; i<=arrayLen(getOrderDeliveryItems()); i++) {
				var orderItem = getService('orderService').getOrderItem(getOrderDeliveryItems()[i].orderItem.orderItemID);
				var thisQuantity = getOrderDeliveryItems()[i].quantity;
				if(thisQuantity > orderItem.getQuantityUndelivered()) {
					thisQuantity = orderItem.getQuantityUndelivered();
				}
				variables.capturableAmount = precisionEvaluate('variables.capturableAmount + ((orderItem.getQuantityUndelivered() / thisQuantity) * orderItem.getExtendedPriceAfterDiscount())');
			}
			
			if(getOrder().getPaymentAmountReceivedTotal() eq 0) {
				variables.capturableAmount = precisionEvaluate('variables.capturableAmount + getOrderFulfillment().getChargeAfterDiscount()');
			} else {
				variables.capturableAmount = precisionEvaluate('variables.capturableAmount - (getOrder().getPaymentAmountReceivedTotal() - getOrder().getDeliveredItemsAmountTotal())');
			}
			
			if(variables.capturableAmount lt 0) {
				variables.capturableAmount = 0;
			}
			
		}
		return variables.capturableAmount;
	}
	
	public boolean function getCaptureAuthorizedPaymentsFlag() {
		if(!structKeyExists(variables, "captureAuthorizedPaymentsFlag")) {
			variables.captureAuthorizedPaymentsFlag = 0;
			if(getCapturableAmount()) {
				variables.captureAuthorizedPaymentsFlag = 1;	
			}
		}
		return variables.captureAuthorizedPaymentsFlag;
	}
	
}
