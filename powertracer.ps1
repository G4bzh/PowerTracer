# Trick to get . as decimal separator
[cultureinfo]::currentculture = 'en-US';

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
    hidden [Float[]]$coord

    # Constructors
    Tuple(
        [Float]$x,
        [Float]$y,
        [Float]$z,
        [Float]$w
    ){
        $this.coord = new-object Float[] 4
        $this.coord[0]=$x
        $this.coord[1]=$y
        $this.coord[2]=$z
        $this.coord[3]=$w
    }

    # Methods

    [Float] x(){
        return $this.coord[0]
    }

    [Float] y(){
        return $this.coord[1]
    }

    [Float] z(){
        return $this.coord[2]
    }

    [Float] w(){
        return $this.coord[4]
    }

    [Float] Magnitude(){
        return [Math]::sqrt(
            $this.coord[0]*$this.coord[0] +
            $this.coord[1]*$this.coord[1] +
            $this.coord[2]*$this.coord[2] +
            $this.coord[3]*$this.coord[3]
        )
    }

    [Bool]is_Point(){
        return is_equal $this.coord[3] 1
    }

    [Bool]is_Vector(){
        return is_equal $this.coord[3] 0
    }    

    [String]ToString(){
        return $this.coord -join ','
    }

    # Static Methods
    static [Tuple]Add(
            [Tuple] $t1,
            [Tuple] $t2
        ){
            return [Tuple]::New($t1.coord[0]+$t2.coord[0],
                                $t1.coord[1]+$t2.coord[1],
                                $t1.coord[2]+$t2.coord[2],
                                $t1.coord[3]+$t2.coord[3])
    }
    
    static [Tuple]Subtract(
        [Tuple] $t1,
        [Tuple] $t2
    ){
        return [Tuple]::New($t1.coord[0]-$t2.coord[0],
                            $t1.coord[1]-$t2.coord[1],
                            $t1.coord[2]-$t2.coord[2],
                            $t1.coord[3]-$t2.coord[3])
    }

    static [Tuple]Negate(
        [Tuple] $t1
    ){
        return [Tuple]::New(-$t1.coord[0],
                            -$t1.coord[1],
                            -$t1.coord[2],
                            -$t1.coord[3])
    }

    static [Tuple]ScalarMult(
        [Tuple] $t1,
        [Float] $a
    ){
        return [Tuple]::New($a*$t1.coord[0],
                            $a*$t1.coord[1],
                            $a*$t1.coord[2],
                            $a*$t1.coord[3])
    }

    static [Tuple]ScalarDiv(
        [Tuple] $t1,
        [Float] $a
    ){
        # Assuming $a != 0
        return [Tuple]::New($t1.coord[0]/$a,
                            $t1.coord[1]/$a,
                            $t1.coord[2]/$a,
                            $t1.coord[3]/$a)
    }


}

#########
# Point #
#########

class Point : Tuple {
    
    # Constructors
    Point(
        [Float]$x,
        [Float]$y,
        [Float]$z
    ) : base($x,$y,$z,1) {}

 }

#########
# Point #
#########

class Vector : Tuple {
    
    # Constructors
    Vector(
        [Float]$x,
        [Float]$y,
        [Float]$z
    ) : base($x,$y,$z,0) {}

}


#########
# Tests #
#########


$a=[Tuple]::New(4.3,-4.2,3.1,1.0)
Write-Host "Tuple: " $a.ToString()
Write-Host "`t is a point ? " $a.is_Point()
Write-Host "`t is a Vector ? " $a.is_Vector()

$b=[Tuple]::New(4.3,-4.2,3.1,0.0)
Write-Host "Tuple: " $b.ToString()
Write-Host "`t is a point ? " $b.is_Point()
Write-Host "`t is a Vector ? " $b.is_Vector()

$p=[Point]::New(4,-4,3)
Write-Host "Point: " $p.ToString()
Write-Host "`t is a point ? " $p.is_Point()
Write-Host "`t is a Vector ? " $p.is_Vector()

$v=[Vector]::New(4,-4,3)
Write-Host "Vector: " $v.ToString()
Write-Host "`t is a point ? " $v.is_Point()
Write-Host "`t is a Vector ? " $v.is_Vector()

$a1=[Tuple]::New(3,-2,5,1)
$a2=[Tuple]::New(-2,3,1,0)
$a1
$a2
[Tuple]::Add($a1,$a2)

$p1 = [Point]::New(3,2,1)
$p2 = [Point]::New(5,6,7)
$p1
$p2
[Tuple]::Subtract($p1,$p2)

[Tuple]::Negate($a1)
[Tuple]::ScalarMult($a1,2.5)
[Tuple]::ScalarDiv($a1,2)

$v1 = [Vector]::New(1,2,3)
$v1.Magnitude()
is_equal $v1.Magnitude() ([Math]::sqrt(14))