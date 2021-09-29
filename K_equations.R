K_equations <- function(AMF, silt, sand, a, b, c) {
  
  t = silt + AMF
  d = sand - AMF
  m1 <- 67*(67 + d) + (t - 67)*(-2.416*d - 17.03*t + 0.02491*d^2 + 0.1103*t^2 + 0.03238*t*d + 730.8)
  
  if (t <= 67) {
    m = t*(t + d)
  } else if (m1 <= 8000) {
    m = m1
  } else{
    k = NA
    return(k)
  }
  
  kt = 2.1*10^(-5)*m^(1.14)
  k0 = (12 - a)*10^(-1)
  k1 = kt*k0
  ks = 3.25*10^(-2)*(b - 2)
  
  if (k1 + ks >= 0.106) {
    k1s = k1 + ks
  } else {
    k1s = (0.8726 + 1.3913*b - 0.3117*b^2 + 0.0238*b^3)*k1^2 + (-0.0843 + 0.1099*b - 0.0608*b^2 + 0.0215*b^3)*k1 + 0.07
  }
  
  kp = 2.5*10^(-2)*(c - 3)
  
  k = k1s + kp
  return(round(k, digits = 3))
}
