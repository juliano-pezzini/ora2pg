-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pfcs_after_upt_unid_atend ON unidade_atendimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pfcs_after_upt_unid_atend() RETURNS trigger AS $BODY$
DECLARE
ds_log_w    varchar(4000);
qt_reg_w    smallint;

BEGIN
    if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'N')  then
        goto Final;
    end if;

    if (OLD.nm_usuario_nrec = 'PFCS') then
        ds_log_w := (
            concat('nr_seq_location: ',             OLD.nr_seq_location || CHR(10))
            || concat('cd_unidade_basica: ',        OLD.cd_unidade_basica) || CHR(10)
            || concat('cd_unidade_compl: ',         OLD.cd_unidade_compl) || CHR(10)
            || concat('cd_setor_atendimento: ',     OLD.cd_setor_atendimento) || CHR(10)
            || concat('old ie_status_unidade: ',    coalesce(OLD.ie_status_unidade, 'null'))
            || concat(' | new ie_status_unidade: ', coalesce(NEW.ie_status_unidade, 'null') || CHR(10))
            || concat('old ie_situacao: ',          OLD.ie_situacao)
            || concat(' | new ie_situacao: ',       NEW.ie_situacao)
        );
        CALL pfcs_log_pck.pfcs_insert_org_struc_log(
            ie_type_p => 'UPDATE',
            nm_table_p => 'UNIDADE_ATENDIMENTO',
            ds_log_p => ds_log_w,
            nm_usuario_p => NEW.nm_usuario
        );
    end if;

<<Final>>
qt_reg_w := 0;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pfcs_after_upt_unid_atend() FROM PUBLIC;

CREATE TRIGGER pfcs_after_upt_unid_atend
	AFTER UPDATE ON unidade_atendimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pfcs_after_upt_unid_atend();
