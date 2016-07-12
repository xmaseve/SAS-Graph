data blood;
   infile 'C:\Users\QI_YI\Desktop\blood.txt' truncover;
   length Gender $ 6 BloodType $ 2 AgeGroup $ 5;
   input Subject 
         Gender 
         BloodType 
         AgeGroup
         WBC 
         RBC 
         Chol;
   label Gender = "Gender"
         BloodType = "Blood Type"
         AgeGroup = "Age Group"
         Chol = "Cholesterol";
run;

goption reset=all ftext='arial' htext=1.0 /*ftext means the font of text, htext is the height of text*/
	    ftitle='' htitle=1.0 colors=(black);

/*Producing a simple bar*/
pattern value=empty;
proc gchart data=blood;
	vbar bloodtype;
run;

goption reset=all;

/*Creating a pie chart*/
proc gchart data=blood;
	pie bloodtype/ noheading;
	pie agegroup;
run;

/*Creating bar charts for a continuous variable*/
proc gchart data=blood;
	vbar wbc/ midpoint=3000 to 12000 by 1000;
	format wbc comma6.;
run;

proc sgplot data=blood;
	histogram wbc;
run; 

axis1 order=('A' 'AB' 'B' 'O');
proc gchart data=blood;
	vbar bloodtype /maxis=axis1;
run;

/*Creating charts with values representing categories*/
data hosp;
   do j = 1 to 1000;
      AdmitDate = int(ranuni(1234)*1200 + 15500);
      quarter = intck('qtr','01jan2002'd,AdmitDate);
      do i = 1 to quarter;
         if ranuni(0) lt .1 and weekday(AdmitDate) eq 1 then
            AdmitDate = AdmitDate + 1;
         if ranuni(0) lt .1 and weekday(AdmitDate) eq 7 then
            AdmitDate = AdmitDate - int(3*ranuni(0) + 1);
         DOB = int(25000*Ranuni(0) + '01jan1920'd);
         DischrDate = AdmitDate + abs(10*rannor(0) + 1);
         Subject + 1;
         output;
      end;
   end;
   drop i j;
   format AdmitDate DOB DischrDate mmddyy10.;
run;

data one;
set hosp;
day = weekday(AdmitDate);
run;

pattern value=l1;
proc gchart data=one;
	vbar day/ discrete;
run;

goption reset=all;

/*Creating bar charts representing sums*/
data sales;
   input    EmpID     :       $4. 
            Name      &      $15.
            Region    :       $5.
            Customer  &      $18.
            Date      : mmddyy10.
            Item      :       $8.
            Quantity  :        5.
            UnitCost  :  dollar9.;
   TotalSales = Quantity * UnitCost;
   format date mmddyy10. UnitCost TotalSales dollar9.;
datalines;
1843 George Smith  North Barco Corporation  10/10/2006 144L 50 $8.99
1843 George Smith  South Cost Cutter's  10/11/2006 122 100 $5.99
1843 George Smith  North Minimart Inc.  10/11/2006 188S 3 $5,199
1843 George Smith  North Barco Corporation  10/15/2006 908X 1 $5,129
1843 George Smith  South Ely Corp.  10/15/2006 122L 10 $29.95
0177 Glenda Johnson  East Food Unlimited  9/1/2006 188X 100 $6.99
0177 Glenda Johnson  East Shop and Drop  9/2/2006 144L 100 $8.99
1843 George Smith  South Cost Cutter's  10/18/2006 855W 1 $9,109
9888 Sharon Lu  West Cost Cutter's  11/14/2006 122 50 $5.99
9888 Sharon Lu  West Pet's are Us  11/15/2006 100W 1000 $1.99
0017 Jason Nguyen  East Roger's Spirits  11/15/2006 122L 500 $39.99
0017 Jason Nguyen  South Spirited Spirits  12/22/2006 407XX 100 $19.95
0177 Glenda Johnson  North Minimart Inc.  12/21/2006 777 5 $10.500
0177 Glenda Johnson  East Barco Corporation  12/20/2006 733 2 $10,000
1843 George Smith  North Minimart Inc.  11/19/2006 188S 3 $5,199
;
run;

proc gchart data=sales;
	vbar region/ sumvar=TotalSales type=sum; 
run;

proc gchart data=blood;
	vbar gender/ sumvar=Chol type=mean group=bloodtype;
run;

/*Producing scatter plot*/
data stocks;
   Do date = '01Jan2006'd to '31Jan2006'd;
      input Price @@;
      output;
   end;
   format Date mmddyy10. Price dollar8.;
datalines;
34 35 39 30 35 35 37 38 39 45 47 52
39 40 51 52 45 47 48 50 50 51 52 53
55 42 41 40 46 55 52
;
run;

symbol value=dot interpol=sm; /*sm is smooth*/
proc gplot data=stocks;
	plot price*date/ vaxis=25 to 60 by 5;
run;
