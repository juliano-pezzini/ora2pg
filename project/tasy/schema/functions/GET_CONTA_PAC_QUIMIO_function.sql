-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_conta_pac_quimio ( nr_seq_atendimento_p bigint, nr_seq_ordem_p bigint) RETURNS bigint AS $body$
DECLARE


nr_interno_conta_w	conta_paciente.nr_interno_conta%type;


BEGIN

SELECT 	coalesce(max(nr_interno_conta),0)
into STRICT	nr_interno_conta_w
FROM	paciente_atend_medic b,
		paciente_atendimento e,
		material_atend_paciente c
WHERE	e.nr_seq_atendimento = b.nr_seq_atendimento
and		e.nr_prescricao = c.nr_prescricao
AND	 	b.nr_seq_material = c.nr_sequencia_prescricao
and	 	b.nr_seq_atendimento = nr_seq_atendimento_p
and		c.nr_seq_ordem_prod = nr_seq_ordem_p;

return	nr_interno_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_conta_pac_quimio ( nr_seq_atendimento_p bigint, nr_seq_ordem_p bigint) FROM PUBLIC;
