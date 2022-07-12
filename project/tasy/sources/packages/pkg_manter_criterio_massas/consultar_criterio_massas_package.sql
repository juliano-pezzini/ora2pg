-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function pkg_manter_criterio_massas.consultar_criterio_massas() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION pkg_manter_criterio_massas.consultar_criterio_massas ( nr_seq_exame_p bigint, qt_result_p bigint, ds_result_p text, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, nr_seq_patologia_p bigint, nr_seq_grupo_pat_p bigint ) RETURNS LAB_LOTE_CRIT_MASSA%ROWTYPE AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	LAB_LOTE_CRIT_MASSA%ROWTYPE;
BEGIN
	v_query := 'SELECT * FROM pkg_manter_criterio_massas.consultar_criterio_massas_atx ( ' || quote_nullable(nr_seq_exame_p) || ',' || quote_nullable(qt_result_p) || ',' || quote_nullable(ds_result_p) || ',' || quote_nullable(nr_seq_prescr_p) || ',' || quote_nullable(nr_seq_resultado_p) || ',' || quote_nullable(nr_seq_patologia_p) || ',' || quote_nullable(nr_seq_grupo_pat_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret LAB_LOTE_CRIT_MASSA%ROWTYPE);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION pkg_manter_criterio_massas.consultar_criterio_massas_atx ( nr_seq_exame_p bigint, qt_result_p bigint, ds_result_p text, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, nr_seq_patologia_p bigint, nr_seq_grupo_pat_p bigint ) RETURNS LAB_LOTE_CRIT_MASSA%ROWTYPE AS $body$
DECLARE
nr_prescricao_w        bigint;
        ie_status_atend_w      bigint;
		crit                   lab_lote_crit_massa%rowtype;

BEGIN

        select  max(nr_prescricao)
        into STRICT    nr_prescricao_w
        from    exame_lab_resultado
        where   nr_seq_resultado = nr_seq_resultado_p;

        select  ie_status_atend
        into STRICT    ie_status_atend_w
        from    prescr_procedimento
        where   nr_prescricao = nr_prescricao_w
            and nr_sequencia = nr_seq_prescr_p;

        -- exames com resultados aprovados
        if (ie_status_atend_w >= 35) then
            -- verifica se ja esta cadastrado na nova tabela
            crit := pkg_manter_criterio_massas.obter_criterio_massas(nr_seq_resultado_p);
            -- caso nao esteja cadastrado
            if (coalesce(crit.nr_sequencia::text, '') = '') then
                -- gera os criterios a partir do antigo select - function - lab_cons_val_lote_massas
                crit := pkg_manter_criterio_massas.calcular_criterio_massas(nr_seq_exame_p,
                                                 qt_result_p,
                                                 ds_result_p,
                                                 nr_seq_prescr_p,
                                                 nr_seq_resultado_p,
                                                 nr_seq_patologia_p,
                                                 nr_seq_grupo_pat_p);
                if (crit.nr_sequencia IS NOT NULL AND crit.nr_sequencia::text <> '') then
                    -- insere os novos criterios na nova tabela
                    CALL pkg_manter_criterio_massas.ins_att_criterio_massas('I',
                                            nr_seq_resultado_p,
                                            crit);
                end if;
            end if;
        else
            -- verifica se ja esta cadastrado na nova tabela
            crit := pkg_manter_criterio_massas.obter_criterio_massas(nr_seq_resultado_p);
            -- caso nao esteja cadastrado
            if (coalesce(crit.nr_sequencia::text, '') = '') then
                -- gera os criterios a partir do antigo select - function - lab_cons_val_lote_massas
                crit := pkg_manter_criterio_massas.calcular_criterio_massas(nr_seq_exame_p,
                                                 qt_result_p,
                                                 ds_result_p,
                                                 nr_seq_prescr_p,
                                                 nr_seq_resultado_p,
                                                 nr_seq_patologia_p,
                                                 nr_seq_grupo_pat_p);
                if (crit.nr_sequencia IS NOT NULL AND crit.nr_sequencia::text <> '') then
                    -- insere os novos criterios na nova tabela
                    CALL pkg_manter_criterio_massas.ins_att_criterio_massas('I',
                                            nr_seq_resultado_p,
                                            crit);
                end if;
            else
                -- gera os criterios a partir do antigo select - function - lab_cons_val_lote_massas
                crit := pkg_manter_criterio_massas.calcular_criterio_massas(nr_seq_exame_p,
                                                 qt_result_p,
                                                 ds_result_p,
                                                 nr_seq_prescr_p,
                                                 nr_seq_resultado_p,
                                                 nr_seq_patologia_p,
                                                 nr_seq_grupo_pat_p);
                if (crit.nr_sequencia IS NOT NULL AND crit.nr_sequencia::text <> '') then
                    -- atualiza os criterios ja existentes na nova tabela
                    CALL pkg_manter_criterio_massas.ins_att_criterio_massas('U',
                                            nr_seq_resultado_p,
                                            crit);
                end if;
            end if;
        end if;

        return crit;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_manter_criterio_massas.consultar_criterio_massas ( nr_seq_exame_p bigint, qt_result_p bigint, ds_result_p text, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, nr_seq_patologia_p bigint, nr_seq_grupo_pat_p bigint ) FROM PUBLIC; -- REVOKE ALL ON FUNCTION pkg_manter_criterio_massas.consultar_criterio_massas_atx ( nr_seq_exame_p bigint, qt_result_p bigint, ds_result_p text, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, nr_seq_patologia_p bigint, nr_seq_grupo_pat_p bigint ) FROM PUBLIC;
