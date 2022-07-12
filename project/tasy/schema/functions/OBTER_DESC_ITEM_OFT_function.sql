-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_item_oft (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_item_w	varchar(40);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select 	max(coalesce(ds_instituicao,obter_desc_expressao(cd_exp_desc_item,ds_item)))
	into STRICT 	ds_item_w
	from  	oftalmologia_item a,
		perfil_item_oftalmologia b
	where 	b.nr_seq_item = a.nr_sequencia
	and	a.nr_sequencia = nr_sequencia_p;
end if;


return	ds_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_item_oft (nr_sequencia_p bigint) FROM PUBLIC;
