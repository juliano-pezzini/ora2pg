-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS convenio_retorno_glosa_insert ON convenio_retorno_glosa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_convenio_retorno_glosa_insert() RETURNS trigger AS $BODY$
DECLARE

qt_reg_w		smallint;
ds_observacao_w		varchar(255) := null;

ds_module_w 		varchar(2000);
ds_action_w 		varchar(2000);

ie_gen_resub_default_w	convenio_estabelecimento.ie_gen_resub_by_default%type;

BEGIN

dbms_application_info.read_module(ds_module_w, ds_action_w);

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto final_lbl;
end if;

ds_observacao_w := ATUALIZAR_CONVENIO_RET_GLOSA(	NEW.nr_seq_ret_item, null, NEW.cd_motivo_glosa, null, NEW.vl_glosa, null, NEW.vl_amaior, NEW.nm_usuario, null, NEW.ie_acao_glosa, ds_observacao_w);

if (ds_observacao_w is not null) then
	NEW.ds_observacao := NEW.ds_observacao || ds_observacao_w;
end if;	


-- The following action is defined on the package CONCILIACAO_INTEGRACAO_RET_PCK.

-- When the receival of the insurance analysis is made through the tasy-interfaces API

-- the default definition of the denial action as resubmission is not applied.

if coalesce(ds_action_w, 'NULL') <> 'INSERT_INTERFACE_PCK' then	
	if NEW.ie_acao_glosa is null then
	
		select	coalesce(c.ie_gen_resub_by_default, 'N')
		into STRICT	ie_gen_resub_default_w
		from	convenio_retorno a,
			convenio_retorno_item b,
			convenio_estabelecimento c
		where	b.nr_seq_retorno 	= a.nr_sequencia		
		and	c.cd_convenio 		= a.cd_convenio
		and	c.cd_estabelecimento 	= a.cd_estabelecimento
		and	b.nr_sequencia 		= NEW.nr_seq_ret_item;
		
		if ie_gen_resub_default_w = 'S' then
			NEW.ie_acao_glosa := 'R';
		end if;
		
	end if;
end if;

<<final_lbl>>
qt_reg_w	:= 0;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_convenio_retorno_glosa_insert() FROM PUBLIC;

CREATE TRIGGER convenio_retorno_glosa_insert
	BEFORE INSERT ON convenio_retorno_glosa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_convenio_retorno_glosa_insert();

