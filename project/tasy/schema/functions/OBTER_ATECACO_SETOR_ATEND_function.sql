-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atecaco_setor_atend ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_atecaco_w	bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_atecaco_w
from	atend_paciente_unidade
where	nr_atendimento = nr_atendimento_p
and	cd_setor_atendimento = cd_setor_atendimento_p;

return	nr_seq_atecaco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atecaco_setor_atend ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

