-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_bloqueia_insert_mat_estag ON pls_guia_plano_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_bloqueia_insert_mat_estag() RETURNS trigger AS $BODY$
declare

ie_estagio_w	pls_guia_plano.ie_estagio%type;
ds_estagio_w	varchar(255);
qt_rotina_w	bigint;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	BEGIN
		select	ie_estagio
		into STRICT	ie_estagio_w
		from	pls_guia_plano
		where	nr_sequencia	= NEW.nr_seq_guia;
	exception
	when others then
		ie_estagio_w	:= 0;
	end;

	select	count(1)
	into STRICT	qt_rotina_w
	from 	v$session
	where	audsid	= (SELECT userenv('sessionid') )
	and	username = (select username from v$session where audsid = (select userenv('sessionid') ))
	and	action like 'INCMATMED%';

	if (ie_estagio_w	<> 7) and (qt_rotina_w = 0) then
		ds_estagio_w	:= obter_valor_dominio(2055,ie_estagio_w);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(255327, 'DS_ESTAGIO=' || ds_estagio_w);
	end if;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_bloqueia_insert_mat_estag() FROM PUBLIC;

CREATE TRIGGER pls_bloqueia_insert_mat_estag
	BEFORE INSERT ON pls_guia_plano_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_bloqueia_insert_mat_estag();
