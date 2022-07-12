-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_prof_captacao ( nr_seq_captacao_p bigint) RETURNS varchar AS $body$
DECLARE


cd_lista_responsaveis_w		varchar(255);

C01 CURSOR FOR
	SELECT	distinct
		b.cd_pessoa_responsavel
	from	mprev_captacao_destino a,
		mprev_equipe b
	where	(b.cd_pessoa_responsavel IS NOT NULL AND b.cd_pessoa_responsavel::text <> '')
	and	a.nr_seq_equipe = b.nr_sequencia
	and	a.nr_seq_captacao =  nr_seq_captacao_p;

BEGIN
if (coalesce(nr_seq_captacao_p,0) > 0) then

	for r_C01 in C01 loop
		begin
			if (cd_lista_responsaveis_w IS NOT NULL AND cd_lista_responsaveis_w::text <> '') then
				cd_lista_responsaveis_w := substr(cd_lista_responsaveis_w || ',' || r_C01.cd_pessoa_responsavel,1,255);
			else
				cd_lista_responsaveis_w := r_C01.cd_pessoa_responsavel;
			end if;
		end;
	end loop;

end if;

return	cd_lista_responsaveis_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_prof_captacao ( nr_seq_captacao_p bigint) FROM PUBLIC;

