-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_pathway_preview_pck.get_settings_preview_header (nr_seq_protocolo_integrado_p protocolo_int_pac_etapa.nr_seq_protocolo_int_pac%TYPE, ie_nome_amigavel_p text DEFAULT 'N') RETURNS SETOF HEADER_TABLE_T AS $body$
DECLARE

         header_row_w header_row_t;
         header_data_settings_c CURSOR FOR
            SELECT
                SEQ_ETAPA,
                DS_EVENTO,
                DS_ETAPA,
                IE_OCULTAR_EVENTO,
                IE_OCULTAR_ETAPA,
                NR_DIAS_ETAPA,
                NR_DIA_EVENTO,
                NR_DIA_PROTOCOLO,
                NR_DIA_INICIAL,
                NR_DIA_FINAL,
                NR_SEQ_PROTOCOLO_INTEGRADO,
                IE_EVENTO_SUMARIO,
                GET_PREVIEW_OUTCOME(SEQ_ETAPA, 'N', IE_NOME_AMIGAVEL_P) DS_OUTCOMES,
                GET_PREVIEW_OUTCOME(SEQ_ETAPA, 'S') QTD_OUTCOMES,
                COLUMN_ID,
				ENCOUNTER_TYPE
            FROM (
              SELECT
               a.nr_sequencia nr_seq_evento,
                b.NR_SEQUENCIA SEQ_ETAPA,
                coalesce(
                    CASE WHEN IE_NOME_AMIGAVEL_P='S' THEN  DS_EVENTO_PACIENTE  ELSE DS_EVENTO END , DS_EVENTO
                ) DS_EVENTO,
                coalesce(
                    CASE WHEN IE_NOME_AMIGAVEL_P='S' THEN  DS_ETAPA_PACIENTE  ELSE DS_ETAPA END , DS_ETAPA
                ) DS_ETAPA,
                a.IE_OCULTAR_VISAO_PACIENTE IE_OCULTAR_EVENTO,
                b.IE_OCULTAR_VISAO_PACIENTE IE_OCULTAR_ETAPA,
                NR_DIAS_ETAPA,
                a.NR_DIA_EVENTO NR_DIA_EVENTO,
                a.NR_DIA_PROTOCOLO NR_DIA_PROTOCOLO,
                b.NR_DIA_INICIAL,
                b.NR_DIA_FINAL,
                b.NR_SEQ_PROTOCOLO_INTEGRADO,
                b.IE_EVENTO_SUMARIO,
                REGEXP_REPLACE(a.ds_evento, '[^0-9A-Za-z]', '') || '_' || a.nr_dia_protocolo || '_' || a.nr_seq_ordem || '_' || coalesce(a.ie_ocultar_visao_paciente, 'N') COLUMN_ID,
                a.nr_seq_ordem NR_ORDEM,
				(SELECT MIN(x.IE_TIPO_ATENDIMENTO) FROM protocolo_integrado_evento x WHERE a.nr_seq_etapa = x.nr_seq_etapa AND a.NR_DIA_EVENTO = x.nr_dia_evento) ENCOUNTER_TYPE																																								
            FROM protocolo_integrado_evento a
            INNER JOIN protocolo_integrado_etapa b ON
                b.nr_sequencia = a.nr_seq_etapa
            WHERE
                b.NR_SEQ_PROTOCOLO_INTEGRADO = nr_seq_protocolo_integrado_p
            ) alias8
            GROUP BY
                SEQ_ETAPA,
                DS_EVENTO,
                DS_ETAPA,
                IE_OCULTAR_EVENTO,
                IE_OCULTAR_ETAPA,
                NR_DIAS_ETAPA,
                NR_DIA_EVENTO,
                NR_DIA_PROTOCOLO,
                NR_DIA_INICIAL,
                NR_DIA_FINAL,
                NR_SEQ_PROTOCOLO_INTEGRADO,
                IE_EVENTO_SUMARIO,
                GET_PREVIEW_OUTCOME(SEQ_ETAPA, 'N', IE_NOME_AMIGAVEL_P),
                GET_PREVIEW_OUTCOME(SEQ_ETAPA, 'S'),
                COLUMN_ID,
                NR_ORDEM,
				ENCOUNTER_TYPE
            ORDER BY NR_DIA_EVENTO, NR_ORDEM;

BEGIN
         FOR header_data_r IN header_data_settings_c LOOP

            header_row_w.column_id := header_data_r.column_id;
            header_row_w.seq_etapa := header_data_r.seq_etapa;
            header_row_w.ds_evento := header_data_r.ds_evento;
            header_row_w.ds_etapa := header_data_r.ds_etapa;
            header_row_w.ie_ocultar_evento := header_data_r.ie_ocultar_evento;
            header_row_w.ie_ocultar_etapa := header_data_r.ie_ocultar_etapa;
            header_row_w.nr_dias_etapa := header_data_r.nr_dias_etapa;
            header_row_w.nr_dia_evento := header_data_r.nr_dia_evento;
            header_row_w.nr_dia_inicial := header_data_r.nr_dia_inicial;
            header_row_w.nr_dia_final := header_data_r.nr_dia_final;
            header_row_w.nr_seq_protocolo_integrado := header_data_r.nr_seq_protocolo_integrado;
			header_row_w.encounter_type := obter_valor_dominio(12, header_data_r.encounter_type);																					
            header_row_w.ie_evento_sumario := header_data_r.ie_evento_sumario;
            header_row_w.ds_outcomes := header_data_r.ds_outcomes;
            RETURN NEXT header_row_w;

        END LOOP;
        RETURN;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clinical_pathway_preview_pck.get_settings_preview_header (nr_seq_protocolo_integrado_p protocolo_int_pac_etapa.nr_seq_protocolo_int_pac%TYPE, ie_nome_amigavel_p text DEFAULT 'N') FROM PUBLIC;
