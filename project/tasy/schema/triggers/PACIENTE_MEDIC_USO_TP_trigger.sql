-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_medic_uso_tp ON paciente_medic_uso CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_medic_uso_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.DT_ATUALIZACAO_NREC,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_DESCRICAO_COMPLEMENTAR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_DESCRICAO_COMPLEMENTAR,1,4000), substr(NEW.DS_DESCRICAO_COMPLEMENTAR,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_DESCRICAO_COMPLEMENTAR', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_MEDICAMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MEDICAMENTO,1,4000), substr(NEW.DS_MEDICAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MEDICAMENTO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MATERIAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_UNID_MED,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_UNID_MED,1,4000), substr(NEW.CD_UNID_MED,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_UNID_MED', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_INTERVALO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERVALO,1,4000), substr(NEW.CD_INTERVALO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERVALO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_REACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REACAO,1,4000), substr(NEW.DS_REACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_DOSE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DOSE,1,4000), substr(NEW.QT_DOSE,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DOSE', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_LIBERACAO,1,4000), substr(NEW.NM_USUARIO_LIBERACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_LIBERACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_OBSERVACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_JUSTIFICATIVA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_JUSTIFICATIVA,1,4000), substr(NEW.DS_JUSTIFICATIVA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_JUSTIFICATIVA', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ULTIMA_DOSE,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ULTIMA_DOSE,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ULTIMA_DOSE,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ULTIMA_DOSE', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_NEGA_MEDICAMENTOS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NEGA_MEDICAMENTOS,1,4000), substr(NEW.IE_NEGA_MEDICAMENTOS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NEGA_MEDICAMENTOS', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_VIA_APLICACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VIA_APLICACAO,1,4000), substr(NEW.IE_VIA_APLICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VIA_APLICACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CLASSIFICACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLASSIFICACAO,1,4000), substr(NEW.IE_CLASSIFICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLASSIFICACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_ORIENTACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ORIENTACAO,1,4000), substr(NEW.DS_ORIENTACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ORIENTACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_LIBERACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_LIBERACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_LIBERACAO', ie_log_w, ds_w, 'PACIENTE_MEDIC_USO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_medic_uso_tp() FROM PUBLIC;

CREATE TRIGGER paciente_medic_uso_tp
	AFTER UPDATE ON paciente_medic_uso FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_medic_uso_tp();

