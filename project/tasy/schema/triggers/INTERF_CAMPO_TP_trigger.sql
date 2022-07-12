-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS interf_campo_tp ON interf_campo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_interf_campo_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_OBRIGATORIO,1,4000), substr(NEW.IE_OBRIGATORIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_OBRIGATORIO', ie_log_w, ds_w, 'INTERF_CAMPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DECIMAIS,1,4000), substr(NEW.QT_DECIMAIS,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DECIMAIS', ie_log_w, ds_w, 'INTERF_CAMPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_TAMANHO,1,4000), substr(NEW.QT_TAMANHO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_TAMANHO', ie_log_w, ds_w, 'INTERF_CAMPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATRIBUTO,1,4000), substr(NEW.IE_TIPO_ATRIBUTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATRIBUTO', ie_log_w, ds_w, 'INTERF_CAMPO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_interf_campo_tp() FROM PUBLIC;

CREATE TRIGGER interf_campo_tp
	AFTER UPDATE ON interf_campo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_interf_campo_tp();
