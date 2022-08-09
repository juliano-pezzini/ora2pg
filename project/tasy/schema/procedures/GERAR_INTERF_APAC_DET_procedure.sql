-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interf_apac_det (cd_estabelecimento_p bigint, nr_seq_protocolo_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_sequencia_w				bigint;
NR_APAC_W             	bigint;
CD_UNIDADE_SOLIC_W        	bigint;
CD_MEDICO_SOLIC_W         	varchar(10);
CD_PROC_PRINCIPAL_W        	bigint;
IE_ORIGEM_PROC_PRINC_W      	bigint;
DT_INICIO_VIGENCIA_W       	timestamp;
DT_FINAL_VIGENCIA_W        	timestamp;
IE_TIPO_APAC_W          	smallint;
NR_ATENDIMENTO_W         	bigint;
CD_UNIDADE_PRESTADORA_W      	bigint;
DT_EMISSAO_W           	timestamp;
CD_ORGAO_AUTORIZADOR_W      	bigint;
DT_ATUALIZACAO_W         	timestamp;
NM_USUARIO_W           	varchar(15);
CD_CPF_AUTORIZ_APAC_W       	bigint;
NR_AIH_TX_W            	bigint;
CD_PROC_TX_W           	bigint;
IE_ORIGEM_PROC_TX_W        	bigint;
DT_TX_W              	timestamp;
IE_RESULTADO_EXAME_W       	smallint;
CD_MOTIVO_COBRANCA_W       	smallint;
IE_TIPO_ATEND_APAC_W       	smallint;
SG_ESTADO_W         		pessoa_juridica.sg_estado%type;
CD_CPF_PACIENTE_W      		varchar(11);
NM_PACIENTE_W      		varchar(30);
UF_NACIONALIDADE_W      		valor_dominio.vl_dominio%type;
NM_MAE_W					varchar(30);
DS_ENDERECO_W				varchar(100);
NR_ENDERECO_W				varchar(5);
DS_COMPLEMENTO_W				varchar(10);
CD_CEP_W              varchar(15);
CD_MUNICIPIO_IBGE_W         varchar(6);
DT_NASCIMENTO_W          	timestamp;
IE_SEXO_W         		varchar(1);
DS_VARIAVEL_W				varchar(60);
NM_SOLICITANTE_W				varchar(30);
CD_CPF_SOLICITANTE_W			bigint;
DT_OCORRENCIA_W          	timestamp;
CD_CPF_DIRETOR_CLINICO_W		bigint;
NM_DIRETOR_CLINICO_W			varchar(30);
CD_DIRETOR_CLINICO_W			varchar(10);
NR_ROWNUM_W					integer;
CD_PROCEDIMENTO_W				bigint;
QT_PROCEDIMENTO_W				integer;
CD_ATIVIDADE_PROF_BPA_W			smallint;
DS_PROCEDIMENTOS_W			varchar(170);
DS_NOTAS_W					varchar(200);
IE_1						integer;
IE_2						integer;

 
C01 CURSOR FOR 
SELECT row_number() OVER () AS rownum, 
	 a.cd_procedimento, 
	 a.qt_procedimento, 
	 a.cd_atividade_prof_bpa 
from	 procedimento_paciente a 
where	 a.nr_atendimento		= nr_atendimento_p 
and	 a.nr_interno_conta	= nr_interno_conta_p 
and	 coalesce(a.cd_motivo_exc_conta::text, '') = '' 
order by a.nr_sequencia;

 
 

BEGIN 
/* Buscar parametros da APAC */
 
select c.sg_estado, 
	 a.cd_diretor_clinico, 
	 d.nr_cpf, 
	 substr(d.nm_pessoa_fisica,1,30) 
into STRICT	 sg_estado_w, 
	 cd_diretor_clinico_w, 
	 cd_cpf_diretor_clinico_w, 
	 nm_diretor_clinico_w 
FROM pessoa_juridica c, estabelecimento b, sus_parametros a
LEFT OUTER JOIN pessoa_fisica d ON (a.cd_diretor_clinico = d.cd_pessoa_fisica)
WHERE a.cd_estabelecimento 	= cd_estabelecimento_p and a.cd_estabelecimento 	= b.cd_estabelecimento and b.cd_cgc			= c.cd_cgc;
 
/* Buscar dados gerais da APAC */
 
select 
 	NR_APAC, 
	CD_UNIDADE_SOLIC, 
	CD_MEDICO_SOLIC, 
	CD_PROC_PRINCIPAL, 
	IE_ORIGEM_PROC_PRINC, 
	DT_INICIO_VIGENCIA, 
	DT_FINAL_VIGENCIA, 
	IE_TIPO_APAC, 
	NR_ATENDIMENTO, 
	CD_UNIDADE_PRESTADORA, 
	DT_EMISSAO, 
	CD_ORGAO_AUTORIZADOR, 
	CD_CPF_AUTORIZ_APAC, 
	NR_AIH_TX, 
	CD_PROC_TX, 
	IE_ORIGEM_PROC_TX, 
	DT_TX, 
	IE_RESULTADO_EXAME, 
	CD_MOTIVO_COBRANCA, 
	IE_TIPO_ATEND_APAC 
into STRICT 
	NR_APAC_W, 
	CD_UNIDADE_SOLIC_W, 
	CD_MEDICO_SOLIC_W, 
	CD_PROC_PRINCIPAL_W, 
	IE_ORIGEM_PROC_PRINC_W, 
	DT_INICIO_VIGENCIA_W, 
	DT_FINAL_VIGENCIA_W, 
	IE_TIPO_APAC_W, 
	NR_ATENDIMENTO_W, 
	CD_UNIDADE_PRESTADORA_W, 
	DT_EMISSAO_W, 
	CD_ORGAO_AUTORIZADOR_W, 
	CD_CPF_AUTORIZ_APAC_W, 
	NR_AIH_TX_W, 
	CD_PROC_TX_W, 
	IE_ORIGEM_PROC_TX_W, 
	DT_TX_W, 
	IE_RESULTADO_EXAME_W, 
	CD_MOTIVO_COBRANCA_W, 
	IE_TIPO_ATEND_APAC_W 
from	sus_apac 
where	nr_atendimento = nr_atendimento_p;
 
/* Buscar dados do paciente */
 
select 
	a.nr_cpf, 
	a.nm_paciente, 
	c.cd_unidade_federacao, 
	substr(obter_nome_contato(a.cd_pessoa_fisica,5),1,30) nm_mae, 
	d.ds_endereco, 
	d.nr_endereco, 
	d.ds_complemento, 
	d.cd_cep, 
	d.cd_municipio_ibge, 
	a.dt_nascimento, 
	a.ie_sexo, 
	coalesce(b.dt_obito,a.dt_alta) 
into STRICT 
	cd_cpf_paciente_w, 
	nm_paciente_w, 
	uf_nacionalidade_w, 
	nm_mae_w, 
	ds_endereco_w, 
	nr_endereco_w, 
	ds_complemento_w, 
	cd_cep_w, 
	cd_municipio_ibge_w, 
	dt_nascimento_w, 
	ie_sexo_w, 
	dt_ocorrencia_w 
FROM pessoa_fisica b
LEFT OUTER JOIN cep_localidade c ON (b.cd_nacionalidade = c.cd_localidade)
, atendimento_paciente_v a
LEFT OUTER JOIN compl_pessoa_fisica d ON (a.cd_pessoa_fisica = d.cd_pessoa_fisica AND 1 = d.ie_tipo_complemento)
WHERE a.nr_atendimento		= nr_atendimento_p and a.cd_pessoa_fisica	= b.cd_pessoa_fisica;
 
/* Buscar dados do solicitante */
 
begin 
select substr(nm_pessoa_fisica,1,30), 
	 nr_cpf 
into STRICT	 nm_solicitante_w, 
	 cd_cpf_solicitante_w 
from	 pessoa_fisica 
where	 cd_pessoa_fisica = cd_medico_solic_w;
exception 
	 when others then 
		nm_solicitante_w	:= nm_solicitante_w;
end;
 
/* MONTA VARIÁVEL APAC */
 
ds_variavel_w	:= ' ';
/* 13 - Terapia Renal Substitutiva */
 
if (ie_tipo_atend_apac_w	= 13) then 
	begin 
	select coalesce(to_char(a.dt_inicio_tratamento,'yyyymm'),'   ')|| 
		 coalesce(a.cd_cid_principal,'  ')||' '|| 
		 coalesce(a.cd_cid_secundario,'  ')||' '|| 
		 coalesce(a.ie_indicado_tx,' ')|| 
		 coalesce(a.ie_inscrito_tx,' ')|| 
		 coalesce(to_char(a.dt_inscricao_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_primeiro_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_segundo_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_terceiro_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.qt_tx_realizado),'1')|| 
		 coalesce(to_char(a.qt_creatinina),'  ')|| 
		 coalesce(to_char(a.qt_ureia_pre),'  ')|| 
		 coalesce(to_char(a.qt_ureia_pos),'  ')|| 
		 coalesce(a.ie_hepatite_c,'N')|| 
		 coalesce(a.ie_hbsag,'N')|| 
		 coalesce(a.ie_hiv,'N')|| 
		 coalesce(a.ie_hla,'N') 
	into STRICT 
		 ds_variavel_w 
	from	 sus_apac_trs a 
	where	 a.nr_apac	= nr_apac_w;
	exception 
   		when others then 
			ds_variavel_w	:= ' ';
	end;
end if;
 
/* 04 - Assistencia Farmaceutica */
 
if (ie_tipo_atend_apac_w	= 04) then 
	begin 
	select coalesce(to_char(a.dt_inicio_tratamento,'yyyymm'),'   ')|| 
		 coalesce(a.cd_cid_principal,'  ')||' '|| 
		 coalesce(a.cd_cid_secundario,'  ')||' '|| 
		 coalesce(a.ie_indicado_tx,' ')|| 
		 coalesce(a.ie_inscrito_tx,' ')|| 
		 coalesce(to_char(a.dt_inscricao_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_primeiro_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_segundo_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_terceiro_tx,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.qt_tx_realizado),'1')|| 
		 '        ' 
	into STRICT 
		 ds_variavel_w 
	from	 sus_apac_af a 
	where	 a.nr_apac	= nr_apac_w;
	exception 
   		when others then 
			ds_variavel_w	:= ' ';
	end;
end if;
 
/* 14 - Radioterapia */
 
if (ie_tipo_atend_apac_w	= 14) then 
	begin 
	select coalesce(to_char(a.dt_inicio_tratamento,'yyyymm'),'   ')|| 
		 coalesce(a.cd_cid_principal,'  ')||' '|| 
		 coalesce(a.cd_cid_secundario,'  ')||' '|| 
		 coalesce(a.ie_metastase,' ')|| 
		 coalesce(a.ie_finalidade,' ')|| 
		 coalesce(to_char(a.dt_diagnostico,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_pri_tratamento,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_seg_tratamento,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_ter_tratamento,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.cd_estagio),' ')|| 
		 coalesce(to_char(a.qt_area_irradiada1),'  ')|| 
		 coalesce(to_char(a.qt_area_irradiada2),'  ')|| 
		 coalesce(to_char(a.qt_area_irradiada3),'  ')|| 
		 coalesce(to_char(a.qt_campos_planejado),'  ') 
	into STRICT 
		 ds_variavel_w 
	from	 sus_apac_radio a 
	where	 a.nr_apac	= nr_apac_w;
	exception 
   		when others then 
			ds_variavel_w	:= ' ';
	end;
end if;
 
/* 15 - Qumioterapia */
 
if (ie_tipo_atend_apac_w	= 15) then 
	begin 
	select coalesce(to_char(a.dt_inicio_tratamento,'yyyymm'),'   ')|| 
		 coalesce(a.cd_cid_principal,'  ')||' '|| 
		 coalesce(a.cd_cid_secundario,'  ')||' '|| 
		 coalesce(a.ie_metastase,' ')||' '|| 
		 coalesce(to_char(a.dt_diagnostico,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_pri_tratamento,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_seg_tratamento,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.dt_ter_tratamento,'yyyymm'),'   ')|| 
		 coalesce(to_char(a.cd_estagio),' ')|| 
		 coalesce(to_char(a.qt_ciclos),'  ')|| 
		 '      ' 
	into STRICT 
		 ds_variavel_w 
	from	 sus_apac_quimio a 
	where	 a.nr_apac	= nr_apac_w;
	exception 
   		when others then 
			ds_variavel_w	:= ' ';
	end;
end if;
 
 
/* TRATAR PROCEDIMENTOS REALIZADOS */
 
ds_procedimentos_w := '';
ds_notas_w 		 := '';
ie_1			 := 0;
ie_2			 := 0;
OPEN C01;
LOOP 
   FETCH C01 	into 
			nr_rownum_w, 
			cd_procedimento_w, 
			qt_procedimento_w, 
			cd_atividade_prof_bpa_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN 
		ds_procedimentos_w	:= 	ds_procedimentos_w|| 
							to_char(cd_procedimento_w)|| 
							to_char(cd_atividade_prof_bpa_w)|| 
							to_char(qt_procedimento_w);
		ie_1	:= ie_1 + 1;
		 
		if (ie_1 = 10) then 
			BEGIN 
			ie_1	:= 0;			
			ie_2	:= ie_2 + 1;
			begin 
			/* Buscar sequence */
 
			select nextval('w_interf_apac_det_seq') 
			into STRICT	 nr_sequencia_w 
			;
 
			insert into W_INTERF_APAC_DET( 
					NR_SEQUENCIA,		 
					DT_ATUALIZACAO, 
					NM_USUARIO, 
					UF_UNIDADE, 
					CD_UNIDADE_APAC, 
					NR_APAC, 
					DT_EMISSAO_APAC, 
					DT_INICIO_VIGENCIA, 
					DT_FINAL_VIGENCIA, 
					CD_TIPO_ATENDIMENTO, 
					IE_TIPO_APAC, 
					CD_CPF_PACIENTE, 
					NM_PACIENTE, 
					UF_NACIONALIDADE, 
					NM_MAE, 
					DS_ENDERECO, 
					NR_ENDERECO, 
					DS_COMPLEMENTO, 
					CD_CEP, 
					CD_MUNICIPIO, 
					DT_NASCIMENTO, 
					IE_SEXO, 
					DS_VARIAVEL, 
					CD_CPF_SOLICITANTE, 
					NM_SOLICITANTE, 
					DS_PROCEDIMENTOS, 
					CD_MOTIVO_COBRANCA, 
					DT_OCORRENCIA, 
					CD_CPF_DIRETOR_CLINICO, 
					NM_DIRETOR_CLINICO, 
					IE_CONTINUACAO, 
					DS_NOTAS) 
			Values (nr_sequencia_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					sg_estado_w, 
					CD_UNIDADE_PRESTADORA_W, 
					NR_APAC_W, 
					DT_EMISSAO_W, 
					DT_INICIO_VIGENCIA_W, 
					DT_FINAL_VIGENCIA_W, 
					IE_TIPO_ATEND_APAC_W, 
					IE_TIPO_APAC_W, 
					cd_cpf_paciente_w, 
					nm_paciente_w, 
					uf_nacionalidade_w, 
					nm_mae_w, 
					ds_endereco_w, 
					nr_endereco_w, 
					ds_complemento_w, 
					cd_cep_w, 
					cd_municipio_ibge_w, 
					dt_nascimento_w, 
					ie_sexo_w, 
					ds_variavel_w, 
					cd_cpf_solicitante_w, 
					nm_solicitante_w, 
					ds_procedimentos_w, 
					cd_motivo_cobranca_w, 
					dt_ocorrencia_w, 
					cd_cpf_diretor_clinico_w, 
					nm_diretor_clinico_w, 
					ie_2, 
					ds_notas_w);
			end;
			ds_procedimentos_w := '';
			END;
		end if;	
		END;
END LOOP;
CLOSE C01;
 
 
if (ie_1 < 10) then 
	BEGIN 
	ie_2	:= ie_2 + 1;
	begin 
	/* Buscar sequence */
 
	select nextval('w_interf_apac_det_seq') 
	into STRICT	 nr_sequencia_w 
	;
 
	insert into W_INTERF_APAC_DET( 
			NR_SEQUENCIA,		 
			DT_ATUALIZACAO, 
			NM_USUARIO, 
			UF_UNIDADE, 
			CD_UNIDADE_APAC, 
			NR_APAC, 
			DT_EMISSAO_APAC, 
			DT_INICIO_VIGENCIA, 
			DT_FINAL_VIGENCIA, 
			CD_TIPO_ATENDIMENTO, 
			IE_TIPO_APAC, 
			CD_CPF_PACIENTE, 
			NM_PACIENTE, 
			UF_NACIONALIDADE, 
			NM_MAE, 
			DS_ENDERECO, 
			NR_ENDERECO, 
			DS_COMPLEMENTO, 
			CD_CEP, 
			CD_MUNICIPIO, 
			DT_NASCIMENTO, 
			IE_SEXO, 
			DS_VARIAVEL, 
			CD_CPF_SOLICITANTE, 
			NM_SOLICITANTE, 
			DS_PROCEDIMENTOS, 
			CD_MOTIVO_COBRANCA, 
			DT_OCORRENCIA, 
			CD_CPF_DIRETOR_CLINICO, 
			NM_DIRETOR_CLINICO, 
			IE_CONTINUACAO, 
			DS_NOTAS) 
	Values (nr_sequencia_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			sg_estado_w, 
			CD_UNIDADE_PRESTADORA_W, 
			NR_APAC_W, 
			DT_EMISSAO_W, 
			DT_INICIO_VIGENCIA_W, 
			DT_FINAL_VIGENCIA_W, 
			IE_TIPO_ATEND_APAC_W, 
			IE_TIPO_APAC_W, 
			cd_cpf_paciente_w, 
			nm_paciente_w, 
			uf_nacionalidade_w, 
			nm_mae_w, 
			ds_endereco_w, 
			nr_endereco_w, 
			ds_complemento_w, 
			cd_cep_w, 
			cd_municipio_ibge_w, 
			dt_nascimento_w, 
			ie_sexo_w, 
			ds_variavel_w, 
			cd_cpf_solicitante_w, 
			nm_solicitante_w, 
			ds_procedimentos_w, 
			cd_motivo_cobranca_w, 
			dt_ocorrencia_w, 
			cd_cpf_diretor_clinico_w, 
			nm_diretor_clinico_w, 
			ie_2, 
			ds_notas_w);
			end;
	END;
end if;
 
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interf_apac_det (cd_estabelecimento_p bigint, nr_seq_protocolo_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
