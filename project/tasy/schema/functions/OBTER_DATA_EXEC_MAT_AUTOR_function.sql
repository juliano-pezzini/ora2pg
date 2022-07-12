-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_exec_mat_autor (nr_seq_mat_autor_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w	timestamp;


BEGIN

select max(b.dt_atendimento) dt_atendimento
into STRICT	dt_retorno_w
from 	material_autorizado a,
	material_atend_paciente b
where	a.nr_sequencia		= nr_seq_mat_autor_p
and 	a.nr_sequencia		= b.nr_seq_mat_autor
and	((a.nr_prescricao	= b.nr_prescricao) or (coalesce(a.nr_prescricao,0) = 0))
and 	coalesce(b.cd_motivo_exc_conta::text, '') = '';

if (coalesce(dt_retorno_w::text, '') = '') then

	select	max(b.dt_atendimento) dt_atendimento
	into STRICT	dt_retorno_w
	from 	material_autorizado a,
		material_atend_paciente b,
		autorizacao_convenio c
	where	a.nr_sequencia 		= nr_seq_mat_autor_p
	and 	c.nr_sequencia		= a.nr_sequencia_autor
	and 	c.nr_atendimento	= b.nr_atendimento
	and 	c.cd_convenio		= b.cd_convenio
	and	((a.nr_prescricao	= b.nr_prescricao) or (coalesce(a.nr_prescricao,0) = 0))
	and 	b.cd_material		= a.cd_material
	and 	coalesce(b.cd_motivo_exc_conta::text, '') = '';

end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_exec_mat_autor (nr_seq_mat_autor_p bigint) FROM PUBLIC;

