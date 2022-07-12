-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sup_regra_planej_compras_tp ON sup_regra_planej_compras CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sup_regra_planej_compras_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONSIGNADO,1,4000), substr(NEW.IE_CONSIGNADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONSIGNADO', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PADRONIZADO,1,4000), substr(NEW.IE_PADRONIZADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PADRONIZADO', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CURVA_ABC,1,4000), substr(NEW.IE_CURVA_ABC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CURVA_ABC', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_MARCA,1,4000), substr(NEW.NR_SEQ_MARCA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_MARCA', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_SEG_COMPRAS,1,4000), substr(NEW.NR_SEQ_GRUPO_SEG_COMPRAS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_SEG_COMPRAS', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR,1,4000), substr(NEW.IE_GERAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CLASSE_MATERIAL,1,4000), substr(NEW.CD_CLASSE_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CLASSE_MATERIAL', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MATERIAL,1,4000), substr(NEW.CD_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MATERIAL', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_MATERIAL,1,4000), substr(NEW.CD_GRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_MATERIAL', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SUBGRUPO_MATERIAL,1,4000), substr(NEW.CD_SUBGRUPO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SUBGRUPO_MATERIAL', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MATERIAL_ESTOQUE,1,4000), substr(NEW.IE_MATERIAL_ESTOQUE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MATERIAL_ESTOQUE', ie_log_w, ds_w, 'SUP_REGRA_PLANEJ_COMPRAS', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sup_regra_planej_compras_tp() FROM PUBLIC;

CREATE TRIGGER sup_regra_planej_compras_tp
	AFTER UPDATE ON sup_regra_planej_compras FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sup_regra_planej_compras_tp();
