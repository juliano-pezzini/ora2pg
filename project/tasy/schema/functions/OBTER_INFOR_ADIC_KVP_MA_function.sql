-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_infor_adic_kvp_ma ( ie_opcao_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_filtro_w	varchar(255);


BEGIN

if (ie_opcao_p = 'KVPF') then

	select 	max(ds_filtro)
	into STRICT	ds_filtro_w
	from 	rxt_kvp_info_adic
	where 	nr_seq_kvp = nr_sequencia_p;

elsif (ie_opcao_p = 'KVPIA') then

	select 	max(ds_info_adic)
	into STRICT	ds_filtro_w
	from 	rxt_kvp_info_adic
	where 	nr_seq_kvp = nr_sequencia_p;

elsif (ie_opcao_p = 'MA') then

	select 	max(ds_info_adic)
	into STRICT	ds_filtro_w
	from 	rxt_ma_info_adic
	where 	nr_seq_ma = nr_sequencia_p;

else
	select 	max(ie_tipo_medida)
	into STRICT	ds_filtro_w
	from 	rxt_aplicador
	where 	nr_sequencia = nr_sequencia_p;

end if;

return ds_filtro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_infor_adic_kvp_ma ( ie_opcao_p text, nr_sequencia_p bigint) FROM PUBLIC;
