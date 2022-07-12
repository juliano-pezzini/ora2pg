-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_senha_local (nr_seq_local_senha_p bigint) RETURNS varchar AS $body$
DECLARE


cd_senha_w	varchar(255);
nr_sequencia_w	bigint;


BEGIN

if (coalesce(nr_seq_local_senha_p,0) > 0) then

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	paciente_senha_fila
	where	nr_seq_local_senha = nr_seq_local_senha_p
	and	(dt_inicio_atendimento IS NOT NULL AND dt_inicio_atendimento::text <> '')
	and	coalesce(dt_fim_atendimento::text, '') = ''
	and	dt_geracao_senha between trunc(clock_timestamp()) and trunc(clock_timestamp())+86399/86400;

	if (coalesce(nr_sequencia_w,0) > 0) then

		select	substr(substr(obter_letra_verifacao_senha(coalesce(nr_seq_fila_senha_origem, nr_seq_fila_senha)),1,10) || cd_senha_gerada,1,255)
		into STRICT	cd_senha_w
		from	paciente_senha_fila
		where	nr_sequencia = nr_sequencia_w;

	end if;

end if;

return	cd_senha_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_senha_local (nr_seq_local_senha_p bigint) FROM PUBLIC;
