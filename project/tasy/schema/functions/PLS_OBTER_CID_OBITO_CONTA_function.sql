-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cid_obito_conta ( nr_seq_conta_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_tipo_p = C
             retorna o código de doença
ie_tipo_p = N
             retorno o número da declaração
*/
cd_cid_w		varchar(10);
nr_nr_decl_w		varchar(20);
ds_valor_w		varchar(20);


BEGIN

select	max(cd_doenca),
	max(nr_declaracao_obito)
into STRICT	cd_cid_w,
	nr_nr_decl_w
from	pls_diagnost_conta_obito
where 	nr_seq_conta = nr_seq_conta_p;

if (ie_tipo_p = 'C') then
	ds_valor_w := cd_cid_w;
else
	ds_valor_w := nr_nr_decl_w;
end if;

return	ds_valor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cid_obito_conta ( nr_seq_conta_p bigint, ie_tipo_p text) FROM PUBLIC;
