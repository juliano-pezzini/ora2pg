-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valida_dt_comp_apres_aut ( qt_meses_permitido_p bigint, ie_comp_fechada_p text default 'S', dt_competencia_p pls_lote_apres_automatica.dt_mes_competencia%type DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Validar a data de competencia do lote de apresentação automática
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(1);
count_w			integer;


BEGIN
ds_retorno_w := 'S';

if (dt_competencia_p IS NOT NULL AND dt_competencia_p::text <> '') then
	if (trunc(dt_competencia_p,'year') < to_date('01/01/2000')) then
		ds_retorno_w := 'A';
	elsif (trunc(dt_competencia_p,'month') > trunc(add_months(clock_timestamp(),qt_meses_permitido_p),'month')) then
		ds_retorno_w := 'N';
	elsif  	((ie_comp_fechada_p = 'N') and (trunc(dt_competencia_p,'month') < trunc(clock_timestamp(),'month')) and (dt_competencia_p < clock_timestamp())) then

		select	count(1)
		into STRICT	count_w
		from	fin_mes_ref
		where	dt_referencia = dt_competencia_p
		and		(dt_fechamento IS NOT NULL AND dt_fechamento::text <> '');

		if (count_w > 0) then
			ds_retorno_w := 'D';
		end if;

	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valida_dt_comp_apres_aut ( qt_meses_permitido_p bigint, ie_comp_fechada_p text default 'S', dt_competencia_p pls_lote_apres_automatica.dt_mes_competencia%type DEFAULT NULL) FROM PUBLIC;
