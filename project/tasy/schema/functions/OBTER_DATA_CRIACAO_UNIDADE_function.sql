-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_criacao_unidade ( nr_seq_interno_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp;



BEGIN

if (coalesce(nr_seq_interno_p,0) > 0) then

	select	max(dt_criacao)
	into STRICT	dt_retorno_w
	from	unidade_atendimento
	where	nr_seq_interno  = nr_seq_interno_p;
end if;
RETURN	dt_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_criacao_unidade ( nr_seq_interno_p bigint) FROM PUBLIC;
