function Y=Deriv_Plink(x)

global ep;

Y=(Plink(x+ep)-Plink(x))/ep;

end


