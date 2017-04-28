public with sharing class PSGeoUtils
{
  public PSGeoUtils()
  {
    
  }

  public static String reverseGeocodeGoogle(Decimal lat, Decimal lng)
  {
    Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?latlng=' + lat + ',' + lng + '&key=AIzaSyD50QQC09XzytM5m_fFkNN00SelCPy6C7M');
    req.setMethod('GET');

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    System.debug('response=' + res.getBody());
    return res.getBody();
  }

  public static String reverseGeocodeEsri(Decimal lat, Decimal lng)
  {
    System.debug('lat=' + lat + ' lng=' + lng);
    Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?location=' + lng + ',' + lat + '&f=json');
    req.setMethod('GET');

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    System.debug('response=' + res.getBody());
    return res.getBody();
  }

  public static String geocodeEsri(String fullAddress)
  {
    System.debug('address=' + fullAddress);
    Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?singleLine=' + EncodingUtil.urlEncode(fullAddress, 'UTF-8') + '&f=json&maxLocations=1');
    req.setMethod('GET');

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    System.debug('response=' + res.getBody());
    return res.getBody();
  }

  public static String geocodeEsri(String street, String city, String state, String postal)
  {
    Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?address=' + EncodingUtil.urlEncode(street, 'UTF-8') + '&city=' + EncodingUtil.urlEncode(city, 'UTF-8') + '&subregion=' + EncodingUtil.urlEncode(state, 'UTF-8') + '&postal=' + EncodingUtil.urlEncode(postal, 'UTF-8') + '&f=json&maxLocations=1');
    req.setMethod('GET');

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    System.debug('response=' + res.getBody());
    return res.getBody();
  }

  @future (callout = true)
  public static void geocodeAddress(String recordId, String address, String latField, String lngField)
  {
    try
    {
      Id recId = Id.valueOf(recordId);
      Schema.SObjectType token = recId.getSObjectType();
      Schema.DescribeSObjectResult dr = token.getDescribe();

      if (address != null && address.length() > 0)
      {
        String resp = geocodeEsri(address);
        System.debug('resp=' + resp);

        PSEsriGeocodeResponse esriResp = (PSEsriGeocodeResponse)JSON.deserialize(resp, PSEsriGeocodeResponse.class);
        System.debug('json=' + JSON.serializePretty(esriResp));
        System.debug('location.x=' + esriResp.candidates[0].location.x);
        System.debug('location.y=' + esriResp.candidates[0].location.y);

        SObject sobj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
        sobj.Id = recId;
        sobj.put(latField, esriResp.candidates[0].location.y);
        sobj.put(lngField, esriResp.candidates[0].location.x);
        update sobj;
      }
      else
      {
        SObject sobj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
        sobj.Id = recId;
        sobj.put(latField, null);
        sobj.put(lngField, null);
        update sobj;
      }
    }
    catch (Exception e)
    {
      // consume error
    }
  }

  @future (callout = true)
  public static void geocodeAddress(String recordId, String street, String city, String state, String postal, String latField, String lngField)
  {
    try
    {
      Id recId = Id.valueOf(recordId);
      Schema.SObjectType token = recId.getSObjectType();
      Schema.DescribeSObjectResult dr = token.getDescribe();

      if (street != null && street.length() > 0 &&
          city != null && city.length() > 0 &&
          state != null && state.length() > 0 &&
          postal != null && postal.length() > 0)
      {
        String resp = geocodeEsri(street, city, state, postal);
        System.debug('resp=' + resp);

        PSEsriGeocodeResponse esriResp = (PSEsriGeocodeResponse)JSON.deserialize(resp, PSEsriGeocodeResponse.class);
        System.debug('json=' + JSON.serializePretty(esriResp));
        System.debug('location.x=' + esriResp.candidates[0].location.x);
        System.debug('location.y=' + esriResp.candidates[0].location.y);

        SObject sobj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
        sobj.Id = recId;
        sobj.put(latField, esriResp.candidates[0].location.y);
        sobj.put(lngField, esriResp.candidates[0].location.x);
        update sobj;
      }
      else
      {
        SObject sobj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
        sobj.Id = recId;
        sobj.put(latField, null);
        sobj.put(lngField, null);
        update sobj;
      }
    }
    catch (Exception e)
    {
      // consume error
    }
  }

  @future (callout = true)
  public static void reverseGeocodeAddress(String recordId, Decimal lat, Decimal lng, String fullAddressField, String streetField, String cityField, String statefield, String postalField)
  {
    try
    {
      if (lat != null && lng != null)
      {
        Id recId = Id.valueOf(recordId);
        Schema.SObjectType token = recId.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();

        if (lat != null && lng != null)
        {
          String resp = reverseGeocodeEsri(lat, lng);
          System.debug('resp1=' + resp);

          PSEsriReverseGeocodeResponse esriResp = (PSEsriReverseGeocodeResponse)JSON.deserialize(resp, PSEsriReverseGeocodeResponse.class);

          SObject sobj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
          sobj.Id = recId;

          if (fullAddressField != null) sobj.put(fullAddressField, esriResp.address.Match_addr);
          if (streetField != null) sobj.put(streetField, esriResp.address.Address);
          if (cityField != null) sobj.put(cityField, esriResp.address.City);
          if (stateField != null) sobj.put(stateField, PSDemoUtils.convertStateToShort(esriResp.address.Region));
          if (postalField != null) sobj.put(postalField, esriResp.address.Postal);
          update sobj;
        }
        else
        {
          SObject sobj = Schema.getGlobalDescribe().get(dr.getName()).newSObject();
          sobj.Id = recId;
          if (fullAddressField != null) sobj.put(fullAddressField, '');
          if (streetField != null) sobj.put(streetField, '');
          if (cityField != null) sobj.put(cityField, '');
          if (stateField != null) sobj.put(stateField, '');
          if (postalField != null) sobj.put(postalField, '');
          update sobj;
        }
      }
    }
    catch (Exception e)
    {
      // consume error
    }
  }

  


}