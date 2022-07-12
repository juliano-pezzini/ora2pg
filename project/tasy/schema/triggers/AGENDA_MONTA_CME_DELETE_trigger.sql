-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_monta_cme_delete ON agenda_monta_cme CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_monta_cme_delete() RETURNS trigger AS $BODY$
declare
ds_alteracao_w		varchar(4000) := null;
BEGIN

if (coalesce(OLD.nr_seq_classificacao,0) > 0) then
	ds_alteracao_w	:=	substr(obter_desc_expressao(499891)||' '||substr(cme_obter_desc_classif_conj(OLD.nr_seq_classificacao),1,125),1,4000);
end if;

if (ds_alteracao_w is not null) then
	CALL gravar_historico_montagem(OLD.nr_seq_agenda,'EC',ds_alteracao_w,OLD.nm_usuario);
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_monta_cme_delete() FROM PUBLIC;

CREATE TRIGGER agenda_monta_cme_delete
	BEFORE DELETE ON agenda_monta_cme FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_monta_cme_delete();
