-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_habito_vicio_tp ON paciente_habito_vicio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_habito_vicio_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.QT_UTILIZACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_UTILIZACAO,1,4000), substr(NEW.QT_UTILIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_UTILIZACAO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_LAXATIVE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_LAXATIVE,1,4000), substr(NEW.DS_LAXATIVE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_LAXATIVE', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO_NREC,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_OBSERVACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_LIBERACAO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_FREQUENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FREQUENCIA,1,4000), substr(NEW.IE_FREQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FREQUENCIA', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_QUANTIDADE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_QUANTIDADE,1,4000), substr(NEW.DS_QUANTIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_QUANTIDADE', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_CONSEQUENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CONSEQUENCIA,1,4000), substr(NEW.DS_CONSEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CONSEQUENCIA', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_TIPO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO,1,4000), substr(NEW.NR_SEQ_TIPO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_LIBERACAO,1,4000), substr(NEW.NM_USUARIO_LIBERACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_LIBERACAO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_IDADE_EXP,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_EXP,1,4000), substr(NEW.QT_IDADE_EXP,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_EXP', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_IDADE_REG,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_REG,1,4000), substr(NEW.QT_IDADE_REG,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_REG', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_ANTECEDENTES_FAM,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ANTECEDENTES_FAM,1,4000), substr(NEW.DS_ANTECEDENTES_FAM,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ANTECEDENTES_FAM', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_NEGA_HABITO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NEGA_HABITO,1,4000), substr(NEW.IE_NEGA_HABITO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NEGA_HABITO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_MARCA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_MARCA,1,4000), substr(NEW.NR_SEQ_MARCA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_MARCA', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_LISTA_PROBLEMA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LISTA_PROBLEMA,1,4000), substr(NEW.IE_LISTA_PROBLEMA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LISTA_PROBLEMA', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_MACO_ANO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MACO_ANO,1,4000), substr(NEW.QT_MACO_ANO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MACO_ANO', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_ABNORMAL_URINE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ABNORMAL_URINE,1,4000), substr(NEW.DS_ABNORMAL_URINE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ABNORMAL_URINE', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_DYSURIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DYSURIA,1,4000), substr(NEW.IE_DYSURIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DYSURIA', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_ABNOR_URINE_HEM,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ABNOR_URINE_HEM,1,4000), substr(NEW.IE_ABNOR_URINE_HEM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ABNOR_URINE_HEM', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_ABNOR_URINE_OTHER,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ABNOR_URINE_OTHER,1,4000), substr(NEW.IE_ABNOR_URINE_OTHER,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ABNOR_URINE_OTHER', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_SENSE_EVA_INCOMP,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SENSE_EVA_INCOMP,1,4000), substr(NEW.IE_SENSE_EVA_INCOMP,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SENSE_EVA_INCOMP', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_LAXATIVE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LAXATIVE,1,4000), substr(NEW.IE_LAXATIVE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LAXATIVE', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_UNIDADE_MEDIDA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_UNIDADE_MEDIDA,1,4000), substr(NEW.CD_UNIDADE_MEDIDA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_UNIDADE_MEDIDA', ie_log_w, ds_w, 'PACIENTE_HABITO_VICIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_habito_vicio_tp() FROM PUBLIC;

CREATE TRIGGER paciente_habito_vicio_tp
	AFTER UPDATE ON paciente_habito_vicio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_habito_vicio_tp();
