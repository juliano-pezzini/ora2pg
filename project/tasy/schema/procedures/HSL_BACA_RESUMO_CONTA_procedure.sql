-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hsl_baca_resumo_conta ( dt_parametro_P timestamp) AS $body$
DECLARE

 
NR_INTERNO_CONTA_W         	bigint;

C01 CURSOR FOR 
SELECT a.nr_interno_conta 
from 	conta_paciente a 
where trunc(a.dt_mesano_referencia,'month') = trunc(dt_parametro_p,'month');


BEGIN 
 
OPEN C01;
LOOP 
FETCH C01 into	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL atualizar_resumo_conta(nr_interno_conta_w, 2);
	end;
END LOOP;
close c01;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hsl_baca_resumo_conta ( dt_parametro_P timestamp) FROM PUBLIC;
