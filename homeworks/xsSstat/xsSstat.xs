#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

typedef struct Data{
    char* name;
    int min;
    int max;
    long sum;
    int cnt;
    char flags;
} metric;

char metricmap(char* met){
    if (strcmp(met,"min")==0)
        return 1;
    else if (strcmp(met,"max")==0)
        return 2;
    else if (strcmp(met,"cnt")==0)
        return 4;
    else if (strcmp(met,"sum")==0)
        return 8;
    else if (strcmp(met,"avg")==0)
        return 16;
    else {
        croak("Mname must be one of avg,sum,min,max,cnt");
        return 0;
        }
}

metric metrics[100];
int metric_cnt = 0;

int min(int a, int b){return a<b?a:b;}
int max(int a, int b){return a>b?a:b;}

void process(metric* m,int val){
   char fl = (*m).flags;
   if (fl & 1) (*m).min = min((*m).min, val);
   if (fl & 2) (*m).max = max((*m).max, val);
   if (fl & 4) (*m).cnt ++; 
   if (fl & 8) (*m).sum += val;
   if ((bool)(fl & 16) && !(fl&12)){
       (*m).sum+=val;
       (*m).cnt++;
       }
}

static SV * keepSub = (SV*)NULL;

MODULE = xsSstat		PACKAGE = xsSstat

INCLUDE: const-xs.inc

void next (name)
    SV * name;
  CODE:
    /* Take a copy of the callback */
    if (keepSub == (SV*)NULL)
    /* First time, so create a new SV */
        keepSub = newSVsv(name);
    else
    /* Been here before, so overwrite */
        SvSetSV(keepSub, name);

SV* stat ()
INIT:
    /* The return value. */
  CODE:
     
    HV * rethash;
    rethash = (HV *)sv_2mortal((SV *)newHV());  
    for (int i=0; i<metric_cnt;i++){ 
        HV * rh;
        rh = (HV *)sv_2mortal((SV *)newHV());
        metric *m = &metrics[i];
        char fl = m->flags;
        if (fl & 1) hv_store(rh, "min",3,newSViv(m->min),0);
        if (fl & 2) hv_store(rh, "max",3,newSViv(m->max),0);
        if (fl & 4) hv_store(rh, "cnt",3,newSViv(m->cnt),0);
        if (fl & 8) hv_store(rh, "sum",3,newSViv(m->sum),0);
        if (fl & 16)hv_store(rh,"avg",3,newSVnv((double)(*m).sum/m->cnt),0);

        (*m) = (metric) {m->name,0,0,0,0,fl};
        hv_store(rethash,m->name,strlen(m->name),newRV((SV *)rh),0);
    //  HV* rethash = newHV();
    //  hv_store(rethash, "key!", 4, newSViv(4), 0);
    //  RETVAL = sv_2mortal((SV*)newRV_noinc((SV *)rethash));
    }
  RETVAL = newRV((SV *)rethash);
OUTPUT:
  RETVAL

void add (mname, value)
    char* mname;
    int value;
  CODE:
    bool flag= true;
    int count;
    for (int i = 0; i<metric_cnt;i++){
        if (strcmp(metrics[i].name,mname)==0){
                process(&metrics[i],value);
                flag = false;
                break;
            }
    }
    if (flag){ 
        printf("%s : %d\n",mname,value);
        ENTER; SAVETMPS;PUSHMARK(SP);

            count = call_sv(keepSub, G_NOARGS|G_ARRAY);

        SPAGAIN;
            metrics[metric_cnt] = (metric) {mname,0,0,0,0,0};
            printf("Count: %d\n",count);
            for (int i=1; i<=count;i++){
                metrics[metric_cnt].flags |= metricmap(POPp);
                printf("type %d : %d\n",i,metrics[metric_cnt].flags);
            }
        FREETMPS;LEAVE;
        process(&metrics[metric_cnt],value);   
        metric_cnt++;
    }
