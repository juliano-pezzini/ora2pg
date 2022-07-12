-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION adds_pck.obter_sinais_vitais ( nr_atendimento_p bigint, nr_seq_adds_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ie_trunc_date_p text default 'S') RETURNS SETOF T_SV_ROW_DATA AS $body$
DECLARE


C01 CURSOR FOR
	SELECT *
	from table(adds_pck.obter_item_adds(nr_seq_adds_p));

C02 CURSOR(nr_seq_sinal_vital_p bigint,nr_seq_adds_sv_p bigint ) FOR
	SELECT *
	from table(adds_pck.obter_sinal_vital( nr_atendimento_p, dt_inicio_p,dt_fim_p,nr_seq_sinal_vital_p,nr_seq_adds_sv_p,ie_trunc_date_p));

BEGIN

for r_c01 in c01 loop
	begin
	for r_c02 in c02( r_c01.nr_seq_sinal_vital, r_c01.nr_seq_adds_sv) loop
		begin

		RETURN NEXT r_c02;

		end;
	end loop;
	end;
end loop;

return;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION adds_pck.obter_sinais_vitais ( nr_atendimento_p bigint, nr_seq_adds_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ie_trunc_date_p text default 'S') FROM PUBLIC;