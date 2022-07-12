-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_obter_valor_rep_conta ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_repasse_w		double precision;

vl_repasse_proc_w		double precision;
vl_Liberado_Proc_w		double precision;
vl_pendente_Proc_w		double precision;

vl_repasse_mat_w		double precision;
vl_Liberado_mat_w		double precision;
vl_pendente_mat_w		double precision;

/* Opção
R - Repasse
L - Liberado
P - Pendente
*/
BEGIN

select
	coalesce(sum(vl_repasse),0),
	coalesce(sum(vl_liberado),0),
	coalesce(sum(vl_repasse),0) - coalesce(sum(vl_liberado),0)
into STRICT	vl_repasse_proc_w,
	vl_liberado_proc_w,
	vl_pendente_proc_w
from 	procedimento_repasse b,
	procedimento_paciente a
where	b.nr_seq_procedimento	= a.nr_sequencia
  and	a.nr_interno_conta		= nr_interno_conta_p;

select
	coalesce(sum(vl_repasse),0),
	coalesce(sum(vl_liberado),0),
	coalesce(sum(vl_repasse),0) - coalesce(sum(vl_liberado),0)
into STRICT	vl_repasse_mat_w,
	vl_liberado_mat_w,
	vl_pendente_mat_w
from 	material_repasse b,
	material_atend_paciente a
where	b.nr_seq_material	= a.nr_sequencia
  and	a.nr_interno_conta	= nr_interno_conta_p;

if (ie_opcao_p	= 'R') then
	vl_repasse_w	:= vl_repasse_proc_w + vl_repasse_mat_w;
elsif (ie_opcao_p	= 'P') then
	vl_repasse_w	:= vl_pendente_proc_w + vl_pendente_mat_w;
else
	vl_repasse_w	:= vl_liberado_proc_w + vl_liberado_mat_w;
end if;

RETURN vl_repasse_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_obter_valor_rep_conta ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;

