-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pontuacao_sepsis ( nr_atendimento_p bigint, nm_tabela_p text, vl_rownumber_p bigint) RETURNS bigint AS $body$
DECLARE


ds_return_w			integer := 0;
ds_sql				varchar(1000);


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') then

	ds_sql :=		'select nr_pontuacao from ('	||
					'		select rownum RN, nr_pontuacao from ('	||
					'				select nr_pontuacao from '|| nm_tabela_p	||
					'				where nr_atendimento = :nr_atendimento_p order by dt_pontuacao desc)'	||
					'		where rownum <= 2) '	||
					'where RN = :vl_rownumber_p';

	EXECUTE
		ds_sql
	into STRICT
		ds_return_w
	using
		nr_atendimento_p, vl_rownumber_p;

end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pontuacao_sepsis ( nr_atendimento_p bigint, nm_tabela_p text, vl_rownumber_p bigint) FROM PUBLIC;

