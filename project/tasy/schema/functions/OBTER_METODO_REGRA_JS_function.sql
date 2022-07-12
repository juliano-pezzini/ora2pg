-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_metodo_regra_js (nr_prescricao_p bigint, nr_seq_exame_p bigint ) RETURNS bigint AS $body$
DECLARE

			
cd_estabelecimento_w	integer;
ie_tipo_atendimento_w	exame_lab_metodo_regra.ie_tipo_atendimento%type;
nr_seq_metodo_w			bigint;



BEGIN

select	cd_estabelecimento,
		coalesce(Obter_Tipo_Atendimento(nr_atendimento),0)
into STRICT	cd_estabelecimento_w,
		ie_tipo_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	coalesce(max(a.nr_seq_metodo),0)
into STRICT	nr_seq_metodo_w
from	exame_lab_metodo a,
	exame_lab_metodo_regra b,
	metodo_exame_lab c	
where	a.nr_seq_exame = b.nr_seq_exame
and	c.nr_sequencia = a.nr_Seq_metodo
and	coalesce(c.ie_situacao,'A') = 'A'
and	b.nr_seq_metodo = a.nr_seq_metodo
and	b.cd_estabelecimento = cd_estabelecimento_w
and coalesce(b.ie_tipo_atendimento,ie_tipo_atendimento_w) = ie_tipo_atendimento_w
and	a.nr_seq_exame = nr_seq_exame_p
and	((b.ie_dia_semana = pkg_date_utils.get_WeekDay(clock_timestamp())) or (b.ie_dia_semana = 9))
and clock_timestamp() between pkg_date_utils.get_Datetime(clock_timestamp(), b.ds_hora_inicio) and pkg_date_utils.get_Datetime(clock_timestamp(), b.ds_hora_fim)
order by a.ie_prioridade;

if (nr_seq_metodo_w = 0) then

	select	coalesce(max(a.nr_seq_metodo),0)
	into STRICT	nr_seq_metodo_w
	from	exame_lab_metodo a,
		exame_lab_metodo_regra b,
		metodo_exame_lab c
	where	a.nr_seq_exame = b.nr_seq_exame
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	c.nr_sequencia = a.nr_Seq_metodo
	and	b.nr_seq_metodo = a.nr_seq_metodo
	and	b.cd_estabelecimento = cd_estabelecimento_w
	and coalesce(b.ie_tipo_atendimento,ie_tipo_atendimento_w) = ie_tipo_atendimento_w
	and	a.nr_seq_exame = nr_seq_exame_p
	order by a.ie_prioridade;
	
	if (nr_seq_metodo_w = 0) then
		
		select coalesce(max(nr_seq_metodo),null)
		into STRICT nr_seq_metodo_w
		from (	SELECT nr_seq_metodo, ie_prioridade
			from 	exame_lab_metodo a,
				metodo_exame_lab c
			where nr_seq_exame = nr_seq_exame_p
			and	c.nr_sequencia = a.nr_Seq_metodo
			and	coalesce(c.ie_situacao,'A') = 'A'
			order by ie_prioridade) alias4 LIMIT 1;
	end if;
end if;

return	nr_seq_metodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_metodo_regra_js (nr_prescricao_p bigint, nr_seq_exame_p bigint ) FROM PUBLIC;

