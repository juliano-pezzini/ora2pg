-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prot_int_atualizar ( nr_seq_protocolo_int_pac_p protocolo_int_paciente.nr_sequencia%TYPE, nm_usuario_p usuario.nm_usuario%TYPE, ds_tratamento_p protocolo_int_paciente.ds_tratamento%TYPE, dt_inicial_previsto_p protocolo_int_paciente.dt_inicial_previsto%TYPE, ie_status_p protocolo_int_paciente.ie_status%TYPE, ie_variacao_p protocolo_int_paciente.ie_variacao%TYPE, ds_variacao_p protocolo_int_paciente.ds_variacao%TYPE, ie_alerta_p protocolo_int_paciente.ie_alerta%TYPE, nr_seq_nais_insurance_p protocolo_int_paciente.nr_seq_nais_insurance%TYPE default null, cd_departamento_med_p protocolo_int_paciente.cd_departamento_med%TYPE  DEFAULT NULL) AS $body$
DECLARE


nr_dias_previsto_w protocolo_int_paciente.nr_dias_previsto%TYPE;
dt_final_previsto_w protocolo_int_paciente.dt_final_previsto%TYPE;
ds_tratamento_w protocolo_int_paciente.ds_tratamento%TYPE;
dt_inicial_previsto_w protocolo_int_paciente.dt_inicial_previsto%TYPE;
nr_etapas_sem_data_real_w bigint;
maior_dt_final_real_w protocolo_int_pac_etapa.dt_final_real%TYPE;
nr_dias_real_w protocolo_int_paciente.nr_dias_real%TYPE;
nr_dias_atraso_w protocolo_int_paciente.nr_dias_atraso%TYPE;
nr_dias_previsto_jp_w protocolo_int_paciente.nr_dias_previsto%TYPE;
qt_etapas_w bigint;
ie_current_status_w protocolo_int_paciente.ie_status%type;


BEGIN

    IF (nr_seq_protocolo_int_pac_p IS NOT NULL AND nr_seq_protocolo_int_pac_p::text <> '') THEN

		CALL prot_int_atualizar_etapas(nr_seq_protocolo_int_pac_p);
		
        if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

          SELECT COUNT(*)
          INTO STRICT qt_etapas_w
          FROM protocolo_int_pac_etapa
          WHERE nr_seq_protocolo_int_pac = nr_seq_protocolo_int_pac_p;

          if (qt_etapas_w = 0) then
            return;
          end if;

        end if;

        SELECT
            SUM(etapa.nr_dias_previsto),
            COALESCE(ds_tratamento_p, protocolo.ds_tratamento),
            COALESCE(dt_inicial_previsto_p, protocolo.dt_inicial_previsto),
            coalesce(max(etapa.nr_dia_final) - min(etapa.nr_dia_inicial) + 1,1)
        INTO STRICT
            nr_dias_previsto_w,
            ds_tratamento_w,
            dt_inicial_previsto_w,
            nr_dias_previsto_jp_w
        FROM
            protocolo_int_paciente protocolo,
            protocolo_int_pac_etapa etapa
        WHERE
            protocolo.nr_sequencia = nr_seq_protocolo_int_pac_p
        AND etapa.nr_seq_protocolo_int_pac = protocolo.nr_sequencia
        GROUP BY
            COALESCE(ds_tratamento_p, protocolo.ds_tratamento),
            COALESCE(dt_inicial_previsto_p, protocolo.dt_inicial_previsto),
            protocolo.nr_sequencia;

        if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

          nr_dias_previsto_w := nr_dias_previsto_jp_w;

        end if;

        dt_final_previsto_w := dt_inicial_previsto_w + nr_dias_previsto_w - 1;

        SELECT COUNT(*)
        INTO STRICT nr_etapas_sem_data_real_w
        FROM protocolo_int_pac_etapa etapa
        WHERE
            etapa.nr_seq_protocolo_int_pac = nr_seq_protocolo_int_pac_p
        AND coalesce(etapa.dt_final_real::text, '') = ''
        AND coalesce(etapa.ie_evento_sumario,'N') = 'N';

        IF (nr_etapas_sem_data_real_w = 0) THEN
            SELECT MAX(dt_final_real)
            INTO STRICT maior_dt_final_real_w
            FROM protocolo_int_pac_etapa etapa
            WHERE etapa.nr_seq_protocolo_int_pac = nr_seq_protocolo_int_pac_p;

            if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
              nr_dias_real_w := trunc(maior_dt_final_real_w,'dd') - trunc(dt_inicial_previsto_w,'dd') + 1;
            else
              nr_dias_real_w := maior_dt_final_real_w - dt_inicial_previsto_w + 1;
            end if;
            nr_dias_atraso_w := nr_dias_real_w - nr_dias_previsto_w;
        END IF;

        ie_current_status_w := ie_status_p;

        if (coalesce(ie_current_status_w::text, '') = '') then

          SELECT ie_status
          INTO STRICT ie_current_status_w
          FROM protocolo_int_paciente
          WHERE nr_sequencia = nr_seq_protocolo_int_pac_p;

        end if;

        UPDATE protocolo_int_paciente
        SET
            dt_atualizacao = clock_timestamp(),
            nm_usuario = nm_usuario_p,
            dt_atualizacao_nrec = clock_timestamp(),
            nm_usuario_nrec = nm_usuario_p,
            ds_tratamento = ds_tratamento_w,
            dt_inicial_previsto = dt_inicial_previsto_w,
            dt_final_previsto = dt_final_previsto_w,
            nr_dias_previsto = nr_dias_previsto_w,
            nr_dias_real = nr_dias_real_w,
            nr_dias_atraso = nr_dias_atraso_w,
            ie_status = ie_current_status_w,
			      ie_variacao = ie_variacao_p,
			      ds_variacao = ds_variacao_p,
            ie_alerta = ie_alerta_p,
            nr_seq_nais_insurance = nr_seq_nais_insurance_p,
            cd_departamento_med = cd_departamento_med_p
        WHERE nr_sequencia = nr_seq_protocolo_int_pac_p;

        COMMIT;
		
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prot_int_atualizar ( nr_seq_protocolo_int_pac_p protocolo_int_paciente.nr_sequencia%TYPE, nm_usuario_p usuario.nm_usuario%TYPE, ds_tratamento_p protocolo_int_paciente.ds_tratamento%TYPE, dt_inicial_previsto_p protocolo_int_paciente.dt_inicial_previsto%TYPE, ie_status_p protocolo_int_paciente.ie_status%TYPE, ie_variacao_p protocolo_int_paciente.ie_variacao%TYPE, ds_variacao_p protocolo_int_paciente.ds_variacao%TYPE, ie_alerta_p protocolo_int_paciente.ie_alerta%TYPE, nr_seq_nais_insurance_p protocolo_int_paciente.nr_seq_nais_insurance%TYPE default null, cd_departamento_med_p protocolo_int_paciente.cd_departamento_med%TYPE  DEFAULT NULL) FROM PUBLIC;
