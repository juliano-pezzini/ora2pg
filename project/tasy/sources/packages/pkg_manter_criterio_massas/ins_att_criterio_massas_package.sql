-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function pkg_manter_criterio_massas.ins_att_criterio_massas() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE pkg_manter_criterio_massas.ins_att_criterio_massas ( acao text, nr_seq_resultado_p bigint, crit lab_lote_crit_massa ) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL pkg_manter_criterio_massas.ins_att_criterio_massas_atx ( ' || quote_nullable(acao) || ',' || quote_nullable(nr_seq_resultado_p) || ',' || quote_nullable(crit) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE pkg_manter_criterio_massas.ins_att_criterio_massas_atx ( acao text, nr_seq_resultado_p bigint, crit lab_lote_crit_massa ) AS $body$
BEGIN
        if (crit.nr_sequencia IS NOT NULL AND crit.nr_sequencia::text <> '') then
            if ('I' = acao) then
                insert into lab_lote_crit_massa(
                    nr_sequencia,
                    dt_atualizacao,
                    dt_atualizacao_nrec,
                    nm_usuario,
                    nm_usuario_nrec,
                    qt_percent_min,
                    qt_percent_max,
                    ds_msg_criterio,
                    ds_acao_criterio,
                    qt_dias_prev,
                    ie_tipo_busca,
                    ie_acao_criterio,
                    ds_resultado_sugerido,
                    ds_material_criterio,
                    ds_metodo_criterio,
                    ie_tipo_valor,
					nr_seq_resultado,
                    nr_seq_prescr,
                    nr_seq_exame
                ) values (
                    crit.nr_sequencia,
                    clock_timestamp(),
                    clock_timestamp(),
                    obter_usuario_ativo,
                    obter_usuario_ativo,
                    crit.qt_percent_min,
                    crit.qt_percent_max,
                    crit.ds_msg_criterio,
                    crit.ds_acao_criterio,
                    crit.qt_dias_prev,
                    crit.ie_tipo_busca,
                    crit.ie_acao_criterio,
                    crit.ds_resultado_sugerido,
                    crit.ds_material_criterio,
                    crit.ds_metodo_criterio,
                    crit.ie_tipo_valor,
                    nr_seq_resultado_p,
                    crit.nr_seq_prescr,
                    crit.nr_seq_exame
                );
            else
                update lab_lote_crit_massa
                    set dt_atualizacao = clock_timestamp(),
                        nm_usuario = obter_usuario_ativo,
                        qt_percent_min = crit.qt_percent_min,
                        qt_percent_max = crit.qt_percent_max,
                        ds_msg_criterio = crit.ds_msg_criterio,
                        ds_acao_criterio = crit.ds_acao_criterio,
                        qt_dias_prev = crit.qt_dias_prev,
                        ie_tipo_busca = crit.ie_tipo_busca,
                        ie_acao_criterio = crit.ie_acao_criterio,
                        ds_resultado_sugerido = crit.ds_resultado_sugerido,
                        ds_material_criterio = crit.ds_material_criterio,
                        ds_metodo_criterio = crit.ds_metodo_criterio,
						ie_tipo_valor = crit.ie_tipo_valor
                where   nr_seq_resultado = nr_seq_resultado_p;
            end if;
            commit;
        end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pkg_manter_criterio_massas.ins_att_criterio_massas ( acao text, nr_seq_resultado_p bigint, crit lab_lote_crit_massa ) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE pkg_manter_criterio_massas.ins_att_criterio_massas_atx ( acao text, nr_seq_resultado_p bigint, crit lab_lote_crit_massa ) FROM PUBLIC;