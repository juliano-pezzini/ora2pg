-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS man_ordem_serv_tecnico_after ON man_ordem_serv_tecnico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_man_ordem_serv_tecnico_after() RETURNS trigger AS $BODY$
DECLARE

nr_seq_estagio_w		bigint;
nr_grupo_trabalho_w	bigint;

BEGIN
if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'N')  then
	goto Final;
end if;

if (coalesce(NEW.nr_seq_tipo, 0) > 0) then
	BEGIN
	select	coalesce(max(nr_seq_estagio),0),
		coalesce(max(nr_grupo_trabalho_atualiz),0)
	into STRICT	nr_seq_estagio_w,
		nr_grupo_trabalho_w
	from	man_tipo_hist
	where	nr_sequencia	= NEW.nr_seq_tipo;
	
	if (nr_seq_estagio_w > 0) then
		update	man_ordem_servico
		set	nr_seq_estagio	= nr_seq_estagio_w,
			nm_usuario	= NEW.nm_usuario,
			dt_atualizacao	= NEW.dt_atualizacao
		where	nr_sequencia	= NEW.nr_seq_ordem_serv;
	end if;
	if (nr_grupo_trabalho_w > 0) then
		update	man_ordem_servico
		set	nr_grupo_trabalho		= nr_grupo_trabalho_w,
			nm_usuario		= NEW.nm_usuario,
			dt_atualizacao		= NEW.dt_atualizacao
		where	nr_sequencia		= NEW.nr_seq_ordem_serv;
	end if;
	end;
end if;
<<Final>>
null;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_man_ordem_serv_tecnico_after() FROM PUBLIC;

CREATE TRIGGER man_ordem_serv_tecnico_after
	AFTER INSERT ON man_ordem_serv_tecnico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_man_ordem_serv_tecnico_after();
