-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_pend_terc_periodo (nr_seq_terceiro_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_medico_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision := 0;
vl_procedimento_w		double precision := 0;
vl_material_w		double precision := 0;


BEGIN

if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then
	begin

	select	sum(coalesce(a.vl_repasse,0))
	into STRICT	vl_procedimento_w
	from	procedimento_paciente b,
		procedimento_repasse a
	where	a.ie_status		<> 'P'
	and	coalesce(a.nr_repasse_terceiro::text, '') = ''
	and	a.nr_seq_terceiro		= nr_seq_terceiro_p
	and	a.nr_seq_procedimento		= b.nr_sequencia
	and	b.dt_procedimento	between dt_inicial_p and fim_dia(dt_final_p)
	and	(b.nr_interno_conta IS NOT NULL AND b.nr_interno_conta::text <> '')
	and	a.cd_medico		= coalesce(cd_medico_p,a.cd_medico)
	and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
	and	(a.nr_seq_procedimento IS NOT NULL AND a.nr_seq_procedimento::text <> '');

	select	sum(coalesce(a.vl_repasse,0))
	into STRICT	vl_material_w
	from	material_atend_paciente b,
		material_repasse a
	where	a.ie_status		<> 'P'
	and	coalesce(a.nr_repasse_terceiro::text, '') = ''
	and	a.nr_seq_terceiro	= nr_seq_terceiro_p
	and	a.nr_seq_material	= b.nr_sequencia
	and	b.dt_atendimento	between dt_inicial_p and fim_dia(dt_final_p)
	and	(b.nr_interno_conta IS NOT NULL AND b.nr_interno_conta::text <> '')
	and	a.cd_medico		= coalesce(cd_medico_p,a.cd_medico)
	and	coalesce(b.cd_motivo_exc_conta::text, '') = '';

	vl_retorno_w	:= coalesce(vl_procedimento_w,0) + coalesce(vl_material_w,0);

	end;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_pend_terc_periodo (nr_seq_terceiro_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_medico_p text) FROM PUBLIC;
