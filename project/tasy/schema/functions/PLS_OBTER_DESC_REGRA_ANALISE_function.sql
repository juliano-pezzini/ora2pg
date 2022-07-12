-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_regra_analise ( nr_seq_regra_analise_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);
qt_idade_inicial_w	bigint;
qt_idade_final_w	bigint;
ds_tipo_regra_w		varchar(255);
qt_minima_vidas_w	bigint;
qt_maxima_vidas_w	bigint;
ie_tipo_contratacao_w	varchar(10);
ds_regra_w		varchar(255);


BEGIN

if (nr_seq_regra_analise_p IS NOT NULL AND nr_seq_regra_analise_p::text <> '') then
	select	coalesce(qt_idade_inicial,0),
		coalesce(qt_idade_final,0),
		substr(obter_valor_dominio(3991,ie_tipo_regra),1,255),
		coalesce(qt_minima_vidas,0),
		coalesce(qt_maxima_vidas,0),
		ie_tipo_contratacao
	into STRICT	qt_idade_inicial_w,
		qt_idade_final_w,
		ds_tipo_regra_w,
		qt_minima_vidas_w,
		qt_maxima_vidas_w,
		ie_tipo_contratacao_w
	from	pls_regra_analise_adesao
	where	nr_sequencia	= nr_seq_regra_analise_p;

	if (qt_idade_inicial_w <> 0) or (qt_idade_final_w <> 0) then
		ds_regra_w	:= ds_regra_w|| ' para beneficiários de '|| qt_idade_inicial_w || ' à ' || qt_idade_final_w;
	end if;

	if (ie_tipo_contratacao_w IS NOT NULL AND ie_tipo_contratacao_w::text <> '') then
		ds_regra_w := ds_regra_w|| ' para inclusões de tipo de contratações ' || substr(obter_valor_dominio(1666,ie_tipo_contratacao_w),1,100);
	end if;

	if (qt_minima_vidas_w <> 0) or (qt_maxima_vidas_w <> 0) then
		ds_regra_w	:= ds_regra_w|| ' para inclusões em contratos com quantidade de vidas  '|| qt_minima_vidas_w || ' à ' || qt_maxima_vidas_w;
	end if;

	ds_retorno_w	:= ds_tipo_regra_w || ds_regra_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_regra_analise ( nr_seq_regra_analise_p bigint) FROM PUBLIC;
