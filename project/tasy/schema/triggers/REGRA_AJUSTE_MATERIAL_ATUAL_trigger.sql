-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_ajuste_material_atual ON regra_ajuste_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_ajuste_material_atual() RETURNS trigger AS $BODY$
declare
qt_preenchido_w		bigint := 0;

BEGIN
if (NEW.CD_CLASSE_MATERIAL IS NOT NULL) then
	qt_preenchido_w	:= qt_preenchido_w + 1;
end if;
if (NEW.CD_SUBGRUPO_MATERIAL IS NOT NULL)  then
	qt_preenchido_w	:= qt_preenchido_w + 1;
end if;
if (NEW.CD_GRUPO_MATERIAL IS NOT NULL) then
	qt_preenchido_w	:= qt_preenchido_w + 1;
end if;
if (NEW.CD_MATERIAL IS NOT NULL) then
	qt_preenchido_w	:= qt_preenchido_w + 1;
end if;
if (NEW.NR_SEQ_ESTRUTURA IS NOT NULL) then
	qt_preenchido_w := qt_preenchido_w + 1;
end if;

if (qt_preenchido_w > 1) then
	--R.AISE_APPLICATION_ERROR(-20001,'Apenas uma regra pode ser selecionada!');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263268);
end if;

-- Campos que podem ser combinados e podem ser únicos também
if (NEW.NR_SEQ_FAMILIA IS NOT NULL) then
	qt_preenchido_w := qt_preenchido_w + 1;
end if;

if (qt_preenchido_w = 0) then
	--R.AISE_APPLICATION_ERROR(-20001,'Uma regra deve ser selecionada!');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263269);
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_ajuste_material_atual() FROM PUBLIC;

CREATE TRIGGER regra_ajuste_material_atual
	BEFORE INSERT OR UPDATE ON regra_ajuste_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_ajuste_material_atual();
