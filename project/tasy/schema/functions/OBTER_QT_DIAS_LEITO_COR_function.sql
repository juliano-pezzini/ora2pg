-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dias_leito_cor ( qt_dia_permanencia_a_p bigint, ie_opcao_p text default 'C') RETURNS varchar AS $body$
DECLARE

ds_cor_fundo_w	varchar(50);
ds_qt_dias_w	varchar(50);
ds_retorno_w	varchar(25);


BEGIN
if (qt_dia_permanencia_a_p IS NOT NULL AND qt_dia_permanencia_a_p::text <> '') then
	if (ie_opcao_p = 'C') then
		select	max(ds_cor_fundo)
		into STRICT	ds_retorno_w
		from	ocup_regra_cor_tempo_perm
		where	qt_dia_permanencia_a_p between qt_dias_inicio and qt_dias_final;
	elsif (ie_opcao_p = 'D') then
		select	max(qt_dias_inicio || ' - ' || qt_dias_final || ' ' || obter_desc_expressao(326313))
		into STRICT	ds_retorno_w
		from	ocup_regra_cor_tempo_perm
		where	qt_dia_permanencia_a_p between qt_dias_inicio and qt_dias_final;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dias_leito_cor ( qt_dia_permanencia_a_p bigint, ie_opcao_p text default 'C') FROM PUBLIC;
