-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_validade_lote_fornec (cd_material_p bigint, nr_seq_dialise_p bigint, cd_lote_fornecedor_p text, ie_param_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ds_lote_fornec_w		varchar(20);
dt_validade_w		varchar(20);


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (nr_seq_dialise_p IS NOT NULL AND nr_seq_dialise_p::text <> '') and (cd_lote_fornecedor_p IS NOT NULL AND cd_lote_fornecedor_p::text <> '') then

	select	max(a.ds_lote_fornec),
		max(PKG_DATE_FORMATERS.TO_VARCHAR(a.dt_validade, 'shortDate', pkg_date_formaters.getUserLanguageTag(WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO), null))
	into STRICT	ds_lote_fornec_w,
		dt_validade_w
	from	material_lote_fornec a
	where	a.nr_sequencia = cd_lote_fornecedor_p;

end if;

if (ie_param_p = 'DS') then
	ds_retorno_w := ds_lote_fornec_w;
elsif (ie_param_p = 'DT') then
	ds_retorno_w := dt_validade_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_validade_lote_fornec (cd_material_p bigint, nr_seq_dialise_p bigint, cd_lote_fornecedor_p text, ie_param_p text) FROM PUBLIC;

