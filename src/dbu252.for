      SUBROUTINE DBU252
C----------------------------------------------------------------------
C      Version 02.June.95   (Rec. 842 reliability added)
C----------------------------------------------------------------------
      INTEGER*4 INDEX(9),PERCENT,JKA(5),KFA(5)
      LOGICAL YNOISE
      REAL SECD(9),FEC(9),XLS(9),SIGPWR(9),PRSA(12)
      REAL*8 RSS1,RSS2,DTEN,E1,E2,F1,F2,F3
      REAL*8 SPE1,SPE2,SPF1,SPF2,SPF3
      character*4 NMODE(10),NMODES(9)
      CHARACTER*40 VERSN
C.WP3L.RG4  June 95 add 'SFA' to COMMON /NOISE/
      COMMON /NOISE/ ATMO,GNOS,XNOISE,SFA,ATNU,ATNY,CC,TM,KJ,JK
      COMMON /NSTATS/ DU,DL,DUA,DLA,DUM,DLM,DUG,DLG
      COMMON /TNOISE/BDWTH,JBW,JRSN,LUF,MAN,RLUF,RSN,XSN(2),YNOISE
      COMMON /CON/D2R, DCL, GAMA, PI, PI2, PIO2, R2D, RZ, VOFL
      COMMON /DON/AMIN,AMIND,BTR,BTRD,BRTD,GCD,GCDKM,PWR,XPW,APW
     A ,RLAT,RLATD,RLONG,RLONGD,SSN,TLAT,TLATD,TLONG,TLONGD,PLAT,PLONG
     B ,PGLAT,ACAV,ASM,FEAV,GMT,VERSN,XLZ,GCDFTZ,GCDEND,XINTS,XINTL
     C ,FLUX,CY12(5),DMXA(24),DMX0,CYRAD(5)
      COMMON /FRQ/ FREL(12),FREL5(11,7),FW5(11,7),MAXF,MF,KOF,FREQ
     A, JKF,FXEMAX
      COMMON/FSTAB/ZTAB(24,12),ZSPWR(24,12)
      COMMON/MUFS/ EMUF(24,3),F2MUF(24,6),ALLMUF(24),EFMUF(24),FOT(24)
     A ,FOT1(24),XLUF(24),ZLUF(24),OPMUF(24),OPMUF1(24),FU(24),FL(24)
     B, KFN,LUFC,NLOOP,ACT1,DXL,XMODE,FX,PR
      COMMON /SOL/ DECL12(12),EQT12(12),DECL,EQT,MONTH,IMON(12)
      COMMON/GEOG/ABIY(5),CLAT(5),CLONG(5),CLCK(5),EPSPAT(5),F2M3(5)
c>>(b)WP-6A SEPT. 93 MODS add 2 lines REMOVE 1 LINE
     A,FI(3,5),GLAT(5),GMDIP(5),GYZ100(5),GYR100,GYZ300(5),HPF2(5),RD(5)
     B,SIGPAT(5),CYCEN(5)
CX   A,FI(3,5),GLAT(5),GMDIP(5),GYZ(5),HPF2(5),RD(5),SIGPAT(5),CYCEN(5)
c>>(b)WP-6A SEPT. 93 MODS end of change
      character*4 IRLAT,IRLONG,ITLAT,ITLONG,IRCVR,ITRANS
      COMMON /ION/ IRLAT,IRLONG,ITLAT,ITLONG,IRCVR(5),ITRANS(5),IT,ITRUN
     A,IT1,IT2,ITSTEP,KM,IA,METHOD,ICON,NPSL,NYEAR,NPAGO,ICGM
      COMMON /IPAR/ XF2(3,24),XM3(3,24),XE(5,24),CY24H(5,24),KF
      COMMON / HOG / IANTT, BANTT, IANTR, BANTR
C RAY MODES FOR DISTANCE GHOP,SEE SUBROUTINE CURMUF
      COMMON/MODES/ DELMOD(9),UTMOD(9),ABPS(9),FLDST(9),FSLOS(9)
     1,GRLOS(9),TLOSS(9),XLOSS(9),DELMD1(9),UTMD1(9),KANGLE(12)
     2,DBLOS(12),DBU(12),MODE(12),NHP(12),KANGLA(24,12)
     3,MODEA(24,12),KANGL4(4,12),KDBU4(4,12),DBU4(4,12),MODE4(4,12)
     4,NHP4(4,12),KODEA(24,12)
       character*4 MODE,MODEA,MODE4
C.WP3L.RG4  Jun mod 1 line
      COMMON /FADE/ PERCENT,FRACX,FSX,FBX,DUSN,DLSN,SDU,SDL,SHU,SHL
      DATA TEN,DTEN/10.0,10.0D+00/
      DATA NMODE/3*'E   ',6*'F2  ','    '/
C
C.WP3L.RG4  June 95 remove 2 lines
CREM      SUM2(A1,A2)=SQRT(A1*A1+A2*A2)
CREM      SUM3(A1,A2,A3)=SQRT(A1*A1+A2*A2+A3*A3)
C.WP3L.RG4 June 95 END
C.....FORMULAE FOR ROOT SUM SQ. DETERMINATIONS (REC 533)
      RSS1(DTEN,E1,E2,F1,F2,F3)=DTEN*DLOG10(DTEN**E1+DTEN**E2
     1+DTEN**F1+DTEN**F2+DTEN**F3)
      RSS2(DTEN,F1,F2,F3)=DTEN*DLOG10(DTEN**F1+DTEN**F2+DTEN**F3)
C.....FORMULA FOR CALC. OF SIGNAL POWER (Rec. 533 eq.35)
      SPWF(FS,RGAIN,OPFREQ)=FS+RGAIN-20.0*ALOG10(OPFREQ)-107.2
      data FLOW,FHIGH/2.,30./
c>>(b)WP-6A SEPT. 93 MODS CHANGE REMOVE 'GYRO=....'
CX    GYRO=GYZ(JKF)
C     MEDIAN LOSS ADJUSTMENT
      ADJ=ASM+XLZ
      IF(GCDKM.GT.4000.) GO TO 215
C.....E-MODES
      IE=1
  210 DELE=D2R*DELMOD(IE)
      CDEL=COS(DELE)
      HOPE=UTMOD(IE)
      GHOP=GCD/HOPE
      PSI=.5*GHOP
      PHE=PIO2-PSI- DELE
      SECD(IE)=1.0/COS(PHE)
      PATHE=2.0*RZ*SIN(PSI)/COS(DELE+PSI)
      PATHE=ABS(HOPE*PATHE)
      GZE=2.*(HOPE-1.)
      FSLOS(IE)=32.45+8.686*ALOG(PATHE)
C.....CALC. NON FREQ-DEPENDANT E-MODE LOSSES
      XLOSS(IE)=FSLOS(IE)+GZE+ADJ
      IE=IE+1
      IF(IE.LE.3) GO TO 210
C.....F2-MODES
  215 CONTINUE
      FREL(12)=ALLMUF(IT)
C.....CALCULATE MEAN ATMOSPHERIC NOISE POWER AT 1 MHZ (AT RECEIVER)
      RLMT=FLOAT(IT)-RLONG*R2D/15.    !  "-" because E long is "-"
      IF(RLMT.GE.24.) RLMT=RLMT-24.
      IF(RLMT.LT.0.) RLMT=RLMT+24.
ccc      write(16,'('' before ANOIS1='',i5,3f10.5)') it,rlong*r2d,rlmt,r2d
      CALL ANOIS1(RLMT,RLAT,RLONG)
C.....SET PARAMS FOR CALC. OF RELIABILITY LUF,INCL. CONTROL VALUE LUFC=1
      KFN=1
      LUFC=1
      NLOOP=0
      ACT1=1.0
      DXL=1.0
      FX=2.
      FREQ=FX
      QMUF=ALLMUF(IT)
      QOPMUF=OPMUF(IT)
      XLUF(IT)=QOPMUF
  300 CONTINUE
      NLOOP=NLOOP+1
C ----------------------------------------------------------------------
C.....ZEROISE ARRAY JKA : USE TO AVOID REPITATIVE CALC. OF NON-FREQ.
C.....DEP. TERMS (IE FOF2/FOE .LT.3.33)
      DO 398 JK15=1,5
  398 JKA(JK15)=0
C.....
      DO 400 IF=1,KFN
      IF(LUFC.EQ.1) THEN
C......SET FREQUENCY USED IN EVALAUATION OF LUF
       FREQ=FX
      ELSE
C......ACCESS FREQUENCY FROM INPUT COMPLEMENT FOR LOSS CALCULATIONS
       FREQ=FREL(IF)
C..... IF NECESSARY SET PREV. CALC LUF TO LOWEST OPERERATIONAL FREQUENCY
       xluf_last=XLUF(IT)
       XLUF(IT)=AMAX1(ABS(XLUF(IT)),FLOW)
       if(xluf_last.lt.0.) XLUF(IT)=-XLUF(IT)

      END IF
ccc      write(16,'(/,'' DBU252, do 400  FREQ='',f10.4)') freq
       do 9 mode9=1,9     !  copy mode indicators for each new frequency
9      NMODES(MODE9)=NMODE(MODE9)
C.....ZEROISE ARRAY KKA : USE TO AVOID REPITATIVE CALC. OF FREQ.
C.....DEP. TERMS (IE FREQ/FOE .LT.3.33)
      DO 399 KF15=1,5
  399 KFA(KF15)=0
C.....
      DO 555 IK=1,9
C.....RESTORE CONTENTS OF ARRAYS 'DELMOD,UTMOD' TO ORIGINAL ORDER
      DELMOD(IK)=DELMD1(IK)
      UTMOD(IK)=UTMD1(IK)
  555 CONTINUE
C.....
C.....CCIR Rec.533 :Calc. those  F2-mode loss parameters which have
C.....height (and thus frequency) dependency
C.....F2-MODES
      IF(FREQ.LE.0.0) GO TO 333
      DO 33 IF1=4,9
      IF2=IF1-3
      HOPF=UTMOD(IF1)
      GHOP=GCD/HOPF
      DH=GCDKM/HOPF
C.....DETERMINE REFLECTION HEIGHT HR
      HRSUM=0.0
      XKF=FLOAT(KF)
C.....TAKE MEAN VALUE OF MIRROR HT. (OVER KF F2 CONTROL PT. LOCATIONS)
      DO 32 K=1,KF
      K1=K+IA
      A=F2M3(K1)
      foF2=FI(3,K1)
      X=foF2/FI(1,K1)
      Y=AMAX1(X,1.8)
      XR=FREQ/foF2
      DELM=0.18/(Y-1.4)+0.00064*(SSN-25.0)
      H=1490.0/(A+DELM)-316.0
C.....CALC. MIRROR REFL. HT HR (km)
      CALL MIRROR(XR,Y,H,DH,KFA,JKA,K1,HR)
      HRSUM=HRSUM+HR
   32 CONTINUE
      HR=HRSUM/XKF
C.....
C.....DETERMINE FOR F2-MODES FREQENCY DEPENDANT OR IONISATION DEPENDANT
C.....REFLECTION HEIGHT,ELEVATION ANGLES,E-LAYER CUT-OFF FREQUENCIES
c.....AND TRANSMISSION LOSS
      PSI=0.5*DH/RZ
      CPSI=COS(PSI)
      SPSI=SIN(PSI)
C.....ANGLE OF ELEVATION DELF
      DEL=ATAN((CPSI-RZ/(RZ+HR))/SPSI)
      DELF=DEL
      DELFD=DELF*R2D
ccc      write(16,137) gcdkm,hopf,dh,hr,psi,delfd
ccc137   format(f10.3,f6.2,4f10.3)
      DELMOD(IF1)=DELFD
      CDEL=COS(DEL)
C.....CALC ANGLE OF INCIDENCE AT 110 km THENCE CUF-OFF FREQUENCY FC
      SINF=RZ*CDEL/(RZ+110.0)
      SINF=AMAX1(0.000001,SINF)
      SECF=1.0/SQRT(1.0-SINF*SINF)
      FEC(IF2)=FXEMAX*SECF*1.05
C.....CALC SLANT RANGES,ANTENNA GAIN GAINF ,ABSORPTION PARAMETER SECD
C.....AND THENCE PARTIAL LOSS CALC (EXCL. ABSORPTION,ABOVE-THE-MUF LOSS)
      PATHF=2.0*RZ*SPSI/COS(DELF+PSI)
      PATHF=ABS(PATHF*HOPF)   !  virtual slant range (km)
C.....FORCE USE OF NIGHT TIME IONOSPHERIC LOSS
C.WP6A-DG5      ACAV=AMAX1(ACAV,0.1)
C.WP6A-DG5      AC=677.2*ACAV
c>>(d)WP-6A SEPT. 93 MODS add 1 line and teplace '100' by '110's
c.....For F modes calculate angle of incidence at 110 km
      SIND=RZ*CDEL/(RZ+110.)
      COSD=1.-SIND*SIND
      COSD=AMAX1(0.000001,COSD)
      SECD(IF1)=1.0/ SQRT(COSD)
C.....GROUND LOSS
      GZ=2.*(HOPF-1.0)
      FSLOS(IF1)=32.45+8.686*ALOG(PATHF)
C.....CALC LOSS (EXCL. ABSORB., ABOVE-THE MUF LOSS,I.E. FREQ. DEP TERMS)
      XLOSS(IF1)=FSLOS(IF1)+GZ+ADJ
   33 CONTINUE
  333 CONTINUE
C.....
      XMODE=0
      MODE(IF)=NMODE(10)
      KANGLE(IF)=0
      DBLOS(IF)=1.0E+6
      DBU(IF)=-1.0E+6
      NHP(IF)=0.0
      PRSA(IF)=0.0
      PR=0.
      ZTAB(IT,IF)=0.
      ZSPWR(IT,IF)=0.0
      IF(LUFC.EQ.1) GO TO 310
      IF(FREQ.LE.0.0) GO TO 395
  310 CONTINUE
      IF(GCDKM.GT.4000.) THEN
        DO 600 L=1,3
        FLDST(L)=-1.0E+6
        SIGPWR(L)=-1.0E+6
        TLOSS(L)= 1.0E+6
  600   CONTINUE
      ELSE
C.....E MODES
        IE=1
  230   CONTINUE
C.....TEST IF ELEV. ANGLE IS BELOW USER SPECIFIED VALUE 'AMIND'
        IF(DELMOD(IE).LT.AMIND) THEN
          FLDST(IE)=-1.0E+6
          SIGPWR(IE)=-1.0E+6
          TLOSS(IE)= 1.0E+6
        ELSE
C.....CALC. FREQUENCY COMPONENT,FSLF,OF BASIC FREE SPACE LOSS
          FSLF=8.686*ALOG(FREQ)
c>>(b)WP-6A SEPT. 93 MODS CHANGE use mean gyrofrequency at ht = 100 km
C.WP6A-DG5          BC=(FREQ+GYR100)**1.98+10.2
C.WP6A-DG5          ABPS(IE)=SECD(IE)*AC/BC
C.....CALC. ABOVE-THE-MUF LOSS (E-MODES)
          Z=FREQ/EMUF(IT,IE) -1.
          IF(Z.LE.0.0) THEN
            XLSE=0.0
          ELSE
            XLSE=130.*Z*Z
            XLSE=AMIN1(XLSE,81.)
          END IF
C.....ADJUSTMENT FACTOR FOR E-LAYER ABSORPTION
C.WP6A-DG5          FRAT=FREQ/EMUF(IT,IE)
C.WP6A-DG5          IF(FRAT.LT.1) THEN
C.WP6A-DG5            ADX=1.359+8.617 * ALOG(FRAT)
C.WP6A-DG5            ADX=AMIN1(ADX,0.)
C.WP6A-DG5            ADX=AMAX1(ADX,-9.)
C.WP6A-DG5          ELSE
                      ADX=0.
C.WP6A-DG5          ENDIF
          HOPE=UTMOD(IE)
      CALL ABSORP (FREQ, SECD(IE), KM, ABPS(IE))                  ! C.WP6A-DG5
C.....ANTENNA GAIN FOR E-MODES AT TRANSMITTER(1) and RECEIVER(2)
C.....DELMOD(IE) REPLACES DELE*R2D 22 FEB 93
          call ANTCALZ(1,FREQ,BANTT,BTRD,DELMOD(IE),TGAINE)
          call ANTCALZ(2,FREQ,BANTR,BRTD,DELMOD(IE),RGAINE)
          TLOSS(IE)=XLOSS(IE)+FSLF+HOPE*ABPS(IE)+XLSE+ADX
          FLDST(IE)=136.6+PWRDB(FREQ)+TGAINE+8.686*ALOG(FREQ)-TLOSS(IE)
C.....CALC SIGNAL POWER Rec. 533 eq. 35
          SIGPWR(IE)=SPWF(FLDST(IE),RGAINE,FREQ)
        END IF
        IE=IE+1
        IF(IE.LE.3) GO TO 230
      ENDIF
C..... F-MODES LOSS AND FIELD STRENGTH
      IF1=4
  235 CONTINUE
      IF2=IF1-3
      FSLF=8.686*ALOG(FREQ)
c>>(b)WP-6A SEPT. 93 MODS CHANGE use gyrofrequency at ht = 100 km
C.WP6A-DG5      BC=(FREQ+GYR100)**1.98+10.2
C.WP6A-DG5      ABPS(IF1)=SECD(IF1)*AC/BC
C.....CALC. ABOVE-THE-MUF LOSS (F2-MODES)
      Z=FREQ/F2MUF(IT,IF2)-1.
      IF(Z.LE.0.0) THEN
        XLSF=0.
      ELSE
        XLSF=36.0*SQRT(Z)
        XLSF=AMIN1(XLSF,62.0)
      END IF
      HOPF=UTMOD(IF1)
      CALL ABSORP (FREQ, SECD(IF1), KM, ABPS(IF1))                ! C.WP6A-DG5
C.....ADJUST FOR EFFECT OF E-LAYER CUTOFF(ALL RANGES) AND TEST
C.....IF ELEV. ANGLE IS BELOW USER SPECIFIED MIN VALUE (AMIND DEGS)
      IF(FREQ.LT.FEC(IF2).OR.DELMOD(IF1).LT.AMIND) THEN
        FLDST(IF1)=-1.0E+6
        SIGPWR(IF1)=-1.0E+6
        TLOSS(IF1)= 1.0E+6
ccc        RGAINF=-30.
        RGAINF=0.
ccc        write(16,'('' rgainf='',4f10.4)') rgainf,freq,fec(if2),
ccc     +         delmod(if1)
      ELSE
        DELFD1=DELMOD(IF1)
        call ANTCALZ(1,FREQ,BANTT,BTRD,DELFD1,TGAINF)   !  gain at transmitter
        call ANTCALZ(2,FREQ,BANTR,BRTD,DELFD1,RGAINF)   !  gain at receiver
ccc        write(16,'('' RGAINF='',4f10.4)') rgainf,freq,fec(if2),
ccc     +         delmod(if1)
C.......
C.......ANTENNA GAIN INCLUDED IN LOSS CALC.
        TLOSS(IF1)=XLOSS(IF1)+FSLF+HOPF*ABPS(IF1)+XLSF
        FLDST(IF1)=136.6+PWRDB(FREQ)+TGAINF+8.686*ALOG(FREQ)-TLOSS(IF1)
C.......CALC SIGNAL POWER Rec. 533 eq. 35
        SIGPWR(IF1)=SPWF(FLDST(IF1),RGAINF,FREQ)
ccc        write(16,109) if1,tloss(if1),xloss(if1),fslf,hopf,abps(if1),
ccc     +               xlsf,tgainf
ccc109     format(' TLOSS=',i5,7f10.5)
      ENDIF
      IF1=IF1+1
      IF(IF1.LE.9) GO TO 235
C.....CALL CLASS TO SORT FIELD STRENGTHS INTO ASCENDING ORDER
      CALL CLASS(1,3,FLDST,UTMOD,NMODES,DELMOD,TLOSS)
      CALL CLASS(4,9,FLDST,UTMOD,NMODES,DELMOD,TLOSS)
  280 CONTINUE
C.....CALL CLASS1 TO SORT SIGNAL POWERS INTO ASCENDING ORDER
      CALL CLASS1(1,3,SIGPWR)
      CALL CLASS1(4,9,SIGPWR)
      DO 110 IL=1,9
      FLDST(IL)=AMAX1(FLDST(IL),-250.0)
      SPWX=SPWF(-250.0,RGAINF,FREQ)
      SIGPWR(IL)=AMAX1(SIGPWR(IL),SPWX)
ccc      write(16,111) il,nmodes(il),utmod(il),fldst(il),sigpwr(il),
ccc     +      rgainf
ccc111   format(' modes=',i5,1h:,a,1h:,4f10.4)
  110 CONTINUE
      IF(GCDKM.LT.4000.) THEN
C.........FOR FIELD STRENGTHS
        E1=FLDST(1)/DTEN
        E2=FLDST(2)/DTEN
        F1=FLDST(4)/DTEN
        F2=FLDST(5)/DTEN
        F3=FLDST(6)/DTEN
        RSSE1=RSS1(DTEN,E1,E2,F1,F2,F3)
C.........FOR SIGNAL POWERS
        SPE1=SIGPWR(1)/DTEN
        SPE2=SIGPWR(2)/DTEN
        SPF1=SIGPWR(4)/DTEN
        SPF2=SIGPWR(5)/DTEN
        SPF3=SIGPWR(6)/DTEN
        RSSPE1=RSS1(DTEN,SPE1,SPE2,SPF1,SPF2,SPF3)
      ELSE
        F1=FLDST(4)/DTEN
        F2=FLDST(5)/DTEN
        F3=FLDST(6)/DTEN
        RSSF1=RSS2(DTEN,F1,F2,F3)
C..........RSS OF SIGNAL POWER
        SPF1=SIGPWR(4)/DTEN
        SPF2=SIGPWR(5)/DTEN
        SPF3=SIGPWR(6)/DTEN
        RSSPF1=RSS2(DTEN,SPF1,SPF2,SPF3)
ccc        write(16,117) rsspf1,spf1,spf2,spf3
ccc117     format(' RSSPF1=',4f11.5)
      ENDIF
      IF(GCDKM.LT.4000.) THEN
        IF(FLDST(1).GT.FLDST(4)) THEN
          KANGLE(IF)=NINT(DELMOD(1))
          DBLOS(IF)=TLOSS(1)
          NHP(IF)=NINT(UTMOD(1))
          MODE(IF)=NMODES(1)
        ELSE
          KANGLE(IF)=NINT(DELMOD(4))
          DBLOS(IF)=TLOSS(4)
          NHP(IF)=NINT(UTMOD(4))
          MODE(IF)=NMODES(4)
        ENDIF
        DBU(IF)=RSSE1
        PRSA(IF)=RSSPE1
      ELSE
        KANGLE(IF)=NINT(DELMOD(4))
        DBLOS(IF)=TLOSS(4)
        NHP(IF)=NINT(UTMOD(4))
        MODE(IF)=NMODES(4)
        MODE(IF)=NMODE(4)            !  may be error in ITU version
        DBU(IF)=RSSF1
        PRSA(IF)=RSSPF1
ccc        write(16,112) if,nhp(if),mode(if),nmodes(4),rssf1,rsspf1
ccc112     format(' sum=',2i5,a,1h:,a,2f10.4)
      ENDIF
C.....STORE ELEVATION,MODE FOR EACH FREQUENCY(RSS MODE) AND TIME
      KANGLA(IT,IF)=KANGLE(IF)
      MODEA(IT,IF)=MODE(IF)
      KODEA(IT,IF)=NHP(IF)
C.....NOISE CALC. ONLY REQ'D FOR ESTIMATION OF LUF WITH METHODS 1,4 5
      IF(LUFC.EQ.0.AND.YNOISE) GO TO 395
      X10=TEN*ALOG10(BDWTH)
C.WP3L.RG4  May 95 add 2 lines
C.....Call FAD842 to compute deviations of noise,signal power and of S/N
      CALL FAD842
C.....
C.....AND S/N NOW AS IN REC. 533 EQ. 37
      SFA=SFA-FBX
      SN=PRSA(IF)-SFA-X10+204.
ccc      write(16,113) if,sn,prsa(if),sfa,x10
ccc113   format(' SN=',i5,4f10.4)
C.....LUFC=0 CALC. PATH PARAMETERS,LUFC=1 FOR LUF CALC.
C..... FOR SINGLE MODE OUTPUTS CALC. S/N ETC...
C.......ALWAYS CALC RELIABILITY PR IN TERMS OF MONTHLY MEDIAN SIGNAL
C.......AND NOISE POWERS
C.......use SNMED to calc. median PR
        SNMED=SN
        IF(METHOD.EQ.2.OR.METHOD.EQ.3) SNMED=SN-FBX
C.WP3L.RG4  Jun mod 1 line
        CALL SNPROB(SNMED,RSN,DUSN,DLSN,PR)
C.....GO TO 395 IF (1) NOISE PREDICTION NOT REQ'D (OTHER THAN FOR LUF)
C.....             (2) END OF FREQUENCY LIST
C.....             (3) F2-MODES CUT OFF BY E LAYER
  395 ZTAB(IT,IF)=DBU(IF)
C.....STORE SIGNAL POWERS
      ZSPWR(IT,IF)=PRSA(IF)
      MODEA(IT,IF)=MODE(IF)
      KODEA(IT,IF)=NHP(IF)
  400 CONTINUE
C ----------------------------------------------------------------------
      IF(LUFC.EQ.0) GO TO 308
C.....CALL SUBROUTINE RELUF TO CALC. LUF,XLUF AT TIME IT
      CALL RELUF(XLUF(IT),QOPMUF,FLOW,FHIGH)
      GO TO 300
  308 continue
      RETURN
      END
