c###evlgog.for
      SUBROUTINE EVLGOG(KTRM,DCOF,DIP,FLAT,FLONG,TSUM)
C .....VERSION 21.JAN.86
C      ROUTINE TO EVALUATE THE COEFF. REPRESENTATION OF
C      THE IONOSPHERIC CHARACTERISTICS.
C
      DIMENSION KTRM(*),DCOF(*),GK(79),
     1 TSUM(*),KM(10)
      real*8 gk,sln,cln,tm1,tm2,slnp,clnp,clt,cltp  !to solve underflows
      DATA INIL,ODIP,OLAT,OLONG/1,100.0,100.0,100.0/
      DATA GK(1),R360/1.0,6.2831853/
      DATA KM/1,14,40,58,68,72,74,76,78,80/
      IF(FLONG)105,100,100
 100  ELONG=R360-FLONG
      GO TO 108
 105  ELONG=ABS(FLONG)
 108  IF(INIL.EQ.0.AND.DIP.EQ.ODIP)GO TO 200
      GK(2)=SIN(DIP)
      DO 110 J=3,13
  110 GK(J)=GK(J-1)*GK(2)
  200 IF(INIL.EQ.0.AND.FLAT.EQ.OLAT) GO TO 300
      CLT=COS(FLAT)
  300 IF(INIL.NE.0.OR.ELONG.NE.OLONG) GO TO 305
      IF(FLAT.NE.OLAT) GO TO 305
      GO TO 400
  305 SLN=SIN(ELONG)
      CLN=COS(ELONG)
      TM1=CLT*CLN
      TM2=CLT*SLN
      DO 310 J=14,39,2
      GK(J)=TM1
  310 GK(J+1)=TM2
      SLNP=SLN
      CLNP=CLN
      CLTP=CLT
      DO 370 J=3,9
      CLTP=CLTP*CLT
      TM2=SLNP*CLN+CLNP*SLN
      TM1=CLNP*CLN-SLNP*SLN
      SLNP=TM2
      CLNP=TM1
      TM1=TM1*CLTP
      TM2=TM2*CLTP
      INDX1=KM(J)
      INDX2=KM(J+1)-1
      DO 330 K=INDX1,INDX2,2
      GK(K)=TM1
  330 GK(K+1)=TM2
  370 CONTINUE
  400 NHRM=2*KTRM(10)+1
      DO 410 J=1,NHRM
  410 TSUM(J)=0.0
      INDX1=KTRM(1)+1
      DO 420 K=1,INDX1
      INDX2=(K-1)*NHRM
      DO 420 J=1,NHRM
      INDX3=INDX2+J
  420 TSUM(J)=TSUM(J)+GK(K)*DCOF(INDX3)
      DO 480 J=2,9
      INDX1=KM(J)
      INDX2=KTRM(J)-KTRM(J-1)+INDX1-1
      IF(INDX1 .GE. INDX2) GO TO 500
      INDX4=0
      DO 470 K=INDX1,INDX2,2
      INDX4=INDX4+1
      INDX3=(KTRM(J-1)+2*INDX4-1)*NHRM
      TM1=GK(K)*GK(INDX4)
      TM2=GK(K+1)*GK(INDX4)
      DO 460 I=1,NHRM
      INDX5=INDX3+I
      INDX6=INDX5+NHRM
  460 TSUM(I)=TSUM(I)+TM1*DCOF(INDX5)+TM2*DCOF(INDX6)
  470 CONTINUE
  480 CONTINUE
  500 RETURN
      END
