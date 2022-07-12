-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_tipo_atend_cid_insert ON regra_tipo_atend_cid CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_tipo_atend_cid_insert() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.cd_procedimento is null) and (NEW.nr_seq_proc_interno is null) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(196410);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_tipo_atend_cid_insert() FROM PUBLIC;

CREATE TRIGGER regra_tipo_atend_cid_insert
	BEFORE INSERT ON regra_tipo_atend_cid FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_tipo_atend_cid_insert();

