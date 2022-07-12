-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_proc_auditoria ( nr_seq_interno_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE



cd_setor_atendimento_w	integer;


BEGIN

if (coalesce(nr_seq_interno_p,0) <> 0) then
	select	cd_setor_atendimento
	into STRICT	cd_setor_atendimento_w
	from	atend_paciente_unidade
	where	nr_seq_interno = nr_seq_interno_p;
else
	select	cd_setor_atendimento
	into STRICT	cd_setor_atendimento_w
	from	procedimento_paciente
	where	nr_sequencia	= nr_seq_item_p;
end if;

return cd_setor_atendimento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_proc_auditoria ( nr_seq_interno_p bigint, nr_seq_item_p bigint) FROM PUBLIC;
