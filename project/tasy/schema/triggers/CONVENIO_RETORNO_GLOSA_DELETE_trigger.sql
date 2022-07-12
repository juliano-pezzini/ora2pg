-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS convenio_retorno_glosa_delete ON convenio_retorno_glosa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_convenio_retorno_glosa_delete() RETURNS trigger AS $BODY$
declare

ds_observacao_w		varchar(255) := null;

BEGIN


if (OLD.nr_seq_propaci_partic is not null) or (OLD.nr_seq_matpaci_partic is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(301557);

end if;


ds_observacao_w := ATUALIZAR_CONVENIO_RET_GLOSA(	OLD.nr_seq_ret_item, OLD.cd_motivo_glosa, null, OLD.vl_glosa, null, OLD.vl_amaior, null, OLD.nm_usuario, OLD.ie_acao_glosa, null, ds_observacao_w);

update	convenio_retorno_movto
set	nr_seq_ret_glosa  = NULL
where	nr_seq_ret_glosa = OLD.nr_sequencia;

RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_convenio_retorno_glosa_delete() FROM PUBLIC;

CREATE TRIGGER convenio_retorno_glosa_delete
	BEFORE DELETE ON convenio_retorno_glosa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_convenio_retorno_glosa_delete();

