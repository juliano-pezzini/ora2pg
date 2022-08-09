-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_activity_sprint (nr_seq_cronograma_p proj_cron_etapa.nr_seq_cronograma%type default null, nr_seq_sprint_p CADASTRO_SPRINT_ATIVIDADE.NR_SEQ_CADASTRO_SPRINT%type DEFAULT NULL, dt_inicial_p proj_cron_etapa.dt_inicio_prev%type default null, dt_final_p proj_cron_etapa.dt_fim_prev%type default null, nr_seq_proj_cron_etp_p proj_cron_etapa.nr_sequencia%type default 0, nr_seq_proj_p proj_projeto.nr_sequencia%type default null, ie_tipo_p text default 'N') AS $body$
DECLARE


ds_atividade_w  proj_cron_etapa.ds_atividade%type;

c01 CURSOR FOR
SELECT 	NR_SEQUENCIA, DS_ATIVIDADE
FROM 	proj_cron_etapa
WHERE 	((coalesce(nr_seq_cronograma_p::text, '') = '' or ((nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') AND nr_seq_cronograma = nr_seq_cronograma_p))
AND (coalesce(nr_seq_proj_p::text, '') = '' or ((nr_seq_proj_p IS NOT NULL AND nr_seq_proj_p::text <> '')
AND 	nr_seq_cronograma IN (SELECT nr_sequencia FROM proj_cronograma where nr_seq_proj = nr_seq_proj_p))))
AND 	(ie_tipo_p = 'S' AND
		(((dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '')
			AND	(dt_final_p IS NOT NULL AND dt_final_p::text <> '')
			AND 	dt_inicio_prev between dt_inicial_p and dt_final_p
			AND 	dt_fim_prev between dt_inicial_p and dt_final_p)
			OR (coalesce(dt_inicial_p::text, '') = '' AND coalesce(dt_final_p::text, '') = ''))
			OR 	ie_tipo_p = 'D' AND
		(((dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '')
			AND 	(dt_final_p IS NOT NULL AND dt_final_p::text <> '')
			AND 	dt_inicio_prev between dt_inicial_p and dt_final_p
			OR 	dt_fim_prev between dt_inicial_p and dt_final_p)
			OR (coalesce(dt_inicial_p::text, '') = '' AND coalesce(dt_final_p::text, '') = ''))
			OR 	ie_tipo_p = 'N');

BEGIN

  if (nr_seq_proj_cron_etp_p > 0) then

      SELECT ds_atividade
      INTO STRICT ds_atividade_w
      FROM proj_cron_etapa
      WHERE nr_sequencia = nr_seq_proj_cron_etp_p;

      INSERT into CADASTRO_SPRINT_ATIVIDADE(
        NR_SEQUENCIA,
        NR_SEQ_PROJ_CRON_ETAPA,
        NR_SEQ_CADASTRO_SPRINT,
        DS_ATIVIDADE,
        DT_ATUALIZACAO,
        NM_USUARIO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC
      ) VALUES (
        nextval('cadastro_sprint_atividade_seq'),
        nr_seq_proj_cron_etp_p,
        nr_seq_sprint_p,
        ds_atividade_w,
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario
      );

  else

  for c01_w in c01 loop
    BEGIN

      INSERT into CADASTRO_SPRINT_ATIVIDADE(
        NR_SEQUENCIA,
        NR_SEQ_PROJ_CRON_ETAPA,
        NR_SEQ_CADASTRO_SPRINT,
        DS_ATIVIDADE,
        DT_ATUALIZACAO,
        NM_USUARIO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC
      ) VALUES (
        nextval('cadastro_sprint_atividade_seq'),
        c01_w.NR_SEQUENCIA,
        nr_seq_sprint_p,
        c01_w.DS_ATIVIDADE,
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario
      );

    END;
    end loop;
  end if;

  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_activity_sprint (nr_seq_cronograma_p proj_cron_etapa.nr_seq_cronograma%type default null, nr_seq_sprint_p CADASTRO_SPRINT_ATIVIDADE.NR_SEQ_CADASTRO_SPRINT%type DEFAULT NULL, dt_inicial_p proj_cron_etapa.dt_inicio_prev%type default null, dt_final_p proj_cron_etapa.dt_fim_prev%type default null, nr_seq_proj_cron_etp_p proj_cron_etapa.nr_sequencia%type default 0, nr_seq_proj_p proj_projeto.nr_sequencia%type default null, ie_tipo_p text default 'N') FROM PUBLIC;
