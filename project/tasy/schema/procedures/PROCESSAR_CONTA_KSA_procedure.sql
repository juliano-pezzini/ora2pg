-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE processar_conta_ksa ( nr_interno_conta_p bigint, ie_separacao_conta_p text, nm_usuario_p text) AS $body$
DECLARE

 
/* Dados da conta */
 
cd_convenio_parametro_w		conta_paciente.cd_convenio_parametro%type;
cd_estabelecimento_w		conta_paciente.cd_estabelecimento%type;
pr_coseg_hosp_conta_w		conta_paciente.pr_coseguro_hosp%type;
pr_coseg_honor_conta_w		conta_paciente.pr_coseguro_honor%type;
vl_deduzido_conta_w			conta_paciente.vl_deduzido%type;
nr_atendimento_w			conta_paciente.nr_atendimento%type;
cd_categoria_parametro_w	conta_paciente.cd_categoria_parametro%type;

/* Dados da regra de calculo da conta */
 
qt_regras_w						bigint;
ie_gerar_valor_paciente_w		varchar(1) := 'N';
cd_proc_calculo_w				conv_regra_calculo_conta.cd_proc_calculo%type;
ie_orig_proc_calculo_w			conv_regra_calculo_conta.ie_orig_proc_calculo%type;
ie_tipo_calculo_w				conv_regra_calculo_conta.ie_tipo_calculo%type;
ds_calculo_w					conv_regra_calculo_conta.ds_calculo%type;
vl_desconto_deduzido_w			conv_regra_calculo_conta.vl_desconto_deduzido%type;
pr_imposto_w					conv_regra_calculo_conta.pr_imposto%type;
ie_considera_atend_agrupado_w	conv_regra_calculo_conta.ie_considera_atend_agrupado%type;

/* Dados do procedimento */
 
vl_procedimento_w			procedimento_paciente.vl_procedimento%type;
vl_real_procedimento_w		procedimento_paciente.vl_procedimento%type;

/* Dados Co-Participação */
 
pr_coparticipacao_w			double precision;
vl_procedimento_cobrado_w	procedimento_paciente.vl_procedimento%type;
vl_limite_w					apolice_classe.vl_limite%type;

/* valores base e impostos */
 
vl_honorario_conta_w		double precision;
vl_base_com_imposto_w		double precision;
vl_base_sem_imposto_w		double precision;

/* Dados primeiro atendimento paciente unidade */
 
cd_setor_atendimento_w		atend_paciente_unidade.cd_setor_atendimento%type;
dt_entrada_unidade_w		atend_paciente_unidade.dt_entrada_unidade%type;
nr_seq_atepacu_w			atend_paciente_unidade.nr_seq_interno%type;

/* Dados do parâmetro faturamento*/
 
cd_convenio_partic_w		parametro_faturamento.cd_convenio_partic%type;
cd_categoria_partic_w		parametro_faturamento.cd_categoria_partic %type;

/* Sequências para lançamentos dos itens */
 
nr_seq_propaci_w			procedimento_paciente.nr_sequencia%type;
nr_seq_propaci_ww			procedimento_paciente.nr_sequencia%type;
nr_seq_conta_log_proc_w		conta_log_processamento.nr_sequencia%type;

/* Número da conta em que o item foi lançado */
 
nr_interno_conta_dest_w		procedimento_paciente.nr_interno_conta%type;

/* Data de inicio da conta */
 
dt_procedimento_w			procedimento_paciente.dt_procedimento%type;

/* Número da conta se separação */
 
nr_interno_conta_sep_w		conta_paciente.nr_interno_conta%type;

/* Dados do Atendimento */
 
nr_atend_original_w			atendimento_paciente.nr_atend_original%type;
nr_atendimento_ww			atendimento_paciente.nr_atendimento%type;
nr_seq_classif_atend_w		atendimento_paciente.nr_seq_classificacao%type;
cd_tipo_acomodacao_w		atend_categoria_convenio.cd_tipo_acomodacao%type;
nr_seq_cobertura_w			atend_categoria_convenio.nr_seq_cobertura%type;

 
/* Dominio 7408 - Tipo de regra 'Cálculo Conta' 
	'D' - Deduzido (Franquia) 
	'H' - Coseguro Hospital 
	'N' - Coseguro Honorário 
*/
 
 
c01 CURSOR FOR 
SELECT	cd_proc_calculo, 
	ie_orig_proc_calculo, 
	ie_tipo_calculo, 
	ds_calculo, 
	vl_desconto_deduzido, 
	pr_imposto, 
	coalesce(ie_considera_atend_agrupado,'N') 
from	conv_regra_calculo_conta 
where	cd_convenio		= cd_convenio_parametro_w 
and	cd_estabelecimento	= cd_estabelecimento_w 
and	ie_situacao		= 'A' 
and	ie_tipo_calculo in ('D', 'H', 'N') 
and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_final_vigencia,clock_timestamp()) 
order by	dt_inicio_vigencia;

--- Buscar os atendimentos vinculados - EPISODE 
C02 CURSOR FOR 
SELECT	nr_atendimento 
from	atendimento_paciente 
where	nr_atend_original = nr_atend_original_w 

union
 
SELECT	nr_atendimento 
from	atendimento_paciente 
where	nr_atendimento = nr_atend_original_w;


BEGIN 
 
select	max(cd_convenio_parametro), 
	max(cd_estabelecimento), 
	max(coalesce(pr_coseguro_hosp,0)) / 100, 
	max(coalesce(pr_coseguro_honor,0)) / 100, 
	max(vl_deduzido), 
	max(nr_atendimento), 
	max(cd_categoria_parametro) 
into STRICT	cd_convenio_parametro_w, 
	cd_estabelecimento_w, 
	pr_coseg_hosp_conta_w, 
	pr_coseg_honor_conta_w, 
	vl_deduzido_conta_w, 
	nr_atendimento_w, 
	cd_categoria_parametro_w 
from	conta_paciente 
where	nr_interno_conta = nr_interno_conta_p;
 
--- Buscar o atendimento original conforme vinculado na EUP 
select	max(a.nr_atend_original), 
		max(a.nr_seq_classificacao), 
		max(b.cd_tipo_acomodacao), 
		max(b.nr_seq_cobertura) 
into STRICT	nr_atend_original_w, 
		nr_seq_classif_atend_w, 
		cd_tipo_acomodacao_w, 
		nr_seq_cobertura_w 
from	atendimento_paciente a, 
		atend_categoria_convenio b 
where	a.nr_atendimento = b.nr_atendimento 
and		a.nr_atendimento = nr_atendimento_w 
and		b.cd_convenio = cd_convenio_parametro_w 
and		b.cd_categoria = cd_categoria_parametro_w;
 
if (coalesce(nr_seq_cobertura_w::text, '') = '') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(758002); -- Favor verificar se a cobertura do convênio está informada corretamente na função Entrada Única de Paciente. 
end if;
 
select	sum(qt) 
into STRICT	qt_regras_w 
from (SELECT	1 qt 
	from	conv_regra_calculo_conta 
	where	cd_convenio		= cd_convenio_parametro_w 
	and	cd_estabelecimento	= cd_estabelecimento_w 
	and	ie_situacao		= 'A' 
	and	ie_tipo_calculo = 'D' 
	and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_final_vigencia,clock_timestamp()) 
	
union all
 
	SELECT	1 qt 
	from	conv_regra_calculo_conta 
	where	cd_convenio		= cd_convenio_parametro_w 
	and	cd_estabelecimento	= cd_estabelecimento_w 
	and	ie_situacao		= 'A' 
	and	ie_tipo_calculo = 'H' 
	and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_final_vigencia,clock_timestamp()) 
	
union all
 
	select	1 qt 
	from	conv_regra_calculo_conta 
	where	cd_convenio		= cd_convenio_parametro_w 
	and	cd_estabelecimento	= cd_estabelecimento_w 
	and	ie_situacao		= 'A' 
	and	ie_tipo_calculo = 'N' 
	and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_final_vigencia,clock_timestamp())) alias10;
 
if (coalesce(qt_regras_w,0) = 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(310776); -- Não existe regra disponível na aba Regra Cálculo Conta 
end if;
 
--if	(ie_considera_valor_bruto_w = 'S') then 
	-- O sistema deve ler o valor do médico do procedimento do tipo honorário, pois o valor do 
	-- procedimento não deve entrar na conta, dessa forma, através da regra de honorário e valores de 
	-- terceiros, o sistema deve estar parametrizado para (Entra na conta = 'N', Calcular valor = 'S') 
	select	coalesce(sum(coalesce(a.vl_medico,0)),0) 
	into STRICT	vl_honorario_conta_w 
	FROM procedimento b, procedimento_paciente a
LEFT OUTER JOIN regra_ajuste_proc c ON (a.nr_seq_ajuste_proc = c.nr_sequencia)
WHERE nr_interno_conta = nr_interno_conta_p and b.cd_procedimento = a.cd_procedimento and b.ie_origem_proced = a.ie_origem_proced and b.cd_tipo_procedimento = 135  -- 135 = Honorário Médico 
;
 
	select	coalesce(sum(coalesce(vl,0)),0) 
	into STRICT	vl_base_sem_imposto_w 
	from (SELECT	coalesce(a.vl_procedimento,0) vl, 
			coalesce(b.tx_ajuste,1) tx 
		FROM procedimento_paciente a
LEFT OUTER JOIN regra_ajuste_proc b ON (a.nr_seq_ajuste_proc = b.nr_sequencia)
WHERE a.nr_interno_conta = nr_interno_conta_p and not exists (	select	1 
				from	propaci_imposto x 
				where	x.nr_seq_propaci = a.nr_sequencia)  
union all
 
		SELECT	coalesce(a.vl_material,0) vl, 
			coalesce(b.tx_afaturar,1) tx 
		FROM material_atend_paciente a
LEFT OUTER JOIN regra_ajuste_material b ON (a.nr_seq_regra_ajuste_mat = b.nr_sequencia)
WHERE a.nr_interno_conta = nr_interno_conta_p and not exists (	select	1 
				from	matpaci_imposto x 
				where	x.nr_seq_matpaci = a.nr_sequencia)  ) alias9;
 
	select	coalesce(sum(coalesce(vl,0)),0) 
	into STRICT	vl_base_com_imposto_w 
	from (SELECT	coalesce(a.vl_procedimento,0) vl, 
			coalesce(b.tx_ajuste,1) tx 
		FROM procedimento_paciente a
LEFT OUTER JOIN regra_ajuste_proc b ON (a.nr_seq_ajuste_proc = b.nr_sequencia)
WHERE a.nr_interno_conta = nr_interno_conta_p and exists (	select	1 
				from	propaci_imposto y 
				where	y.nr_seq_propaci = a.nr_sequencia)  
union all
 
		SELECT	coalesce(a.vl_material,0) vl, 
			coalesce(b.tx_afaturar,1) tx 
		FROM material_atend_paciente a
LEFT OUTER JOIN regra_ajuste_material b ON (a.nr_seq_regra_ajuste_mat = b.nr_sequencia)
WHERE a.nr_interno_conta = nr_interno_conta_p and exists (	select	1 
				from	matpaci_imposto x 
				where	x.nr_seq_matpaci = a.nr_sequencia)  ) alias9;
 
select	obter_atepacu_paciente(nr_atendimento_w,'P') 
into STRICT	nr_seq_atepacu_w
;
 
select	max(cd_setor_atendimento), 
	max(dt_entrada_unidade) 
into STRICT	cd_setor_atendimento_w, 
	dt_entrada_unidade_w 
from	atend_paciente_unidade 
where	nr_seq_interno = nr_seq_atepacu_w;
 
select	max(cd_convenio_partic), 
	max(cd_categoria_partic) 
into STRICT	cd_convenio_partic_w, 
	cd_categoria_partic_w 
from	parametro_faturamento 
where	cd_estabelecimento = cd_estabelecimento_w;
 
dt_procedimento_w 		:= clock_timestamp();
nr_interno_conta_sep_w	:= null;
 
select 	coalesce(min(dt_periodo_inicial),dt_procedimento_w) 
into STRICT	dt_procedimento_w 
from 	conta_paciente 
where 	nr_interno_conta = nr_interno_conta_p;
 
nr_interno_conta_sep_w := nr_interno_conta_p;
 
-- Obter os valores da apolice conforme a classo do paciente 
select	max(coalesce(b.vl_limite,0)), 
		max(coalesce(b.pr_coparticipacao,0)) / 100 
into STRICT	vl_limite_w, 
		pr_coparticipacao_w 
from	apolice_classe b, 
		convenio_apolice c, 
		pessoa_titular_convenio d, 
		atendimento_paciente e 
where	c.nr_sequencia = b.nr_seq_apolice 
and		c.nr_apolice = d.nr_apolice 
and		c.cd_convenio = d.cd_convenio 
and		e.cd_pessoa_fisica = d.cd_pessoa_fisica 
and		d.cd_plano_convenio = b.cd_plano 
and		c.cd_convenio = cd_convenio_parametro_w 
and		e.nr_atendimento = nr_atendimento_w 
and		coalesce(b.cd_tipo_acomodacao, cd_tipo_acomodacao_w) = cd_tipo_acomodacao_w 
and		coalesce(b.nr_seq_cobertura, nr_seq_cobertura_w) = nr_seq_cobertura_w;
 
CALL processar_conta_pck.set_vl_honorario_conta(vl_honorario_conta_w);
CALL processar_conta_pck.set_vl_base_com_imposto(vl_base_com_imposto_w);
CALL processar_conta_pck.set_vl_base_sem_imposto(vl_base_sem_imposto_w);
CALL processar_conta_pck.set_vl_conta(vl_base_sem_imposto_w + vl_base_com_imposto_w);
CALL processar_conta_pck.set_pr_coseg_hosp_conta(pr_coparticipacao_w); ------ Coparticipação conforme a classe da apolice 
CALL processar_conta_pck.set_pr_coseg_honor_conta(pr_coseg_honor_conta_w);
CALL processar_conta_pck.set_vl_deduzido_conta(vl_deduzido_conta_w);
 
open c01;
loop 
	fetch	c01	into 
		cd_proc_calculo_w, 
		ie_orig_proc_calculo_w, 
		ie_tipo_calculo_w, 
		ds_calculo_w, 
		vl_desconto_deduzido_w, 
		pr_imposto_w, 
		ie_considera_atend_agrupado_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		vl_procedimento_cobrado_w := 0;
 
		/* GERAR OS VALORES QUE SERÃO COBRADOS */
 
		CALL processar_conta_pck.set_vl_imposto(vl_base_com_imposto_w * pr_imposto_w);
		CALL processar_conta_pck.set_vl_desconto_deduzido(vl_desconto_deduzido_w);
		CALL processar_conta_pck.set_pr_imposto(pr_imposto_w);
		CALL processar_conta_pck.set_ie_tipo_calculo(ie_tipo_calculo_w);
 
		CALL processar_conta_macro(ds_calculo_w, 'P');
 
		if (ie_considera_atend_agrupado_w = 'S') then 
			begin 
			--- Abrir o C01 para identificar os procedimentos que foram já lançados para os atendimentos vinculados ao EPISODE - Atendimento Original 
			open C02;
			loop 
			fetch C02 into 
				nr_atendimento_ww;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
				select coalesce(sum(a.vl_procedimento),0) 
				into STRICT	vl_procedimento_w 
				from  procedimento_paciente a, 
						conta_paciente b, 
						convenio c 
				where  a.nr_interno_conta = b.nr_interno_conta 
				and   b.cd_convenio_parametro = c.cd_convenio 
				and 	c.ie_tipo_convenio = 1 						--- somente particular 
				and 	b.nr_atendimento = nr_atendimento_ww		--- EPISODE 
				and   cd_procedimento = cd_proc_calculo_w;
 
				vl_procedimento_cobrado_w := vl_procedimento_cobrado_w + vl_procedimento_w;
 
				end;
			end loop;
			close C02;
 
			end;
		else 
			begin 
			select coalesce(sum(a.vl_procedimento),0) 
			into STRICT	vl_procedimento_w 
			from  procedimento_paciente a, 
					conta_paciente b, 
					convenio c 
			where  a.nr_interno_conta = b.nr_interno_conta 
			and   b.cd_convenio_parametro = c.cd_convenio 
			and		b.ie_cancelamento not in ('E','C')			-- Cancelada ou Estornada 
			and 	c.ie_tipo_convenio = 1 						--- somente particular 
			and 	b.nr_atendimento = nr_atendimento_w			--- VISIT 
			and   cd_procedimento = cd_proc_calculo_w;
 
			vl_procedimento_cobrado_w := vl_procedimento_w;
			end;
		end if;
 
		-- Verifica se os valores já cobrados do paciente ultrapassam o limite cadastrado para a classe da apolice 
		if	(vl_limite_w > (vl_procedimento_cobrado_w + processar_conta_pck.get_vl_procedimento)) then 
			begin 
			ie_gerar_valor_paciente_w := 'S';
			end;
		elsif (vl_limite_w < (vl_procedimento_cobrado_w + processar_conta_pck.get_vl_procedimento)) then 
			begin 
			vl_real_procedimento_w := vl_limite_w - vl_procedimento_cobrado_w;
 
			if (coalesce(vl_real_procedimento_w,0) > 0) then 
				CALL processar_conta_pck.set_vl_procedimento(vl_real_procedimento_w);
				ie_gerar_valor_paciente_w := 'S';
			end if;	
				 
			end;
		end if;
 
		if (ie_gerar_valor_paciente_w = 'S') then 
			begin 
 
			select	nextval('procedimento_paciente_seq') 
			into STRICT	nr_seq_propaci_w 
			;
 
			insert into procedimento_paciente(nr_sequencia, 
				cd_procedimento, 
				ie_origem_proced, 
				qt_procedimento, 
				ie_valor_informado, 
				vl_procedimento, 
				nr_seq_proc_princ, 
				dt_entrada_unidade, 
				cd_setor_atendimento, 
				nr_seq_atepacu, 
				nr_atendimento, 
				dt_procedimento, 
				dt_atualizacao, 
				nm_usuario, 
				cd_convenio, 
				vl_medico, 
				vl_anestesista, 
				vl_materiais, 
				vl_auxiliares, 
				vl_custo_operacional, 
				ie_auditoria, 
				cd_categoria, 
				nr_interno_conta) 
			values (nr_seq_propaci_w,					-- nr_sequencia 
				cd_proc_calculo_w,					-- cd_procedimento 
				ie_orig_proc_calculo_w,					-- ie_origem_proced 
				1,							-- qt_procedimento 
				'S',							-- ie_valor_informado 
				processar_conta_pck.get_vl_procedimento * -1,		-- vl_procedimento 
				null,							-- nr_seq_proc_princ 
				dt_entrada_unidade_w,					-- dt_entrada_unidade 
				cd_setor_atendimento_w,					-- cd_setor_atendimento 
				nr_seq_atepacu_w,					-- nr_seq_atepacu 
				nr_atendimento_w,					-- nr_atendimento 
				dt_procedimento_w,					-- dt_procedimento 
				clock_timestamp(),						-- dt_atualizacao 
				nm_usuario_p,						-- nm_usuario 
				cd_convenio_parametro_w,				-- cd_convenio 
				0,							-- vl_medico 
				0,							-- vl_anestesista 
				0,							-- vl_materiais 
				0,							-- vl_auxiliares 
				0,							-- vl_custo_operacional 
				'N',							-- ie_auditoria 
				cd_categoria_parametro_w,				-- cd_categoria 
				nr_interno_conta_sep_w					-- nr_interno_conta 
				);
 
			CALL atualiza_preco_procedimento(nr_seq_propaci_w,cd_convenio_parametro_w,nm_usuario_p);
 
			select	max(nr_interno_conta) 
			into STRICT	nr_interno_conta_dest_w 
			from	procedimento_paciente 
			where	nr_sequencia = nr_seq_propaci_w;
 
			select	nextval('conta_log_processamento_seq') 
			into STRICT	nr_seq_conta_log_proc_w 
			;
 
			insert into conta_log_processamento( 
				nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				nr_atendimento, 
				nr_seq_item, 
				nr_interno_conta, 
				nr_interno_conta_base) 
			values ( 
				nr_seq_conta_log_proc_w,				-- nr_sequencia 
				nm_usuario_p,						-- nm_usuario 
				clock_timestamp(),						-- dt_atualizacao 
				nm_usuario_p,						-- nm_usuario_nrec 
				clock_timestamp(),						-- dt_atualizacao_nrec 
				nr_atendimento_w,					-- nr_atendimento 
				nr_seq_propaci_w,					-- nr_seq_item 
				nr_interno_conta_dest_w,				-- nr_interno_conta 
				nr_interno_conta_p					-- nr_interno_conta_base 
				);
 
			select	nextval('procedimento_paciente_seq') 
			into STRICT	nr_seq_propaci_ww 
			;
 
			insert into procedimento_paciente(nr_sequencia, 
				cd_procedimento, 
				ie_origem_proced, 
				qt_procedimento, 
				ie_valor_informado, 
				vl_procedimento, 
				nr_seq_proc_princ, 
				dt_entrada_unidade, 
				cd_setor_atendimento, 
				nr_seq_atepacu, 
				nr_atendimento, 
				dt_procedimento, 
				dt_atualizacao, 
				nm_usuario, 
				cd_convenio, 
				vl_medico, 
				vl_anestesista, 
				vl_materiais, 
				vl_auxiliares, 
				vl_custo_operacional, 
				cd_categoria, 
				ie_auditoria 
				) 
			values (nr_seq_propaci_ww,					-- nr_sequencia 
				cd_proc_calculo_w,					-- cd_procedimento 
				ie_orig_proc_calculo_w,					-- ie_origem_proced 
				1,							-- qt_procedimento 
				'S',							-- ie_valor_informado 
				processar_conta_pck.get_vl_procedimento,		-- vl_procedimento 
				nr_seq_propaci_w,					-- nr_seq_proc_princ 
				dt_entrada_unidade_w,					-- dt_entrada_unidade 
				cd_setor_atendimento_w,					-- cd_setor_atendimento 
				nr_seq_atepacu_w,					-- nr_seq_atepacu 
				nr_atendimento_w,					-- nr_atendimento 
				dt_procedimento_w,					-- dt_procedimento 
				clock_timestamp(),						-- dt_atualizacao 
				nm_usuario_p,						-- nm_usuario 
				cd_convenio_partic_w,					-- cd_convenio 
				0,							-- vl_medico 
				0,							-- vl_anestesista 
				0,							-- vl_materiais 
				0,							-- vl_auxiliares 
				0,							-- vl_custo_operacional 
				cd_categoria_partic_w,					-- cd_categoria 
				'N'							-- ie_auditoria 
				);
 
			CALL atualiza_preco_procedimento(nr_seq_propaci_ww,cd_convenio_parametro_w,nm_usuario_p);
 
			select	max(nr_interno_conta) 
			into STRICT	nr_interno_conta_dest_w 
			from	procedimento_paciente 
			where	nr_sequencia = nr_seq_propaci_ww;
 
			select	nextval('conta_log_processamento_seq') 
			into STRICT	nr_seq_conta_log_proc_w 
			;
 
			insert into conta_log_processamento( 
				nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				nr_atendimento, 
				nr_seq_item, 
				nr_interno_conta, 
				nr_interno_conta_base) 
			values ( 
				nr_seq_conta_log_proc_w,				-- nr_sequencia 
				nm_usuario_p,						-- nm_usuario 
				clock_timestamp(),						-- dt_atualizacao 
				nm_usuario_p,						-- nm_usuario_nrec 
				clock_timestamp(),						-- dt_atualizacao_nrec 
				nr_atendimento_w,					-- nr_atendimento 
				nr_seq_propaci_ww,					-- nr_seq_item 
				nr_interno_conta_dest_w,				-- nr_interno_conta 
				nr_interno_conta_p					-- nr_interno_conta_base 
				);
			end;
		end if;
	end;
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_conta_ksa ( nr_interno_conta_p bigint, ie_separacao_conta_p text, nm_usuario_p text) FROM PUBLIC;
