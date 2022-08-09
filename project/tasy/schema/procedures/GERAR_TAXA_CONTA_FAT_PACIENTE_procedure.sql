-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_taxa_conta_fat_paciente (nr_interno_conta_p bigint) AS $body$
DECLARE


dt_entrada_w			atendimento_paciente.dt_entrada%type;
tx_ajuste_w			regra_taxa_conta.tx_ajuste%type;
cd_proc_taxa_w			regra_taxa_conta.cd_procedimento%type;
cd_area_procedimento_taxa_w	regra_taxa_procedimento.cd_area_procedimento%type;
cd_especialidade_taxa_w		regra_taxa_procedimento.cd_especialidade%type;
cd_grupo_proc_taxa_w		regra_taxa_procedimento.cd_grupo_proc%type;
cd_procedimento_taxa_w		regra_taxa_procedimento.cd_procedimento%type;

nr_Atendimento_w 		conta_paciente.nr_atendimento%type;
cd_area_w			especialidade_proc.cd_area_procedimento%type;
cd_especialidade_w		grupo_proc.cd_especialidade%type;
cd_grupo			procedimento.cd_grupo_proc%type;

vl_proc_per_w			procedimento_paciente.vl_procedimento%type;
vl_procedimento_w		procedimento_paciente.vl_procedimento%type;
nr_seq_proc_taxa_w		procedimento_paciente.nr_sequencia%type;
nr_seq_proc_w			procedimento_paciente.nr_sequencia%type;
cd_setor_atendimento_w		procedimento_paciente.cd_setor_atendimento%type;
dt_atualizacao_w		procedimento_paciente.dt_atualizacao%type := clock_timestamp();
dt_entrada_unidade_w		procedimento_paciente.dt_entrada_unidade%type;
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;
ie_origem_proc_w		procedimento_paciente.ie_origem_proced%type;
nm_usuario_w			procedimento_paciente.nm_usuario%type;
nr_seq_atepacu_w		procedimento_paciente.nr_seq_atepacu%type;
qt_procedimento_w		procedimento_paciente.qt_procedimento%type;
cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
cd_grupo_w			procedimento.cd_grupo_proc%type;

cd_material_w			material_atend_paciente.cd_material%type;
cd_grupo_mat_w			subgrupo_material.cd_grupo_material%type;
cd_subgrupo_w			classe_material.cd_subgrupo_material%type;
cd_classe_w			material.cd_classe_material%type;
vl_material_w			material_atend_paciente.vl_material%type;
dt_atendimento_w		material_atend_paciente.dt_atendimento%type;
qt_material_w			material_atend_paciente.qt_material%type;

vl_proc_per_adic_w		procedimento_paciente.vl_procedimento%type;
qt_conta_taxa_w			bigint;

C01 CURSOR FOR
	SELECT	a.cd_procedimento,
		(obter_dados_estrut_proc(a.cd_procedimento,a.ie_origem_proced,'C','A'))::numeric  cd_area,
		(obter_dados_estrut_proc(a.cd_procedimento,a.ie_origem_proced,'C','E'))::numeric  cd_especialidade,
		b.cd_grupo_proc cd_grupo,
		a.vl_procedimento,
		a.cd_setor_atendimento,
		a.dt_atualizacao,
		dt_procedimento,
		a.dt_entrada_unidade,
		a.ie_origem_proced,
		a.nm_usuario,
		a.nr_seq_atepacu,
		a.qt_procedimento
	from 	procedimento_paciente a,
		procedimento b
	where 	a.cd_procedimento = b.cd_procedimento
	and	ie_valor_informado = 'N'
	and	a.nr_interno_conta = nr_interno_conta_p
	group by a.cd_procedimento,
		(obter_dados_estrut_proc(a.cd_procedimento,a.ie_origem_proced,'C','A'))::numeric  ,
		(obter_dados_estrut_proc(a.cd_procedimento,a.ie_origem_proced,'C','E'))::numeric ,
		b.cd_grupo_proc,
		a.vl_procedimento,
		a.cd_setor_atendimento,
		a.dt_atualizacao,
		dt_procedimento,
		a.dt_entrada_unidade,
		a.ie_origem_proced,
		a.nm_usuario,
		a.nr_seq_atepacu,
		a.qt_procedimento;

C02 CURSOR FOR
	SELECT	a.cd_material,
		Obter_estrutura_material(a.cd_material,'G') cd_grupo,
		Obter_estrutura_material(a.cd_material,'S') cd_subgrupo,
		b.cd_classe_material,
		a.vl_material,
		a.cd_setor_atendimento,
		a.dt_atualizacao,
		dt_atendimento,
		a.dt_entrada_unidade,
		a.nm_usuario,
		a.nr_seq_atepacu,
		a.qt_material
	from	material_atend_paciente a,
		material b
	where 	a.cd_material = b.cd_material
	and	a.nr_interno_conta = nr_interno_conta_p;

c03 CURSOR FOR
	SELECT	nr_sequencia,
		ie_regra,
		ie_periodo,
		cd_procedimento,
		ie_origem_proced,
		tx_ajuste
	from	regra_taxa_conta
	where	dt_entrada_w between coalesce(dt_vigencia_inicial,(clock_timestamp() - interval '9999 days')) and fim_dia(coalesce(dt_vigencia_final,clock_timestamp()));

vet03		c03%rowtype;


BEGIN

select obter_usuario_ativo
 into STRICT nm_usuario_w
;

vl_proc_per_adic_w := 0;

select	max(nr_atendimento)
into STRICT	nr_Atendimento_w
from	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;

select	dt_entrada
into STRICT	dt_entrada_w
from	atendimento_paciente
where	nr_atendimento 		= nr_Atendimento_w;

select	count(*)
into STRICT	qt_conta_taxa_w
FROM regra_taxa_procedimento b
LEFT OUTER JOIN regra_taxa_conta a ON (b.nr_seq_regra_conta = a.nr_sequencia)
WHERE dt_entrada_w between coalesce(dt_vigencia_inicial,clock_timestamp()) and fim_dia(coalesce(dt_vigencia_final,clock_timestamp()));

if (coalesce(qt_conta_taxa_w,0) > 0) then
	open c03;
	loop
	fetch c03 into
		vet03;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		if (coalesce(vet03.ie_regra,'P') = 'C') then
			select	sum(a.vl_material)
			into STRICT	vl_material_w
			from	material_atend_paciente a,
				atendimento_paciente b
			where	a.nr_atendimento = b.nr_atendimento
			and	a.nr_interno_conta = nr_interno_conta_p
			and	((vet03.ie_periodo = 'U' and obter_se_dia_util(coalesce(a.dt_prescricao,a.dt_atendimento),b.cd_estabelecimento) = 'S')
				or (vet03.ie_periodo = 'D' and obter_se_dia_util(coalesce(a.dt_prescricao,a.dt_atendimento),b.cd_estabelecimento) = 'N')
				or (vet03.ie_periodo = 'S' and pkg_date_utils.IS_BUSINESS_DAY(coalesce(a.dt_prescricao,a.dt_atendimento)) = 0)
				or (vet03.ie_periodo = 'F' and obter_se_feriado(b.cd_estabelecimento,coalesce(a.dt_prescricao,a.dt_atendimento)) > 0));

			select	sum(a.vl_procedimento)
			into STRICT	vl_procedimento_w
			from	procedimento_paciente a,
				atendimento_paciente b
			where	a.nr_atendimento = b.nr_atendimento
			and	a.ie_valor_informado = 'N'
			and	a.nr_interno_conta = nr_interno_conta_p
			and	((vet03.ie_periodo = 'U' and obter_se_dia_util(a.dt_procedimento,b.cd_estabelecimento) = 'S')
				or (vet03.ie_periodo = 'D' and obter_se_dia_util(a.dt_procedimento,b.cd_estabelecimento) = 'N')
				or (vet03.ie_periodo = 'S' and pkg_date_utils.IS_BUSINESS_DAY(a.dt_procedimento) = 0)
				or (vet03.ie_periodo = 'F' and obter_se_feriado(b.cd_estabelecimento,a.dt_procedimento) > 0));

			vl_proc_per_adic_w := ((coalesce(vl_material_w,0) + coalesce(vl_procedimento_w,0)) * vet03.tx_ajuste) / 100;
			cd_proc_taxa_w := vet03.cd_procedimento;
			ie_origem_proc_w := vet03.ie_origem_proced;
			tx_ajuste_w := vet03.tx_ajuste;

			select	obter_setor_atendimento(nr_atendimento_w)
			into STRICT	cd_setor_atendimento_w
			;

			select	max(nr_seq_interno)
			into STRICT	nr_seq_atepacu_w
			from	atend_paciente_unidade
			where	nr_atendimento = nr_atendimento_w
			and	cd_setor_atendimento = cd_setor_atendimento_w;

			select	max(dt_entrada_unidade)
			into STRICT	dt_entrada_unidade_w
			from	atend_paciente_unidade
			where	nr_atendimento = nr_atendimento_w
			and	nr_seq_interno = nr_seq_atepacu_w;

		elsif (coalesce(vet03.ie_regra,'P') = 'P') then
			-- Procedimentos
			open C01;
			loop
			fetch C01 into
				cd_procedimento_w,
				cd_area_w,
				cd_especialidade_w,
				cd_grupo_w,
				vl_procedimento_w,
				cd_setor_atendimento_w,
				dt_atualizacao_w,
				dt_procedimento_w,
				dt_entrada_unidade_w,
				ie_origem_proc_w,
				nm_usuario_w,
				nr_seq_atepacu_w,
				qt_procedimento_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */

				begin

				select	max(a.tx_ajuste),
					max(a.cd_procedimento),
					max(a.ie_origem_proced)
				into STRICT	tx_ajuste_w,
					cd_proc_taxa_w,
					ie_origem_proc_w
				from	regra_taxa_conta a,
					regra_taxa_procedimento b
				where	b.nr_seq_regra_conta 				= a.nr_sequencia
				and	coalesce(b.cd_area_procedimento,cd_area_w) 		= cd_area_w
				and	coalesce(b.cd_especialidade,cd_especialidade_w) 	= cd_especialidade_w
				and	coalesce(b.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
				and	coalesce(b.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w
				and	dt_entrada_w between coalesce(a.dt_vigencia_inicial,(clock_timestamp() - interval '9999 days')) and fim_dia(coalesce(a.dt_vigencia_final,clock_timestamp()))
				and	a.ie_regra	<> 'C';

				if (coalesce(tx_ajuste_w,0) > 0) then

					vl_proc_per_w := dividir((vl_procedimento_w * tx_ajuste_w),100);
					vl_proc_per_adic_w := vl_proc_per_adic_w + vl_proc_per_w;


				end if;

				end;
			end loop;
			close C01;



			vl_proc_per_w		:= 0;
			vl_procedimento_w	:= 0;
			--Materiais
			open C02;
			loop
			fetch C02 into
				cd_material_w,
				cd_grupo_mat_w,
				cd_subgrupo_w,
				cd_classe_w,
				vl_material_w,
				cd_setor_atendimento_w,
				dt_atualizacao_w,
				dt_atendimento_w,
				dt_entrada_unidade_w,
				nm_usuario_w,
				nr_seq_atepacu_w,
				qt_material_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */

				begin

				select	max(a.tx_ajuste),
					max(a.cd_procedimento),
					max(a.ie_origem_proced)
				into STRICT	tx_ajuste_w,
					cd_proc_taxa_w,
					ie_origem_proc_w
				from	regra_taxa_conta a,
					regra_taxa_material b
				where	b.nr_seq_regra_conta 				= a.nr_sequencia
				and	coalesce(b.cd_grupo_material,coalesce(cd_grupo_w,0)) 	= coalesce(cd_grupo_w,0)
				and	coalesce(b.cd_subgrupo_material,coalesce(cd_subgrupo_w,0))= coalesce(cd_subgrupo_w,0)
				and	coalesce(b.cd_classe_material,coalesce(cd_classe_w,0))	= coalesce(cd_classe_w,0)
				and	coalesce(b.cd_material,coalesce(cd_material_w,0))		= coalesce(cd_material_w,0)
				and	dt_entrada_w between coalesce(a.dt_vigencia_inicial,(clock_timestamp() - interval '9999 days')) and fim_dia(coalesce(a.dt_vigencia_final,clock_timestamp()))
				and	a.ie_regra	<> 'C';

				if (coalesce(tx_ajuste_w,0) > 0) then
					vl_proc_per_w := dividir((vl_material_w * tx_ajuste_w),100);
					vl_proc_per_adic_w := vl_proc_per_adic_w + vl_proc_per_w;
				end if;

				end;

			end loop;

			close C02;
		end if;

		select	max(nr_sequencia)
		into STRICT	nr_seq_proc_taxa_w
		from	procedimento_paciente
		where	nr_interno_conta 	=  nr_interno_conta_p
		and	cd_procedimento 	=  cd_proc_taxa_w;

		if (coalesce(tx_ajuste_w,0) > 0) then

			if (coalesce(nr_seq_proc_taxa_w,0) = 0) then

				select	nextval('procedimento_paciente_seq')
				into STRICT	nr_seq_proc_w
				;

				insert into procedimento_paciente(cd_procedimento,
								cd_setor_atendimento,
								dt_atualizacao,
								dt_entrada_unidade,
								dt_procedimento,
								ie_origem_proced,
								nm_usuario,
								nr_atendimento,
								nr_seq_atepacu,
								nr_sequencia,
								qt_procedimento,
								vl_procedimento,
								nr_interno_conta,
								ie_valor_informado)
						values (	cd_proc_taxa_w,
								cd_setor_atendimento_w,
								dt_atualizacao_w,
								dt_entrada_unidade_w,
								coalesce(dt_atendimento_w,clock_timestamp()),
								ie_origem_proc_w,
								nm_usuario_w,
								nr_atendimento_w,
								nr_seq_atepacu_w,
								nr_seq_proc_w,
								1,
								vl_proc_per_adic_w,
								nr_interno_conta_p,
								'S');

			end if;
		end if;

		if (coalesce(nr_seq_proc_taxa_w,0) > 0) then
			update 	procedimento_paciente
			set	vl_procedimento = vl_proc_per_adic_w
			where	nr_sequencia 	= nr_seq_proc_taxa_w;
		end if;

		commit;
	end loop;
	close c03;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_taxa_conta_fat_paciente (nr_interno_conta_p bigint) FROM PUBLIC;
