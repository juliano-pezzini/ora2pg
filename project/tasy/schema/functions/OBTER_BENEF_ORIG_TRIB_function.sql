-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_benef_orig_trib ( nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_beneficiario_w		varchar(80);
nr_titulo_w			bigint;


BEGIN 
 
select	coalesce(max(nr_titulo),0) 
into STRICT	nr_titulo_w 
from	titulo_pagar_imposto 
where	nr_sequencia	= ( 
	SELECT	nr_seq_tributo 
	from	titulo_pagar	 
	where	nr_titulo	= nr_titulo_p);
 
if (nr_titulo_w > 0) then 
	select substr(obter_nome_pf_pj(cd_pessoa_fisica, cd_cgc),1,80) 
	into STRICT	ds_beneficiario_w 
	from	titulo_pagar 
	where	nr_titulo	= nr_titulo_w;
end if;
 
return	ds_beneficiario_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_benef_orig_trib ( nr_titulo_p bigint) FROM PUBLIC;

