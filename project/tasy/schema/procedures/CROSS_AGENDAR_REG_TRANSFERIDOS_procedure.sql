-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cross_agendar_reg_transferidos ( nr_sequencia_p REG_AGE_EVENTO.nr_sequencia%TYPE ) AS $body$
DECLARE

  ie_erro_w REG_AGE_EVENTO.ie_status%TYPE;
  ds_erro_w REG_AGE_EVENTO.ds_erro_agendamento%TYPE;
  qt_erro_w AGENDA_PACIENTE.nr_sequencia%TYPE;
  nm_usuario_w constant AGENDA_PACIENTE.nm_usuario%TYPE := 'Cross';

  rae_nr_sequencia_w REG_AGE_EVENTO.nr_sequencia%TYPE;
  rae_nr_seq_solic_w REG_AGE_EVENTO.nr_seq_solic%TYPE;
  rae_dt_agenda_w REG_AGE_EVENTO.dt_agenda%TYPE;
  rae_nr_seq_agend_dest_w REG_AGE_EVENTO.nr_seq_agendamento_destino%TYPE;
  rae_nr_seq_agend_orig_w REG_AGE_EVENTO.nr_seq_agendamento_origem%TYPE;

  gsc_cd_tipo_agenda_w GERCON_SOLIC_CONSULTA.cd_tipo_agenda%TYPE;
  gsc_cd_agenda_externa_w GERCON_SOLIC_CONSULTA.cd_agenda_externa%TYPE;
  gsc_dt_nascimento_w GERCON_SOLIC_CONSULTA.dt_nascimento%TYPE;
  gsc_nm_pessoa_fisica_w GERCON_SOLIC_CONSULTA.nm_pessoa_fisica%TYPE;
  gsc_cd_cid_w GERCON_SOLIC_CONSULTA.cd_cid%TYPE;
  gsc_cd_medico_w GERCON_SOLIC_CONSULTA.cd_medico%TYPE;

  ap_nr_sequencia_w AGENDA_PACIENTE.nr_sequencia%TYPE;

  nr_seq_agenda_origem_W agenda_paciente.nr_sequencia%type;
  cd_agenda_w agenda_paciente.cd_agenda%type;

  IE_STATUS_CANCELADO_W constant agenda_consulta.ie_status_agenda%type := 'C';
  IE_STATUS_LIVRE_W constant agenda_consulta.ie_status_agenda%type := 'L';
  IE_STATUS_FORCADO_W constant agenda_consulta.ie_status_agenda%type := 'LF';
  IE_STATUS_FALTA_W constant agenda_consulta.ie_status_agenda%type := 'F';
  IE_STATUS_FALTA_JUST_W constant agenda_consulta.ie_status_agenda%type := 'I';
  IE_STATUS_CONFIR_W constant agenda_consulta.ie_status_agenda%type := 'CN';

  IE_STATUS_ERRO_w constant GERCON_SOLIC_CONSULTA.ie_status%type := 'E';
  IE_STATUS_TRANSFERIDO_w constant GERCON_SOLIC_CONSULTA.ie_status%type := 'T';


BEGIN
  SELECT
    coalesce(rae.nr_sequencia, 0),
    coalesce(rae.nr_seq_solic, 0),
    rae.dt_agenda,
    gsc.cd_tipo_agenda,
    gsc.cd_agenda_externa,
    gsc.dt_nascimento,
    gsc.nm_pessoa_fisica,
    gsc.cd_cid,
    gsc.cd_medico,
	rae.nr_seq_agendamento_destino,
	rae.nr_seq_agendamento_origem
  INTO STRICT
    rae_nr_sequencia_w,
    rae_nr_seq_solic_w,
    rae_dt_agenda_w,
    gsc_cd_tipo_agenda_w,
    gsc_cd_agenda_externa_w,
    gsc_dt_nascimento_w,
    gsc_nm_pessoa_fisica_w,
    gsc_cd_cid_w,
    gsc_cd_medico_w,
	rae_nr_seq_agend_dest_w,
	rae_nr_seq_agend_orig_w
  FROM REG_AGE_EVENTO rae
  INNER JOIN GERCON_SOLIC_CONSULTA gsc ON (
    gsc.nr_sequencia = rae.nr_seq_solic
  )
  WHERE
    rae.nr_sequencia = nr_sequencia_p;

  ie_erro_w := IE_STATUS_TRANSFERIDO_w;
  ds_erro_w := NULL;
  qt_erro_w := 0;


  IF (gsc_cd_tipo_agenda_w = 2) THEN -- Exame
    SELECT
      coalesce(MAX(ap.nr_sequencia), 0)
    INTO STRICT
      ap_nr_sequencia_w
    FROM AGENDA_PACIENTE ap,
		agenda a
    WHERE
      a.cd_Agenda = ap.cd_agenda
      and ap.ie_status_agenda IN (IE_STATUS_LIVRE_W, IE_STATUS_FORCADO_W)
      AND ap.dt_agenda = rae_dt_agenda_w
      AND a.cd_agenda_externa = to_char(gsc_cd_agenda_externa_w);

    IF (ap_nr_sequencia_w < 1) THEN
      ie_erro_w := IE_STATUS_ERRO_w;
      ds_erro_w := obter_expressao_dic_objeto(1112604);
    ELSE
      SELECT
        coalesce(COUNT(ap.nr_sequencia), 0)
      INTO STRICT
        qt_erro_w
      FROM AGENDA_PACIENTE ap,
		agenda a
      WHERE
		a.cd_Agenda = ap.cd_agenda
        and ap.ie_status_agenda not IN (IE_STATUS_CANCELADO_W, IE_STATUS_FALTA_W, IE_STATUS_FALTA_JUST_W)
        AND ap.dt_agenda = rae_dt_agenda_w
        AND a.cd_agenda_externa = to_char(gsc_cd_agenda_externa_w);

      IF (qt_erro_w > 0) THEN
        ie_erro_w := IE_STATUS_ERRO_w;
        ds_erro_w := obter_expressao_dic_objeto(1112605);
      ELSE
        UPDATE AGENDA_PACIENTE
        SET
          nm_usuario = nm_usuario_w,
          nm_usuario_orig = nm_usuario_w,
          dt_atualizacao = clock_timestamp(),
          ie_status_agenda = IE_STATUS_CONFIR_W,
          dt_agendamento = coalesce(dt_agendamento, clock_timestamp()),
          nm_paciente = gsc_nm_pessoa_fisica_w,
          -- qt_idade_paciente = qt_idade_w,
          dt_nascimento_pac = gsc_dt_nascimento_w,
          cd_doenca_cid = gsc_cd_cid_w,
          cd_medico_req = gsc_cd_medico_w,
		  cd_agendamento_externo = rae_nr_seq_agend_dest_w
        WHERE
          nr_sequencia = ap_nr_sequencia_w;
		
		select max(nr_Sequencia),
			max(cd_agenda)
		into STRICT
		  nr_seq_agenda_origem_W,
		  cd_agenda_w
		from agenda_paciente
		where cd_agendamento_externo = rae_nr_seq_agend_orig_w
		and ie_status_agenda <> IE_STATUS_CANCELADO_W;
		
		if (nr_seq_agenda_origem_W IS NOT NULL AND nr_seq_agenda_origem_W::text <> '' AND cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '') then
			CALL Alterar_status_agenda(cd_agenda_w, nr_seq_agenda_origem_W, IE_STATUS_CANCELADO_W, null, null, null, nm_usuario_w, null);
		end if;
      END IF;
    END IF;
  ELSE -- Consulta
    SELECT
      coalesce(MAX(ap.nr_sequencia), 0)
    INTO STRICT
      ap_nr_sequencia_w
    FROM AGENDA_CONSULTA ap,
		agenda a
    WHERE
      ap.ie_status_agenda IN (IE_STATUS_LIVRE_W, IE_STATUS_FORCADO_W)
      AND ap.dt_agenda = rae_dt_agenda_w
      AND a.cd_agenda_externa = to_char(gsc_cd_agenda_externa_w);

    IF (ap_nr_sequencia_w < 1) THEN
      ie_erro_w := IE_STATUS_ERRO_w;
      ds_erro_w := obter_expressao_dic_objeto(1112604);
    ELSE
      SELECT
        coalesce(COUNT(ap.nr_sequencia), 0)
      INTO STRICT
        qt_erro_w
      FROM AGENDA_CONSULTA ap,
		agenda a
      WHERE
		a.cd_agenda = ap.cd_agenda
        AND ap.ie_status_agenda not IN (IE_STATUS_CANCELADO_W, IE_STATUS_FALTA_W, IE_STATUS_FALTA_JUST_W)
        AND ap.dt_agenda = rae_dt_agenda_w
        AND a.cd_agenda_externa = to_char(gsc_cd_agenda_externa_w);

      IF (qt_erro_w > 0) THEN
        ie_erro_w := IE_STATUS_ERRO_w;
        ds_erro_w := obter_expressao_dic_objeto(1112605);
      ELSE
        UPDATE AGENDA_CONSULTA
        SET
          nm_usuario = nm_usuario_w,
          nm_usuario_origem = nm_usuario_w,
          dt_atualizacao = clock_timestamp(),
          ie_status_agenda = IE_STATUS_CONFIR_W,
          dt_agendamento = coalesce(dt_agendamento, clock_timestamp()),
          nm_paciente = gsc_nm_pessoa_fisica_w,
          -- qt_idade_paciente = qt_idade_w,
          dt_nascimento_pac = gsc_dt_nascimento_w,
          cd_cid = gsc_cd_cid_w,
          cd_medico_req = gsc_cd_medico_w,
		  cd_agendamento_externo = rae_nr_seq_agend_dest_w
        WHERE
          nr_sequencia = ap_nr_sequencia_w;
		
		select max(nr_Sequencia),
			max(cd_agenda)
		into STRICT
		  nr_seq_agenda_origem_W,
		  cd_agenda_w
		from agenda_consulta
		where cd_agendamento_externo = rae_nr_seq_agend_orig_w
		and ie_status_agenda <> IE_STATUS_CANCELADO_W;
		
		if (nr_seq_agenda_origem_W IS NOT NULL AND nr_seq_agenda_origem_W::text <> '' AND cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '') then
			CALL Cancelar_Agenda_Consulta(nr_seq_agenda_origem_W,  nm_usuario_w);
		end if;
		
      END IF;
    END IF;
  END IF;

  IF (rae_nr_sequencia_w > 0 AND rae_nr_seq_solic_w > 0) THEN
    UPDATE REG_AGE_EVENTO SET
      ie_status = ie_erro_w,
      ds_erro_agendamento = ds_erro_w,
	  dt_atualizacao = clock_timestamp(),
	  nm_usuario = nm_usuario_w
    WHERE
      nr_sequencia = rae_nr_sequencia_w;

    UPDATE GERCON_SOLIC_CONSULTA SET
      ie_status = ie_erro_w,
	  dt_atualizacao = clock_timestamp(),
	  nm_usuario = nm_usuario_w,
	  cd_agendamento_externo = CASE WHEN ie_erro_w=IE_STATUS_TRANSFERIDO_w THEN  rae_nr_seq_agend_dest_w  ELSE cd_agendamento_externo END
    WHERE
      nr_sequencia = rae_nr_seq_solic_w;
  END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cross_agendar_reg_transferidos ( nr_sequencia_p REG_AGE_EVENTO.nr_sequencia%TYPE ) FROM PUBLIC;
