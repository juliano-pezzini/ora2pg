-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_atendimento_pac ( nr_atendimento_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, nr_atend_novo_p INOUT bigint, ds_lista_prescr_p text, ds_lista_diagnostico_p text) AS $body$
DECLARE

nr_atend_novo_w		bigint;
ie_possui_atend_w	varchar(1);
ie_possui_conv_w	varchar(1);
ie_unidade_livre_w	varchar(1);
dt_entrada_unidade_w	timestamp;
ie_vigencia_vencida_w	varchar(1) := 'N';

ds_lista_prescr_w	varchar(4000);
ds_lista_diagnostico_w	varchar(4000);

nr_prescricao_w		bigint;
nr_sequencia_diag_w	bigint;

ie_pos_virgula_w	smallint;
ie_pos_sep_w		smallint;
tam_lista_w		bigint;

nr_prescricao_nova_w	bigint;
nr_sequencia_item_w	bigint;
dt_diagnostico_novo_w	timestamp;

ie_duplica_prescricao_w varchar(1);
ie_duplica_diagnostico_w varchar(1);

dt_diagnostico_origem_w	timestamp;
qt_contador_w		bigint;
ie_replica_proc_cih_w varchar(1);

/* 		prescrição		*/
	 
C01 CURSOR FOR 
	SELECT nr_prescricao, 
	dt_entrega, 
	cd_medico, 
	nr_seq_forma_laudo, 
	ds_dado_clinico, 
	cd_cgc_solic, 
	ds_endereco_entrega, 
	cd_setor_entrega, 
	qt_peso, 
	qt_altura_cm, 
	substr(Obter_IMC(qt_peso,qt_altura_cm),1,20) qt_imc, 
	nr_doc_conv, 
	cd_senha, 
	nr_prioridade, 
	nr_controle, 
	ds_observacao, 
	dt_prescricao, 
	dt_mestruacao, 
	qt_tempo_jejum_real, 
	nm_usuario, 
	dt_atualizacao, 
	cd_pessoa_fisica, 
	nr_atendimento 
from  prescr_medica 
where  nr_atendimento = nr_atendimento_p 
and	(((ie_duplica_prescricao_w = 'A') and ( (ds_lista_prescr_p IS NOT NULL AND ds_lista_prescr_p::text <> '') and obter_se_contido(nr_prescricao,ds_lista_prescr_p) = 'S')) or (coalesce(ds_lista_prescr_p::text, '') = '' and ie_duplica_prescricao_w = 'S')) 
and   coalesce(dt_suspensao::text, '') = '';

C01_w	c01%rowtype;

/* 		itens prescricao 		*/
	 
C03 CURSOR FOR 
	SELECT nr_sequencia, 
		nr_prescricao, 
		cd_procedimento, 
		qt_procedimento, 
		dt_atualizacao,                                                                                       
		nm_usuario, 
		ie_origem_inf, 
		nr_seq_proc_interno, 
		nr_seq_exame, 
		substr(lab_obter_dados_exame(nr_seq_exame,'C'),1,255) cd_exame, 
		cd_setor_coleta, 
		cd_material_exame, 
		cd_medico_exec, 
		cd_medico_solicitante, 
		ie_amostra, 
		ie_urgencia, 
		nr_doc_convenio, 
		cd_senha, 
		dt_coleta, 
		dt_resultado, 
		ds_material_especial, 
		dt_prev_execucao, 
		ie_orientar_paciente, 
		ie_pendente_amostra, 
		ds_observacao_coleta, 
		ie_coleta_externa, 
		cd_profissional, 
		ds_dado_clinico, 
		ds_observacao, 
		ie_aprovacao_execucao, 
		nr_controle_ext, 
		ie_lado, 
		dt_baixa, 
		ie_executar_leito, 
		cd_setor_entrega, 
		ie_origem_proced, 
		cd_setor_atendimento 
	from  prescr_procedimento b 
	where  nr_prescricao = C01_w.nr_prescricao 
	order  by nr_prescricao;

c03_w	c03%rowtype;	
	 
/* 		Dignostico		*/
		 
C02 CURSOR FOR 
	SELECT nr_atendimento, 
		dt_diagnostico, 
		cd_doenca, 
		dt_atualizacao, 
		nm_usuario, 
		substr(ds_diagnostico,1,2000) ds_diagnostico, 
		qt_tempo, 
		ie_unidade_tempo, 
		ie_classificacao_doenca, 
		ie_tipo_doenca, 
		ie_tipo_atendimento, 
		cd_medico, 
		ie_tipo_diagnostico 
	from 	diagnostico_doenca 
	where 	nr_atendimento = nr_atendimento_p 
	order by 1, 2;
	
c02_w	c02%rowtype;

C05 CURSOR FOR 
	SELECT nr_atendimento, 
		dt_diagnostico, 
		cd_doenca, 
		dt_atualizacao, 
		nm_usuario, 
		substr(ds_diagnostico,1,2000) ds_diagnostico, 
		qt_tempo, 
		ie_unidade_tempo, 
		ie_classificacao_doenca, 
		ie_tipo_doenca, 
		ie_tipo_atendimento, 
		cd_medico, 
		ie_tipo_diagnostico 
	from 	diagnostico_doenca 
	where 	nr_atendimento = nr_atendimento_p 
	and	dt_diagnostico = dt_diagnostico_origem_w 
	order by 1, 2;

c05_w	c05%rowtype;	
	 
C04 CURSOR FOR 
	SELECT 	nr_atendimento, 
		dt_diagnostico, 
		ie_tipo_diagnostico, 
		cd_medico, 
		dt_atualizacao, 
		nm_usuario, 
		ds_diagnostico, 
		ie_tipo_atendimento 
	from	diagnostico_medico 
	where	nr_atendimento = nr_atendimento_p 
	order by 1,2;
	
c04_w	c04%rowtype;	
 
/*Proc CIH*/
 
 
C06 CURSOR FOR 
SELECT	nr_atendimento, 
	nr_sequencia, 
	cd_procedimento, 
	ie_origem_proced, 
	dt_atualizacao, 
	nm_usuario, 
	cd_cid_primario, 
	cd_cid_secundario, 
	cd_motivo_alta, 
	nr_seq_sus_proc_gen 
from	procedimento_paciente_cih 
where	nr_atendimento = nr_atendimento_p 
order by 1,2;
	
c06_w	c06%rowtype;	
	 

BEGIN 
 
ie_replica_proc_cih_w := Obter_param_Usuario(916, 1116, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_replica_proc_cih_w);
nr_atend_novo_w	:= 0;
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
	 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_possui_atend_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;	
	 
	if (ie_possui_atend_w = 'S') then 
	 
		select	nextval('atendimento_paciente_seq') 
		into STRICT	nr_atend_novo_w 
		;		
 
		insert into atendimento_paciente(	 
			nr_atendimento, 
			ie_permite_visita, 
			dt_entrada, 
			ie_tipo_atendimento, 
			cd_procedencia, 
			cd_medico_resp, 
			cd_pessoa_fisica, 
			cd_estabelecimento, 
			dt_atualizacao, 
			nm_usuario, 
			cd_pessoa_responsavel, 
			ie_carater_inter_sus, 
			cd_municipio_ocorrencia, 
			cd_medico_referido, 
			cd_cgc_indicacao, 
			qt_dias_prev_inter, 
			nr_seq_queixa, 
			ie_tipo_convenio, 
			ie_tipo_atend_tiss, 
			ie_responsavel, 
			nr_seq_indicacao) 
		SELECT	nr_atend_novo_w, 
			ie_permite_visita, 
			clock_timestamp(), 
			ie_tipo_atendimento, 
			cd_procedencia, 
			cd_medico_resp, 
			cd_pessoa_fisica_p, 
			cd_estabelecimento, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_pessoa_responsavel, 
			ie_carater_inter_sus, 
			cd_municipio_ocorrencia, 
			cd_medico_referido, 
			cd_cgc_indicacao, 
			qt_dias_prev_inter, 
			nr_seq_queixa, 
			ie_tipo_convenio, 
			ie_tipo_atend_tiss, 
			ie_responsavel, 
			nr_seq_indicacao 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_p;
		 
		commit;
		 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_possui_conv_w 
		from	atend_categoria_convenio 
		where	nr_atendimento = nr_atendimento_p;
		 
		 
		if (ie_possui_conv_w = 'S') then 
		 
			SELECT	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
			into STRICT	ie_vigencia_vencida_w 
			from	atend_categoria_convenio 
			where	nr_atendimento = nr_atendimento_p 
			and	TO_DATE(TO_CHAR(dt_final_vigencia,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') < clock_timestamp();
		 
			insert into atend_categoria_convenio(	 
				cd_convenio, 
				cd_categoria, 
				dt_inicio_vigencia, 
				nr_seq_interno, 
				nr_atendimento, 
				dt_atualizacao, 
				nm_usuario, 
				cd_plano_convenio, 
				nr_seq_origem, 
				cd_municipio_convenio, 
				cd_plano_glosa, 
				cd_empresa, 
				qt_dia_internacao, 
				dt_final_vigencia, 
				cd_usuario_convenio, 
				dt_validade_carteira, 
				ie_tipo_guia) 
			SELECT	cd_convenio, 
				cd_categoria, 
				clock_timestamp(), 
				nextval('atend_categoria_convenio_seq'), 
				nr_atend_novo_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_plano_convenio, 
				nr_seq_origem, 
				cd_municipio_convenio, 
				cd_plano_glosa, 
				cd_empresa, 
				qt_dia_internacao, 
				CASE WHEN ie_vigencia_vencida_w='S' THEN  null  ELSE dt_final_vigencia END , 
				cd_usuario_convenio, 
				dt_validade_carteira, 
				ie_tipo_guia 
			from	atend_categoria_convenio 
			where	nr_atendimento = nr_atendimento_p;
		 
		end if;
		 
		select	max(dt_entrada_unidade) 
		into STRICT	dt_entrada_unidade_w 
		from	atend_paciente_unidade 
		where	nr_atendimento = nr_atendimento_p;
						 
		 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_unidade_livre_w 
		from	unidade_atendimento a, 
			atend_paciente_unidade b	 
		where	a.ie_status_unidade = 'L' 
		and	coalesce(a.nr_atendimento::text, '') = '' 
		and	a.cd_setor_atendimento = b.cd_setor_atendimento 
		and	a.cd_unidade_basica = b.cd_unidade_basica 
		and	a.cd_unidade_compl = b.cd_unidade_compl 
		and	b.nr_atendimento = nr_atendimento_p 
		and	b.dt_entrada_unidade = dt_entrada_unidade_w;
		 
		if (ie_unidade_livre_w = 'S') then 
			insert into atend_paciente_unidade(	 
				cd_setor_atendimento, 
				cd_unidade_basica, 
				cd_unidade_compl, 
				dt_entrada_unidade, 
				nr_seq_interno, 
				nr_atendimento, 
				nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_saida_interno, 
				cd_tipo_acomodacao ) 
			SELECT	cd_setor_atendimento, 
				cd_unidade_basica, 
				cd_unidade_compl, 
				clock_timestamp(), 
				nextval('atend_paciente_unidade_seq'), 
				nr_atend_novo_w, 
				1, 
				clock_timestamp(), 
				nm_usuario_p, 
				null, 
				cd_tipo_acomodacao 
			from	atend_paciente_unidade	 
			where	nr_atendimento = nr_atendimento_p 
			and	dt_entrada_unidade = dt_entrada_unidade_w;
			 
			select coalesce(max(ie_duplica_prescricao), 0) 
			into STRICT	ie_duplica_prescricao_w 
			from	regra_duplicar_atendimento 
			where coalesce(cd_estabelecimento, OBTER_ESTABELECIMENTO_ATIVO) = OBTER_ESTABELECIMENTO_ATIVO;
		 
			open C01;
			loop 
			fetch C01 into	 
				C01_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				select 	nextval('prescr_medica_seq') 
				into STRICT	nr_prescricao_nova_w 
				;
				 
				insert into prescr_medica(nr_prescricao, 
							dt_entrega, 
							cd_medico, 
							nr_seq_forma_laudo, 
							ds_dado_clinico, 
							cd_cgc_solic, 
							ds_endereco_entrega, 
							cd_setor_entrega, 
							qt_peso, 
							qt_altura_cm, 
							nr_doc_conv, 
							cd_senha, 
							nr_prioridade, 
							nr_controle, 
							ds_observacao, 
							dt_prescricao, 
							dt_mestruacao, 
							qt_tempo_jejum_real, 
							nm_usuario, 
							dt_atualizacao, 
							cd_pessoa_fisica, 
							nr_atendimento) 
					values (	nr_prescricao_nova_w, 
							C01_w.dt_entrega, 
							C01_w.cd_medico, 
							C01_w.nr_seq_forma_laudo, 
							C01_w.ds_dado_clinico, 
							C01_w.cd_cgc_solic, 
							C01_w.ds_endereco_entrega, 
							C01_w.cd_setor_entrega, 
							C01_w.qt_peso, 
							C01_w.qt_altura_cm, 
							C01_w.nr_doc_conv, 
							C01_w.cd_senha, 
							C01_w.nr_prioridade, 
							C01_w.nr_controle, 
							C01_w.ds_observacao, 
							C01_w.dt_prescricao, 
							C01_w.dt_mestruacao, 
							C01_w.qt_tempo_jejum_real, 
							C01_w.nm_usuario, 
							C01_w.dt_atualizacao, 
							C01_w.cd_pessoa_fisica, 
							nr_atend_novo_w);
										 
					open C03;
					loop 
					fetch C03 into	 
						c03_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
						begin 
						 
						select 	nextval('prescr_procedimento_seq') 
						into STRICT	nr_sequencia_item_w 
						;
						 
						 
						insert into prescr_procedimento(nr_sequencia, 
										nr_prescricao, 
										cd_procedimento, 
										qt_procedimento, 
										dt_atualizacao,                                                                                       
										nm_usuario, 
										ie_origem_inf, 
										nr_seq_interno, 
										nr_seq_proc_interno, 
										nr_seq_exame, 
										cd_setor_coleta, 
										cd_material_exame, 
										cd_medico_exec, 
										cd_medico_solicitante, 
										ie_amostra, 
										ie_urgencia, 
										nr_doc_convenio, 
										cd_senha, 
										dt_coleta, 
										dt_resultado, 
										ds_material_especial, 
										dt_prev_execucao, 
										ie_orientar_paciente, 
										ie_pendente_amostra, 
										ds_observacao_coleta, 
										ie_coleta_externa, 
										cd_profissional, 
										ds_dado_clinico, 
										ds_observacao, 
										ie_aprovacao_execucao, 
										nr_controle_ext, 
										ie_lado, 
										dt_baixa, 
										ie_executar_leito, 
										cd_setor_entrega, 
										ie_origem_proced, 
										cd_setor_atendimento)	 
								values (	c03_w.nr_sequencia, 
										nr_prescricao_nova_w,								 
										c03_w.cd_procedimento, 
										c03_w.qt_procedimento, 
										c03_w.dt_atualizacao,                                                                                       
										c03_w.nm_usuario, 
										c03_w.ie_origem_inf, 
										nr_sequencia_item_w, 
										c03_w.nr_seq_proc_interno, 
										c03_w.nr_seq_exame, 
										c03_w.cd_setor_coleta, 
										c03_w.cd_material_exame, 
										c03_w.cd_medico_exec, 
										c03_w.cd_medico_solicitante, 
										c03_w.ie_amostra, 
										c03_w.ie_urgencia, 
										c03_w.nr_doc_convenio, 
										c03_w.cd_senha, 
										c03_w.dt_coleta, 
										c03_w.dt_resultado, 
										c03_w.ds_material_especial, 
										c03_w.dt_prev_execucao, 
										c03_w.ie_orientar_paciente, 
										c03_w.ie_pendente_amostra, 
										c03_w.ds_observacao_coleta, 
										c03_w.ie_coleta_externa, 
										c03_w.cd_profissional, 
										c03_w.ds_dado_clinico, 
										c03_w.ds_observacao, 
										c03_w.ie_aprovacao_execucao, 
										c03_w.nr_controle_ext, 
										c03_w.ie_lado, 
										c03_w.dt_baixa, 
										c03_w.ie_executar_leito, 
										c03_w.cd_setor_entrega, 
										c03_w.ie_origem_proced, 
										c03_w.cd_setor_atendimento);
						end;
					end loop;
					close C03;
				end;
			end loop;
		close C01;
		 
		end if;
		 
		select coalesce(max(ie_duplica_diagnostico), 0) 
		into STRICT	ie_duplica_diagnostico_w 
		from	regra_duplicar_atendimento 
		where coalesce(cd_estabelecimento, OBTER_ESTABELECIMENTO_ATIVO) = OBTER_ESTABELECIMENTO_ATIVO;	
		 
		 
		dt_diagnostico_novo_w	:= clock_timestamp();	
		 
		if (ds_lista_diagnostico_p IS NOT NULL AND ds_lista_diagnostico_p::text <> '') then 
			ds_lista_diagnostico_w := ds_lista_diagnostico_p;	
		 
			qt_contador_w := 0;
			while 	(ds_lista_diagnostico_w IS NOT NULL AND ds_lista_diagnostico_w::text <> '') loop 
				qt_contador_w := qt_contador_w + 1;
				 
				ie_pos_virgula_w	:= position(',' in ds_lista_diagnostico_w);
				tam_lista_w	:= length(ds_lista_diagnostico_w);				
								 
				if (ie_pos_virgula_w <> 0) then 
					dt_diagnostico_origem_w := to_date(substr(ds_lista_diagnostico_w,1,(ie_pos_virgula_w - 1)), 'dd/mm/yyyy hh24:mi:ss');
				else 
					dt_diagnostico_origem_w := to_date(ds_lista_diagnostico_w, 'dd/mm/yyyy hh24:mi:ss');
				end if;					
								 
				ds_lista_diagnostico_w	:= substr(ds_lista_diagnostico_w,ie_pos_virgula_w+1,tam_lista_w);
										 
				dt_diagnostico_novo_w	:= clock_timestamp() + qt_contador_w/86400;
		 
				insert 	into diagnostico_medico(nr_atendimento, 
								dt_diagnostico, 
								ie_tipo_diagnostico, 
								cd_medico, 
								dt_atualizacao, 
								nm_usuario, 
								ds_diagnostico, 
								ie_tipo_atendimento) 
							SELECT 	nr_atend_novo_w, 
								dt_diagnostico_novo_w, 
								ie_tipo_diagnostico, 
								cd_medico, 
								clock_timestamp(), 
								nm_usuario, 
								substr(ds_diagnostico,1,2000)ds_diagnostico, 
								ie_tipo_atendimento 
							from	diagnostico_medico 
							where	nr_atendimento = nr_atendimento_p 
							and	dt_diagnostico = dt_diagnostico_origem_w;
 
				open C05;
				loop 
				fetch C05 into	 
					c05_w;
				EXIT WHEN NOT FOUND; /* apply on C05 */
					begin 
					 
					insert into diagnostico_doenca(nr_atendimento, 
								   dt_diagnostico, 
								   cd_doenca, 
								   dt_atualizacao, 
								   nm_usuario, 
								   ds_diagnostico, 
								   qt_tempo, 
								   ie_unidade_tempo, 
								   ie_classificacao_doenca, 
								   ie_tipo_doenca) 
							values (nr_atend_novo_w, 
								dt_diagnostico_novo_w, 
								c05_w.cd_doenca, 
								c05_w.dt_atualizacao, 
								c05_w.nm_usuario, 
								c05_w.ds_diagnostico, 
								c05_w.qt_tempo, 
								c05_w.ie_unidade_tempo, 
								c05_w.ie_classificacao_doenca, 
								c05_w.ie_tipo_doenca);
					end;
				end loop;
				close C05;
		 
			end loop;
			 
		elsif (coalesce(ds_lista_diagnostico_p::text, '') = '') and (ie_duplica_diagnostico_w = 'S')	then 
			qt_contador_w := 0;
			open C04;
			loop 
			fetch C04 into	 
				c04_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin 
				qt_contador_w := qt_contador_w + 1;
				dt_diagnostico_novo_w := dt_diagnostico_novo_w + qt_contador_w/86400;
				insert 	into diagnostico_medico(nr_atendimento, 
								dt_diagnostico, 
								ie_tipo_diagnostico, 
								cd_medico, 
								dt_atualizacao, 
								nm_usuario, 
								ds_diagnostico, 
								ie_tipo_atendimento) 
						values (	nr_atend_novo_w, 
								dt_diagnostico_novo_w, 
								c04_w.ie_tipo_diagnostico, 
								c04_w.cd_medico, 
								c04_w.dt_atualizacao, 
								c04_w.nm_usuario, 
								c04_w.ds_diagnostico, 
								c04_w.ie_tipo_atendimento);
								 
				dt_diagnostico_origem_w := c04_w.dt_diagnostico;
									 
				open C05;
				loop 
				fetch C05 into	 
					c05_w;
				EXIT WHEN NOT FOUND; /* apply on C05 */
					begin 
					 
					insert into diagnostico_doenca(nr_atendimento, 
								   dt_diagnostico, 
								   cd_doenca, 
								   dt_atualizacao, 
								   nm_usuario, 
								   ds_diagnostico, 
								   qt_tempo, 
								   ie_unidade_tempo, 
								   ie_classificacao_doenca, 
								   ie_tipo_doenca) 
							values (nr_atend_novo_w, 
								dt_diagnostico_novo_w, 
								c05_w.cd_doenca, 
								c05_w.dt_atualizacao, 
								c05_w.nm_usuario, 
								c05_w.ds_diagnostico, 
								c05_w.qt_tempo, 
								c05_w.ie_unidade_tempo, 
								c05_w.ie_classificacao_doenca, 
								c05_w.ie_tipo_doenca);
					end;
				end loop;
				close C05;
 
				 
				end;
			end loop;
			close C04;
		 
		end if;
		if (ie_replica_proc_cih_w = 'S') then 
			begin 
			open C06;
			loop 
			fetch C06 into	 
				c06_w;
			EXIT WHEN NOT FOUND; /* apply on C06 */
				begin 
				insert 	into procedimento_paciente_cih(	nr_atendimento, 
									nr_sequencia, 
									cd_procedimento, 
									ie_origem_proced, 
									dt_atualizacao, 
									nm_usuario, 
									cd_cid_primario, 
									cd_cid_secundario, 
									cd_motivo_alta, 
									nr_seq_sus_proc_gen) 
								values ( nr_atend_novo_w, 
									c06_w.nr_sequencia, 
									c06_w.cd_procedimento, 
									c06_w.ie_origem_proced, 
									clock_timestamp(), 
									nm_usuario_p, 
									c06_w.cd_cid_primario, 
									c06_w.cd_cid_secundario, 
									c06_w.cd_motivo_alta, 
									c06_w.nr_seq_sus_proc_gen);
				 
				end;
			end loop;
			close C06;
			end;
		end if;
		 
	end if;				
end if;
nr_atend_novo_p := nr_atend_novo_w;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_atendimento_pac ( nr_atendimento_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, nr_atend_novo_p INOUT bigint, ds_lista_prescr_p text, ds_lista_diagnostico_p text) FROM PUBLIC;
