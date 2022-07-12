-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_metodo_int_alvaro (nr_seq_exame_p bigint, cd_metodo_integracao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_metodo_w		metodo_exame_lab.nr_sequencia%type;


BEGIN

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (cd_metodo_integracao_p IS NOT NULL AND cd_metodo_integracao_p::text <> '')then

select MAX(a.nr_sequencia)
into STRICT   nr_seq_metodo_w
from   metodo_exame_lab a,
	   exame_lab_metodo b
where  a.nr_sequencia = b.nr_seq_metodo
and	   b.nr_seq_exame = nr_seq_exame_p
and	   a.cd_integracao = cd_metodo_integracao_p;

	if (coalesce(nr_seq_metodo_w::text, '') = '') then

		select 	MAX(a.nr_seq_metodo)
		into STRICT	nr_seq_metodo_w
		from 	metodo_exame_lab_int a,
				equipamento_lab b
		where 	a.cd_equipamento = b.cd_equipamento
		and		a.cd_metodo_integracao = cd_metodo_integracao_p
		and		upper(b.ds_sigla) = 'ALVARO';

		if (coalesce(nr_seq_metodo_w::text, '') = '') then
			select 	MAX(nr_sequencia)
			into STRICT	nr_seq_metodo_w
			from	metodo_exame_lab
			where	cd_integracao = cd_metodo_integracao_p;

			end if;
	end if;
end if;

return	nr_seq_metodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_metodo_int_alvaro (nr_seq_exame_p bigint, cd_metodo_integracao_p text) FROM PUBLIC;

