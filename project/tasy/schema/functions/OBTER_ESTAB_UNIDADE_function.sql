-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_unidade (nr_seq_unid_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estabelecimento_w		smallint;


BEGIN

select	coalesce(max(a.cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from	setor_Atendimento a,
	unidade_atendimento b
where	b.nr_seq_interno = nr_seq_unid_p
and	a.cd_setor_atendimento = b.cd_setor_atendimento;

return	cd_estabelecimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estab_unidade (nr_seq_unid_p bigint) FROM PUBLIC;
