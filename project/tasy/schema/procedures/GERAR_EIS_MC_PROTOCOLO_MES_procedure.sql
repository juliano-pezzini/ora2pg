-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_mc_protocolo_mes ( dt_mes_ref_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w			bigint;
dt_inicio_w			timestamp;
dt_fim_w				timestamp;

C01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	conta_paciente b, 
		protocolo_convenio a 
	where	a.nr_seq_protocolo		= b.nr_seq_protocolo 
	and	a.dt_mesano_referencia between dt_inicio_w and dt_fim_w;


BEGIN 
 
dt_inicio_w			:= trunc(dt_mes_ref_p,'month');
dt_fim_w				:= last_day(dt_inicio_w) + 86399/86400;
 
OPEN C01;
LOOP 
	FETCH C01 into 	nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		CALL Gerar_Eis_Margem_Contrib(nr_interno_conta_w, nm_usuario_p);
END LOOP;
CLOSE C01;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_mc_protocolo_mes ( dt_mes_ref_p timestamp, nm_usuario_p text) FROM PUBLIC;
