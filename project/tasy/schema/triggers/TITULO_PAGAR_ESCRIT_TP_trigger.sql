-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_escrit_tp ON titulo_pagar_escrit CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_escrit_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'NR_SEQ_ESCRIT='||to_char(OLD.NR_SEQ_ESCRIT)||'#@#@NR_TITULO='||to_char(OLD.NR_TITULO); ds_w:=substr(NEW.VL_LIQUIDACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_LIQUIDACAO,1,4000), substr(NEW.VL_LIQUIDACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_LIQUIDACAO', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_DESCONTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_DESCONTO,1,4000), substr(NEW.VL_DESCONTO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_DESCONTO', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_ACRESCIMO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_ACRESCIMO,1,4000), substr(NEW.VL_ACRESCIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_ACRESCIMO', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_TITULO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TITULO,1,4000), substr(NEW.NR_TITULO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TITULO', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_DESPESA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_DESPESA,1,4000), substr(NEW.VL_DESPESA,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_DESPESA', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_ESCRITURAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_ESCRITURAL,1,4000), substr(NEW.VL_ESCRITURAL,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_ESCRITURAL', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_MULTA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_MULTA,1,4000), substr(NEW.VL_MULTA,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_MULTA', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_JUROS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_JUROS,1,4000), substr(NEW.VL_JUROS,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_JUROS', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_ESCRIT,1,4000), substr(NEW.NR_SEQ_ESCRIT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_ESCRIT', ie_log_w, ds_w, 'TITULO_PAGAR_ESCRIT', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_escrit_tp() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_escrit_tp
	AFTER UPDATE ON titulo_pagar_escrit FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_escrit_tp();

