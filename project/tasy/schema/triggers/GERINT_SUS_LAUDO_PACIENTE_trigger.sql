-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gerint_sus_laudo_paciente ON sus_laudo_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gerint_sus_laudo_paciente() RETURNS trigger AS $BODY$
declare

nr_seq_forma_chegada_w			atendimento_paciente.NR_SEQ_FORMA_CHEGADA%type;
frequencia_cardiaca_w			atendimento_sinal_vital.qt_freq_cardiaca%type;
frequencia_respiratoria_w		atendimento_sinal_vital.qt_freq_resp%type;
pressao_arterial_maxima_w		atendimento_sinal_vital.qt_pa_sistolica%type;
pressao_arterial_minima_w		atendimento_sinal_vital.qt_pa_diastolica%type;
temperatura_w					atendimento_sinal_vital.qt_temp%type;
saturacao_o2_w					atendimento_sinal_vital.qt_saturacao_o2%type;
ie_nivel_consciencia_w			atendimento_sinal_vital.ie_nivel_consciencia%type;
fluxo_w							atendimento_monit_resp.qt_fluxo_insp%type;
fiO2_w							atendimento_monit_resp.qt_fio2%type;
satO2_w							atendimento_monit_resp.qt_saturacao_o2%type;
peep_w							atendimento_monit_resp.qt_peep%type;
ie_disp_resp_esp_w				atendimento_monit_resp.ie_disp_resp_esp%type;
tipo_internacao_w 				conversao_meio_externo.cd_externo%type;
tipo_acesso_w					conversao_meio_externo.cd_externo%type;
tipo_leito_w					conversao_meio_externo.cd_externo%type;
sensorio_w						conversao_meio_externo.cd_externo%type;
suporteO2_w						conversao_meio_externo.cd_externo%type;
cartao_sus_w 					pessoa_fisica.nr_cartao_nac_sus%type;
cpf_profissional_solicitante_w	pessoa_fisica.nr_cpf%type;
tipo_protocolo_origem_w			varchar(255);
numero_protocolo_origem_w		varchar(12);
cor_w							varchar(255);
debito_urinario_w				varchar(60);
dialise_w						varchar(3);
internacao_propria_w			varchar(3);
ie_regulacao_gerint_w			parametro_atendimento.ie_regulacao_gerint%type;

ie_condicao_w					gerint_solic_internacao.ie_condicao%type;
ie_carater_inter_sus_origem_w	atendimento_paciente.ie_carater_inter_sus%type;

nr_seq_solic_internacao_w		GERINT_SOLIC_INTERNACAO.nr_sequencia%type;
ds_sep_bv_w						varchar(50);

--variaveis do evento automático para integração
seq_gerint_evento_w		GERINT_EVENTO_INTEGRACAO.nr_sequencia%type;
nr_cpf_paciente_w		pessoa_fisica.nr_cpf%type;
BEGIN

	--Verifica se utiliza regulação de leitos para o estado do Rio Grande do Sul.
	select	coalesce(max(ie_regulacao_gerint),'N')
	into STRICT	ie_regulacao_gerint_w
	from	parametro_atendimento
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

	if ((OLD.dt_liberacao is null AND NEW.dt_liberacao is not null) and (ie_regulacao_gerint_w = 'S') and (NEW.ie_classificacao = 1)) then

		--Obter valores da ATENDIMENTO_PACIENTE
		select	max(NR_SEQ_FORMA_CHEGADA),
				max(IE_CARATER_INTER_SUS)
		into STRICT	nr_seq_forma_chegada_w,
				ie_carater_inter_sus_origem_w
		from	atendimento_paciente
		where	nr_atendimento = NEW.nr_atendimento;

		--Obter valores da tabela ATENDIMENTO_SINAL_VITAL
		select	max(qt_freq_cardiaca),
				max(qt_freq_resp),
				max(qt_pa_sistolica),
				max(qt_pa_diastolica),
				max(qt_temp),
				max(qt_saturacao_o2),
				max(ie_nivel_consciencia)
		into STRICT	frequencia_cardiaca_w,
				frequencia_respiratoria_w,
				pressao_arterial_maxima_w,
				pressao_arterial_minima_w,
				temperatura_w,
				saturacao_o2_w,
				ie_nivel_consciencia_w
		from	atendimento_sinal_vital
		where	nr_sequencia = (SELECT 	max(nr_sequencia)
								from	atendimento_sinal_vital
								where	nr_atendimento = NEW.nr_atendimento
								and		dt_liberacao is not null
								and		dt_inativacao is null);

		--Obter valores da tabela ATENDIMENTO_MONIT_RESP
		select	max(qt_fluxo_insp),
				max(qt_fio2),
				max(qt_saturacao_o2),
				max(qt_peep),
				max(ie_disp_resp_esp)
		into STRICT	fluxo_w,
				fiO2_w,
				satO2_w,
				peep_w,
				ie_disp_resp_esp_w
		from	atendimento_monit_resp
		where	nr_sequencia = (SELECT 	max(nr_sequencia)
								from	atendimento_monit_resp
								where	nr_atendimento = NEW.nr_atendimento
								and		dt_liberacao is not null
								and		dt_inativacao is null);

		--Obter valores da tabela HD_PRESCRICAO
		SELECT 	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	dialise_w
		FROM   	prescr_medica p,
				hd_prescricao h
		WHERE	p.nr_prescricao = h.nr_prescricao
		and		p.nr_atendimento = NEW.nr_atendimento
		and		dt_liberacao is not null
		and		dt_suspensao is null;

		--Obter valores da conversão meio externo.
		tipo_internacao_w 	:= obter_conversao_externa_int(null, 'GERINT_SOLIC_INTERNACAO',	'IE_CARATER_INTER_SUS', coalesce(NEW.ie_carater_inter_sus,ie_carater_inter_sus_origem_w), 	'GERINT');
		tipo_acesso_w		:= obter_conversao_externa_int(null, 'GERINT_SOLIC_INTERNACAO',	'NR_SEQ_FORMA_CHEGADA', nr_seq_forma_chegada_w, 	'GERINT');
		tipo_leito_w		:= obter_conversao_externa_int(null, 'GERINT_SOLIC_INTERNACAO',	'IE_TIPO_LEITO', 		NEW.ie_tipo_leito, 		'GERINT');
		sensorio_w			:= obter_conversao_externa_int(null, 'GERINT_SOLIC_INTERNACAO',	'IE_NIVEL_CONSCIENCIA', ie_nivel_consciencia_w, 	'GERINT');
		suporteO2_w			:= obter_conversao_externa_int(null, 'GERINT_SOLIC_INTERNACAO',	'IE_DISP_RESP_ESP', 	ie_disp_resp_esp_w, 		'GERINT');

		--Obter valores de function
		cartao_sus_w 					:= substr(obter_dados_pf(NEW.cd_pessoa_fisica,'CNS'),1,15);
		cpf_profissional_solicitante_w 	:= obter_dados_pf(NEW.cd_medico_requisitante,'CPF');
		tipo_protocolo_origem_w 		:= '';
		numero_protocolo_origem_w 		:= '';
		cor_w 							:= ''; --Não será informado;
		debito_urinario_w 				:= 'NAO_AVALIADO';
		internacao_propria_w			:= 'S'; -- sempre que gerado pela Laudo SUS, vai gerar como internação própria;
		if (cartao_sus_w is null) and (cpf_profissional_solicitante_w is null) then
			ie_condicao_w := 'P';
		end if;

		select 	nextval('gerint_solic_internacao_seq')
		into STRICT	nr_seq_solic_internacao_w
		;

		insert into GERINT_SOLIC_INTERNACAO(
											nr_sequencia,
											cd_estabelecimento,
											dt_atualizacao,
											nm_usuario,
											dt_atualizacao_nrec,
											nm_usuario_nrec,
											cd_pessoa_fisica,
											nr_cartao_sus,
											ds_tipo_internacao,
											ie_protocolo_origem,
											nr_protocolo_origem,
											nr_seq_forma_chegada,
											ds_tipo_acesso,
											ie_internacao_propria,
											ie_tipo_leito,
											ds_tipo_leito,
											cd_cid_principal,
											cd_medico_requisitante,
											nr_cpf_medico_req,
											ds_sinal_sintoma,
											ds_condicao_justifica,
											ds_cor,
											qt_freq_cardiaca,
											qt_freq_resp,
											qt_pa_sistolica,
											qt_pa_diastolica,
											qt_temp,
											qt_saturacao_o2,
											ie_nivel_consciencia,
											ds_debito_urinario,
											cd_procedimento,
											ie_origem_proced,
											ie_dialise,
											ie_disp_resp_esp,
											qt_fluxo_insp,
											qt_fio2,
											qt_sat_o2,
											qt_peep,
											ie_situacao,
											nr_atendimento_origem,
											ie_carater_inter_sus,
											nr_cpf_paciente,
											nm_pessoa_fisica,
											ie_condicao,
											ie_sexo,
											qt_idade,
											ds_endereco_pf,
											ds_municipio_pf,
											CD_MUNICIPIO_IBGE
										) values (
											nr_seq_solic_internacao_w,
											wheb_usuario_pck.get_cd_estabelecimento,
											LOCALTIMESTAMP,
											wheb_usuario_pck.get_nm_usuario,
											LOCALTIMESTAMP,
											wheb_usuario_pck.get_nm_usuario,
											coalesce(NEW.cd_pessoa_fisica, obter_pessoa_atendimento(NEW.nr_atendimento_origem,'C')),
											cartao_sus_w,
											tipo_internacao_w,
											tipo_protocolo_origem_w,
											numero_protocolo_origem_w,
											nr_seq_forma_chegada_w,
											tipo_acesso_w,
											internacao_propria_w,
											NEW.ie_tipo_leito,
											tipo_leito_w,
											NEW.cd_cid_principal,
											NEW.cd_medico_requisitante,
											cpf_profissional_solicitante_w,
											substr(NEW.ds_sinal_sintoma,1,2000),
											substr(NEW.ds_condicao_justifica,1,2000),
											cor_w,
											frequencia_cardiaca_w,
											frequencia_respiratoria_w,
											pressao_arterial_maxima_w,
											pressao_arterial_minima_w,
											temperatura_w,
											saturacao_o2_w,
											sensorio_w,
											debito_urinario_w,
											NEW.cd_procedimento_solic,
											NEW.ie_origem_proced,
											dialise_w,
											suporteO2_w,
											fluxo_w,
											fiO2_w,
											satO2_w,
											peep_w,
											'E',
											NEW.nr_atendimento_origem,
											coalesce(NEW.ie_carater_inter_sus,ie_carater_inter_sus_origem_w),
											obter_dados_pf(NEW.cd_pessoa_fisica,'CPF'),
											obter_nome_pf(NEW.cd_pessoa_fisica),
											ie_condicao_w,
											obter_dados_pf(NEW.cd_pessoa_fisica,'SE'),
											obter_dados_pf(NEW.cd_pessoa_fisica,'I'),
											obter_endereco_pf(NEW.cd_pessoa_fisica,'END'),
											obter_municipio_pf(NEW.cd_pessoa_fisica),
											substr(OBTER_DADOS_COMPL_PF(NEW.cd_pessoa_fisica,'M'),1,6));

		--Dispara o evento automaticamente para integração.
		select	nextval('gerint_evento_integracao_seq')
		into STRICT	seq_gerint_evento_w
		;

		nr_cpf_paciente_w := obter_dados_pf(NEW.cd_pessoa_fisica,'CPF');

		insert into GERINT_EVENTO_INTEGRACAO(	NR_SEQUENCIA,
												NM_USUARIO,
												NM_PESSOA_FISICA,
												IE_SITUACAO,
												ID_EVENTO,
												DT_ATUALIZACAO_NREC,
												DT_ATUALIZACAO,
												CD_ESTABELECIMENTO,
												CD_PESSOA_FISICA,
												NR_SEQ_SOLIC_INTER
											) values (
												seq_gerint_evento_w,
												wheb_usuario_pck.get_nm_usuario,
												obter_nome_pf(NEW.cd_pessoa_fisica),
												'N',
												9,
												LOCALTIMESTAMP,
												LOCALTIMESTAMP,
												wheb_usuario_pck.get_cd_estabelecimento,
												NEW.cd_pessoa_fisica,
												nr_seq_solic_internacao_w);

		insert into GERINT_EVENTO_INT_DADOS(	NR_SEQ_EVENTO,
												NR_CARTAO_SUS,
												DS_TIPO_INTERNACAO,
												DS_TIPO_PROTOCOLO_ORIGEM,
												NR_PROTOCOLO_ORIGEM,
												DS_TIPO_ACESSO,
												IE_INTERNACAO_PROPRIA,
												DS_TIPO_LEITO,
												CD_CID_PRINCIPAL,
												NR_CPF_PROF_SOLICITANTE,
												DS_SINAIS_SINTOMAS,
												DS_JUSTIFICATIVA_INTERNACAO,
												DS_COR,
												QT_FREQ_CARDIACA,
												QT_FREQ_RESPIRATORIA,
												QT_PRESSAO_ART_MAXIMA,
												QT_PRESSAO_ART_MINIMA,
												QT_TEMPERATURA,
												QT_SATURACAO_O2,
												DS_NIVEL_CONSCIENCIA,
												DS_DEBITO_URINARIO,
												CD_PROCEDIMENTO,
												IE_DIALISE,
												DS_SUPORTE_O2,
												QT_FLUXO,
												QT_FIO2,
												QT_SAT_O2,
												QT_PEEP,
												NR_CPF_PACIENTE,
												DS_CONDICAO,
												NM_PESSOA_FISICA,
												DS_SEXO_PF,
												QT_IDADE_PF,
												DS_ENDERECO_PF,
												DS_MUNICIPIO_RESIDENCIA_PF,
												IE_TIPO_LEITO,
												CD_MUNICIPIO_IBGE
											)
											SELECT
												seq_gerint_evento_w,
												cartao_sus_w,
												obter_conversao_externa_int(null,'GERINT_SOLIC_INTERNACAO','IE_CARATER_INTER_SUS',coalesce(NEW.ie_carater_inter_sus,ie_carater_inter_sus_origem_w),'GERINT'),
												Gerint_desc_de_para(tipo_protocolo_origem_w),
												numero_protocolo_origem_w,
												Obter_conversao_externa_int(null,'GERINT_SOLIC_INTERNACAO','NR_SEQ_FORMA_CHEGADA',nr_seq_forma_chegada_w,'GERINT'),
												internacao_propria_w,
												obter_conversao_externa_int(null,'GERINT_SOLIC_INTERNACAO','IE_TIPO_LEITO',NEW.ie_tipo_leito,'GERINT'),
												NEW.cd_cid_principal,
												cpf_profissional_solicitante_w,
												substr(NEW.ds_sinal_sintoma,1,2000),
												substr(NEW.ds_condicao_justifica,1,2000),
												cor_w,
												frequencia_cardiaca_w,
												frequencia_respiratoria_w,
												pressao_arterial_maxima_w,
												pressao_arterial_minima_w,
												temperatura_w,
												saturacao_o2_w,
												obter_conversao_externa_int(null,'GERINT_SOLIC_INTERNACAO','IE_NIVEL_CONSCIENCIA',sensorio_w,'GERINT'),
												debito_urinario_w,
												NEW.cd_procedimento_solic,
												dialise_w,
												obter_conversao_externa_int(null,'GERINT_SOLIC_INTERNACAO','IE_DISP_RESP_ESP',suporteO2_w,'GERINT'),
												fluxo_w,
												fiO2_w,
												satO2_w,
												peep_w,
												CASE WHEN cartao_sus_w IS NULL THEN nr_cpf_paciente_w  ELSE null END , --não enviar se possuir CNS
												CASE WHEN cartao_sus_w IS NULL THEN obter_conversao_externa_int(null,'GERINT_SOLIC_INTERNACAO','IE_CONDICAO',ie_condicao_w,'GERINT')  ELSE null END , --enviar somente se não possuir CNS
												CASE WHEN ie_condicao_w='R' THEN obter_nome_pf(NEW.cd_pessoa_fisica)  ELSE CASE WHEN cartao_sus_w IS NULL THEN CASE WHEN nr_cpf_paciente_w IS NULL THEN obter_nome_pf(NEW.cd_pessoa_fisica)  ELSE null END   ELSE null END  END , --não enviar se possuir CNS/CPF
												CASE WHEN cartao_sus_w IS NULL THEN CASE WHEN nr_cpf_paciente_w IS NULL THEN CASE WHEN obter_dados_pf(NEW.cd_pessoa_fisica,'SE')='F' THEN 'FEMININO' WHEN obter_dados_pf(NEW.cd_pessoa_fisica,'SE')='M' THEN 'MASCULINO'  ELSE null END   ELSE null END   ELSE null END , --não enviar se possuir CNS/CPF
												CASE WHEN cartao_sus_w IS NULL THEN CASE WHEN nr_cpf_paciente_w IS NULL THEN obter_dados_pf(NEW.cd_pessoa_fisica,'I')  ELSE null END   ELSE null END , --não enviar se possuir CNS/CPF
												CASE WHEN cartao_sus_w IS NULL THEN CASE WHEN nr_cpf_paciente_w IS NULL THEN obter_endereco_pf(NEW.cd_pessoa_fisica,'END')  ELSE null END   ELSE null END , --não enviar se possuir CNS/CPF
												CASE WHEN cartao_sus_w IS NULL THEN CASE WHEN nr_cpf_paciente_w IS NULL THEN obter_municipio_pf(NEW.cd_pessoa_fisica)  ELSE null END   ELSE null END , --não enviar se possuir CNS/CPF
												NEW.IE_TIPO_LEITO,
												substr(OBTER_DADOS_COMPL_PF(NEW.cd_pessoa_fisica,'M'),1,6)
											;

		update	GERINT_SOLIC_INTERNACAO
		set		IE_SITUACAO	 		= 'O',
				DT_GERACAO_EVENTO	= LOCALTIMESTAMP,
				NM_USUARIO 			= wheb_usuario_pck.get_nm_usuario,
				DT_ATUALIZACAO 		= LOCALTIMESTAMP
		where	nr_sequencia 		= nr_seq_solic_internacao_w;
	end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gerint_sus_laudo_paciente() FROM PUBLIC;

CREATE TRIGGER gerint_sus_laudo_paciente
	AFTER INSERT OR UPDATE ON sus_laudo_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gerint_sus_laudo_paciente();

