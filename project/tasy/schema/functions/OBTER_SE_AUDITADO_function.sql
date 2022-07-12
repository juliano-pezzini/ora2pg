-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_auditado ( nr_seq_auditoria_p bigint, cd_item_p bigint, cd_setor_atendimento_p bigint, dt_conta_p timestamp, vl_unitario_p bigint, ie_tipo_item_p bigint, ie_tipo_ajuste_p text, cd_material_tiss_p text Default Null) RETURNS varchar AS $body$
DECLARE


ie_auditado_w	varchar(1):= 'N';
qt_auditado_w	bigint;


BEGIN

if (coalesce(ie_tipo_ajuste_p,'DIA') = 'DIA') then

	if (ie_tipo_item_p = 1 ) then
		select 	count(*)
		into STRICT	qt_auditado_w
		from 	auditoria_matpaci a,
			material_atend_paciente b
		where	a.nr_seq_matpaci = b.nr_sequencia
		and	a.ie_tipo_auditoria = 'D'
		and	a.nr_seq_auditoria = nr_seq_auditoria_p
		and	b.cd_material = cd_item_p
		and	coalesce((SELECT max(x.cd_setor_atendimento) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu_ajuste),b.cd_setor_atendimento) = cd_setor_atendimento_p
		and	trunc(b.dt_conta) = trunc(dt_conta_p);
	elsif (ie_tipo_item_p = 2 ) then
		select 	count(*)
		into STRICT	qt_auditado_w
		from 	auditoria_propaci a,
			procedimento_paciente b
		where	a.nr_seq_propaci = b.nr_sequencia
		and	a.ie_tipo_auditoria = 'D'
		and	a.nr_seq_auditoria = nr_seq_auditoria_p
		and	b.cd_procedimento = cd_item_p
		and	coalesce((SELECT max(x.cd_setor_atendimento) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu_ajuste),b.cd_setor_atendimento) = cd_setor_atendimento_p
		and	trunc(b.dt_conta) = trunc(dt_conta_p);
	end if;

elsif (coalesce(ie_tipo_ajuste_p,'DIA') = 'SETOR') then

	if (ie_tipo_item_p = 1 ) then
		select 	count(*)
		into STRICT	qt_auditado_w
		from 	auditoria_matpaci a,
			material_atend_paciente b
		where	a.nr_seq_matpaci = b.nr_sequencia
		and	a.ie_tipo_auditoria = 'D'
		and	a.nr_seq_auditoria = nr_seq_auditoria_p
		and	b.cd_material = cd_item_p
		and	coalesce((SELECT max(x.cd_setor_atendimento) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu_ajuste),b.cd_setor_atendimento) = cd_setor_atendimento_p
		and	b.vl_unitario = vl_unitario_p
		and	((b.cd_material_tiss = cd_material_tiss_p) or (coalesce(cd_material_tiss_p::text, '') = ''));
	elsif (ie_tipo_item_p = 2 ) then
		select 	count(*)
		into STRICT	qt_auditado_w
		from 	auditoria_propaci a,
			procedimento_paciente b
		where	a.nr_seq_propaci = b.nr_sequencia
		and	a.ie_tipo_auditoria = 'D'
		and	a.nr_seq_auditoria = nr_seq_auditoria_p
		and	b.cd_procedimento = cd_item_p
		and	coalesce((SELECT max(x.cd_setor_atendimento) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu_ajuste),b.cd_setor_atendimento) = cd_setor_atendimento_p
		and	trunc(b.dt_conta) = trunc(dt_conta_p);
	end if;

end if;

if (qt_auditado_w > 0) then
	ie_auditado_w:= 'S';
end if;

return	ie_auditado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_auditado ( nr_seq_auditoria_p bigint, cd_item_p bigint, cd_setor_atendimento_p bigint, dt_conta_p timestamp, vl_unitario_p bigint, ie_tipo_item_p bigint, ie_tipo_ajuste_p text, cd_material_tiss_p text Default Null) FROM PUBLIC;

