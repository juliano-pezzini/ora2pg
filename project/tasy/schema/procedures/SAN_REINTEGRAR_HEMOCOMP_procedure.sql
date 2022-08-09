-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_reintegrar_hemocomp ( nr_sequencia_p bigint, nr_seq_producao_p bigint) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
nr_seq_propaci_w	bigint;


BEGIN

if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then

	update 	san_producao
	set	nr_seq_transfusao  = NULL
	where	nr_sequencia   	  = nr_seq_producao_p;

	update	san_retorno_transfusao
	set	dt_liberacao 	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;

	select 	max(nr_seq_propaci)
	into STRICT	nr_seq_propaci_w
	from 	san_producao
	where	nr_sequencia = nr_seq_producao_p;

	if (nr_seq_propaci_w IS NOT NULL AND nr_seq_propaci_w::text <> '') then

		delete
		from	procedimento_paciente a
		where	a.nr_seq_transfusao = nr_seq_propaci_w;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_reintegrar_hemocomp ( nr_sequencia_p bigint, nr_seq_producao_p bigint) FROM PUBLIC;
