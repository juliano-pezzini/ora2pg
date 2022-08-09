-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interf_item_susaih ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
cd_codigo_executor_w		varchar(10);
ie_doc_medico_prof_w		smallint;
nr_cpf_executor_w			varchar(11);
cd_cbo_executor_w		varchar(6);
ie_doc_prestador_w		smallint		:= 0;
ie_doc_executor_w			smallint;
ie_doc_executor_ww			smallint;
cd_cns_executor_w		varchar(15);
cd_cns_cpf_executor_w		varchar(15);
ie_funcao_w			smallint;
cd_cgc_prestador_w		varchar(14);
cd_cnes_w			varchar(7);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_procedimento_w			integer;
dt_competencia_w			timestamp;
dt_comp_interf_w			varchar(6);
nr_aih_w				bigint;
nr_seq_proc_w			bigint;
ds_registro_w			varchar(711);
cd_doc_executor_w		varchar(15);
qt_registro_w			bigint	:= 0;
nr_seq_reg_proc_w			smallint	:= 1;
cd_pessoa_fisica_w		varchar(10);
nr_seq_protocolo_w		bigint;
nr_linha_proc_w			bigint	:= 1;
cd_estabelecimento_w		smallint;
cd_cgc_estab_w			varchar(14);
cd_forma_organizacao_w		integer;
cd_cnes_prestador_w		varchar(20);
ie_ordem_w			integer;
nr_seq_proc_princ_w		bigint;
nr_seq_ordem_w			bigint;
nr_seq_ordem_princ_w		bigint;
cd_convenio_w			integer;
ie_tipo_servico_w			smallint;
ie_credenciamento_w		varchar(3);
qt_registros_w			integer		:= 0;
cd_grupo_w			smallint;
nr_seq_regra_w			bigint;
ie_exclui_medico_w			varchar(1)	:= 'N';
ie_exclui_cnes_w			varchar(1)	:= 'N';
qt_reg_w				bigint	:= 0;
qt_proc_interf_w			bigint	:= 0;
cd_cbo_exec_exp_w		varchar(6);
cd_exec_exp_w			varchar(10);
ie_ignora_participou_sus_w		varchar(1)	:= 'N';
ie_exporta_cnes_w			varchar(1)	:= 'N';
ie_exporta_cnes_hosp_w		varchar(1);
ie_exclui_procedimento_w		varchar(1)	:= 'N';
cd_cgc_prestador_exp_w		varchar(14);
ie_exporta_cnes_setor_w		varchar(1)	:= 'N';
cd_setor_atendimento_w		integer;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
cd_procedimento_real_w		bigint;
dt_alta_w				timestamp;
ie_forma_envio_data_proc_w		varchar(15)	:= 'P';
dt_mesano_referencia_w			timestamp;
qt_reg_cnes_proc_w		integer		:= 0;
cd_cnes_regra_proc_w		varchar(20);
cd_motivo_cobranca_w		smallint;
ie_identificacao_aih_w		varchar(2);
cd_servico_w			varchar(3);
cd_servico_classif_w		varchar(3);
ie_exp_cnpj_fornec_fabric_w	varchar(1)	:= coalesce(sus_obter_parametro_aih('IE_EXP_CNPJ_FORNEC_FABRIC', obter_estab_conta_paciente(nr_interno_conta_p)),'N');
cd_cgc_fabricante_w		varchar(14);
qt_reg_prof_vinc_w		bigint := 0;
ie_considerar_cns_ant_w		parametro_faturamento.ie_considerar_cns_ant%type;
nr_cartao_nac_sus_ant_w		cnes_profissional.nr_cartao_nac_sus_ant%type;
ie_manter_doc_executor_w	sus_parametros_aih.ie_manter_doc_executor%type;
ie_regra_agrup_proc_w		varchar(15) := 'N';
ie_exp_cnes_exc_med_w		varchar(15) := 'N';
nr_seq_partic_w             procedimento_participante.nr_seq_partic%type;
dt_procedimento_w 			procedimento_paciente.dt_procedimento%type;

/* Obter os procedimentos Secudarios/Especiais no maximo 10*/

c01 CURSOR FOR
SELECT	a.nr_sequencia nr_seq_proc,
	coalesce(a.cd_medico_executor, a.cd_pessoa_fisica) cd_codigo_executor,
	coalesce(substr(obter_dados_pf(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),'CPF'),1,11),0) nr_cpf_executor,
	coalesce(substr(obter_dados_pf(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),'CNS'),1,15),0) cd_cns_executor,
	1 ie_funcao_equipe,
	coalesce(a.cd_cgc_prestador,0) cd_cgc_prestador,
	coalesce(a.cd_procedimento,0) cd_procedimento,
	coalesce(a.ie_origem_proced, 7) ie_origem_proced,
	coalesce(a.qt_procedimento,1) qt_procedimento,
	coalesce(a.dt_procedimento,clock_timestamp()) dt_competencia,
	coalesce(a.cd_cbo, coalesce(sus_obter_cbo_medico(coalesce(a.cd_medico_executor,a.cd_pessoa_fisica), a.cd_procedimento, a.dt_procedimento,0 ),'0')) cd_cbo_executor,
	coalesce(a.ie_doc_executor, 5) ie_doc_executor,
	a.nr_seq_proc_princ nr_seq_proc_princ,
	sus_obter_seq_ordem(a.nr_sequencia) nr_seq_ordem,
	sus_obter_seq_ordem_princ(a.nr_sequencia) nr_seq_ordem_princ,
	sus_ordenar_proc_aih(a.nr_sequencia) ie_ordem,
	a.cd_setor_atendimento cd_setor_atendimento,
	coalesce(sus_obter_dados_servico(a.nr_seq_servico,'C'),'0') cd_servico,
	coalesce(sus_obter_desc_classif(a.nr_seq_servico_classif,null,'C'),0) cd_servico_classif,
	null nr_seq_partic,
	a.dt_procedimento dt_procedimento
from	procedimento_paciente a
where	a.qt_procedimento	> 0
and	a.cd_procedimento <> 415020050
and	not exists (	select 1
			from sus_regra_proc x
			where	x.nr_seq_regra in (7,11,13)
			and	x.cd_procedimento = a.cd_procedimento
			and	x.ie_origem_proced = a.ie_origem_proced)
and	a.ie_origem_proced	= 7
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''			
and	a.nr_interno_conta	= nr_interno_conta_p

union

select	a.nr_sequencia,
	b.cd_pessoa_fisica,
	coalesce(substr(obter_dados_pf(b.cd_pessoa_fisica,'CPF'),1,11),0) nr_cpf_executor,
	coalesce(substr(obter_dados_pf(b.cd_pessoa_fisica,'CNS'),1,15),0) cd_cns_executor,
	coalesce(sus_obter_indicador_equipe(b.ie_funcao),0) ie_funcao_equipe,
	coalesce(coalesce(b.cd_cgc,a.cd_cgc_prestador),0),
	coalesce(a.cd_procedimento,0) cd_procedimento,
	coalesce(a.ie_origem_proced, 7) ie_origem_proced,
	coalesce(a.qt_procedimento,1),
	coalesce(a.dt_procedimento,clock_timestamp()),
	coalesce(b.cd_cbo, coalesce(sus_obter_cbo_medico(b.cd_pessoa_fisica, a.cd_procedimento, a.dt_procedimento,coalesce(sus_obter_indicador_equipe(b.ie_funcao),0)),'0')),
	coalesce(b.ie_doc_executor,coalesce(a.ie_doc_executor, 5)),
	a.nr_seq_proc_princ,
	sus_obter_seq_ordem(a.nr_sequencia) nr_seq_ordem,
	sus_obter_seq_ordem_princ(a.nr_sequencia) nr_seq_ordem_princ,
	sus_ordenar_proc_aih(a.nr_sequencia) ie_ordem,
	a.cd_setor_atendimento,
	coalesce(sus_obter_dados_servico(a.nr_seq_servico,'C'),'0'),
	coalesce(sus_obter_desc_classif(a.nr_seq_servico_classif,null,'C'),0),
    b.nr_seq_partic,
	a.dt_procedimento dt_procedimento
from	procedimento_participante	b,
	procedimento_paciente		a
where	a.qt_procedimento	> 0
and	(((coalesce(b.ie_participou_sus,'S')	= 'S') and (ie_ignora_participou_sus_w = 'N')) or (ie_ignora_participou_sus_w = 'S'))
and	a.cd_procedimento <> 415020050
and	not exists (	select 1 
			from sus_regra_proc x
			where	x.nr_seq_regra in (4,7,11,13)
			and	x.cd_procedimento = a.cd_procedimento
			and	x.ie_origem_proced = a.ie_origem_proced)
and	a.nr_sequencia		= b.nr_sequencia
and	a.ie_origem_proced	= 7
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''			
and	a.nr_interno_conta	= nr_interno_conta_p

union

select	min(a.nr_sequencia),
	max(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica)),
	max(coalesce(substr(obter_dados_pf(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),'CPF'),1,11),0)) nr_cpf_executor,
	max(coalesce(substr(obter_dados_pf(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),'CNS'),1,15),0)) cd_cns_executor,
	1 ie_funcao_equipe ,
	max(coalesce(a.cd_cgc_prestador,0)),
	coalesce(a.cd_procedimento,0) cd_procedimento,
	coalesce(a.ie_origem_proced, 7) ie_origem_proced,
	sum(coalesce(a.qt_procedimento,1)),
	trunc(coalesce(a.dt_procedimento,clock_timestamp()),'Month'),
	max(coalesce(a.cd_cbo, coalesce(sus_obter_cbo_medico(coalesce(a.cd_medico_executor,a.cd_pessoa_fisica), a.cd_procedimento, a.dt_procedimento,0 ),'0'))),
	max(coalesce(a.ie_doc_executor, 5)),
	min(a.nr_seq_proc_princ),
	min(sus_obter_seq_ordem(a.nr_sequencia)) nr_seq_ordem,
	min(sus_obter_seq_ordem_princ(a.nr_sequencia)) nr_seq_ordem_princ,
	min(sus_ordenar_proc_aih(a.nr_sequencia)) ie_ordem,
	max(a.cd_setor_atendimento),
	max(coalesce(sus_obter_dados_servico(a.nr_seq_servico,'C'),'0')),
	max(coalesce(sus_obter_desc_classif(a.nr_seq_servico_classif,null,'C'),0)),
    null nr_seq_partic,
	min(a.dt_procedimento) dt_procedimento
from	procedimento_paciente a
where	a.qt_procedimento	> 0
and	a.cd_procedimento <> 415020050
and	exists (	select 1 
			from sus_regra_proc x
			where	x.nr_seq_regra in (7,13)
			and	x.cd_procedimento = a.cd_procedimento
			and	x.ie_origem_proced = a.ie_origem_proced)
and	a.ie_origem_proced	= 7
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''			
and	a.nr_interno_conta	= nr_interno_conta_p
group by a.ie_origem_proced,
	trunc(coalesce(dt_procedimento,clock_timestamp()),'Month'),
	a.cd_procedimento

union

select	a.nr_sequencia,
	coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),
	coalesce(substr(obter_dados_pf(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),'CPF'),1,11),0) nr_cpf_executor,
	coalesce(substr(obter_dados_pf(coalesce(a.cd_medico_executor, a.cd_pessoa_fisica),'CNS'),1,15),0) cd_cns_executor,
	1 ie_funcao_equipe,
	coalesce(a.cd_cgc_prestador,0),
	coalesce(a.cd_procedimento,0) cd_procedimento,
	coalesce(a.ie_origem_proced, 7) ie_origem_proced,
	coalesce(a.qt_procedimento,1),
	coalesce(a.dt_procedimento,clock_timestamp()),
	coalesce(a.cd_cbo, coalesce(sus_obter_cbo_medico(coalesce(a.cd_medico_executor,a.cd_pessoa_fisica), a.cd_procedimento, a.dt_procedimento,0 ),'0')),
	coalesce(a.ie_doc_executor, 5),
	a.nr_seq_proc_princ,
	sus_obter_seq_ordem(a.nr_sequencia) nr_seq_ordem,
	sus_obter_seq_ordem_princ(a.nr_sequencia) nr_seq_ordem_princ,
	sus_ordenar_proc_aih(a.nr_sequencia) ie_ordem,
	a.cd_setor_atendimento,
	coalesce(sus_obter_dados_servico(a.nr_seq_servico,'C'),'0'),
	coalesce(sus_obter_desc_classif(a.nr_seq_servico_classif,null,'C'),0),
    null nr_seq_partic,
	a.dt_procedimento dt_procedimento
from	procedimento_paciente a
where	a.qt_procedimento	= 0
and	Sus_Obter_Se_Detalhe_Proc(a.cd_procedimento, a.ie_origem_proced,'007', a.dt_procedimento) > 0
and	trunc(dt_final_w) = trunc(dt_final_w,'month')
and	cd_motivo_cobranca_w not in (21,22,23,24,25,26,27,28,31,32,41,42,43,65,66,67)
and	ie_identificacao_aih_w = '05'
and	a.cd_procedimento <> 415020050
and	not exists (	select 1 
			from sus_regra_proc x
			where	x.nr_seq_regra in (7,11,13)
			and	x.cd_procedimento = a.cd_procedimento
			and	x.ie_origem_proced = a.ie_origem_proced)
and	a.ie_origem_proced	= 7
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''			
and	a.nr_interno_conta	= nr_interno_conta_p
order by ie_ordem, nr_seq_ordem, nr_seq_ordem_princ, cd_procedimento desc, ie_funcao_equipe;

type 		fetch_array is table of c01%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c01_w			vetor;

BEGIN

begin
select	a.nr_aih,
	b.cd_pessoa_fisica,
	b.cd_estabelecimento,
	c.cd_convenio_parametro,
	a.dt_inicial,
	a.dt_final,
	a.CD_PROCEDIMENTO_REAL,
	b.dt_alta,
	c.dt_mesano_referencia,
	a.cd_motivo_cobranca,
	a.ie_identificacao_aih
into STRICT	nr_aih_w,
	cd_pessoa_fisica_w,
	cd_estabelecimento_w,
	cd_convenio_w,
	dt_inicial_w,
	dt_final_w,
	cd_procedimento_real_w,
	dt_alta_w,
	dt_mesano_referencia_w,
	cd_motivo_cobranca_w,
	ie_identificacao_aih_w
from	conta_paciente		c,
	atendimento_paciente	b,
	sus_aih_unif		a
where	a.nr_interno_conta	= nr_interno_conta_p
and	a.nr_atendimento	= b.nr_atendimento
and	a.nr_interno_conta	= c.nr_interno_conta;
exception when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(195846,'NR_INTERNO_CONTA='||nr_interno_conta_p);
	/*Existe mais de uma AIH cadastrada para a conta n ' || nr_interno_conta_p*/

end;

ie_ignora_participou_sus_w	:= coalesce(sus_obter_parametro_aih('IE_IGNORA_PARTICIPOU_SUS', cd_estabelecimento_w),'N');

select	coalesce(max(cd_cgc),'0')
into STRICT	cd_cgc_estab_w
from 	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_w;

/* Buscar o CNES do prestador */

if	((coalesce(sus_parametros_aih_pck.get_cd_estabelecimento,0) <> cd_estabelecimento_w) or (coalesce(sus_parametros_aih_pck.get_dt_atualizacao,clock_timestamp()) > coalesce(sus_parametros_aih_pck.get_dt_geracao,clock_timestamp()))) then
	begin
	CALL gerar_sus_parametros_aih_pck(cd_estabelecimento_w);
	
	cd_cnes_w			:= lpad(sus_parametros_aih_pck.get_cd_cnes_hospital,7,'0');
	ie_exporta_cnes_w		:= sus_parametros_aih_pck.get_ie_exporta_cnes;
	ie_exporta_cnes_hosp_w		:= sus_parametros_aih_pck.get_ie_exporta_cnes_hosp;
	ie_exporta_cnes_setor_w		:= sus_parametros_aih_pck.get_ie_exporta_cnes_setor;
	ie_forma_envio_data_proc_w	:= sus_parametros_aih_pck.get_ie_forma_envio_data_proc;
	ie_manter_doc_executor_w	:= sus_parametros_aih_pck.get_ie_manter_doc_executor;
	ie_exp_cnes_exc_med_w		:= sus_parametros_aih_pck.get_ie_exp_cnes_exc_med;	
	end;
else	
	begin
	cd_cnes_w			:= lpad(sus_parametros_aih_pck.get_cd_cnes_hospital,7,'0');
	ie_exporta_cnes_w		:= sus_parametros_aih_pck.get_ie_exporta_cnes;
	ie_exporta_cnes_hosp_w		:= sus_parametros_aih_pck.get_ie_exporta_cnes_hosp;
	ie_exporta_cnes_setor_w		:= sus_parametros_aih_pck.get_ie_exporta_cnes_setor;
	ie_forma_envio_data_proc_w	:= sus_parametros_aih_pck.get_ie_forma_envio_data_proc;
	ie_manter_doc_executor_w	:= sus_parametros_aih_pck.get_ie_manter_doc_executor;
	ie_exp_cnes_exc_med_w		:= sus_parametros_aih_pck.get_ie_exp_cnes_exc_med;
	end;
end if;

select	coalesce(max(nr_seq_protocolo),0)
into STRICT	nr_seq_protocolo_w
from	conta_paciente
where	nr_interno_conta	= nr_interno_conta_p;

open c01;
loop
fetch c01 bulk collect into s_array limit 1000;
	vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

for i in 1..vetor_c01_w.count loop
	begin
	s_array := vetor_c01_w(i);
	for z in 1..s_array.count loop
		begin
		
		nr_seq_proc_w		:= s_array[z].nr_seq_proc;
		cd_codigo_executor_w	:= s_array[z].cd_codigo_executor;
		nr_cpf_executor_w	:= s_array[z].nr_cpf_executor;
		cd_cns_executor_w	:= s_array[z].cd_cns_executor;
		ie_funcao_w		:= s_array[z].ie_funcao_equipe;
		cd_cgc_prestador_w	:= s_array[z].cd_cgc_prestador;
		cd_procedimento_w	:= s_array[z].cd_procedimento;
		ie_origem_proced_w	:= s_array[z].ie_origem_proced;
		qt_procedimento_w	:= s_array[z].qt_procedimento;
		dt_competencia_w	:= s_array[z].dt_competencia;
		cd_cbo_executor_w	:= s_array[z].cd_cbo_executor;
		ie_doc_executor_w	:= s_array[z].ie_doc_executor;
		nr_seq_proc_princ_w	:= s_array[z].nr_seq_proc_princ;
		nr_seq_ordem_w		:= s_array[z].nr_seq_ordem;
		nr_seq_ordem_princ_w	:= s_array[z].nr_seq_ordem_princ;
		ie_ordem_w		:= s_array[z].ie_ordem;
		cd_setor_atendimento_w	:= s_array[z].cd_setor_atendimento;
		cd_servico_w		:= s_array[z].cd_servico;
		cd_servico_classif_w	:= s_array[z].cd_servico_classif;
        nr_seq_partic_w     := s_array[z].nr_seq_partic;
		dt_procedimento_w   := s_array[z].dt_procedimento;
		if (length(qt_procedimento_w) > 3) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(195847,'CD_PROCED='|| cd_procedimento_w ||
									'QT_PROCED='|| qt_procedimento_w ||
									'NR_INTERNO_CONTA='|| nr_interno_conta_p);
			/*Problema na leitura da quatidade do procedimento ' || cd_procedimento_w || '(' || qt_procedimento_w ||'). Conta: ' || nr_interno_conta_p*/

		end if;

		/* Flag de controle da quantidade de procedimento */

		qt_registro_w	:= qt_registro_w + 1;
		
		SELECT * FROM sus_obter_exec_exp_aih(cd_procedimento_w, ie_origem_proced_w, cd_codigo_executor_w, cd_cbo_executor_w, cd_estabelecimento_w, 'S', 'N', 'N', cd_exec_exp_w, cd_cbo_exec_exp_w) INTO STRICT cd_exec_exp_w, cd_cbo_exec_exp_w;
		cd_cgc_prestador_exp_w := sus_obter_prest_exp(cd_procedimento_w, ie_origem_proced_w, cd_cgc_prestador_w, cd_estabelecimento_w, 'S', 'N', 'N', cd_cgc_prestador_exp_w);
		if (cd_cbo_exec_exp_w IS NOT NULL AND cd_cbo_exec_exp_w::text <> '') and (cd_exec_exp_w IS NOT NULL AND cd_exec_exp_w::text <> '') then
			begin
			cd_codigo_executor_w	:= cd_exec_exp_w;
			cd_cbo_executor_w	:= cd_cbo_exec_exp_w;			
			
			nr_cpf_executor_w := coalesce(substr(obter_dados_pf(cd_codigo_executor_w,'CPF'),1,11),0);
			cd_cns_executor_w := coalesce(substr(obter_dados_pf(cd_codigo_executor_w,'CNS'),1,15),0);
			
			ie_doc_executor_ww := null;
			
			ie_doc_executor_ww := sus_obter_doc_exec_cnes( cd_estabelecimento_w, cd_cbo_executor_w, cd_codigo_executor_w, dt_competencia_w, ie_doc_executor_ww);
			
			if (coalesce(ie_doc_executor_ww,ie_doc_executor_w) <> ie_doc_executor_w) then
				ie_doc_executor_w := ie_doc_executor_ww;
			end if;		
			end;
		end if;

		if (cd_cgc_prestador_exp_w IS NOT NULL AND cd_cgc_prestador_exp_w::text <> '') then
			cd_cgc_prestador_w	:= cd_cgc_prestador_exp_w;
		end if;
		
		if (sus_validar_regra(4, cd_procedimento_w, ie_origem_proced_w,dt_procedimento_w) > 0) then
			if (ie_exp_cnpj_fornec_fabric_w = 'S') then
				
				select	max(cd_cgc_fabricante)
				into STRICT	cd_cgc_fabricante_w
				from	sus_aih_opm
				where	nr_seq_procedimento = nr_seq_proc_w;
				
				cd_cgc_prestador_w := cd_cgc_fabricante_w;
				
			end if;
		end if;
		
		if (sus_obter_se_detalhe_proc(cd_procedimento_w, ie_origem_proced_w, '10008', dt_competencia_w) = 0) then
			ie_funcao_w		:= 0;
		end if;

		begin
		select	coalesce(cd_grupo,0),
			coalesce(cd_forma_organizacao,0)
		into STRICT	cd_grupo_w,
			cd_forma_organizacao_w
		from	sus_estrutura_procedimento_v
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w;
		exception
			when others then
			cd_grupo_w		:= 0;
			cd_forma_organizacao_w	:= 0;
		end;

		select	substr(coalesce(max(cd_cnes),''),1,7)
		into STRICT	cd_cnes_prestador_w
		from	pessoa_juridica
		where	cd_cgc	= cd_cgc_prestador_w;

		if (ie_exporta_cnes_setor_w = 'S') then
			begin

			begin
			select	substr(coalesce(max(cd_cnes),cd_cnes_prestador_w),1,7)
			into STRICT	cd_cnes_prestador_w
			from	setor_atendimento
			where	cd_setor_atendimento	= cd_setor_atendimento_w;
			exception
				when others then
				cd_cnes_prestador_w := cd_cnes_prestador_w;
				end;

			end;
		end if;

		if (cd_forma_organizacao_w	= 041701) then
			ie_funcao_w		:= 0;
		end if;

		if (cd_cbo_executor_w	= '0') then
			cd_cbo_executor_w	:= '      ';
		end if;
		
		begin
		select  count(1)
		into STRICT 	qt_reg_prof_vinc_w
		from    cnes_profissional y,
			cnes_identificacao x,
			cnes_profissional_vinculo z
		where   y.nr_seq_identificacao  = x.nr_sequencia
		and     x.CD_CNES               = cd_cnes_w
		and     y.cd_pessoa_fisica      = cd_codigo_executor_w
		and     z.nr_seq_profissional   = y.nr_sequencia
		and     cd_cbo 			= coalesce(cd_cbo_executor_w,'X')
		and     ((coalesce(z.dt_vigencia_inicial::text, '') = '') or (trunc(z.dt_vigencia_inicial,'month') <= trunc(dt_competencia_w)))
		and     ((coalesce(z.dt_vigencia_final::text, '') = '') or (trunc(z.dt_vigencia_final,'month') >= trunc(dt_competencia_w)))
		and     z.ie_atendimento_sus 	= 'S'  LIMIT 1;	
		exception
		when others then
			qt_reg_prof_vinc_w := 0;
		end;
		

		/* Quando o prestador for o proprio hospital e o procedimento NaO for OPM, entao deve ser exportado o CNES do hospital*/

		if (cd_cgc_prestador_w	= cd_cgc_estab_w) and (cd_grupo_w		<> 7) then
			ie_doc_prestador_w	:= 5; /* CNES */
			cd_cgc_prestador_w	:= lpad(cd_cnes_w,14,' ');
		else
			/* Sempre que o procedimento for OPM deve ser exportado o CNPJ */

			ie_doc_prestador_w	:= 3; /* CNPJ */
			if (cd_grupo_w		<> 7) and (cd_cnes_prestador_w IS NOT NULL AND cd_cnes_prestador_w::text <> '') then
				ie_doc_prestador_w	:= 5; /* CNES */
				cd_cgc_prestador_w	:= lpad(cd_cnes_prestador_w,14,' ');
			end if;
		end if;

		if (ie_forma_envio_data_proc_w = 'A') then
			dt_competencia_w := dt_alta_w;
		elsif (ie_forma_envio_data_proc_w = 'F') then
			dt_competencia_w := dt_final_w;
		end if;
		
		/* Obter a regra de alteracao no disquete para excluir ou nao o Medico ou CNES */
		
		SELECT * FROM sus_obter_regra_expaih(nr_seq_proc_w, nm_usuario_p, nr_seq_regra_w, ie_exclui_medico_w, ie_exclui_cnes_w, ie_exclui_procedimento_w, nr_seq_partic_w) INTO STRICT nr_seq_regra_w, ie_exclui_medico_w, ie_exclui_cnes_w, ie_exclui_procedimento_w;
		
		begin
		select	coalesce(ie_considerar_cns_ant, 'N')
		into STRICT	ie_considerar_cns_ant_w
		from	parametro_faturamento
		where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
		exception
			when others then
			ie_considerar_cns_ant_w :='N';
		end;
		
		if (ie_considerar_cns_ant_w = 'S') then
			begin
				select	coalesce(b.nr_cartao_nac_sus_ant, ' ')
				into STRICT	nr_cartao_nac_sus_ant_w
				from 	cnes_profissional 	b
				where	b.cd_pessoa_fisica = cd_codigo_executor_w  LIMIT 1;
				exception
			when others then
				nr_cartao_nac_sus_ant_w := ' ';
			end;
			if (nr_cartao_nac_sus_ant_w <> ' ') then
				cd_cns_executor_w 		:= nr_cartao_nac_sus_ant_w;
				cd_cns_cpf_executor_w	:= nr_cartao_nac_sus_ant_w;
			end if;
		end if;
		
		if (ie_doc_executor_w	= 1) then /* CNS/CPF */
			begin
			if (trunc(dt_competencia_w,'month') < to_date('01/01/2012','dd/mm/yyyy')) then
				cd_doc_executor_w	:= nr_cpf_executor_w;
			elsif (trunc(dt_competencia_w,'month') >= to_date('01/01/2012','dd/mm/yyyy')) then
				cd_doc_executor_w	:= cd_cns_executor_w;
			end if;
			if (ie_manter_doc_executor_w = 'N') then	
				if (qt_reg_prof_vinc_w > 0) then
					begin
					ie_doc_executor_w  := 5;
					cd_doc_executor_w  := cd_cnes_w;
					if (ie_exclui_medico_w = 'N') then
						cd_cgc_prestador_w	:= '0';
					end if;
					end;
				end if;
			end if;
			end;
		elsif (ie_doc_executor_w	= 3) then /* CNPJ */
			cd_doc_executor_w	:= cd_cgc_prestador_w;
		elsif (ie_doc_executor_w	= 5) then /* CNES */
			cd_doc_executor_w	:= cd_cnes_w;
		elsif (ie_doc_executor_w	= 6) then /* CNES Terc.*/
			if (cd_cnes_prestador_w IS NOT NULL AND cd_cnes_prestador_w::text <> '') then
				ie_doc_prestador_w	:= 5; /* CNES */
				cd_cgc_prestador_w	:= lpad(cd_cnes_prestador_w,14,' ');
			end if;
			ie_doc_executor_w	:= 5;
			cd_doc_executor_w	:= cd_cnes_prestador_w;

			if (ie_exporta_cnes_hosp_w	= 'S')	and (ie_exporta_cnes_setor_w = 'N')	then
				cd_doc_executor_w	:= cd_cnes_w;
			end if;
		end if;

		/*Geliard - Tratamento seguinte foi adicionado para atender a portaria sas/ms n 203 de 04 de maio de 2011 - OS 322199*/

		if (dt_mesano_referencia_w < to_date('01/01/2012','dd/mm/yyyy')) then
			begin
			if (dt_competencia_w	< to_date('01/05/2011','dd/mm/yyyy')) then
				begin
				if (cd_procedimento_real_w = cd_procedimento_w) and (dt_inicial_w	>= to_date('01/05/2011','dd/mm/yyyy')) then
					dt_comp_interf_w	:= to_char(dt_inicial_w,'yyyymm');
				else
					dt_comp_interf_w	:= '      ';
				end if;
				end;
			else
				begin
				if (coalesce(dt_final_w,dt_alta_w) < to_date('01/05/2011','dd/mm/yyyy')) then
					dt_comp_interf_w	:= '      ';
				else
					dt_comp_interf_w	:= to_char(dt_competencia_w, 'yyyymm');
				end if;
				end;
			end if;
			end;
		else
			dt_comp_interf_w	:= to_char(dt_competencia_w, 'yyyymm');
		end if;	
		
		/*Geliard - Tratamento seguinte foi adicionado para atender a portaria n 763 de 20 de Julho de 2011 - OS 401210*/

		if (cd_cns_executor_w = '0') and (nr_cpf_executor_w = '0') then
			ie_doc_medico_prof_w	:= 0;
			cd_cns_cpf_executor_w	:= '0';
		elsif (trunc(dt_competencia_w,'month') < to_date('01/01/2012','dd/mm/yyyy')) then
			ie_doc_medico_prof_w	:= 1;
			cd_cns_cpf_executor_w	:= nr_cpf_executor_w;
		elsif (trunc(dt_competencia_w,'month') >= to_date('01/01/2012','dd/mm/yyyy')) then
			ie_doc_medico_prof_w	:= 2;
			cd_cns_cpf_executor_w	:= cd_cns_executor_w;
		end if;

		if (sus_validar_regra(7, cd_procedimento_w, ie_origem_proced_w,dt_procedimento_w) > 0) or (sus_validar_regra(13,cd_procedimento_w, ie_origem_proced_w,dt_procedimento_w) > 0) then
			dt_comp_interf_w	:= to_char(dt_competencia_w, 'yyyymm');
		end if;
		
		if (ie_exporta_cnes_w	= 'S') then
			begin
			select	coalesce(ie_tipo_servico_sus,0)
			into STRICT	ie_tipo_servico_w
			from	medico_convenio
			where	cd_pessoa_fisica	= cd_codigo_executor_w
			and	cd_convenio		= cd_convenio_w;
			exception
			when others then
				ie_tipo_servico_w	:= 30;
			end;
		else
			
			select	coalesce(max(ie_tipo_servico_sus),0)
			into STRICT	ie_tipo_servico_w
			from	medico_convenio
			where	cd_pessoa_fisica	= cd_codigo_executor_w
			and	cd_convenio		= cd_convenio_w;
		end if;
		
		
		select	count(*)
		into STRICT	qt_reg_cnes_proc_w
		from	sus_regra_cnes_proc_aih
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	ie_situacao		= 'A'  LIMIT 1;
		
		if (qt_reg_cnes_proc_w > 0) then
			begin
			
			cd_cnes_regra_proc_w := sus_obter_cnes_proc_aih(cd_procedimento_w, ie_origem_proced_w,cd_estabelecimento_w);	
			
			if (coalesce(cd_cnes_regra_proc_w,'X') <> 'X') then
				ie_doc_prestador_w	:= 5;
				cd_cnes_regra_proc_w	:= lpad(cd_cnes_regra_proc_w,7,'0');
				cd_cgc_prestador_w	:= lpad(cd_cnes_regra_proc_w,14,' ');
			end if;
			
			end;
		end if;
		
		/* De acordo com a regra do SUS: Medico credenciado deve exportar CPF + CBO + CNES. Profissional autonomo deve exportar CPF + CBO */
		
		begin
		select	coalesce(max(ie_credenciamento),ie_tipo_servico_w)
		into STRICT	ie_credenciamento_w
		from	sus_medico_credenciamento
		where	cd_medico				= cd_codigo_executor_w
		and	coalesce(cd_cbo,coalesce(cd_cbo_executor_w,'X'))	= coalesce(cd_cbo_executor_w,'X')
		and	coalesce(ie_situacao,'A') = 'A'
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;	
		exception
		when others then
			ie_credenciamento_w := ie_tipo_servico_w;
		end;	

		if (sus_validar_regra(12, cd_procedimento_w, ie_origem_proced_w,dt_procedimento_w) > 0) and (ie_doc_prestador_w = 5) and (ie_credenciamento_w not in ('4','30')) and (cd_procedimento_w not in (0802020011, 0309010047, 0309010071)) and (qt_reg_prof_vinc_w = 0) then
			cd_cgc_prestador_w	:= '0';
		end if;

		if (ie_exclui_medico_w = 'S') then
			cd_cns_cpf_executor_w	:= ' ';
			cd_cbo_executor_w	:= '      ';
			ie_doc_medico_prof_w	:= 0;
			
			if (ie_exp_cnes_exc_med_w = 'S') then
				ie_doc_executor_w	:= 5;
				cd_doc_executor_w	:= cd_cnes_w;
			end if;
		end if;
		if (ie_exclui_cnes_w = 'S') then
			cd_cgc_prestador_w	:= '0';
		end if;

		/* Alteracao para tratamento de mais de 150 linhas (agrupar procedimentos nao OPME) */

		ie_regra_agrup_proc_w	:= coalesce(sus_obter_se_regra_agrup_proc(cd_estabelecimento_w, cd_procedimento_w,7),'N');
		
		select	count(*)
		into STRICT	qt_reg_w
		from	sus_estrutura_procedimento_v
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= 7
		and	((cd_grupo		= 2) or (ie_regra_agrup_proc_w = 'S'))  LIMIT 1;

		if (coalesce(cd_doc_executor_w::text, '') = '') then
			cd_doc_executor_w	:= ' ';
		end if;
		
		if (qt_reg_w	> 0) then
			begin

			select	coalesce(sum(qt_procedimento),0),
				max(nr_sequencia),
				count(*)
			into STRICT	qt_proc_interf_w,
				nr_sequencia_w,
				qt_reg_w
			from (
			SELECT	qt_procedimento,
				nr_sequencia
			from	w_susaih_interf_item
			where	nr_interno_conta		= nr_interno_conta_p
			and	cd_procedimento			= cd_procedimento_w
			and	nr_aih				= nr_aih_w
			and	coalesce(ie_doc_medico_exec,0)	= coalesce(ie_doc_medico_prof_w, 0)
			and	coalesce(nr_cpf_executor, '0')	= coalesce(nr_cpf_executor_w, '0')
			and	coalesce(cd_cbo_executor, '0')	= coalesce(cd_cbo_executor_w, '0')
			and	coalesce(ie_funcao, 0)		= coalesce(ie_funcao_w, 0)
			and	coalesce(ie_doc_prestador, 0)	= coalesce(ie_doc_prestador_w, 0)
			and	coalesce(cd_cgc_prestador,'0')	= coalesce(cd_cgc_prestador_w, '0')
			and	coalesce(ie_doc_executor, 0)		= coalesce(ie_doc_executor_w, 0)
			and	dt_competencia			< to_date('01/05/2011','dd/mm/yyyy')
			and	dt_competencia_w		< to_date('01/05/2011','dd/mm/yyyy')
			
union

			SELECT	qt_procedimento,
				nr_sequencia
			from	w_susaih_interf_item
			where	nr_interno_conta		= nr_interno_conta_p
			and	cd_procedimento			= cd_procedimento_w
			and	nr_aih				= nr_aih_w
			and	coalesce(ie_doc_medico_exec,0)	= coalesce(ie_doc_medico_prof_w, 0)
			and	coalesce(nr_cpf_executor, '0')	= coalesce(nr_cpf_executor_w, '0')
			and	coalesce(cd_cbo_executor, '0')	= coalesce(cd_cbo_executor_w, '0')
			and	coalesce(ie_funcao, 0)		= coalesce(ie_funcao_w, 0)
			and	coalesce(ie_doc_prestador, 0)	= coalesce(ie_doc_prestador_w, 0)
			and	coalesce(cd_cgc_prestador,'0')	= coalesce(cd_cgc_prestador_w, '0')
			and	coalesce(ie_doc_executor, 0)		= coalesce(ie_doc_executor_w, 0)
			and	dt_competencia_w		>= to_date('01/05/2011','dd/mm/yyyy')
			and	trunc(dt_competencia,'month')	= trunc(dt_competencia_w,'month')) alias38;

			if (qt_reg_w > 0) then

				qt_procedimento_w	:= qt_procedimento_w + qt_proc_interf_w;

				ds_registro_w		:= ie_doc_medico_prof_w || lpad(cd_cns_cpf_executor_w,15,' ') || lpad(cd_cbo_executor_w,6,' ') || ie_funcao_w ||
							   ie_doc_prestador_w || rpad(cd_cgc_prestador_w,14,'0') || ie_doc_executor_w || lpad(cd_doc_executor_w,15,' ') ||
							   lpad(cd_procedimento_w,10,0) || lpad(qt_procedimento_w,3,0) || coalesce(dt_comp_interf_w,'      ') || lpad(cd_servico_w,3,'0') ||
							   lpad(cd_servico_classif_w,3,'0');

				begin			
					update	w_susaih_interf_item
					set	qt_procedimento	= qt_procedimento_w,
						ds_registro	= ds_registro_w
					where	nr_sequencia	= nr_sequencia_w;
				exception
				when others then
					/*Erro ao atualizar quantidade do procedimento!
					Conta: nr_interno_conta_p
					AIH: nr_aih_w
					Procedimento: cd_procedimento_w
					Quantidade: qt_procedimento_w
					Erro: sqlerrm*/
					CALL wheb_mensagem_pck.exibir_mensagem_abort(330029,
									'nr_interno_conta_p='||nr_interno_conta_p||
									';nr_aih_w='||nr_aih_w||
									';cd_procedimento_w='||cd_procedimento_w||
									';qt_procedimento_w='||qt_procedimento_w||
									';sqlerrm='||sqlerrm);				
				end;

			else
				begin

				ds_registro_w		:= ie_doc_medico_prof_w || lpad(cd_cns_cpf_executor_w,15,' ') || lpad(cd_cbo_executor_w,6,' ') || ie_funcao_w ||
							   ie_doc_prestador_w || rpad(cd_cgc_prestador_w,14,'0') || ie_doc_executor_w || lpad(cd_doc_executor_w,15,' ') ||
							   lpad(cd_procedimento_w,10,0) || lpad(qt_procedimento_w,3,0) || coalesce(dt_comp_interf_w,'      ') || lpad(cd_servico_w,3,'0') ||
							   lpad(cd_servico_classif_w,3,'0');


				if (ie_exclui_procedimento_w	<> 'S') then

					/* Obter a sequence da tabela*/

					select	nextval('w_susaih_interf_item_seq')
					into STRICT	nr_sequencia_w
					;

					insert into w_susaih_interf_item(
						nr_sequencia,
						ie_doc_medico_exec,
						nr_cpf_executor,
						cd_cns_executor,
						cd_cbo_executor,
						ie_funcao,
						cd_cgc_prestador,
						cd_cnes,
						cd_procedimento,
						ie_origem_proced,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						qt_procedimento,
						dt_competencia,
						nr_aih,
						nr_interno_conta,
						nr_seq_proc,
						nr_seq_reg_proc,
						nr_seq_protocolo,
						nr_linha_proc,
						ds_registro,
						nr_seq_proc_princ,
						ie_ordem,
						ie_doc_prestador,
						ie_doc_executor,
						cd_doc_executor,
						dt_comp_proc)
					values (	nr_sequencia_w,
						ie_doc_medico_prof_w,
						nr_cpf_executor_w,
						cd_cns_executor_w,
						cd_cbo_executor_w,
						ie_funcao_w,
						cd_cgc_prestador_w,
						cd_cnes_w,
						cd_procedimento_w,
						ie_origem_proced_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						qt_procedimento_w,
						dt_competencia_w,
						nr_aih_w,
						nr_interno_conta_p,
						nr_seq_proc_w,
						nr_seq_reg_proc_w,
						nr_seq_protocolo_w,
						nr_linha_proc_w,
						ds_registro_w,
						nr_seq_proc_princ_w,
						ie_ordem_w,
						ie_doc_prestador_w,
						ie_doc_executor_w,
						cd_doc_executor_w,
						dt_competencia_w);

					nr_linha_proc_w	:= nr_linha_proc_w + 1;

					if (qt_registro_w	= 9) then
						qt_registro_w		:= 0;
						ds_registro_w		:= '';
						nr_seq_reg_proc_w	:= nr_seq_reg_proc_w + 1;
					end if;
				end if;
				end;
			end if;
			end;
		else
			begin

			ds_registro_w	:= 	ie_doc_medico_prof_w || lpad(cd_cns_cpf_executor_w,15,' ') || lpad(cd_cbo_executor_w,6,' ') || ie_funcao_w ||
						ie_doc_prestador_w || rpad(cd_cgc_prestador_w,14,'0') || ie_doc_executor_w || lpad(cd_doc_executor_w,15,' ') ||
						lpad(cd_procedimento_w,10,0) || lpad(qt_procedimento_w,3,0) || coalesce(dt_comp_interf_w,'      ') || lpad(cd_servico_w,3,'0') ||
						lpad(cd_servico_classif_w,3,'0');


			if (ie_exclui_procedimento_w		<> 'S')	then
				/* Obter a sequence da tabela*/

				select	nextval('w_susaih_interf_item_seq')
				into STRICT	nr_sequencia_w
				;

				insert into w_susaih_interf_item(
					nr_sequencia,
					ie_doc_medico_exec,
					nr_cpf_executor,
					cd_cns_executor,
					cd_cbo_executor,
					ie_funcao,
					cd_cgc_prestador,
					cd_cnes,
					cd_procedimento,
					ie_origem_proced,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					qt_procedimento,
					dt_competencia,
					nr_aih,
					nr_interno_conta,
					nr_seq_proc,
					nr_seq_reg_proc,
					nr_seq_protocolo,
					nr_linha_proc,
					ds_registro,
					nr_seq_proc_princ,
					ie_ordem,
					ie_doc_prestador,
					ie_doc_executor,
					cd_doc_executor,
					dt_comp_proc)
				values (	nr_sequencia_w,
					ie_doc_medico_prof_w,
					nr_cpf_executor_w,
					cd_cns_executor_w,
					cd_cbo_executor_w,
					ie_funcao_w,
					cd_cgc_prestador_w,
					cd_cnes_w,
					cd_procedimento_w,
					ie_origem_proced_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					qt_procedimento_w,
					dt_competencia_w,
					nr_aih_w,
					nr_interno_conta_p,
					nr_seq_proc_w,
					nr_seq_reg_proc_w,
					nr_seq_protocolo_w,
					nr_linha_proc_w,
					ds_registro_w,
					nr_seq_proc_princ_w,
					ie_ordem_w,
					ie_doc_prestador_w,
					ie_doc_executor_w,
					cd_doc_executor_w,
					dt_competencia_w);

				nr_linha_proc_w	:= nr_linha_proc_w + 1;

				if (qt_registro_w	= 9) then
					qt_registro_w	:= 0;
					ds_registro_w	:= '';
					nr_seq_reg_proc_w	:= nr_seq_reg_proc_w + 1;
				end if;
			end if;
			end;
		end if;
	
		end;
	end loop;
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interf_item_susaih ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
