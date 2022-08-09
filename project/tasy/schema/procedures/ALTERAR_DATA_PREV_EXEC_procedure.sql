-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_data_prev_exec ( dt_prevista_p timestamp, nr_prescricao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
 
			 
cd_procedimento_w	bigint;
cd_intervalo_w		varchar(7);
nr_horas_validade_w	integer;
ds_horarios_w		varchar(2000);
ds_erro_w		varchar(255);
nr_intervalo_w		bigint 	:= 0;

			 

BEGIN 
 
select 	a.cd_procedimento, 
	a.cd_intervalo, 
	a.ds_horarios, 
	b.nr_horas_validade 
into STRICT	cd_procedimento_w, 
	cd_intervalo_w, 
	ds_horarios_w, 
	nr_horas_validade_w 
from	prescr_procedimento a, 
	prescr_medica b 
where	a.nr_prescricao	= b.nr_prescricao 
and	a.nr_sequencia	= nr_sequencia_p 
and	a.nr_prescricao	= nr_prescricao_p 
and	b.nr_prescricao	= nr_prescricao_p;
 
 
UPDATE 	PRESCR_PROCEDIMENTO  
SET 	DT_PREV_EXECUCAO 	= dt_prevista_p  
WHERE 	NR_PRESCRICAO 		= nr_prescricao_p 
AND 	NR_SEQUENCIA 		= nr_sequencia_p;
 
commit;
 
SELECT * FROM Recalcular_Horario_Prescricao(cd_intervalo_w, dt_prevista_p, nr_horas_validade_w, cd_procedimento_w, nr_intervalo_w, ds_horarios_w, 'N', cd_procedimento_w, nr_prescricao_p, nr_sequencia_p) INTO STRICT nr_intervalo_w, ds_horarios_w;
 
ds_erro_w := Consistir_prescr_procedimento(nr_prescricao_p, nr_sequencia_p, nm_usuario_p, cd_perfil_p, ds_erro_w);
 
ds_erro_p := ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_data_prev_exec ( dt_prevista_p timestamp, nr_prescricao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
