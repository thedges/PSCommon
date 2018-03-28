public with sharing class PSEsriReverseGeocodeResponse {
	public PSEsriReverseGeocodeResponse() {
		
	}

	public Address address;
	public Location location;

	public class Address
	{
		public String Address;
        public String Neighborhood;
        public String City;
        public String Subregion;
        public String Region;
        public String Postal;
        public String PostalExt;
        public String CountryCode;
        public String Match_addr;
        public String Loc_name;
        public String Addr_type;
	}

	public class Location
	{
		public Decimal x;
		public Decimal y;
		public SpatialReference spatialReference;
	}

	public class SpatialReference
	{
		public Integer wkid;
		public Integer latestWkid;
	}
}