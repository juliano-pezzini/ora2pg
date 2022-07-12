-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION paf_requisito_vii_item_7_p9 (cd_estabelecimento_p bigint, qt_registros_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000);
nr_inscricao_w	varchar(15);
cd_cnpj_w	varchar(50);


BEGIN

select 	substr(lpad(elimina_caractere_especial(e.cd_cgc),14,'0'),1,14),
	substr(lpad(elimina_caractere_especial(coalesce(p.nr_inscricao_estadual,' ')),14,'0'),1,14)
into STRICT	cd_cnpj_w,
	nr_inscricao_w
from 	estabelecimento e,
	pessoa_juridica p
where	e.cd_cgc = p.cd_cgc
and	e.cd_estabelecimento = cd_estabelecimento_p;

select 	'P9' ||
	cd_cnpj_w ||
	nr_inscricao_w ||
	lpad(qt_registros_p,6,'0')
into STRICT	ds_retorno_w
;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION paf_requisito_vii_item_7_p9 (cd_estabelecimento_p bigint, qt_registros_p bigint) FROM PUBLIC;

