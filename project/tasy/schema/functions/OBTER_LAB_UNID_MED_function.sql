-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lab_unid_med ( nr_seq_unid_med_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


cd_unidade_medida_w	varchar(30);
ds_unidade_medida_w	varchar(40);


BEGIN

select	coalesce(max(cd_unidade_medida), ''),
	coalesce(max(ds_unidade_medida), '')
into STRICT	cd_unidade_medida_w,
	ds_unidade_medida_w
from lab_unidade_medida
where nr_sequencia = nr_seq_unid_med_p;

if (ie_opcao_p = 'C') then
	return cd_unidade_medida_w;
else
	return ds_unidade_medida_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lab_unid_med ( nr_seq_unid_med_p bigint, ie_opcao_p text) FROM PUBLIC;
