-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_same ( cd_estabelecimento_p bigint, nr_seq_prontuario_p bigint default null) RETURNS bigint AS $body$
DECLARE


cd_setor_atendimento_w		integer;
nr_seq_agrupamento_w		bigint;


BEGIN

if (nr_seq_prontuario_p IS NOT NULL AND nr_seq_prontuario_p::text <> '') then

	select	max(b.nr_seq_agrupamento)
	into STRICT	nr_seq_agrupamento_w
	from	same_prontuario a,
		same_local b
	where	a.nr_seq_local = b.nr_sequencia
	and	a.nr_sequencia = nr_seq_prontuario_p;

	if (nr_seq_agrupamento_w IS NOT NULL AND nr_seq_agrupamento_w::text <> '') then
		select	max(cd_setor_atendimento)
		into STRICT	cd_setor_atendimento_w
		from	setor_atendimento
		where	cd_classif_setor = 6
		and	nr_seq_agrupamento = nr_seq_agrupamento_w;
	end if;
end if;

if (coalesce(cd_setor_atendimento_w::text, '') = '') then
	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_atendimento_w
	from	setor_atendimento
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_classif_setor = 6;
end if;

if (coalesce(cd_setor_atendimento_w::text, '') = '') then
	select	max(cd_Setor_Atendimento)
	into STRICT	cd_setor_atendimento_w
	from	setor_atendimento
	where	cd_classif_setor = 6;
end if;

return	cd_setor_atendimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_same ( cd_estabelecimento_p bigint, nr_seq_prontuario_p bigint default null) FROM PUBLIC;
