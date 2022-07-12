-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_se_apresenta_comp ( nr_seq_serv_dia_p bigint, nr_seq_acompanhante_p bigint, cd_acompanhante_p bigint, nr_seq_comp_p bigint, cd_dieta_p bigint) RETURNS varchar AS $body$
DECLARE


dt_servico_w		timestamp;
nr_seq_servico_w	bigint;
nr_atendimento_w	bigint;
cd_setor_atendimento_w	integer;
nr_seq_local_w		bigint;
nr_seq_servico_acomp_w	bigint;
ds_retorno_w		varchar(1) := 'N';
ie_local_composicao_w	varchar(1);
			

BEGIN

select	a.dt_servico,
	a.nr_seq_servico,
	a.nr_atendimento,
	obter_setor_atendimento(a.nr_atendimento)
into STRICT	dt_servico_w,
	nr_seq_servico_w,
	nr_atendimento_w,
	cd_setor_atendimento_w
from	nut_atend_serv_dia a
where	nr_sequencia = nr_seq_serv_dia_p;

ie_local_composicao_w := nut_obter_se_setor_comp(cd_setor_atendimento_w,
						nr_atendimento_w,
						nr_seq_servico_w,
						dt_servico_w);

select	coalesce(max(nr_seq_atend_serv_dia),0)
into STRICT	nr_seq_servico_acomp_w
from	nut_atend_acompanhante
where	nr_sequencia = nr_seq_acompanhante_p;

if (ie_local_composicao_w = 'N') then
	
	nr_seq_local_w :=  nut_obter_local_paciente;

	select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from    nut_cardapio a,
		nut_cardapio_dia b
	where   b.nr_seq_servico    = nr_seq_servico_w
	and     a.nr_seq_card_dia   = b.nr_sequencia
	and	a.nr_seq_comp = nr_seq_comp_p
	and     obter_se_cardapio_dia(dt_servico_w, b.ie_semana, b.ie_dia_semana) = 'S'
	and     b.nr_seq_local = nr_seq_local_w
	and     dt_servico_w between b.dt_vigencia_inicial and b.dt_vigencia_final
	and (b.cd_dieta  = cd_dieta_p 
	or	exists (SELECT	1
			from	nut_grupo_producao_dieta c
			where	c.nr_seq_grupo_producao = b.nr_seq_grupo_producao
			and	c.cd_dieta = cd_dieta_p))
	and	not exists (select	1
			from	nut_local_refeicao k,
				nut_local_refeicao_setor j
			where	k.nr_sequencia = b.nr_seq_local
			and	k.nr_sequencia = j.nr_seq_local
			and	j.cd_setor_atendimento = cd_setor_atendimento_w);
			
else

	select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from    nut_cardapio a,
		nut_cardapio_dia b
	where   b.nr_seq_servico    = nr_seq_servico_w
	and     a.nr_seq_card_dia   = b.nr_sequencia
	and	a.nr_seq_comp = nr_seq_comp_p
	and     obter_se_cardapio_dia(dt_servico_w, b.ie_semana, b.ie_dia_semana) = 'S'
	and     dt_servico_w between b.dt_vigencia_inicial and b.dt_vigencia_final
	and (b.cd_dieta  = cd_dieta_p 
	or	exists (SELECT	1
			from	nut_grupo_producao_dieta c
			where	c.nr_seq_grupo_producao = b.nr_seq_grupo_producao
			and	c.cd_dieta = cd_dieta_p));
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_se_apresenta_comp ( nr_seq_serv_dia_p bigint, nr_seq_acompanhante_p bigint, cd_acompanhante_p bigint, nr_seq_comp_p bigint, cd_dieta_p bigint) FROM PUBLIC;
