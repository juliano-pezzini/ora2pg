-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_orc_valor_partic ( nr_seq_proc_orc_p bigint, vl_procedimento_p bigint, vl_medico_p bigint, vl_auxiliar_p bigint, vl_anestesista_p bigint, vl_co_p bigint, nm_usuario_p text, vl_auxiliares_p INOUT bigint ) AS $body$
DECLARE


vl_participante_w			orcamento_particip_proc.vl_participante%type;
pr_participante_w			orcamento_particip_proc.pr_participante%type;
ie_funcao_partic_w 			orcamento_particip_proc.ie_funcao%type;
ie_valor_informado_w		orcamento_particip_proc.ie_valor_informado%type;
nr_sequencia_w				orcamento_particip_proc.nr_sequencia%type;

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_estab_logado_w			estabelecimento.cd_estabelecimento%type;
cd_estab_honorario_w		estabelecimento.cd_estabelecimento%type;

ie_estabelecimento_conta_w	parametro_faturamento.ie_estabelecimento_conta%type;

ie_partic_resp_cred_w		convenio_estabelecimento.ie_partic_resp_cred%type;

cd_convenio_w				orcamento_paciente.cd_convenio%type;
cd_categoria_w				orcamento_paciente.cd_categoria%type;

ie_origem_proced_w			orcamento_paciente_proc.ie_origem_proced%type;
cd_procedimento_w			orcamento_paciente_proc.cd_procedimento%type;

cd_area_proc_w				area_procedimento.cd_area_procedimento%type;
cd_espec_proc_w				especialidade_proc.cd_especialidade%type;
cd_grupo_proc_w				grupo_proc.cd_grupo_proc%type;

tx_valor_medico_w			funcao_medico_convenio.tx_valor_medico%type;
tx_valor_anestesista_w		funcao_medico_convenio.tx_valor_anestesista%type;
tx_valor_auxiliar_w			funcao_medico_convenio.tx_valor_auxiliar%type;
tx_co_w						funcao_medico_convenio.tx_custo_oper%type;


c00 CURSOR FOR
	SELECT 	ie_funcao,
			ie_valor_informado,
			nr_sequencia
	from 	orcamento_particip_proc
	where 	nr_seq_proc_orc = nr_seq_proc_orc_p
	order by nr_sequencia;


c01 CURSOR FOR
	SELECT	coalesce(tx_valor_medico,0),
		coalesce(tx_valor_anestesista,0),
		coalesce(tx_valor_auxiliar,0),
		coalesce(tx_custo_oper,0)
	from 	funcao_medico_convenio
	where	cd_funcao_medico				= ie_funcao_partic_w
	and 	coalesce(cd_convenio, cd_convenio_w)		= cd_convenio_w
	and 	coalesce(cd_categoria, coalesce(cd_categoria_w,'0'))	= coalesce(cd_categoria_w,'0')
	and 	coalesce(cd_area_proc, cd_area_proc_w)		= cd_area_proc_w
	and 	coalesce(cd_espec_proc, cd_espec_proc_w) 		= cd_espec_proc_w
	and 	coalesce(cd_procedimento, cd_procedimento_w) 	= cd_procedimento_w
	and 	((coalesce(cd_procedimento::text, '') = '') or (((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') and (coalesce(ie_origem_proced, ie_origem_proced_w) = ie_origem_proced_w ))))
	--and	nvl(nr_seq_grupo,nr_seq_grupo_w)		= nr_seq_grupo_w					--->>>> Não faz sentido ter Orçamento para o SUS
	--and	nvl(nr_seq_subgrupo,nr_seq_subgrupo_w)	= nr_seq_subgrupo_w				--->>>> Não faz sentido ter Orçamento para o SUS
	--and	nvl(nr_seq_forma_org,nr_seq_forma_org_w)	= nr_seq_forma_org_w				--->>>> Não faz sentido ter Orçamento para o SUS
    --and 	((nvl(ie_credenciado,'T') = 'T') or (nvl(ie_credenciado,'T') = ie_credenciado_w))	--->>>> Não temos o médico informado para saber se é Credenciado
	order by	coalesce(cd_categoria,'0'),
			cd_convenio desc,
			--nvl(nr_seq_forma_org,0) desc,
			--nvl(nr_seq_subgrupo,0) desc,
			--nvl(nr_seq_grupo,0) desc,
			cd_area_proc desc,
			cd_espec_proc desc,
			cd_grupo_proc desc,
			cd_procedimento desc;



BEGIN

begin
	select	a.cd_estabelecimento,
		a.cd_convenio,
		a.cd_categoria,
		b.ie_origem_proced,
		b.cd_procedimento
	into STRICT	cd_estabelecimento_w,
		cd_convenio_w,
		cd_categoria_w,
		ie_origem_proced_w,
		cd_procedimento_w
	from	orcamento_paciente a,
		orcamento_paciente_proc b
	where	a.nr_sequencia_orcamento = b.nr_sequencia_orcamento
	and	b.nr_sequencia = nr_seq_proc_orc_p;
exception
    when others then
		cd_estabelecimento_w	:= 0;
end;

select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estab_logado_w
;

select	coalesce(max(ie_estabelecimento_conta), 'A')
into STRICT	ie_estabelecimento_conta_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estab_logado_w;

if (ie_estabelecimento_conta_w = 'L') then
	cd_estabelecimento_w := cd_estab_logado_w;
end if;

select	coalesce(max(ie_partic_resp_cred), 'N')
into STRICT	ie_partic_resp_cred_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

if (ie_origem_proced_w not in (2,3,7)) 	then

	select	cd_area_procedimento,
			cd_especialidade,
			cd_grupo_proc
	into STRICT	cd_area_proc_w,
			cd_espec_proc_w,
			cd_grupo_proc_w
	from 	estrutura_procedimento_v
	where 	cd_procedimento = cd_procedimento_w
	and ie_origem_proced = ie_origem_proced_w;

	open c00;
	loop
		fetch c00 into
			ie_funcao_partic_w,
			ie_valor_informado_w,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on c00 */

		if (ie_valor_informado_w = 'N') 	then
			tx_valor_medico_w := 0;
			tx_valor_anestesista_w := 0;
			tx_valor_auxiliar_w  := 0;
			tx_co_w  := 0;
			open c01;
			loop
				fetch c01 into
					tx_valor_medico_w,
					tx_valor_anestesista_w,
					tx_valor_auxiliar_w,
					tx_co_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */

			end loop;
			close c01;



			if (tx_valor_medico_w > 0) then
				vl_participante_w := vl_medico_p * tx_valor_medico_w;
				pr_participante_w	:= tx_valor_medico_w;
			elsif	(tx_valor_auxiliar_w > 0 AND vl_auxiliar_p IS NOT NULL AND vl_auxiliar_p::text <> '') then
				vl_participante_w 	:= vl_auxiliar_p * tx_valor_auxiliar_w;
				pr_participante_w	:= tx_valor_auxiliar_w;
			else
				vl_participante_w := vl_anestesista_p * tx_valor_anestesista_w;
				pr_participante_w	:= tx_valor_anestesista_w;
			end if;

			if (tx_co_w > 0) then
				vl_participante_w := vl_participante_w + (vl_co_p * tx_co_w);
				if (pr_participante_w = 0) then
					pr_participante_w:= tx_co_w;
				end if;
			end if;

			update	orcamento_particip_proc
			set		vl_participante = vl_participante_w,
					pr_participante = pr_participante_w
			where	nr_sequencia = nr_sequencia_w;

			commit;

		end if;

	end loop;
	close c00;

end if;

begin
	select	sum(coalesce(vl_participante,0))
	into STRICT	vl_participante_w
	from	orcamento_particip_proc
	where	nr_seq_proc_orc = nr_seq_proc_orc_p;
exception
    when others then
		vl_participante_w	:= 0;
end;

vl_auxiliares_p := vl_participante_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_orc_valor_partic ( nr_seq_proc_orc_p bigint, vl_procedimento_p bigint, vl_medico_p bigint, vl_auxiliar_p bigint, vl_anestesista_p bigint, vl_co_p bigint, nm_usuario_p text, vl_auxiliares_p INOUT bigint ) FROM PUBLIC;

