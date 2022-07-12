-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS local_estoque_tp ON local_estoque CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_local_estoque_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.CD_LOCAL_ESTOQUE);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.DS_LOCAL_ESTOQUE,1,4000), substr(NEW.DS_LOCAL_ESTOQUE,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_LOCAL_ESTOQUE', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERMITE_OC,1,4000), substr(NEW.IE_PERMITE_OC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERMITE_OC', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PONTO_PEDIDO,1,4000), substr(NEW.IE_PONTO_PEDIDO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PONTO_PEDIDO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CENTRO_CUSTO,1,4000), substr(NEW.CD_CENTRO_CUSTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CENTRO_CUSTO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERMITE_DIGITACAO,1,4000), substr(NEW.IE_PERMITE_DIGITACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERMITE_DIGITACAO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_SOLIC_CONSIG,1,4000), substr(NEW.CD_PESSOA_SOLIC_CONSIG,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_SOLIC_CONSIG', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_COMPRADOR_CONSIG,1,4000), substr(NEW.CD_COMPRADOR_CONSIG,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_COMPRADOR_CONSIG', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PROPRIO,1,4000), substr(NEW.IE_PROPRIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PROPRIO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_LOCAL,1,4000), substr(NEW.IE_TIPO_LOCAL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_LOCAL', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REQ_AUTOMATICA,1,4000), substr(NEW.IE_REQ_AUTOMATICA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REQ_AUTOMATICA', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_LOCAL_ESTOQUE,1,4000), substr(NEW.CD_LOCAL_ESTOQUE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_LOCAL_ESTOQUE', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REQ_MAT_ESTOQUE,1,4000), substr(NEW.IE_REQ_MAT_ESTOQUE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REQ_MAT_ESTOQUE', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CENTRO_INVENTARIO,1,4000), substr(NEW.IE_CENTRO_INVENTARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CENTRO_INVENTARIO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_BAIXA_DISP,1,4000), substr(NEW.IE_BAIXA_DISP,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_BAIXA_DISP', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DIA_AJUSTE_MINIMO,1,4000), substr(NEW.QT_DIA_AJUSTE_MINIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DIA_AJUSTE_MINIMO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DIA_AJUSTE_MAXIMO,1,4000), substr(NEW.QT_DIA_AJUSTE_MAXIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DIA_AJUSTE_MAXIMO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DIA_CONSUMO,1,4000), substr(NEW.QT_DIA_CONSUMO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DIA_CONSUMO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERMITE_ESTOQUE_NEGATIVO,1,4000), substr(NEW.IE_PERMITE_ESTOQUE_NEGATIVO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERMITE_ESTOQUE_NEGATIVO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CENTRO_CUSTO_ORDEM,1,4000), substr(NEW.IE_CENTRO_CUSTO_ORDEM,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CENTRO_CUSTO_ORDEM', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LOCAL_ENTREGA_OC,1,4000), substr(NEW.IE_LOCAL_ENTREGA_OC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LOCAL_ENTREGA_OC', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXTERNO,1,4000), substr(NEW.IE_EXTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXTERNO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERA_LOTE,1,4000), substr(NEW.IE_GERA_LOTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERA_LOTE', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONSIDERA_TRANSF_PADRAO,1,4000), substr(NEW.IE_CONSIDERA_TRANSF_PADRAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONSIDERA_TRANSF_PADRAO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CENTRO_CUSTO_NF,1,4000), substr(NEW.IE_CENTRO_CUSTO_NF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CENTRO_CUSTO_NF', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_COMPLEMENTO,1,4000), substr(NEW.DS_COMPLEMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_COMPLEMENTO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONSISTE_SALDO_REP,1,4000), substr(NEW.IE_CONSISTE_SALDO_REP,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONSISTE_SALDO_REP', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERMITE_EMPRESTIMO,1,4000), substr(NEW.IE_PERMITE_EMPRESTIMO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERMITE_EMPRESTIMO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LIMPA_REQUISICAO,1,4000), substr(NEW.IE_LIMPA_REQUISICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LIMPA_REQUISICAO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,4000), substr(NEW.CD_ESTABELECIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'LOCAL_ESTOQUE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_local_estoque_tp() FROM PUBLIC;

CREATE TRIGGER local_estoque_tp
	AFTER UPDATE ON local_estoque FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_local_estoque_tp();

