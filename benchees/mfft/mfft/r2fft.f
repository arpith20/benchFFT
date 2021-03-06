       SUBROUTINE R2FFT(C,ID,NM,NN,WM,WN,ISIG,IORD,IWORK,IERR)
****PURPOSE:
*       THIS ROUTINE PERFORMS A 2-DIMENSIONAL REAL FOURIER TRANSFORM,
*       OF ORDER NM*NN.
****USAGE:
*       THE USER IS EXPECTED TO PROVIDE THE DATA IN A 2-DIMENSIONAL
*       REAL ARRAY C, DIMENSIONED IN THE CALLING PROGRAM C(ID,NN)
*       AND EQUIVALENCED TO A COMPLEX ARRAY CCOM(ID/2,NN).
*       WHEN A DIRECT TRASNFORM IS PERFORMED, HALF OF THE OUTPUT
*       COEFFICIENTS ARE CONTAINED IN CCOM(I,J) AS FOLLOWS
*        X(I,J)= CCOM(I,J) WITH I=1,(NM/2+1) AND J=1,NN
*       THE REMAINING ONES ARE OBTAINED EXPLOITING THE CONJUGATED
*       SYMMETRY RELATION
*        X(I,J) = CONJG(CCOM(NM-I+2,NN-J+2))
*       WITH I=NM/2+2,NM  AND  J=1,NN
*       NM (ACTUAL FIRST DIMENSION OF DATA) MUST BE AN EVEN NUMBER;
*       ID (DECLARED FIRST DIMENSION) MUST BE GR. OR EQ. TO NM+2.
*       THE ELEMENTS C(K,*), NM<K<=ID MUST BE ZEROED. THE ROUTINE IS
*       INTENDED FOR REPEATED USAGE, THUS SEPARATE SET-UP AND
*       OPERATING CALLS ARE AVAILABLE : THE USER SHOULD ALWAYS PERFORM
*       A SET-UP CALL ( ISIG=0 ) PASSING THE CHOSEN PARAMETERS, BEFORE
*       PERFORMING THE ACTUAL TRANSFORM ( ISIG= +1 OR -1 ); THE USER CAN
*       CHOOSE WHETHER TO OBTAIN THE RESULTS OF THE DIRECT TRANSFORM
*       IN NATURAL ORDER (ISIG=-1,IORD=1) OR LEAVE THEM IN THE
*       BIT-REVERSED  ORDER( ISIG=-1,IORD=0); THIS CHOICE SAVES
*       SOME COMPUTER TIME, AND IT IS RECOMMENDED IN CASES DISCUSSED
*       IN THE LONG WRITE-UP. ANALOGOUSLY, THE INVERSE TRANSFORM ACCEPTS
*       INPUT ( PLEASE NOTE| ) DATA IN NATURAL ORDER ( ISIG=1,IORD=1),
*       OR DATA ALREADY SUBJECTED TO A BIT-REVERSAL PERMUTATION( ISIG=1
*       IORD=0 ).
****PARAMETERS :
*       INPUT :
*       C : ARRAY TO BE TRANSFORMED; DECLARED REAL C(ID,NN) IN THE
*           CALLING PROGRAM;
*       ID : FIRST DIMENSION OF C IN THE CALLING PROGRAM
*            IT MUST BE AN EVEN NUMBER EQUAL TO NM+2.
*       ISIG : OPTION FLAG : ISIG=0 : SET-UP RUN, C NOT USED
*                            ISIG=-1: DIRECT TRANSFORM
*                            ISIG=+1: INVERSE TRANSFORM
*       WM,WN : INTEGER ARRAYS , USED TO HOST TABLES FOR THE TRANSFORM;
*               DIMENSIONED IN THE CALLING PROGRAM IN THIS WAY :
*               WM : AT LEAST (6*NM+14)
*               WN : AT LEAST (4*NN+14)
*               IF ISIG.NE.0 ,THEY ARE ASSUMED TO HAVE BEEN SET
*                BY A PREVIOUS CALL WITH ISIG=0 AND
*               ALL THE OTHER ARGUMENTS UNCHANGED, AND NEVER HAVE BEEN
*               MODIFIED SINCE THEN;
*               IF NM=NN, WM AND WN DO NOT NEED TO BE DISTINCT;
*       NM : ORDER OF THE TRANSFORM ALONG THE COLUMNS OF C
*       NN : ORDER OF THE TRANSFORM ALONG THE ROWS OF C
*       IORD : OPTION FLAG : =1 : OUTPUT IN NATURAL ORDER (ISIG=-1)
*                                 INPUT IN NATURAL ORDER  (ISIG=+1)
*                            =0 : OUTPUT IN BIT-REVERSED ORDER(ISIG=-1)
*                                 INPUT IN BIT-REVERSED ORDER(ISIG=+1)
*                                 WARNING:THE FIRST DIMENSION IS ORDERED
*                                 IN ANY CASE BECAUSE OF POST-PROCESSING
*                                 (FOR DIRECT) AND PRE-PROCESSING FOR
*                                 INVERSE REAL TRANSFORMS
*       IWORK : INTEGER ARRAY, USED AS WORK AREA FOR REORDERING IF IORD=
*               1, MUST BE AT LEAST MAX(NM,NN) WORDS LONG.
*
****OUTPUT :
*       C : TRANSFORMED ARRAY
*       WM, WN : ONLY IF ISIG=0, WM AND WN ARE FILLED WITH THE
*               APPROPRIATE  TABLES
*       IWORK : UNDEFINED
*       IERR  : ERROR CODE : =0 : SUCCESSFUL
*                            =1 : WRONG ID PARAMETER
*                            =2 : PRIME FACTORS DIFFERENT FROM 2,3,5
*                                 ARE PRESENT IN DATA DIMENSIONS
*                            =3 : TABLES NOT CORRECTLY INITIALIZED
*                            =4 : FIRST DIMENSION IS AN ODD NUMBER
      COMPLEX C(*)
      INTEGER WM(-14:*),WN(-14:*)
      INTEGER IWORK(*)
*
      INTEGER IDERR,FACERR,TBERR,ODDERR
      PARAMETER (IDERR=1,FACERR=2,TBERR=3,ODDERR=4)
*
      IF(ID.LT.NM+2)THEN
        IERR=IDERR
        RETURN
      ENDIF
      NM1=NM/2
      IF(NM1*2.NE.NM)THEN
        IERR=ODDERR
        RETURN
      ENDIF
      IERR=0
*
      IF(ISIG.EQ.0) THEN
        CALL MFFTRP(NM,WM(4*NM))
        CALL MFFTP(NM1,WM,0,IERR)
        IF(IERR.NE.0)RETURN
        IF(NN.NE.NM1) THEN
          CALL MFFTP(NN,WN,0,IERR)
          IF(IERR.NE.0)RETURN
        ELSE
          CALL MFFTZ0(WM,1,4*NM1+14,WN,1)
        ENDIF
        RETURN
      ELSE  IF(ISIG.GT.0) THEN
 
        IF(IORD.NE.0) THEN
          CALL MFFTOV(C,ID/2,1,NN,NM1+1,WN(3*NN),IWORK)
        ENDIF
        CALL MFFTIV(C,ID/2,1,NN,NM1+1,WN,IERR)
        IF(IERR.NE.0)RETURN
        CALL MFFTRI(C,1,ID/2,NM1,NN,WM(4*NM))
        CALL MFFTOV(C,1,ID/2,NM1,NN,WM(3*NM1),IWORK)
        CALL MFFTIV(C,1,ID/2,NM1,NN,WM,IERR)
        IF(IERR.NE.0)RETURN
 
      ELSE
        CALL MFFTDV(C,1,ID/2,NM1,NN,WM,IERR)
        IF(IERR.NE.0)RETURN
        CALL MFFTOV(C,1,ID/2,NM1,NN,WM(NM1*2),IWORK)
        CALL MFFTRD(C,1,ID/2,NM1,NN,WM(4*NM))
        CALL MFFTDV(C,ID/2,1,NN,NM1+1,WN,IERR)
        IF(IERR.NE.0)RETURN
 
        IF(IORD.NE.0) THEN
          CALL MFFTOV(C,ID/2,1,NN,NM1+1,WN(NN*2),IWORK)
        ENDIF
*
      ENDIF
*
      END
