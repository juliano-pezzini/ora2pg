-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_prestador_proc_tp ON pls_prestador_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_prestador_proc_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.CD_ESPECIALIDADE_PROC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIALIDADE_PROC,1,4000), substr(NEW.CD_ESPECIALIDADE_PROC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIALIDADE_PROC', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PROCEDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_AREA_PROCEDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_AREA_PROCEDIMENTO,1,4000), substr(NEW.CD_AREA_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_AREA_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_LIBERAR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LIBERAR,1,4000), substr(NEW.IE_LIBERAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LIBERAR', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_PRESTADOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PRESTADOR,1,4000), substr(NEW.NR_SEQ_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PRESTADOR', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_GRUPO_PROC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_PROC,1,4000), substr(NEW.CD_GRUPO_PROC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_PROC', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_ORIGEM_PROCED,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORIGEM_PROCED,1,4000), substr(NEW.IE_ORIGEM_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ORIGEM_PROCED', ie_log_w, ds_w, 'PLS_PRESTADOR_PROC', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_prestador_proc_tp() FROM PUBLIC;

CREATE TRIGGER pls_prestador_proc_tp
	AFTER UPDATE ON pls_prestador_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_prestador_proc_tp();
