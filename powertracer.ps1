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

    static [Tuple]Normalize(
        [Tuple] $t1
    ){
        $m = $t1.Magnitude()
        # Assuming $m != 0
        return [Tuple]::New($t1.coord[0]/$m,
                            $t1.coord[1]/$m,
                            $t1.coord[2]/$m,
                            $t1.coord[3]/$m)
    }

    static [Float]Dot(
            [Tuple] $t1,
            [Tuple] $t2
        ){
            return ($t1.coord[0]*$t2.coord[0] +
                    $t1.coord[1]*$t2.coord[1] +
                    $t1.coord[2]*$t2.coord[2] +
                    $t1.coord[3]*$t2.coord[3])
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

##########
# Vector #
##########

class Vector : Tuple {
    
    # Constructors
    Vector(
        [Float]$x,
        [Float]$y,
        [Float]$z
    ) : base($x,$y,$z,0) {}

    # Static Methods

    static [Vector]Cross(
        [Vector] $v1,
        [Vector] $v2
    ){
        return [Vector]::New($v1.coord[1]*$v2.coord[2] - $v1.coord[2]*$v2.coord[1],
                            $v1.coord[2]*$v2.coord[0] - $v1.coord[0]*$v2.coord[2],
                            $v1.coord[0]*$v2.coord[1] - $v1.coord[1]*$v2.coord[0])
}


}


#########
# Color #
#########

class Color : Tuple {
    
    # Constructors
    Color(
        [Float]$r,
        [Float]$g,
        [Float]$b
    ) : base($r,$g,$b,0) {}


    [Float] red(){
        return $this.x()
    }

    [Float] green(){
        return $this.y()
    }

    [Float] blue(){
        return $this.z()
    }

    static [Color]Multiply(
            [Color] $c1,
            [Color] $c2
        ){
            return [Color]::New($c1.coord[0]*$c2.coord[0], 
                                $c1.coord[1]*$c2.coord[1], 
                                $c1.coord[2]*$c2.coord[2])
        }
}

##########
# Canvas #
##########


class Canvas {
    # Properties
    hidden [Int] $width
    hidden [Int] $height
    hidden [Color[]] $pixels

    # Constructors
    Canvas(
        [Float]$width,
        [Float]$height
    ){
        $this.pixels = new-object Color[] ($width*$height)
        $this.width=$width
        $this.height=$height

        for ($i = 0; $i -lt ($width*$height); $i++) {
            $this.pixels[$i] = [Color]::New(0,0,0)
        }
    }

    # Methods
    [Void] WritePixel(
        [Int] $w,
        [Int] $h,
        [Color] $c
    ){
        $this.pixels[$this.width * $h + $w] = $c
    }

    [Color] PixelAt(
        [Int] $w,
        [Int] $h
    ){
        return $this.pixels[$this.width * $h + $w]
    }

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

[Tuple]::Normalize($v1)

$v2 = [Vector]::New(2,3,4)
[Tuple]::Dot($v1,$v2)
[Vector]::Cross($v1,$v2)
[Vector]::Cross($v2,$v1)

$c = [Color]::New(-0.5,0.4,1.7)
$c
$c.red()
$c.green()
$c.blue()

$c1 = [Color]::New(0.9,0.6,0.75)
$c2 = [Color]::New(0.7,0.1,0.25)
[Color]::Add($c1,$c2)
[Color]::Subtract($c1,$c2)
[Color]::ScalarMult([Color]::New(0.2,0.3,0.4),2)
[Color]::Multiply([Color]::New(1,0.2,0.4),[Color]::New(0.9,1,0.1))

$canvas = [Canvas]::New(10,20)
$canvas.WritePixel(2,3,[Color]::New(1,0,0))
$canvas.PixelAt(2,3)
