#############
# Constants #
#############


Set-Variable EPSILON -option Constant -value 0.0001

###########
# Helpers #
###########

function is_equal {
    param (
        [Parameter(Mandatory)]
        [Float] $a,
        [Parameter(Mandatory)]
        [Float] $b
    )

    if ([Math]::Abs($a-$b) -lt $EPSILON) {
        return $true
    } else {
        return $false
    }
    
}


#########
# Tuple #
#########

class Tuple {
    # Properties
    [Float]$x
    [Float]$y
    [Float]$z
    [Float]$w

    # Constructors
    Tuple(
        [Float]$x,
        [Float]$y,
        [Float]$z,
        [Float]$w
    ){
        $this.x=$x
        $this.y=$y
        $this.z=$z
        $this.w=$w
    }

    # Methods

    [Bool]is_Point(){
        return is_equal $this.w 1
    }

    [Bool]is_Vector(){
        return is_equal $this.w 0
    }    

    [String]ToString(){
        return ("[{0};{1};{2};{3}]" -f $this.x, $this.y, $this.z, $this.w)
    }
     
}

$a=[Tuple]::New(4.3,-4.2,3.1,1.0)
$a.ToString()
$a.is_Point()
$a.is_Vector()

$b=[Tuple]::New(4.3,-4.2,3.1,0.0)
$b.ToString()
$b.is_Point()
$b.is_Vector()