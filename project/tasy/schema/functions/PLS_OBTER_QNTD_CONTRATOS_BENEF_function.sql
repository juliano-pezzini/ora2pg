-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qntd_contratos_benef ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
qt_contratos_w			bigint;


BEGIN

select  cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from    pls_segurado
where   nr_sequencia   = nr_seq_segurado_p;

select	count(*)
into STRICT	qt_contratos_w
from	pls_contrato b,
	pls_segurado a
where	a.nr_seq_contrato	= b.nr_sequencia
and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	((coalesce(a.dt_rescisao::text, '') = '')
or 	((a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '')
and (a.dt_limite_utilizacao >= clock_timestamp())));

if (qt_contratos_w	<= 1) then
	cd_pessoa_fisica_w	:= 'X';
end if;

return	cd_pessoa_fisica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qntd_contratos_benef ( nr_seq_segurado_p bigint) FROM PUBLIC;

