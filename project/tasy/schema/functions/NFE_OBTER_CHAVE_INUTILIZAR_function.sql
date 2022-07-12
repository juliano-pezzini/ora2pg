-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfe_obter_chave_inutilizar (cd_cnpj_emitente_p text, cd_serie_p text, nr_nota_inicial_p text, nr_nota_final_p text, ie_tipo_p text, dt_ano_p bigint default null) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);


BEGIN

if (ie_tipo_p = '1') then
	ds_retorno_w := 'ID' || obter_valor_dominio(3620,nfe_obter_dados_pj(cd_cnpj_emitente_p,'UF')) ||
			coalesce(dt_ano_p, to_char(clock_timestamp(),'yy')) || substr(cd_cnpj_emitente_p,1,14) || '55' || LPAD(cd_serie_p,3,'0') ||
			LPAD(nr_nota_inicial_p,9,'0') || LPAD(nr_nota_final_p,9,'0');
else
	ds_retorno_w := 'Id="ID' || obter_valor_dominio(3620,nfe_obter_dados_pj(cd_cnpj_emitente_p,'UF')) ||
			coalesce(dt_ano_p, to_char(clock_timestamp(),'yy')) || substr(cd_cnpj_emitente_p,1,14) || '55' || LPAD(cd_serie_p,3,'0') ||
			LPAD(nr_nota_inicial_p,9,'0') || LPAD(nr_nota_final_p,9,'0') || '"';
end if;
	

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfe_obter_chave_inutilizar (cd_cnpj_emitente_p text, cd_serie_p text, nr_nota_inicial_p text, nr_nota_final_p text, ie_tipo_p text, dt_ano_p bigint default null) FROM PUBLIC;

