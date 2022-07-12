-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_checkup ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, cd_setor_atendimento_p bigint, dt_previsto_p timestamp) RETURNS timestamp AS $body$
DECLARE


qt_agendado_checkup_w		bigint;
qt_agendado_checkup_set_w	bigint;
ds_retorno_w			timestamp;


BEGIN

if (cd_pessoa_Fisica_p IS NOT NULL AND cd_pessoa_Fisica_p::text <> '') and (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (dt_previsto_p IS NOT NULL AND dt_previsto_p::text <> '') then
	select	count(*)
	into STRICT	qt_agendado_checkup_w
	from	checkup
	where	nr_sequencia		<> nr_sequencia_p
	and	cd_setor_atendimento	<> cd_setor_atendimento_p
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	dt_previsto		= dt_previsto_p;

	select	count(*)
	into STRICT	qt_agendado_checkup_set_w
	from	checkup
	where	nr_sequencia		<> nr_sequencia_p
	and	cd_setor_atendimento	= cd_setor_atendimento_p
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	dt_previsto		= dt_previsto_p;

	if (qt_agendado_checkup_w > 0) then
		begin
		select	max(dt_previsto)
		into STRICT	ds_retorno_w
		from	checkup
		where	nr_sequencia		<> nr_sequencia_p
		and	cd_setor_atendimento	<> cd_setor_atendimento_p
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	dt_previsto		= dt_previsto_p;

		end;
	elsif (qt_agendado_checkup_set_w > 0) then
		begin
		select	max(dt_previsto)
		into STRICT	ds_retorno_w
		from	checkup
		where	nr_sequencia		<> nr_sequencia_p
		and	cd_setor_atendimento	= cd_setor_atendimento_p
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	dt_previsto		= dt_previsto_p;

		end;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_checkup ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, cd_setor_atendimento_p bigint, dt_previsto_p timestamp) FROM PUBLIC;
