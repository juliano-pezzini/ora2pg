-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_modulo_implant_funcao (cd_funcao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

select	max(b.nr_sequencia)
into STRICT	nr_sequencia_w
from	funcao a,
	modulo_implantacao b
where	b.nr_sequencia = a.nr_seq_mod_impl
and	cd_funcao = cd_funcao_p;

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_modulo_implant_funcao (cd_funcao_p bigint) FROM PUBLIC;
