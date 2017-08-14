pragma solidity ^0.4.11;


import './SafeMath.sol';


contract Math is SafeMath {

    uint256 constant PRECISION = 64;  // fractional bits
    uint256 constant SUB_PRECISION = 48;  // fractional bits
    uint256 constant DECIMAL = 8;
    uint256 constant DECIMAL_ONE = uint256(100000000);
    uint256 constant ETHER_ONE = uint256(1000000000000000000);
    uint256 constant FLOAT_ONE = uint256(1) << PRECISION;
    uint256 constant ETHER_DECIMAL = ETHER_ONE/DECIMAL_ONE;
    uint256 constant FLOAT_DECIMAL = FLOAT_ONE/DECIMAL_ONE;

// MAX_D > MAX_E > MAX_F; accuracy(D)<accuracy(E)<accuracy(F)
// conversion MAX < min(MAX)*min(accuracy)
// mul max < (1<<127)
    uint256 constant MAX_F = uint256(1) << (255 - PRECISION);
    uint256 constant MAX_D = (uint256(1) << 255)/DECIMAL_ONE;
    uint256 constant MAX_E = (uint256(1) << 255)/ETHER_ONE;
    uint256 constant MAX_DF = MAX_F*DECIMAL_ONE;
    uint256 constant MAX_DE = MAX_E*DECIMAL_ONE;
    uint256 constant MAX_FE = MAX_F*ETHER_ONE;

    string public version = '0.1';

/** @dev constructor
    The values below depend on MIN_PRECISION and MAX_PRECISION. If you choose to change either one of them:
    Apply the same change in file 'PrintFunctionFormula.py', run it and paste the printed results below.
*/
    function Math() {
    }

/**
    @dev new Float

    @return Float
*/
    function Float(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_F);
        if (_int == 0){
            return 0;
        }else{
            return _int << PRECISION;
        }
    }

/**
    @dev new Decimal

    @return Decimal
*/
    function Decimal(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_D);
        if(_int == 0){
            return 0;
        }else{
            return safeMul(_int, DECIMAL_ONE);
        }
    }


/**
    @dev cast the Float to Decimal

    @return Decimal
*/
    function FloatToDecimal(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_DF);
        return (safeMul(_int, DECIMAL_ONE)) >> PRECISION;
    }

/**
    @dev cast the Decimal to Float

    @return Float
*/
    function DecimalToFloat(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_DF);
        return safeDiv((_int << PRECISION), DECIMAL_ONE);
    }

/**
    @dev cast the Ether to Decimal

    @return Decimal
*/
    function EtherToDecimal(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_DE);
        return safeDiv(_int, ETHER_DECIMAL);
    }

/**
    @dev cast the Decimal to Ether

    @return Ether
*/
    function DecimalToEther(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_DE);
        return safeMul(_int, ETHER_DECIMAL);
    }

/**
    @dev cast the Float to Ether

    @return Ether
*/
    function FloatToEther(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_FE);
        return (safeMul(_int, ETHER_ONE)) >> PRECISION;
    }

/**
    @dev cast the Ether to Float

    @return Float
*/
    function EtherToFloat(uint256 _int) internal constant returns (uint256) {
        assert(_int <= MAX_FE);
        return safeDiv((_int << PRECISION), ETHER_ONE);
    }

/**
    @dev returns the sum of _x and _y, asserts if the calculation overflows

    @param _x   value 1
    @param _y   value 2

    @return sum
*/
    function add(uint256 _x, uint256 _y)
    internal constant
    returns (uint256) {
        assert(_x <= MAX_F/2 && _y <= MAX_F/2);
        uint256 z = _x + _y;
        assert(z >= _x);
        return z;
    }

/**
    @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number

    @param _x   minuend
    @param _y   subtrahend

    @return difference
*/
    function sub(uint256 _x, uint256 _y)
    internal constant
    returns (uint256) {
        assert(_x <= MAX_F && _y <= MAX_F);
        assert(_x >= _y);
        return _x - _y;
    }

/**
    @dev returns the product of multiplying _x by _y, asserts if the calculation overflows

    @param _x   factor 1
    @param _y   factor 2

    @return product
*/
    function mul(uint256 _x, uint256 _y)
    internal constant
    returns (uint256) {
        assert(_x <= 1<<128 && _y <= 1<<128);
        uint256 z = _x * _y;
        assert(_x == 0 || z / _x == _y);
        z = z >> PRECISION;
        if(_x <= 1 && _y <= FLOAT_ONE){
            assert(z == 0);
        }else if(_y <= 1 && _x <= FLOAT_ONE){
            assert(z == 0);
        }else{
            assert(z != 0);
        }
        return z;
    }

/**
    @dev returns the division of divide _x by _y, asserts if the calculation overflows

    @param _x   value 1
    @param _y   value 2

    @return division
*/
    function div(uint256 _x, uint256 _y)
    internal constant
    returns (uint256) {
        assert(_x <= MAX_F && _y <= MAX_F);
        assert(_y > 0);
    // Solidity automatically throws when dividing by 0
        _x = _x << PRECISION;
        uint256 _z = _x / _y;
        assert(_x == _z * _y + _x % _y);
    // There is no case in which this doesn't hold
        return _z;
    }

}
