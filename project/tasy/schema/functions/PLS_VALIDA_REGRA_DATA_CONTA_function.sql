-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valida_regra_data_conta ( dt_atendimento_referencia_p timestamp, ie_valida_dt_senha_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_retorno_w		pls_conta_glosa.ds_observacao%type;
ie_valida_dt_senha_w	pls_val_data_cta.ie_dt_validade_senha%type;

C01 CURSOR(ie_valida_dt_senha_pc	text) FOR
	SELECT	fim_dia(clock_timestamp() + qt_dias) dt_posterior,
		trunc(clock_timestamp() - qt_dias) dt_anterior,
		coalesce(ie_periodo_anterior,'N') ie_periodo_anterior
	from	pls_val_data_cta
	where	ie_situacao = 'A'
	and (coalesce(ie_dt_validade_senha,'N') = 'S' or ie_valida_dt_senha_pc = 'N');
BEGIN

ie_valida_dt_senha_w := coalesce(ie_valida_dt_senha_p,'N');

for r_C01_w in C01(ie_valida_dt_senha_w) loop
	if (r_C01_w.ie_periodo_anterior = 'S') and (dt_atendimento_referencia_p < r_C01_w.dt_anterior) then
		ds_retorno_w := 	wheb_mensagem_pck.get_texto(791818) || ' ' || dt_atendimento_referencia_p || '; ' || wheb_mensagem_pck.get_texto(791820) || ' ' || r_C01_w.dt_anterior;

	elsif (r_C01_w.ie_periodo_anterior = 'N') and (dt_atendimento_referencia_p > r_C01_w.dt_posterior) then
		ds_retorno_w := 	wheb_mensagem_pck.get_texto(791819) || ' ' || dt_atendimento_referencia_p || '; ' || wheb_mensagem_pck.get_texto(791820) || ' ' || r_C01_w.dt_posterior;
	end if;

	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		exit;
	end if;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valida_regra_data_conta ( dt_atendimento_referencia_p timestamp, ie_valida_dt_senha_p text default 'N') FROM PUBLIC;

