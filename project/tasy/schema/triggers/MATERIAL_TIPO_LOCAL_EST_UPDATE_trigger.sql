-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS material_tipo_local_est_update ON material_tipo_local_est CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_material_tipo_local_est_update() RETURNS trigger AS $BODY$
declare
qt_registro_w		integer;

BEGIN

/* Não considerar quando for atualizado pela exclusão da PLS_MATERIAL - MATERIAL_ESTAB */

if (NEW.ie_operadora <> 'X') and (NEW.ie_prestador <> 'X') and (NEW.ie_farmacia <> 'X') then
	select	count(*)
	into STRICT	qt_registro_w
	from	material_estab a
	where	cd_material = OLD.cd_material
	and	exists (SELECT	1
			from	parametro_gestao_material y,
				estabelecimento x
			where	x.nr_seq_unid_neg	= y.nr_seq_unidade_hosp
			and	x.cd_estabelecimento	= a.cd_estabelecimento);

	if (NEW.ie_prestador = 'N') and (qt_registro_w > 0) then
		--O campo "Prestador (hospitalar)" não pode ser desmarcado pois há cadastro na atividade correspondente.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267088);
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_material
	where	cd_material = OLD.cd_material;

	if (NEW.ie_operadora = 'N') and (qt_registro_w > 0) then
		--O campo "Operadora" não pode ser desmarcado pois há cadastro  na atividade correspondente.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267089);
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	material_estab a
	where	cd_material = OLD.cd_material
	and	exists (SELECT	1
			from	parametro_gestao_material y,
				estabelecimento x
			where	x.nr_seq_unid_neg	= y.nr_seq_unidade_farm
			and	x.cd_estabelecimento	= a.cd_estabelecimento);

	if (NEW.ie_farmacia = 'N') and (qt_registro_w > 0) then
		--O campo "Farmácia comercial" não pode ser desmarcado pois há cadastro na atividade correspondente.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267090);
	end if;
end if;

if (NEW.ie_operadora = 'X') then
	NEW.ie_operadora	:= 'N';
elsif (NEW.ie_prestador = 'X') then
	NEW.ie_prestador	:= 'N';
elsif (NEW.ie_farmacia = 'X') then
	NEW.ie_farmacia	:= 'N';
end if;
null;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_material_tipo_local_est_update() FROM PUBLIC;

CREATE TRIGGER material_tipo_local_est_update
	BEFORE INSERT OR UPDATE ON material_tipo_local_est FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_material_tipo_local_est_update();
