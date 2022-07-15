-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE lista_proc_gerado AS (nr_sequencia		bigint);
CREATE TYPE lista_conta_atualizar AS (nr_interno_conta	bigint);


CREATE OR REPLACE PROCEDURE gerar_propaci_dia ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, dt_inicial_p timestamp, nr_dias_p bigint, qt_proc_lanc_dia_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_atepacu_p bigint, vl_informado_p bigint, cd_medico_executor_p text, ie_fim_semana_p text, nm_usuario_p text) AS $body$
DECLARE

				
--------------------------------------------------------------------------------------------------------
		
type Vetor_Proc_Gerado is 
	table of lista_proc_gerado index by integer;
	
l				integer := 1;
j				integer := 1;
Vetor_Proc_Gerado_w		Vetor_Proc_Gerado;

--------------------------------------------------------------------------------------------------------
		
type Vetor_Conta_Atualizar is
	table of lista_conta_atualizar index by integer;
	
k				integer := 1;
Vetor_Conta_Atualizar_w		Vetor_Conta_Atualizar;

--------------------------------------------------------------------------------------------------------
				
nr_sequencia_w			bigint;
dt_entrada_unidade_w		timestamp;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(2);
cd_senha_w			varchar(20);
cd_cgc_prestador_w 		varchar(14);	
ie_origem_proced_w		bigint;
dt_procedimento_w		timestamp;
cd_procedimento_w		bigint;
cd_setor_atendimento_w		integer;
i				integer;
qt_procedimento_w		double precision;
ie_convenio_conta_param_w	varchar(1);
cd_estabelecimento_w		smallint;
dt_entrada_w			timestamp;

qt_registro_w			bigint;
dt_procedimento_ww		timestamp;

vl_total_w			double precision;
vl_dif_w			double precision;
nr_dias_final_semana_w		bigint;
ie_tipo_atendimento_w		smallint;
cd_especialidade_w		integer := null;
ie_funcao_medico_w		varchar(10) := null;

ie_responsavel_credito_w	varchar(5);
ie_emite_conta_w		varchar(3);
ie_emite_conta_honor_w		varchar(3);
ie_clinica_w			integer;
vl_regra_proced_espec_w		varchar(255);
nr_seq_classificacao_w		bigint;
ie_medico_executor_w		varchar(1);
cd_cgc_w			varchar(14);
cd_medico_executor_w		varchar(10);
cd_pessoa_fisica_w		varchar(10);
cd_medico_exec_w		varchar(10);
cd_medico_laudo_sus_w		varchar(10);
ds_erro_w			varchar(2000);
ie_via_acesso_w			varchar(1);
ie_atualizar_ref_conta_w	varchar(1);
nr_conta_atualizar_ref_w	bigint;
dt_refer_conta_atualizar_w	timestamp;
dt_final_conta_atualizar_w	timestamp;
ie_existe_conta_atualizar_w	varchar(1);
vl_procedimento_w		procedimento_paciente.vl_procedimento%type := vl_informado_p;
ie_valor_informado_w		procedimento_paciente.ie_valor_informado%type := 'N';
nr_seq_atepacu_w		atendimento_paciente_v.nr_seq_atepacu%type;
cd_plano_convenio_w		atendimento_paciente_v.cd_plano_convenio%type;
cd_medico_resp_w		atendimento_paciente_v.cd_medico_resp%type;
ie_valida_regra_qtde_w		varchar(1) := 'N';
cd_motivo_exc_conta_w		parametro_faturamento.cd_motivo_exc_conta%type;
nr_interno_conta_w		procedimento_paciente.nr_interno_conta%type := nr_interno_conta_p;


BEGIN

dt_procedimento_w	:= dt_inicial_p;
dt_procedimento_ww	:= dt_inicial_p;
cd_medico_exec_w	:= cd_medico_executor_p;
vl_regra_proced_espec_w := obter_param_usuario(67, 59, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, vl_regra_proced_espec_w);
ie_atualizar_ref_conta_w := obter_param_usuario(67, 609, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_atualizar_ref_conta_w);
ie_valida_regra_qtde_w 	:= obter_valor_param_usuario(67, 111, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);

ie_atualizar_ref_conta_w	:= coalesce(ie_atualizar_ref_conta_w, 'N');

begin
select	cd_setor_atendimento,
	dt_entrada_unidade
into STRICT	cd_setor_atendimento_w,
	dt_entrada_unidade_w
from	atend_paciente_unidade
where	nr_seq_interno = nr_seq_atepacu_p;

select	a.cd_cgc,
	b.dt_entrada
into STRICT	cd_cgc_prestador_w,
	dt_entrada_w
from 	estabelecimento a,
	atendimento_paciente b
where	a.cd_estabelecimento 	= b.cd_estabelecimento
and	b.nr_atendimento 	= nr_atendimento_p;

select	max(ie_tipo_atendimento),
	max(ie_clinica),
	max(nr_seq_classificacao)
into STRICT	ie_tipo_atendimento_w,
	ie_clinica_w,
	nr_seq_classificacao_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from 	conta_paciente
where 	nr_interno_conta = nr_interno_conta_w;

select	max(ie_convenio_conta_param),
	max(cd_motivo_exc_conta)
into STRICT	ie_convenio_conta_param_w,
	cd_motivo_exc_conta_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_w;

select	nr_seq_atepacu,
	cd_plano_convenio,
	cd_medico_resp
into STRICT	nr_seq_atepacu_w,
	cd_plano_convenio_w,
	cd_medico_resp_w
from 	atendimento_paciente_v
where	nr_atendimento = nr_atendimento_p;

if (ie_convenio_conta_param_w = 'S') then
	begin
	select	cd_convenio_parametro,
			cd_categoria_parametro
	into STRICT	cd_convenio_w,
			cd_categoria_w
	from	conta_paciente
	where	nr_interno_conta = nr_interno_conta_w;	
	end;
else
	-- Obter o convenio de execucao 
	SELECT * FROM obter_convenio_execucao(nr_atendimento_p, dt_entrada_unidade_w, cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;
end if;

exception when others then
	ds_erro_w:= substr(sqlerrm,1,2000);	
	goto final;
end;

nr_dias_final_semana_w:= 0;

if (vl_informado_p IS NOT NULL AND vl_informado_p::text <> '') then
	qt_registro_w	  := 0;
	while(qt_registro_w	< nr_dias_p) loop
		begin
		
		if (dt_entrada_w > dt_procedimento_ww) then
			dt_procedimento_ww := dt_entrada_unidade_w;
		end if;
		
		if (ie_fim_semana_p = 'S') or (PKG_DATE_UTILS.IS_BUSINESS_DAY(dt_procedimento_ww) = 1) then
			qt_registro_w:= qt_registro_w + 1;
		elsif (ie_fim_semana_p = 'N') and (PKG_DATE_UTILS.IS_BUSINESS_DAY(dt_procedimento_ww) = 0) then -- Finais de semana
			nr_dias_final_semana_w:= nr_dias_final_semana_w + 1;
		end if;
		
		dt_procedimento_ww := dt_procedimento_ww + 1;		
		
		end;
	end loop;
end if;

vl_total_w:= 0;

for i in 1..nr_dias_p + nr_dias_final_semana_w loop
	begin
	qt_procedimento_w	:= coalesce(qt_proc_lanc_dia_p,1);
	
	-- Obter a maxima sequencia da procedimento_paciente 
	select	nextval('procedimento_paciente_seq')
	into STRICT	nr_sequencia_w
	;
	
	if (dt_entrada_w > dt_procedimento_w) then
		dt_procedimento_w := dt_entrada_unidade_w;
	end if;
	
	if (ie_fim_semana_p = 'S') or (PKG_DATE_UTILS.IS_BUSINESS_DAY(dt_procedimento_w) = 1) then
	
		if (ie_valida_regra_qtde_w = 'S') then
		
			SELECT * FROM tratar_retorno_regra_uso_proc(	nr_atendimento_p, cd_procedimento_p, ie_origem_proced_p, cd_setor_atendimento_w, cd_estabelecimento_w, cd_plano_convenio_w, dt_procedimento_w, cd_medico_resp_w, nr_seq_atepacu_w, cd_motivo_exc_conta_w, nm_usuario_p, cd_categoria_w, cd_convenio_w, nr_interno_conta_w, qt_procedimento_w, ds_erro_w, ie_valor_informado_w, vl_procedimento_w) INTO STRICT cd_categoria_w, cd_convenio_w, nr_interno_conta_w, qt_procedimento_w, ds_erro_w, ie_valor_informado_w, vl_procedimento_w;

			if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
				goto final;	
			end if;
		end if;	
			
		SELECT * FROM consiste_medico_executor(wheb_usuario_pck.get_cd_estabelecimento, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_p, ie_origem_proced_p, ie_tipo_atendimento_w, null, nr_seq_proc_interno_p, ie_medico_executor_w, cd_cgc_w, cd_medico_executor_w, cd_pessoa_fisica_w, cd_medico_executor_p, dt_procedimento_w, nr_seq_classificacao_w, null, null, null) INTO STRICT ie_medico_executor_w, cd_cgc_w, cd_medico_executor_w, cd_pessoa_fisica_w;
				
		if (coalesce(cd_cgc_w,'0') <> '0') then
			cd_cgc_prestador_w	:= cd_cgc_w;
		end if;
		
		if (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') and (coalesce(cd_medico_exec_w::text, '') = '') then
			cd_medico_exec_w	:= cd_medico_executor_w;
		end if;
		
		if (coalesce(cd_medico_executor_w::text, '') = '') and (ie_medico_executor_w = 'N') then
			cd_medico_exec_w	:= null;
		end if;		
		
		if (ie_medico_executor_w = 'S') then
			select	max(cd_medico_requisitante)
			into STRICT	cd_medico_laudo_sus_w
			from	sus_laudo_paciente
			where	nr_atendimento = nr_atendimento_p
			and	cd_procedimento_solic = cd_procedimento_p
			and	ie_origem_proced = ie_origem_proced_p;
			
			cd_medico_exec_w	:= coalesce(cd_medico_laudo_sus_w,cd_medico_exec_w);
		end if;
		
		if (ie_medico_executor_w = 'M') then
			begin
			cd_medico_laudo_sus_w	:= sus_obter_dados_sismama_atend(nr_atendimento_p,'M','CMR');
			cd_medico_exec_w 	:= coalesce(cd_medico_laudo_sus_w,cd_medico_exec_w);
			end;
		end if;
		
		if (ie_medico_executor_w = 'A') and (coalesce(cd_medico_exec_w::text, '') = '') then
			select	max(cd_medico_resp)
			into STRICT	cd_medico_exec_w
			from	atendimento_paciente
			where	nr_atendimento = nr_atendimento_p;
		end if;
		
		if (ie_medico_executor_w	= 'F') and (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then
			cd_medico_exec_w	:= cd_medico_executor_w;
		end if;
		
		select 	substr(obter_regra_via_acesso(cd_procedimento_p, ie_origem_proced_p, cd_estabelecimento_w, cd_convenio_w),1,2)
		into STRICT	ie_via_acesso_w
		;

		-- inserir na tabela procedimento_paciente
		insert into procedimento_paciente(
				nr_sequencia,
				nr_atendimento,	
				dt_entrada_unidade,		
				cd_procedimento,
				dt_procedimento,
				cd_convenio,
				cd_categoria,
				nr_doc_convenio,
				ie_tipo_guia,
				cd_senha,
				ie_auditoria,
				ie_emite_conta,
				cd_cgc_prestador,
				ie_origem_proced,
				nr_seq_exame,
				nr_seq_proc_interno,
				qt_procedimento,
				cd_setor_atendimento,
				nr_seq_atepacu,
				nr_seq_cor_exec,
				vl_procedimento,
				ie_proc_princ_atend,
				ie_video,
				tx_medico,
				tx_Anestesia,
				tx_procedimento,
				ie_valor_informado,
				ie_guia_informada,
				cd_situacao_glosa,
				nm_usuario_original,
				ds_observacao,
				dt_atualizacao,
				nm_usuario,
				cd_pessoa_fisica,
				cd_medico_executor,
				nr_interno_conta,
				dt_conta,
				cd_especialidade,
				ie_funcao_medico,
				ie_via_acesso)
			values ( 
				nr_sequencia_w,
				nr_atendimento_p,
				dt_entrada_unidade_w,
				cd_procedimento_p,
				dt_procedimento_w,
				cd_convenio_w,
				cd_categoria_w,
				nr_doc_convenio_w,
				ie_tipo_guia_w,
				cd_senha_w,
				'N',
				null,
				cd_cgc_prestador_w,
				ie_origem_proced_p,
				null,
				nr_seq_proc_interno_p,
				qt_procedimento_w,
				cd_setor_atendimento_w,
				nr_seq_atepacu_p,
				null,
				CASE WHEN coalesce(vl_procedimento_w::text, '') = '' THEN  100  ELSE dividir(vl_procedimento_w,nr_dias_p) END ,
				'N',
				'N',
				100,
				100,
				100,
				ie_valor_informado_w,
				'N',
				0,
				nm_usuario_p,
				null,
				clock_timestamp(),
				nm_usuario_p,
				null,
				cd_medico_exec_w,
				nr_interno_conta_w,
				dt_procedimento_w,
				cd_especialidade_w,
				ie_funcao_medico_w,
				ie_via_acesso_w);

		vl_total_w:= vl_total_w + dividir(vl_procedimento_w,nr_dias_p);
	
		--calcular item
		CALL atualiza_preco_procedimento(nr_sequencia_w,cd_convenio_w,nm_usuario_p);
		
		if (ie_atualizar_ref_conta_w = 'S') then
			l	:= coalesce(Vetor_Proc_Gerado_w.Count,0) + 1;
			
			Vetor_Proc_Gerado_w[l].nr_sequencia	:= nr_sequencia_w;
		end if;
		
		if (vl_regra_proced_espec_w <> 'N') then
		
			if (vl_regra_proced_espec_w = 'S') or (vl_regra_proced_espec_w = 'R') then
			
				select	max(ie_responsavel_credito),
					max(ie_emite_conta),
					max(ie_emite_conta_honor)
				into STRICT	ie_responsavel_credito_w,
					ie_emite_conta_w,
					ie_emite_conta_honor_w
				from	procedimento_paciente
				where	nr_sequencia = nr_sequencia_w;
				
				SELECT * FROM obter_proced_espec_medica(wheb_usuario_pck.get_cd_estabelecimento, cd_convenio_w, cd_procedimento_p, ie_origem_proced_p, ie_responsavel_credito_w, ie_emite_conta_w, ie_emite_conta_honor_w, ie_clinica_w, cd_setor_atendimento_w, cd_especialidade_w, ie_funcao_medico_w, cd_medico_exec_w, nr_seq_proc_interno_p, ie_tipo_atendimento_w) INTO STRICT cd_especialidade_w, ie_funcao_medico_w;
				
				if (coalesce(cd_especialidade_w::text, '') = '') and (vl_regra_proced_espec_w = 'R') then
					
					select	obter_especialidade_medico(cd_medico_exec_w, 'C')
					into STRICT	cd_especialidade_w
					;
					
				end if;
				
			elsif (vl_regra_proced_espec_w = 'M') then
			
				select	obter_especialidade_medico(cd_medico_exec_w, 'C')
				into STRICT	cd_especialidade_w
				;
				
			end if;
			
			update	procedimento_paciente
			set	cd_especialidade = cd_especialidade_w,
				ie_funcao_medico = ie_funcao_medico_w
			where	nr_sequencia = nr_sequencia_w;
			
		end if;
		
		CALL gerar_lancamento_automatico(nr_atendimento_p, null, 34, nm_usuario_p, nr_sequencia_w, null, null, null, null, nr_interno_conta_w);
	
	end if;
	
	dt_procedimento_w := dt_procedimento_w +1;
	
	end;
end loop;

if (vl_procedimento_w IS NOT NULL AND vl_procedimento_w::text <> '') then
	
	vl_dif_w:= vl_total_w - vl_procedimento_w;
	
	if (vl_dif_w <> 0) then
		
		update	procedimento_paciente
		set 	vl_procedimento = vl_procedimento - vl_dif_w
		where	nr_sequencia = nr_sequencia_w;
	
	end if;
	
end if;

if (coalesce(Vetor_Proc_Gerado_w.count,0) > 0) then
	j	:= 1;

	for	j in 1..Vetor_Proc_Gerado_w.count loop
	
		select	coalesce(max(nr_interno_conta),0)
		into STRICT	nr_conta_atualizar_ref_w
		from	procedimento_paciente
		where	nr_sequencia = Vetor_Proc_Gerado_w[j].nr_sequencia;
		
		if (coalesce(nr_conta_atualizar_ref_w,0) > 0) then
			l	:= coalesce(Vetor_Conta_Atualizar_w.Count,0) + 1;
			k	:= 1;
			
			select	coalesce(max(dt_mesano_referencia),clock_timestamp()),
				coalesce(max(dt_periodo_final),clock_timestamp())
			into STRICT	dt_refer_conta_atualizar_w,
				dt_final_conta_atualizar_w
			from	conta_paciente
			where	nr_interno_conta = nr_conta_atualizar_ref_w;
			
			if (PKG_DATE_UTILS.start_of(dt_refer_conta_atualizar_w,'month',0) <> PKG_DATE_UTILS.start_of(dt_final_conta_atualizar_w,'month',0)) then
			
				if (l > 1) then
					ie_existe_conta_atualizar_w	:= 'N';
				
					for k in 1..Vetor_Conta_Atualizar_w.count loop
					
						if (Vetor_Conta_Atualizar_w[k].nr_interno_conta = nr_conta_atualizar_ref_w) then
							ie_existe_conta_atualizar_w	:= 'S';
						end if;
					
					end loop;
					
					if (ie_existe_conta_atualizar_w = 'N') then
						update	conta_paciente
						set	dt_mesano_referencia = PKG_DATE_UTILS.start_of(fim_mes(dt_final_conta_atualizar_w), 'dd', 0)
						where	nr_interno_conta = nr_conta_atualizar_ref_w;
					
						Vetor_Conta_Atualizar_w[l].nr_interno_conta	:= nr_conta_atualizar_ref_w;
					end if;
				
				else
					update	conta_paciente
					set	dt_mesano_referencia = PKG_DATE_UTILS.start_of(fim_mes(dt_final_conta_atualizar_w), 'dd', 0)
					where	nr_interno_conta = nr_conta_atualizar_ref_w;
				
					Vetor_Conta_Atualizar_w[l].nr_interno_conta	:= nr_conta_atualizar_ref_w;
				end if;
				
			end if;
		
		end if;
		
	end loop;
end if;

commit;

<<final>>
	begin
	ds_erro_w:= '';
	end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_propaci_dia ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, dt_inicial_p timestamp, nr_dias_p bigint, qt_proc_lanc_dia_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_atepacu_p bigint, vl_informado_p bigint, cd_medico_executor_p text, ie_fim_semana_p text, nm_usuario_p text) FROM PUBLIC;

