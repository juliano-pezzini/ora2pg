-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_preco_mat_atual ON pls_regra_preco_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_preco_mat_atual() RETURNS trigger AS $BODY$
declare

cd_material_w	integer;

BEGIN

-- previnir que seja gravada a hora junto na regra.
-- essa situação ocorre quando o usuário seleciona a data no campo via enter
if (NEW.dt_inicio_vigencia is not null) then
	NEW.dt_inicio_vigencia := trunc(NEW.dt_inicio_vigencia);
end if;
if (NEW.dt_fim_vigencia is not null) then
	NEW.dt_fim_vigencia := trunc(NEW.dt_fim_vigencia);
end if;

-- esta trigger foi criada para alimentar os campos de data referencia, isto por questões de performance
-- para que não seja necessário utilizar um or is null nas rotinas que utilizam esta tabela
-- o campo inicial ref é alimentado com o valor informado no campo inicial ou se este for nulo é alimentado
-- com a data zero do oracle 31/12/1899, já o campo fim ref é alimentado com o campo fim ou se o mesmo for nulo
-- é alimentado com a data 31/12/3000 desta forma podemos utilizar um between ou fazer uma comparação com estes campos
-- sem precisar se preocupar se o campo vai estar nulo
NEW.dt_inicio_vigencia_ref := pls_util_pck.obter_dt_vigencia_null( NEW.dt_inicio_vigencia, 'I');
NEW.dt_fim_vigencia_ref := pls_util_pck.obter_dt_vigencia_null( NEW.dt_fim_vigencia, 'F');

if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
	if (NEW.nr_seq_material is not null) then
		select	max(cd_material)
		into STRICT	cd_material_w
		from	pls_material a
		where	a.nr_sequencia	= NEW.nr_seq_material;

		NEW.cd_material	:= cd_material_w;
	end if;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_preco_mat_atual() FROM PUBLIC;

CREATE TRIGGER pls_regra_preco_mat_atual
	BEFORE INSERT OR UPDATE ON pls_regra_preco_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_preco_mat_atual();

