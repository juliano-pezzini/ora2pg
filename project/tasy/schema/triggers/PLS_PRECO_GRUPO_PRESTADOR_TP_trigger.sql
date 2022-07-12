-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_preco_grupo_prestador_tp ON pls_preco_grupo_prestador CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_preco_grupo_prestador_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AUTOGERADO,1,4000), substr(NEW.IE_AUTOGERADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AUTOGERADO', ie_log_w, ds_w, 'PLS_PRECO_GRUPO_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SISTEMA_ANT,1,4000), substr(NEW.CD_SISTEMA_ANT,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SISTEMA_ANT', ie_log_w, ds_w, 'PLS_PRECO_GRUPO_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_GRUPO,1,4000), substr(NEW.DS_GRUPO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_GRUPO', ie_log_w, ds_w, 'PLS_PRECO_GRUPO_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_PRECO_GRUPO_PRESTADOR', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_preco_grupo_prestador_tp() FROM PUBLIC;

CREATE TRIGGER pls_preco_grupo_prestador_tp
	AFTER UPDATE ON pls_preco_grupo_prestador FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_preco_grupo_prestador_tp();

