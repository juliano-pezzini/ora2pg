-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function pkg_manter_valor_referencia.ins_att_valor_referencia() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE pkg_manter_valor_referencia.ins_att_valor_referencia ( acao text, refer lab_lote_val_ref ) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL pkg_manter_valor_referencia.ins_att_valor_referencia_atx ( ' || quote_nullable(acao) || ',' || quote_nullable(refer) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE pkg_manter_valor_referencia.ins_att_valor_referencia_atx ( acao text, refer lab_lote_val_ref ) AS $body$
BEGIN
        if (refer.nr_sequencia IS NOT NULL AND refer.nr_sequencia::text <> '') then
            if ('I' = acao) then
                insert into lab_lote_val_ref(
                    nr_sequencia,
                    dt_atualizacao,
                    dt_atualizacao_nrec,
                    nm_usuario,
                    nm_usuario_nrec,
                    nr_prescricao,
                    nr_seq_prescr,
                    nr_seq_exame,
                    qt_minima,
                    qt_maxima,
                    qt_percent_min,
                    qt_percent_max,
                    ds_observacao
                ) values (
                    refer.nr_sequencia,
                    clock_timestamp(),
                    clock_timestamp(),
                    obter_usuario_ativo,
                    obter_usuario_ativo,
                    refer.nr_prescricao,
                    refer.nr_seq_prescr,
                    refer.nr_seq_exame,
                    refer.qt_minima,
                    refer.qt_maxima,
                    refer.qt_percent_min,
                    refer.qt_percent_max,
                    refer.ds_observacao
                );
            else
                update lab_lote_val_ref
                    set dt_atualizacao = clock_timestamp(),
                        nm_usuario = obter_usuario_ativo,
                        qt_minima = refer.qt_minima,
                        qt_maxima = refer.qt_maxima,
                        qt_percent_min = refer.qt_percent_min,
                        qt_percent_max = refer.qt_percent_max,
                        ds_observacao = refer.ds_observacao
                where   nr_prescricao = refer.nr_prescricao
                    and nr_seq_prescr = refer.nr_seq_prescr
                    and nr_seq_exame = refer.nr_seq_exame;
            end if;
            commit;
        end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pkg_manter_valor_referencia.ins_att_valor_referencia ( acao text, refer lab_lote_val_ref ) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE pkg_manter_valor_referencia.ins_att_valor_referencia_atx ( acao text, refer lab_lote_val_ref ) FROM PUBLIC;