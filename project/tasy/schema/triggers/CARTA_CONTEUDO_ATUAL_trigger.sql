-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS carta_conteudo_atual ON carta_conteudo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_carta_conteudo_atual() RETURNS trigger AS $BODY$
declare
 
ie_gravar_log_w		varchar(1);
 
BEGIN 
 
select	coalesce(max('N'),'S') 
into STRICT	ie_gravar_log_w 
from	carta_conteudo_texto 
where	nr_seq_carta_conteudo = NEW.nr_sequencia;
 
if (ie_gravar_log_w = 'S') then 
	insert into carta_conteudo_texto(	 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ds_texto_original, 
			nr_seq_carta_conteudo) 
	values (	nextval('carta_conteudo_texto_seq'), 
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			OLD.ds_texto, 
			NEW.nr_sequencia);
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_carta_conteudo_atual() FROM PUBLIC;

CREATE TRIGGER carta_conteudo_atual
	BEFORE UPDATE ON carta_conteudo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_carta_conteudo_atual();
