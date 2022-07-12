-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ehr_obter_desc_unid_med ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
C - Código
D - Descrição
*/
cd_unidade_medida_w varchar(100);
ds_unidade_medida_w varchar(100);
ds_retorno_w		varchar(100);


BEGIN

if (nr_sequencia_p > 0) then
	begin
	select	cd_unidade_medida,
			ds_unidade_medida
	into STRICT	cd_unidade_medida_w,
			ds_unidade_medida_w
	from	ehr_unidade_medida
	where	nr_sequencia	= nr_sequencia_p;

	if (ie_opcao_p = 'C') then
		ds_retorno_w := cd_unidade_medida_w;
	else
		ds_retorno_w := ds_unidade_medida_w;
	end if;
	end;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ehr_obter_desc_unid_med ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

