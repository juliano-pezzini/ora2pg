-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_laudo_procedimento ( nr_seq_propaci_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
'DL'  - Data Liberação do Laudo
*/
ds_retorno_w		varchar(255);
dt_liberacao_laudo_w	timestamp;
nr_seq_proc_princ_w	bigint;
nr_laudo_w		bigint;


BEGIN
ds_retorno_w	:= '';
if (ie_opcao_p	= 'DL') then
	select	max(a.dt_liberacao)
	into STRICT	dt_liberacao_laudo_w
	from	laudo_paciente a
	where	a.nr_seq_proc	= nr_seq_propaci_p;

	if (coalesce(dt_liberacao_laudo_w::text, '') = '') then
		select	max(a.nr_seq_proc_princ)
		into STRICT	nr_seq_proc_princ_w
		from	procedimento_paciente a
		where	a.nr_sequencia	= nr_seq_propaci_p;

		select	max(a.dt_liberacao)
		into STRICT	dt_liberacao_laudo_w
		from	laudo_paciente a
		where	a.nr_seq_proc	= nr_seq_proc_princ_w;
	end if;

		if (coalesce(dt_liberacao_laudo_w::text, '') = '') then

			select	max(a.nr_laudo)
			into STRICT	nr_laudo_w
			from	procedimento_paciente a
			where	a.nr_sequencia	= nr_seq_propaci_p;

			select	max(a.dt_liberacao)
			into STRICT	dt_liberacao_laudo_w
			from	laudo_paciente a
			where	a.nr_sequencia	= nr_laudo_w;

		end if;

	ds_retorno_w	:= to_char(dt_liberacao_laudo_w,'dd/mm/yyyy');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_laudo_procedimento ( nr_seq_propaci_p bigint, ie_opcao_p text) FROM PUBLIC;

