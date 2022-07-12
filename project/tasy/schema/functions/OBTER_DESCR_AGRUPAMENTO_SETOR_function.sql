-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descr_agrupamento_setor (cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_agrupamento_w 	varchar(255);


BEGIN

select  max(ds_agrupamento)
into STRICT	ds_agrupamento_w
from	setor_atendimento a,
	agrupamento_setor b
where   a.cd_setor_atendimento = cd_setor_atendimento_p
and	b.nr_sequencia = a.nr_seq_agrupamento;

return	ds_agrupamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descr_agrupamento_setor (cd_setor_atendimento_p bigint) FROM PUBLIC;
