-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_servico_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, dt_procedimento_p timestamp default clock_timestamp()) RETURNS bigint AS $body$
DECLARE


nr_seq_retorno_w			bigint := null;
qt_regra_bpa_w			bigint;
qt_hab_bpa_w			bigint;
qt_serv_bpa_w			bigint;


BEGIN

if (ie_tipo_atendimento_p <> 1) and (Sus_Obter_Se_Detalhe_Proc(cd_procedimento_p,ie_origem_proced_p,'020',dt_procedimento_p) > 0) then
	begin

	select	count(1)
	into STRICT	qt_regra_bpa_w
	from	sus_procedimento a
	where	a.cd_procedimento	= cd_procedimento_p
	and	a.ie_origem_proced	= ie_origem_proced_p
	and	exists (	SELECT	1
			from	sus_procedimento_registro x
			where	x.cd_procedimento	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced
			and	x.cd_registro 		= 1)
	and	exists (	select	1
			from	sus_procedimento_registro x
			where	x.cd_procedimento	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced
			and	x.cd_registro 		= 2)  LIMIT 1;

	if (qt_regra_bpa_w > 0) then
		begin

		select	count(1)
		into STRICT	qt_hab_bpa_w
		from	sus_habilitacao_hospital
		where	cd_estabelecimento = cd_estabelecimento_p
		and	cd_habilitacao in (403,404,405)  LIMIT 1;

		select 	count(1)
		into STRICT	qt_serv_bpa_w
		from	sus_serv_classif_hosp x,
			sus_servico_hospital y
		where	x.nr_seq_serv_classif = 6761
		and	y.nr_seq_servico = 1351
		and	x.nr_seq_serv_hosp = y.nr_sequencia  LIMIT 1;

		if (qt_hab_bpa_w > 0) and (qt_serv_bpa_w > 0) then
			begin
			nr_seq_retorno_w := 1351;
			end;
		end if;

		end;
	end if;

	end;
end if;

if (coalesce(nr_seq_retorno_w::text, '') = '') then
	begin

	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_retorno_w
	from	sus_servico a,
		sus_servico_classif b,
		sus_proced_serv_classif c
	where	a.nr_sequencia = b.nr_seq_servico
	and	b.nr_sequencia = c.nr_seq_serv_classif
	and	c.cd_procedimento = cd_procedimento_p
	and	c.ie_origem_proced = ie_origem_proced_p
	and	exists (SELECT	1
          		from	sus_servico_hospital x
			where	x.nr_seq_servico = a.nr_sequencia
			and	x.cd_estabelecimento = cd_estabelecimento_p
			and	exists ( select	1
					from	sus_serv_classif_hosp w
					where	w.nr_seq_serv_classif = b.nr_sequencia
					and	w.nr_seq_serv_hosp = x.nr_sequencia));
	exception
	when others then
		nr_seq_retorno_w := null;
	end;

	if (coalesce(nr_seq_retorno_w::text, '') = '') then
		begin

		begin
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_retorno_w
		from	sus_servico a,
			sus_servico_classif b,
			sus_proced_serv_classif c
		where	a.nr_sequencia = b.nr_seq_servico
		and	b.nr_sequencia = c.nr_seq_serv_classif
		and	c.cd_procedimento = cd_procedimento_p
		and	c.ie_origem_proced = ie_origem_proced_p
		and	exists (SELECT	1
          			from	sus_servico_hospital x
				where	x.nr_seq_servico = a.nr_sequencia
				and	x.cd_estabelecimento = cd_estabelecimento_p);
		exception
		when others then
			nr_seq_retorno_w := null;
		end;

		end;
	end if;

	end;
end if;

return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_servico_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, dt_procedimento_p timestamp default clock_timestamp()) FROM PUBLIC;
