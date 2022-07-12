-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_programacao_reajuste_pck.obter_sinistralidade_ideal ( qt_vidas_p bigint) RETURNS bigint AS $body$
DECLARE


tx_sinistralidade_ideal_w	pls_regra_sinistral_ideal.tx_sinistralidade_ideal%type;

C01 CURSOR(	qt_vidas_pc		bigint,
		dt_mes_reajuste_pc	timestamp) FOR
	SELECT	tx_sinistralidade_ideal
	from	pls_regra_sinistral_ideal
	where	qt_vidas_pc between coalesce(qt_vidas_inicial,0) and coalesce(qt_vidas_final, 9999999999)
	and	dt_mes_reajuste_pc between coalesce(dt_inicio_vigencia, dt_mes_reajuste_pc) and coalesce(dt_fim_vigencia, dt_mes_reajuste_pc);

BEGIN

tx_sinistralidade_ideal_w	:= null;

for r_c01_w in c01(	coalesce(qt_vidas_p, 0),
			current_setting('pls_programacao_reajuste_pck.pls_programacao_lote_w')::pls_prog_reaj_colet_lote%rowtype.dt_mes_reajuste) loop
	begin
	tx_sinistralidade_ideal_w	:= r_c01_w.tx_sinistralidade_ideal;
	end;
end loop;

return tx_sinistralidade_ideal_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_programacao_reajuste_pck.obter_sinistralidade_ideal ( qt_vidas_p bigint) FROM PUBLIC;
