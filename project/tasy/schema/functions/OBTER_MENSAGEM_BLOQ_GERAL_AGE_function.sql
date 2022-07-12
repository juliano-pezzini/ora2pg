-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mensagem_bloq_geral_age (nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE


nr_tam_maximo_w		bigint := 4000;
ds_mensagem_w		varchar(4000) := '';
ds_mensagem_campo_w	varchar(4000) := '';
ds_agenda_w		varchar(255);
ds_classif_exame_w	agenda_paciente_classif.ds_classificacao%type;
ds_motivo_bloq_w	varchar(4000);

  regra RECORD;

BEGIN
for regra in (SELECT * from agenda_bloqueio_geral where nr_sequencia = nr_seq_regra_p) loop
	if (regra.CD_ESTABELECIMENTO IS NOT NULL AND regra.CD_ESTABELECIMENTO::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046957) ||' '|| obter_nome_estab(regra.CD_ESTABELECIMENTO),1,nr_tam_maximo_w); --Estabelecimento
	end if;
	if (regra.CD_TIPO_AGENDA IS NOT NULL AND regra.CD_TIPO_AGENDA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046958) ||' '|| obter_valor_dominio(34,regra.CD_TIPO_AGENDA),1,nr_tam_maximo_w); --Tipo de agenda
	end if;
	if (regra.CD_AGENDA IS NOT NULL AND regra.CD_AGENDA::text <> '') then
		SELECT 	max(SUBSTR(obter_valor_dominio(34, a.cd_tipo_agenda)||' - '|| CASE WHEN a.cd_tipo_agenda=5 THEN  CASE WHEN coalesce(a.ie_ordenacao::text, '') = '' THEN  a.ds_agenda  ELSE SUBSTR(obter_desc_agenda_servico(a.cd_estabelecimento, a.cd_agenda, a.ie_ordenacao),1,255) END  WHEN a.cd_tipo_agenda=2 THEN     CASE WHEN coalesce(a.ie_desc_curta_exame,'N')='S' THEN  coalesce(a.ds_curta,a.ds_agenda)  ELSE a.ds_agenda END   ELSE SUBSTR(obter_nome_medico_combo_agcons(a.cd_estabelecimento, a.cd_agenda, a.cd_tipo_agenda, CASE WHEN coalesce(a.ie_ordenacao::text, '') = '' THEN  obter_parametro_funcao(898,51,wheb_usuario_pck.get_nm_usuario)   ELSE a.ie_ordenacao END ),1,240) END ,1,255)) ds
		INTO STRICT	ds_agenda_w
		FROM 	agenda a
		WHERE 	a.cd_agenda = regra.CD_AGENDA;
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046959) ||' '|| ds_agenda_w,1,nr_tam_maximo_w); --Agenda
	end if;
	if (regra.CD_PESSOA_FISICA IS NOT NULL AND regra.CD_PESSOA_FISICA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046960) ||' '|| obter_nome_pf(regra.CD_PESSOA_FISICA),1,nr_tam_maximo_w); --Profissional
	end if;
	if (regra.CD_ESPEC_MEDICA IS NOT NULL AND regra.CD_ESPEC_MEDICA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046961) ||' '|| Obter_Desc_Espec_medica(regra.CD_ESPEC_MEDICA),1,nr_tam_maximo_w); --Especialidade Medica
	end if;
	if (regra.CD_SETOR_ATENDIMENTO IS NOT NULL AND regra.CD_SETOR_ATENDIMENTO::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046962) ||' '|| obter_ds_setor_atendimento(regra.CD_SETOR_ATENDIMENTO),1,nr_tam_maximo_w); --Setor de Atendimento
	end if;
	if (regra.IE_CLASSIF_AGENDA IS NOT NULL AND regra.IE_CLASSIF_AGENDA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046963) ||' '|| obter_Desc_classif_agecon(regra.IE_CLASSIF_AGENDA),1,nr_tam_maximo_w); --Classificacao das agendas de consulta e servico
	end if;
	if (regra.NR_SEQ_CLASSIF_AGENDA IS NOT NULL AND regra.NR_SEQ_CLASSIF_AGENDA::text <> '') then
		select 	max(ds_classificacao)
		into STRICT	ds_classif_exame_w
		from 	agenda_paciente_classif
		where	nr_sequencia = regra.NR_SEQ_CLASSIF_AGENDA;
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046964) ||' '|| ds_classif_exame_w,1,nr_tam_maximo_w); --Classificacao da agenda de exame
	end if;
	if (regra.NR_SEQ_PROC_INTERNO IS NOT NULL AND regra.NR_SEQ_PROC_INTERNO::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046965) ||' '|| OBTER_DESC_PROC_INTERNO(regra.NR_SEQ_PROC_INTERNO),1,nr_tam_maximo_w); --Procedimento interno
	end if;
	if (regra.CD_PROCEDIMENTO IS NOT NULL AND regra.CD_PROCEDIMENTO::text <> '') and (regra.IE_ORIGEM_PROCED IS NOT NULL AND regra.IE_ORIGEM_PROCED::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046966) ||' '|| OBTER_DESC_PROCEDIMENTO(regra.CD_PROCEDIMENTO, regra.IE_ORIGEM_PROCED),1,nr_tam_maximo_w); --Procedimento
	end if;
	if (regra.CD_GRUPO_PROC IS NOT NULL AND regra.CD_GRUPO_PROC::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046967) ||' '|| OBTER_DESC_GRUPO_PROC(regra.CD_GRUPO_PROC),1,nr_tam_maximo_w); --Grupo do procedimento
	end if;
	if (regra.CD_ESPECIALIDADE IS NOT NULL AND regra.CD_ESPECIALIDADE::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046968) ||' '|| OBTER_DESC_ESPECIALIDADE_PROC(regra.CD_ESPECIALIDADE),1,nr_tam_maximo_w); --Especialidade procedimento
	end if;
	if (regra.CD_AREA_PROCEDIMENTO IS NOT NULL AND regra.CD_AREA_PROCEDIMENTO::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046969) ||' '|| OBTER_DESC_AREA_PROCEDIMENTO(regra.CD_AREA_PROCEDIMENTO),1,nr_tam_maximo_w); --Area do procedimento
	end if;
	if (regra.IE_DIA_SEMANA IS NOT NULL AND regra.IE_DIA_SEMANA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046970) ||' '|| obter_valor_dominio(35,regra.IE_DIA_SEMANA),1,nr_tam_maximo_w); --Dia da semana
	end if;
	if (regra.DT_INICIO_VIGENCIA IS NOT NULL AND regra.DT_INICIO_VIGENCIA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046971) ||' '|| PKG_DATE_FORMATERS_TZ.TO_VARCHAR(regra.DT_INICIO_VIGENCIA, 'shortDate', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),1,nr_tam_maximo_w); --Inicio de vigencia
	end if;
	if (regra.DT_FIM_VIGENCIA IS NOT NULL AND regra.DT_FIM_VIGENCIA::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046972) ||' '|| PKG_DATE_FORMATERS_TZ.TO_VARCHAR(regra.DT_FIM_VIGENCIA, 'shortDate', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),1,nr_tam_maximo_w); --Fim de vigencia
	end if;
	if (regra.HR_INICIAL IS NOT NULL AND regra.HR_INICIAL::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046973) ||' '|| PKG_DATE_FORMATERS_TZ.TO_VARCHAR(regra.HR_INICIAL, 'shortTime', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),1,nr_tam_maximo_w); --Horario inicial
	end if;
	if (regra.HR_FINAL IS NOT NULL AND regra.HR_FINAL::text <> '') then
		ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
						wheb_mensagem_pck.get_texto(1046974) ||' '|| PKG_DATE_FORMATERS_TZ.TO_VARCHAR(regra.HR_FINAL, 'shortTime', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),1,nr_tam_maximo_w); --Horario Final
	end if;
	
	if (regra.IE_MOTIVO_BLOQUEIO IS NOT NULL AND regra.IE_MOTIVO_BLOQUEIO::text <> '') then
		select max(ds_expressao)
		into STRICT ds_motivo_bloq_w
		from valor_dominio_v
		where cd_dominio = 1007
		and vl_dominio = regra.IE_MOTIVO_BLOQUEIO;
		
		if (ds_motivo_bloq_w IS NOT NULL AND ds_motivo_bloq_w::text <> '') then
			ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
							wheb_mensagem_pck.get_texto(1075962) ||' '|| ds_motivo_bloq_w,1,nr_tam_maximo_w);
		end if;
	end if;

	if (regra.NR_SEQ_MOTIVO_BLOQ_AG IS NOT NULL AND regra.NR_SEQ_MOTIVO_BLOQ_AG::text <> '') then
		select   max(a.ds_motivo)
		into STRICT     ds_motivo_bloq_w		
		from     agenda_motivo a
		where	 a.nr_sequencia = regra.NR_SEQ_MOTIVO_BLOQ_AG;		
		
		if (ds_motivo_bloq_w IS NOT NULL AND ds_motivo_bloq_w::text <> '') then
			ds_mensagem_campo_w := substr(ds_mensagem_campo_w || chr(10) ||
							wheb_mensagem_pck.get_texto(1075962) ||' '|| ds_motivo_bloq_w,1,nr_tam_maximo_w);
		end if;
	end if;
	
end loop;

ds_mensagem_w := substr(wheb_mensagem_pck.get_texto(1048231) || ds_mensagem_campo_w,1,nr_tam_maximo_w);

return	ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mensagem_bloq_geral_age (nr_seq_regra_p bigint) FROM PUBLIC;

