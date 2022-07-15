-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_especialidade ( dt_parametro_P timestamp) AS $body$
DECLARE

 
dt_parametro_inicio_w       	timestamp;
dt_parametro_fim_w        	timestamp;
NR_INTERNO_CONTA_W         bigint;
C01 CURSOR FOR
SELECT distinct a.nr_interno_conta 
from 	Procedimento_paciente a 
where a.dt_procedimento between dt_parametro_inicio_w and dt_parametro_fim_w 
 and coalesce(a.cd_especialidade::text, '') = '';


BEGIN 
 
dt_parametro_fim_w         := last_day(Trunc(dt_parametro_p,'dd'));
dt_parametro_Inicio_w		 	:= trunc(dt_parametro_p,'month');
	 
OPEN C01;
LOOP 
FETCH C01 into	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL atualizar_Especialidade_conta(nr_interno_conta_w);
	CALL atualizar_resumo_conta(nr_interno_conta_w, 2);
	commit;
	end;
END LOOP;
close c01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_especialidade ( dt_parametro_P timestamp) FROM PUBLIC;

