-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registra_final_conta (NR_ATENDIMENTO_P bigint, DS_ERRO_P INOUT text) AS $body$
DECLARE

DT_ATUALIZACAO_W     timestamp    := clock_timestamp();
DT_ALTA_W     	 timestamp;
DT_ENTRADA_W     	 timestamp;
QT_PROCESSO_PENDENTE_W  bigint 	:= 0;
QT_PROC_PENDENTE_W    bigint 	:= 0;
QT_MAT_PENDENTE_W    bigint 	:= 0;
QT_ATEN_PENDENTE_W    bigint 	:= 0;
QT_ATEN_SEM_ALTA_W    bigint 	:= 0;
QT_TOTAL_PENDENTE_W   bigint 	:= 0;
IE_TIPO_ATENDIMENTO_W  smallint  	:= 0;
NR_ATENDIMENTO_W   	 bigint  	:= 0;
QT_CONTA_W   		 bigint 	:= 0;
DS_ERRO_W     	 varchar(80) 	:= '';
DS_ERRO_W2     	 varchar(80) 	:= '';
IE_TIPO_CONVENIO_W  	smallint  	:= 0;

 
 

BEGIN 
nr_atendimento_w			:= nr_atendimento_p;
ds_erro_w			 	:= '';
ds_erro_w2			 	:= '';
begin 
Select ie_tipo_atendimento, 
	 coalesce(dt_alta,to_date('01/01/1900 00:00:00','dd/mm/yyyy hh24:mi:ss')), 
	 dt_entrada, 
	 ie_tipo_convenio 
 into STRICT ie_tipo_atendimento_w, 
	 dt_alta_w, 
	 dt_entrada_w, 
	 ie_tipo_convenio_w 
 from atendimento_paciente 
 where nr_atendimento = nr_atendimento_p;
exception 
   when others then 
   ie_tipo_atendimento_w := 7;
end;
 
Select count(*) 
into STRICT qt_proc_pendente_w 
from procedimento_paciente 
where nr_atendimento = nr_atendimento_p 
 and qt_procedimento <> 0 
 and coalesce(cd_motivo_exc_conta::text, '') = '' 
 and coalesce(nr_interno_conta::text, '') = '';
 
if	qt_proc_pendente_w > 0 then 
	ds_erro_w	:= ds_erro_w || '4 ';
end if;
 
Select count(*) 
into STRICT qt_mat_pendente_w 
from material_atend_paciente 
where nr_atendimento = nr_atendimento_p 
 and qt_material <> 0 
 and coalesce(cd_motivo_exc_conta::text, '') = '' 
 and coalesce(nr_interno_conta::text, '') = '';
 
if	qt_mat_pendente_w > 0 then 
	ds_erro_w	:= ds_erro_w || '3 ';
end if;
 
Select count(*) 
into STRICT qt_aten_pendente_w 
from conta_paciente 
where nr_atendimento = nr_atendimento_p 
 and ie_status_acerto = 1;
 
if	qt_aten_pendente_w > 0 then 
	ds_erro_w	:= ds_erro_w || '5 ';
end if;
 
Select count(*) 
into STRICT qt_conta_w 
from conta_paciente 
where nr_atendimento = nr_atendimento_p;
 
if	qt_conta_w = 0 then 
	begin 
	qt_aten_pendente_w := 1;
	ds_erro_w	:= ds_erro_w || '5 ';
	end;
end if;
 
if (dt_alta_w = to_date('01/01/1900 00:00:00','dd/mm/yyyy hh24:mi:ss')) then 
	begin 
	qt_aten_sem_alta_w := 1;
	ds_erro_w	:= ds_erro_w || '1 ';
	end;
end if;
 
 
begin 
Select count(*) 
into STRICT qt_processo_pendente_w 
from processo_atendimento 
where nr_atendimento = nr_atendimento_p 
 and coalesce(dt_fim_real::text, '') = '';
exception 
	when others then 
		qt_processo_pendente_w := 0;
end;
 
if	qt_processo_pendente_w > 0 then 
	ds_erro_w	:= ds_erro_w || '2 ';
end if;
 
qt_total_pendente_w := 	qt_proc_pendente_w + 
				qt_processo_pendente_w + 
            	qt_mat_pendente_w + 
            	qt_aten_pendente_w + 
            	qt_aten_sem_alta_w;
if 	qt_total_pendente_w = 0 then 
  	begin 
  	update 	atendimento_paciente 
   set 		dt_fim_conta 	= dt_atualizacao_w, 
			ie_fim_conta	= 'F', 
			dt_alta_interno	= dt_alta 
  	where 	nr_atendimento 	= nr_atendimento_p;
  	end;
else 
	begin 
	update 	atendimento_paciente 
   	set 		dt_fim_conta  	 = NULL, 
			ie_fim_conta	= CASE WHEN qt_proc_pendente_w=0 THEN  'A'  ELSE 'P' END , 
			dt_alta_interno	= coalesce(dt_alta,to_date('30/12/2999','dd/mm/yyyy')) 
	where 	nr_atendimento 	= nr_atendimento_p;
	end;
end if;
 
if (ie_tipo_atendimento_w <> 1)	and (ie_tipo_convenio_w = 3)	then 
	begin 
	ds_erro_w2 := CONSISTE_SUS_BPA(nr_atendimento_w, ds_erro_w2);
	ds_erro_w := ds_erro_w || ds_erro_w2;
	end;
end if;
 
/* 
if	(ie_tipo_atendimento_w = 1)	and 
	(ie_tipo_convenio_w = 3)	then 
	begin 
	CONSISTE_SUS_AIH(nr_atendimento_w, 
				0, 
				ds_erro_w2); 
	ds_erro_w := ds_erro_w || ds_erro_w2; 
	end; 
end if; 
*/
 
 
 
ds_erro_p	:= ds_erro_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registra_final_conta (NR_ATENDIMENTO_P bigint, DS_ERRO_P INOUT text) FROM PUBLIC;
