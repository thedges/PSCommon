global class PSDecimalRangeComparator implements PSObjectComparator{

    global Integer compare(Object object1, Object object2){
        if(object1==null || !(object1 instanceof DecimalRange)
        || object2==null || !(object2 instanceof DecimalRange)){
            throw new PSIllegalArgumentException();
        }
        Decimal dr1 = ((DecimalRange) object1).min();
        Decimal dr2 = ((DecimalRange) object2).min();
        if(dr1 < dr2){
            return -1;
        } else if(dr1 == dr2){
            return 0;
        }else{
            return 1;
        }
    }

}