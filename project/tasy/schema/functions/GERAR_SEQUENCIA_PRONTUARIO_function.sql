-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gerar_sequencia_prontuario () RETURNS bigint AS $body$
DECLARE


nr_prontuario_w	bigint;


BEGIN

lock table pessoa_fisica in exclusive mode;

	/* Até 2009 */

if (TO_CHAR(clock_timestamp(),'yy') < 10) then
	select	MAX((SUBSTR('0' || TO_CHAR(nr_prontuario),3,6))::numeric ) + 1
	into STRICT	nr_prontuario_w
	from	pessoa_fisica
	where	SUBSTR('0' || TO_CHAR(nr_prontuario),1,2) = TO_CHAR(clock_timestamp(),'yy');
else	/* Até 2099 */
	select	MAX((SUBSTR(TO_CHAR(nr_prontuario),3,6))::numeric ) + 1
	into STRICT	nr_prontuario_w
	from	pessoa_fisica
	where	SUBSTR(TO_CHAR(nr_prontuario),1,2) = TO_CHAR(clock_timestamp(),'yy');
end	if;

return	(TO_CHAR(clock_timestamp(),'yy') || lpad(nr_prontuario_w,6,'0'))::numeric;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gerar_sequencia_prontuario () FROM PUBLIC;

