-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_itens_negativo_audit ( nr_seq_auditoria_p bigint) RETURNS bigint AS $body$
DECLARE


qt_item_negativo_w	bigint := 0;


BEGIN

if (nr_seq_auditoria_p IS NOT NULL AND nr_seq_auditoria_p::text <> '') then

	select	coalesce(sum(x.qt_item_negativo),0)
	into STRICT	qt_item_negativo_w
	from (
		SELECT  count(*) qt_item_negativo
		from    auditoria_conta_paciente a,
			material_atend_paciente  b,
			auditoria_matpaci        c
		where   a.nr_sequencia = nr_seq_auditoria_p
		and     a.nr_sequencia = c.nr_seq_auditoria
		and    	b.nr_sequencia = c.nr_seq_matpaci
		group by	b.cd_material
		having	sum(coalesce(c.qt_ajuste, c.qt_original)) < 0
		
union all

		SELECT  count(*) qt_item_negativo
		from    auditoria_conta_paciente a,
			procedimento_paciente  b,
			auditoria_propaci        c
		where   a.nr_sequencia = nr_seq_auditoria_p
		and     a.nr_sequencia = c.nr_seq_auditoria
		and    	b.nr_sequencia = c.nr_seq_propaci
		group by	b.cd_procedimento,
			b.ie_origem_proced
		having	sum(coalesce(c.qt_ajuste, c.qt_original)) < 0) x;

end if;

return	qt_item_negativo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_itens_negativo_audit ( nr_seq_auditoria_p bigint) FROM PUBLIC;
