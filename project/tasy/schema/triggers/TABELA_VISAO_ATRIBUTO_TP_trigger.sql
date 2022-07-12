-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tabela_visao_atributo_tp ON tabela_visao_atributo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tabela_visao_atributo_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'NR_SEQUENCIA='||to_char(OLD.NR_SEQUENCIA)||'#@#@NM_ATRIBUTO='||to_char(OLD.NM_ATRIBUTO); ds_w:=substr(NEW.NM_ATRIBUTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_ATRIBUTO,1,4000), substr(NEW.NM_ATRIBUTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_ATRIBUTO', ie_log_w, ds_w, 'TABELA_VISAO_ATRIBUTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQUENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'TABELA_VISAO_ATRIBUTO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tabela_visao_atributo_tp() FROM PUBLIC;

CREATE TRIGGER tabela_visao_atributo_tp
	AFTER UPDATE ON tabela_visao_atributo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tabela_visao_atributo_tp();
