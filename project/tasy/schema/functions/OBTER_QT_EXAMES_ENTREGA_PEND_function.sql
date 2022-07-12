-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_exames_entrega_pend (cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE

 
qt_retorno_w	bigint;

BEGIN
 
qt_retorno_w := 0;
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
	 
	select	count(a.nr_sequencia) 
	into STRICT	qt_retorno_w 
	from	exame_paciente a, 
		atendimento_paciente b 
	where	a.nr_atendimento = b.nr_atendimento 
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and	coalesce(a.dt_entrega::text, '') = '';
end if;
 
return	qt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_exames_entrega_pend (cd_pessoa_fisica_p text) FROM PUBLIC;

