-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valida_dia_mes ( dt_ini_ent_p text, dt_fim_ent_p text, dt_registro_p timestamp, ie_tipo_saida_p text) RETURNS timestamp AS $body$
DECLARE

/*
ie_tipo_saida_p
	I = início
	F = fim
*/
dt_retorno_w		timestamp;
ds_dia_filtro_w		varchar(2);
ds_dia_data_w		varchar(2);


BEGIN

if (ie_tipo_saida_p = 'I') then
	if (coalesce(dt_ini_ent_p::text, '') = '') or (coalesce(dt_registro_p::text, '') = '') then
		dt_retorno_w := to_date('01/01/' || to_char(dt_registro_p,'yy'));
	else
		dt_retorno_w := to_date(dt_ini_ent_p || '/' || to_char(dt_registro_p,'yy'));
	end if;

elsif (ie_tipo_saida_p = 'F') then
	if (coalesce(dt_fim_ent_p::text, '') = '') or (coalesce(dt_registro_p::text, '') = '') then
		dt_retorno_w := to_date('31/12/' || to_char(dt_registro_p,'yy'));
	else
		-- Pegamos o dia vindo do filtro pois como o filtro não é um componente de data o mesmo permite informar por exemplo, '31/04', neste caso pegamos o valor '30'
		ds_dia_filtro_w := substr(dt_fim_ent_p, 1, 2);

		-- Pegamos o último dia do mês, por exemplo, seguindo o exemplo do comentário acima, '30', visto que o mês '04' tem apenas '30' dias
		ds_dia_data_w	:= to_char(last_day(to_date('01/' || substr(dt_fim_ent_p, 4, 2) || to_char(dt_registro_p,'yy'))), 'dd');

		-- Se o dia vindo do filtro for maior que o último dia do mês vindo do filtro, por exemplo, '31/04' não existe, então substituímos a data para o último dia do mês, retornando '30/04'
		if ((ds_dia_filtro_w)::numeric  > (ds_dia_data_w)::numeric ) then
			dt_retorno_w := to_date(ds_dia_data_w || '/' || substr(dt_fim_ent_p, 4, 2) || '/' || to_char(dt_registro_p,'yy'));
		else
			dt_retorno_w := to_date(dt_fim_ent_p || '/' || to_char(dt_registro_p,'yy'));
		end if;
	end if;
end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valida_dia_mes ( dt_ini_ent_p text, dt_fim_ent_p text, dt_registro_p timestamp, ie_tipo_saida_p text) FROM PUBLIC;

