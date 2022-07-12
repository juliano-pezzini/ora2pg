-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_opme_tp ON agenda_pac_opme CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_opme_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NR_SEQ_AGENDA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_AGENDA,1,4000), substr(NEW.NR_SEQ_AGENDA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_AGENDA', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MATERIAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_MATERIAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MATERIAL,1,4000), substr(NEW.QT_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_MATERIAL', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DS_OBSERVACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_AUTORIZADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AUTORIZADO,1,4000), substr(NEW.IE_AUTORIZADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AUTORIZADO', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_AGENDA_INT,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_AGENDA_INT,1,4000), substr(NEW.NR_SEQ_AGENDA_INT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_AGENDA_INT', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_EXCLUSAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_EXCLUSAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_EXCLUSAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_EXCLUSAO', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CGC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC,1,4000), substr(NEW.CD_CGC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_GERAR_AUTOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR_AUTOR,1,4000), substr(NEW.IE_GERAR_AUTOR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR_AUTOR', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_INTEGRACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INTEGRACAO,1,4000), substr(NEW.IE_INTEGRACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_INTEGRACAO', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_UNITARIO_ITEM,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_UNITARIO_ITEM,1,4000), substr(NEW.VL_UNITARIO_ITEM,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_UNITARIO_ITEM', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_PADRAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PADRAO,1,4000), substr(NEW.IE_PADRAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PADRAO', ie_log_w, ds_w, 'AGENDA_PAC_OPME', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_opme_tp() FROM PUBLIC;

CREATE TRIGGER agenda_pac_opme_tp
	AFTER UPDATE ON agenda_pac_opme FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_opme_tp();
