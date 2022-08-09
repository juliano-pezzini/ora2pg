-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_zera_auxiliares (dt_parametro_P timestamp, nr_seq_protocolo_p bigint) AS $body$
DECLARE

 
dt_parametro_inicio_w       	timestamp;
dt_parametro_fim_w        	timestamp;
NR_INTERNO_CONTA_W         bigint;

C01 CURSOR FOR 
SELECT 	a.nr_interno_conta 
from 		conta_paciente a, 
		convenio b 
where		a.cd_convenio_parametro	= b.cd_convenio 
 and 	a.dt_mesano_referencia between dt_parametro_inicio_w and dt_parametro_fim_w 
 and 	a.ie_status_acerto 	= 2 
 and 	nr_seq_protocolo_p	= 0 
 and		b.ie_tipo_convenio	<> 3 

union
 
SELECT 	a.nr_interno_conta 
from 		conta_paciente a, 
		convenio b 
where		a.cd_convenio_parametro	= b.cd_convenio 
 and 	a.ie_status_acerto 	= 2 
 and 	a.nr_seq_protocolo	= nr_seq_protocolo_p 
 and 	nr_seq_protocolo_p	<> 0 
 and		b.ie_tipo_convenio	<> 3;


BEGIN 
 
dt_parametro_fim_w         := last_day(Trunc(dt_parametro_p,'dd'));
dt_parametro_Inicio_w		 	:= trunc(dt_parametro_p,'month');
	 
OPEN C01;
LOOP 
FETCH C01 into	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	update 	procedimento_paciente 
	set 		vl_auxiliares 		= 0, 
 			vl_anestesista 		= 0 
	where 	nr_interno_conta		= nr_interno_conta_w;
	commit;
 
	end;
END LOOP;
close c01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_zera_auxiliares (dt_parametro_P timestamp, nr_seq_protocolo_p bigint) FROM PUBLIC;
