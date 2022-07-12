-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS enferm_perfil_tp ON enferm_perfil CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_enferm_perfil_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.NM_CONTATO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_CONTATO,1,4000), substr(NEW.NM_CONTATO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_CONTATO', ie_log_w, ds_w, 'ENFERM_PERFIL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_IDADE_ADMISSAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_IDADE_ADMISSAO,1,4000), substr(NEW.NR_IDADE_ADMISSAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_IDADE_ADMISSAO', ie_log_w, ds_w, 'ENFERM_PERFIL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'ENFERM_PERFIL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_FONE_ADIC,1,4000), substr(NEW.DS_FONE_ADIC,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_FONE_ADIC', ie_log_w, ds_w, 'ENFERM_PERFIL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_COMPLEMENTO,1,4000), substr(NEW.IE_TIPO_COMPLEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_COMPLEMENTO', ie_log_w, ds_w, 'ENFERM_PERFIL', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_enferm_perfil_tp() FROM PUBLIC;

CREATE TRIGGER enferm_perfil_tp
	AFTER UPDATE ON enferm_perfil FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_enferm_perfil_tp();
