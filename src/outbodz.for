c###outbod.for
      SUBROUTINE OUTBODZ(ipoint,SPWR,SNA,PSN)
      dimension XDBU(24,12),SPWR(24,12),SNA(24,12),PSN(24,12)
C.....VERSION 10.APRIL.92
      CHARACTER*4 NFREQ
      CHARACTER*4 NAMES,APW,KLINE(6),DASH
      CHARACTER*40 VERSN
      COMMON /CON/D2R, DCL, GAMA, PI, PI2, PIO2, R2D, RZ, VOFL
      COMMON /DON/AMIN,AMIND,BTR,BTRD,BRTD,GCD,GCDKM,PWR,XPW,APW
     A ,RLAT,RLATD,RLONG,RLONGD,SSN,TLAT,TLATD,TLONG,TLONGD,PLAT,PLONG
     B ,PGLAT,ACAV,ASM,FEAV,GMT,VERSN,XLZ,GCDFTZ,GCDEND,XINTS,XINTL
     C ,FLUX,CY12(5),DMXA(24),DMX0,CYRAD(5)
      LOGICAL YNOISE
      COMMON /TNOISE/BDWTH,JBW,JRSN,LUF,MAN,RLUF,RSN,XSN(2),YNOISE
      COMMON / FILES / LUI,LUO,LU2,LU5,LU6,LU8,LU16,LU61,LU7,LU15
      COMMON /FRQ/ FREL(12),FREL5(11,7),FW5(11,7),MAXF,MF,KOF,FREQ
     A, JKF,FXEMAX
      character*4 IRLAT,IRLONG,ITLAT,ITLONG,IRCVR,ITRANS
      COMMON /ION/ IRLAT,IRLONG,ITLAT,ITLONG,IRCVR(5),ITRANS(5),IT,ITRUN
     A,IT1,IT2,ITSTEP,KM,IA,METHOD,ICON,NPSL,NYEAR,NPAGO,ICGM
      COMMON/MUFS/ EMUF(24,3),F2MUF(24,6),ALLMUF(24),EFMUF(24),FOT(24)
     A,FOT1(24),XLUF(24),ZLUF(24),OPMUF(24),OPMUF1(24),FU(24),FL(24)
     B, KFN,LUFC,NLOOP,ACT1,DXL,XMODE,FX,PR
      COMMON/NAMEX/NAMES(20),ISSN,IRED,LINES,LPAGES,MAPIN,KRUN
C RAY MODES FOR DISTANCE GHOP,SEE SUBROUTINE CURMUF
      COMMON/MODES/ DELMOD(9),UTMOD(9),ABPS(9),FLDST(9),FSLOS(9)
     1,GRLOS(9),TLOSS(9),XLOSS(9),DELMD1(9),UTMD1(9),KANGLE(12)
     2,DBLOS(12),DBU(12),MODE(12),NHP(12),KANGLA(24,12)
     3,MODEA(24,12),KANGL4(4,12),KDBU4(4,12),DBU4(4,12),MODE4(4,12)
     4,NHP4(4,12),KODEA(24,12)
       character*4 MODE,MODEA,MODE4

      GMT=IT
C.....

      WRITE(LUO,1506) ipoint,it,icgm,allmuf(IT),NINT(SPWR(IT,12)),
     +                (NINT(SPWR(IT,I)),I=1,MAXF)
1506  FORMAT(2i3,i2,f5.1,11I5)
      RETURN
      END