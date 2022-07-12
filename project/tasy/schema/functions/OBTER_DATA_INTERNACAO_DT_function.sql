-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_internacao_dt (nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_entrada_w	timestamp;


BEGIN

select	min(a.dt_entrada_unidade)
into STRICT	dt_entrada_w
from	setor_atendimento b,
	atend_paciente_unidade a
where	a.nr_atendimento		= nr_atendimento_p
and	a.cd_setor_atendimento	= b.cd_setor_atendimento
and	b.cd_classif_setor		in ('3','4');

return	dt_entrada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_internacao_dt (nr_atendimento_p bigint) FROM PUBLIC;

