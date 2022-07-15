-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_dif_conta_paciente ( dt_parametro_P timestamp) AS $body$
DECLARE

 
 
dt_parametro_inicio_w		timestamp;
dt_parametro_fim_w		timestamp;
nr_interno_conta_w		bigint;
nr_atendimento_w		bigint;
vl_guia_w			double precision;
vl_conta_w			double precision;

 
C01 CURSOR FOR 
SELECT	a.nr_interno_conta, 
	nr_atendimento, 
  	obter_valor_guia_conta(nr_interno_conta), 
	obter_valor_conta(nr_interno_conta,0) 
from 	conta_paciente a 
where	a.dt_mesano_referencia between dt_parametro_inicio_w and dt_parametro_fim_w 
 and	a.ie_status_acerto	= 2 
 and	obter_valor_guia_conta(nr_interno_conta) <> obter_valor_conta(nr_interno_conta,0);


BEGIN 
 
dt_parametro_fim_w	:= last_day(Trunc(dt_parametro_p,'dd')) + 86399/86400;
dt_parametro_Inicio_w	:= trunc(dt_parametro_p,'month');
 
	OPEN C01;
LOOP 
FETCH C01 into	 
	nr_interno_conta_w, 
	nr_atendimento_w, 
	vl_guia_w, 
	vl_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (vl_conta_w = 0) and (vl_guia_w > 0) then 
		CALL atualizar_resumo_conta(nr_interno_conta_w,2);
		select obter_valor_conta(nr_interno_conta_w,0) 
		into STRICT	vl_conta_w 
		;
	end if;
	if (vl_conta_w > 0) and (vl_guia_w = 0) then 
		CALL Gerar_Conta_Paciente_Guia(nr_interno_conta_w,2);
		select obter_valor_guia_conta(nr_interno_conta_w) 
		into STRICT	vl_conta_w 
		;
	end if;
	/*if	(vl_conta_w <> vl_guia_w) then 
		insert into logxxxx_tasy values (sysdate, 'Marcus', 899, 
			'Atendimento:' || nr_atendimento_w || 
			'Conta:' || nr_interno_conta_w || 
			' Guia: ' || vl_guia_w || ' Conta: ' || vl_conta_w); 
	end if;*/
 
	end;
END LOOP;
close c01;
 
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_dif_conta_paciente ( dt_parametro_P timestamp) FROM PUBLIC;

