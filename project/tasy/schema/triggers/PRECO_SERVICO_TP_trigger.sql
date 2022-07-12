-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS preco_servico_tp ON preco_servico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_preco_servico_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := null;  ds_c_w:= 'CD_ESTABELECIMENTO='||to_char(OLD.CD_ESTABELECIMENTO)||'#@#@CD_TABELA_SERVICO='||to_char(OLD.CD_TABELA_SERVICO)||'#@#@CD_PROCEDIMENTO='||to_char(OLD.CD_PROCEDIMENTO)||'#@#@DT_INICIO_VIGENCIA='||to_char(OLD.DT_INICIO_VIGENCIA); ds_w:=substr(NEW.CD_PROCEDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_UNIDADE_MEDIDA,1,4000), substr(NEW.CD_UNIDADE_MEDIDA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_UNIDADE_MEDIDA', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MOEDA,1,4000), substr(NEW.CD_MOEDA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MOEDA', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TABELA_SERVICO,1,4000), substr(NEW.CD_TABELA_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TABELA_SERVICO', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_SERVICO,1,4000), substr(NEW.VL_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_SERVICO', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_VIGENCIA_FINAL,1,4000), substr(NEW.DT_VIGENCIA_FINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_VIGENCIA_FINAL', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_INATIVACAO,1,4000), substr(NEW.DT_INATIVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_INATIVACAO', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DT_INICIO_VIGENCIA,1,4000), substr(NEW.DT_INICIO_VIGENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VIGENCIA', ie_log_w, ds_w, 'PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_preco_servico_tp() FROM PUBLIC;

CREATE TRIGGER preco_servico_tp
	AFTER UPDATE ON preco_servico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_preco_servico_tp();
