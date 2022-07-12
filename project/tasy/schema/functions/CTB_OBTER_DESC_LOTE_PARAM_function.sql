-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_desc_lote_param ( nr_lote_contabil_p bigint, cd_tipo_lote_contabil_p bigint, nr_seq_parametro_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
ds_valor_parametro_w		varchar(4000);
ie_tipo_parametro_w		varchar(2);
vl_parametro_w			double precision;


BEGIN

select	max(ie_tipo_parametro)
into STRICT	ie_tipo_parametro_w
from	tipo_lote_contabil_param
where	cd_tipo_lote_contabil	= cd_tipo_lote_contabil_p
and	nr_seq_parametro		= nr_seq_parametro_p;

if (ie_tipo_parametro_w = 1) then

	select	coalesce(max(ds_valor_parametro),0)
	into STRICT	ds_valor_parametro_w
	from	lote_contabil_parametro
	where	nr_lote_contabil		= nr_lote_contabil_p
	and	cd_tipo_lote_contabil	= cd_tipo_lote_contabil_p
	and	nr_seq_parametro		= nr_seq_parametro_p;


elsif (ie_tipo_parametro_w = 5) then

	select	coalesce(max(vl_parametro),0)
	into STRICT	vl_parametro_w
	from	lote_contabil_parametro
	where	nr_lote_contabil		= nr_lote_contabil_p
	and	cd_tipo_lote_contabil	= cd_tipo_lote_contabil_p
	and	nr_seq_parametro		= nr_seq_parametro_p;

end if;

	/*Tipo de lote Notas fiscais */

if (cd_tipo_lote_contabil_p = 2) then

	if (nr_seq_parametro_p = 5) and (coalesce(ds_valor_parametro_w,'A') <> 'A') then

		vl_parametro_w		:= somente_numero(ds_valor_parametro_w);

		select	max(ds_grupo_contabil)
		into STRICT	ds_retorno_w
		from	sup_grupo_contab_nota
		where	nr_sequencia	= vl_parametro_w;

	end if;
	/*Tipo de lote Receitas */

elsif (cd_tipo_lote_contabil_p = 6) then

	if (nr_seq_parametro_p = 3) and (vl_parametro_w <> 0) then

		select	max(ds_convenio)
		into STRICT	ds_retorno_w
		from	convenio
		where	cd_convenio	= vl_parametro_w;

	end if;
	/*Tipo de lote Tesouraria */

elsif (cd_tipo_lote_contabil_p = 10) then

	if (nr_seq_parametro_p = 1) and (vl_parametro_w <> 0) then

		select	max(ds_classificacao)
		into STRICT	ds_retorno_w
		from	classif_caixa
		where	nr_sequencia	= vl_parametro_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_desc_lote_param ( nr_lote_contabil_p bigint, cd_tipo_lote_contabil_p bigint, nr_seq_parametro_p bigint) FROM PUBLIC;
