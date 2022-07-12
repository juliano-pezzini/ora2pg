-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS qua_evento_paciente_log ON qua_evento_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_qua_evento_paciente_log() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then  ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ANALISE,1,2000), substr(NEW.CD_SETOR_ANALISE,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ANALISE', ie_log_w, ds_w, 'QUA_EVENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIF_EVENTO,1,2000), substr(NEW.NR_SEQ_CLASSIF_EVENTO,1,2000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIF_EVENTO', ie_log_w, ds_w, 'QUA_EVENTO_PACIENTE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  end if;  exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_qua_evento_paciente_log() FROM PUBLIC;

CREATE TRIGGER qua_evento_paciente_log
	AFTER UPDATE ON qua_evento_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_qua_evento_paciente_log();

