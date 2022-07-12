-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_mat_insert ON pls_conta_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_mat_insert() RETURNS trigger AS $BODY$
declare

ie_tipo_despesa_w	varchar(3);

BEGIN
if	((NEW.nr_seq_material <> OLD.nr_seq_material) or (OLD.nr_seq_material is null)) then
	/* Buscar a classificação do material e atualizar na tabela */

	select 	coalesce(max(ie_tipo_despesa),0)
	into STRICT	ie_tipo_despesa_w
	from	pls_material
	where	nr_sequencia = NEW.nr_seq_material;

	/* Felipe 25/05/2009 - OS 132654 */

	if (ie_tipo_despesa_w	> 0) then
		NEW.ie_tipo_despesa	:= ie_tipo_despesa_w;
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_mat_insert() FROM PUBLIC;

CREATE TRIGGER pls_conta_mat_insert
	BEFORE INSERT OR UPDATE ON pls_conta_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_mat_insert();

