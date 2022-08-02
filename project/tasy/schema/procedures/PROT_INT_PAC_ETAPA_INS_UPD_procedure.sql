-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prot_int_pac_etapa_ins_upd ( nr_seq_prot_int_pac_etapa_p protocolo_int_pac_etapa.nr_sequencia%TYPE, ds_etapa_p protocolo_int_pac_etapa.ds_etapa%TYPE, nr_dias_previsto_p protocolo_int_pac_etapa.nr_dias_previsto%TYPE, nm_usuario_p protocolo_int_pac_etapa.nm_usuario%TYPE, nr_seq_protocolo_int_pac_p protocolo_int_paciente.nr_sequencia%TYPE, ds_etapa_paciente_p protocolo_int_pac_etapa.ds_etapa_paciente%TYPE, ie_ocultar_visao_paciente_p protocolo_int_pac_etapa.ie_ocultar_visao_paciente%type, ie_evento_sumario_p protocolo_int_pac_etapa.ie_evento_sumario%type default null, nr_dia_inicial_p protocolo_int_pac_etapa.nr_dia_inicial%type default null, nr_dia_final_p protocolo_int_pac_etapa.nr_dia_final%type default null, nr_ordem_inicial_p protocolo_int_pac_etapa.nr_ordem_inicial%type default null, nr_ordem_final_p protocolo_int_pac_etapa.nr_ordem_final%type default null) AS $body$
DECLARE


nr_seq_protocolo_int_pac_w protocolo_int_paciente.nr_sequencia%TYPE;
min_nr_seq_etapa_w protocolo_int_pac_etapa.nr_sequencia%TYPE;
dt_inicial_previsto_w protocolo_int_pac_etapa.dt_inicial_previsto%TYPE;
dt_final_previsto_w protocolo_int_pac_etapa.dt_final_previsto%TYPE;
nr_seq_prot_int_pac_etapa_w protocolo_int_pac_etapa.nr_sequencia%TYPE;


BEGIN

-- Protocolo da etapa
SELECT
    dt_inicial_previsto
INTO STRICT
    dt_inicial_previsto_w
FROM
    protocolo_int_paciente
WHERE
    nr_sequencia = nr_seq_protocolo_int_pac_p;

if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

  if (ie_evento_sumario_p = 'S') then

    dt_final_previsto_w := dt_inicial_previsto_w;

  else

    dt_final_previsto_w := dt_inicial_previsto_w + coalesce(nr_dia_final_p,1) - 1;
    dt_inicial_previsto_w := dt_inicial_previsto_w + coalesce(nr_dia_inicial_p,1) - 1;

  end if;

else

  -- Primeira etapa do protocolo
  SELECT MIN(nr_sequencia)
  INTO STRICT min_nr_seq_etapa_w
  FROM protocolo_int_pac_etapa
  WHERE nr_seq_protocolo_int_pac = nr_seq_protocolo_int_pac_p;

  -- NAO e a primeira etapa do protocolo
  IF ((min_nr_seq_etapa_w IS NOT NULL AND min_nr_seq_etapa_w::text <> '') AND (min_nr_seq_etapa_w <> nr_seq_prot_int_pac_etapa_p OR coalesce(nr_seq_prot_int_pac_etapa_p::text, '') = '')) THEN
      SELECT dt_final_previsto + 1
      INTO STRICT dt_inicial_previsto_w
      FROM protocolo_int_pac_etapa
      WHERE nr_sequencia = (
          SELECT MAX(nr_sequencia)
          FROM protocolo_int_pac_etapa
          WHERE ((nr_seq_prot_int_pac_etapa_p IS NOT NULL AND nr_seq_prot_int_pac_etapa_p::text <> '') AND nr_sequencia < nr_seq_prot_int_pac_etapa_p)
          OR (coalesce(nr_seq_prot_int_pac_etapa_p::text, '') = '' AND nr_seq_protocolo_int_pac = nr_seq_protocolo_int_pac_p)
      );
  END IF;

  dt_final_previsto_w := dt_inicial_previsto_w + coalesce(nr_dias_previsto_p,1) - 1;

end if;

IF (coalesce(nr_seq_prot_int_pac_etapa_p::text, '') = '') THEN -- Insert
    SELECT nextval('protocolo_int_pac_etapa_seq')
    INTO STRICT nr_seq_prot_int_pac_etapa_w
;

    INSERT INTO protocolo_int_pac_etapa(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_protocolo_int_pac,
        ds_etapa,
        nr_dias_previsto,
        dt_inicial_previsto,
        dt_final_previsto,
        ie_ocultar_visao_paciente,
        ie_evento_sumario,
        nr_dia_inicial,
        nr_dia_final,
        nr_ordem_inicial,
        nr_ordem_final
    ) VALUES (
        nr_seq_prot_int_pac_etapa_w,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_protocolo_int_pac_p,
        ds_etapa_p,
        nr_dias_previsto_p,
        dt_inicial_previsto_w,
        dt_final_previsto_w,
		    ie_ocultar_visao_paciente_p,
        ie_evento_sumario_p,
        nr_dia_inicial_p,
        nr_dia_final_p,
        nr_ordem_inicial_p,
        nr_ordem_final_p
    );
    if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

      if (coalesce(ie_evento_sumario_p,'N') = 'N') then

        EXECUTE   'begin link_event_from_sum_pac(:1, :2, :3, :4, :5, :6, :7); end;'
        using   nr_seq_prot_int_pac_etapa_w,
                nr_dia_inicial_p,
                nr_dia_final_p,
                nr_ordem_inicial_p,
                nr_ordem_final_p,
                nr_seq_protocolo_int_pac_p,
                0;

      end if;

    end if;
ELSE -- Update
    UPDATE protocolo_int_pac_etapa
    SET dt_inicial_previsto = dt_inicial_previsto_w,
        dt_final_previsto = dt_final_previsto_w,
        nr_dias_previsto = nr_dias_previsto_p,
        ds_etapa = ds_etapa_p,
        nm_usuario = nm_usuario_p,
        dt_atualizacao = clock_timestamp(),
        ds_etapa_paciente = ds_etapa_paciente_p,
		    ie_ocultar_visao_paciente	=	ie_ocultar_visao_paciente_p,
        ie_evento_sumario = ie_evento_sumario_p,
        nr_dia_inicial = nr_dia_inicial_p,
        nr_dia_final = nr_dia_final_p,
        nr_ordem_inicial = nr_ordem_inicial_p,
        nr_ordem_final = nr_ordem_final_p
    WHERE nr_sequencia = nr_seq_prot_int_pac_etapa_p;

    if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

      if (coalesce(ie_evento_sumario_p,'N') = 'N') then

      EXECUTE   'begin link_event_from_sum_pac(:1, :2, :3, :4, :5, :6, :7); end;'
        using   nr_seq_prot_int_pac_etapa_p,
                nr_dia_inicial_p,
                nr_dia_final_p,
                nr_ordem_inicial_p,
                nr_ordem_final_p,
                nr_seq_protocolo_int_pac_p,
                1;

      end if;

    end if;

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prot_int_pac_etapa_ins_upd ( nr_seq_prot_int_pac_etapa_p protocolo_int_pac_etapa.nr_sequencia%TYPE, ds_etapa_p protocolo_int_pac_etapa.ds_etapa%TYPE, nr_dias_previsto_p protocolo_int_pac_etapa.nr_dias_previsto%TYPE, nm_usuario_p protocolo_int_pac_etapa.nm_usuario%TYPE, nr_seq_protocolo_int_pac_p protocolo_int_paciente.nr_sequencia%TYPE, ds_etapa_paciente_p protocolo_int_pac_etapa.ds_etapa_paciente%TYPE, ie_ocultar_visao_paciente_p protocolo_int_pac_etapa.ie_ocultar_visao_paciente%type, ie_evento_sumario_p protocolo_int_pac_etapa.ie_evento_sumario%type default null, nr_dia_inicial_p protocolo_int_pac_etapa.nr_dia_inicial%type default null, nr_dia_final_p protocolo_int_pac_etapa.nr_dia_final%type default null, nr_ordem_inicial_p protocolo_int_pac_etapa.nr_ordem_inicial%type default null, nr_ordem_final_p protocolo_int_pac_etapa.nr_ordem_final%type default null) FROM PUBLIC;

