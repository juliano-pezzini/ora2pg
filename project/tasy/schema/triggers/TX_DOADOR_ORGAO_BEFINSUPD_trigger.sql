-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tx_doador_orgao_befinsupd ON tx_doador_orgao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tx_doador_orgao_befinsupd() RETURNS trigger AS $BODY$
declare
ie_doador_vivo_w	varchar(1);
ie_tipo_doador_w	varchar(15);

BEGIN

select	ie_doador_vivo
into STRICT	ie_doador_vivo_w
from	tx_orgao
where	nr_sequencia	= NEW.nr_seq_orgao;

select	ie_tipo_doador
into STRICT	ie_tipo_doador_w
from	tx_doador
where	nr_sequencia	= NEW.nr_seq_doador;

if (ie_tipo_doador_w = 'VIV') and (ie_doador_vivo_w <> 'S') then
	--O órgão informado no cadastro do doador não pode ser doado em vida.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264228);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tx_doador_orgao_befinsupd() FROM PUBLIC;

CREATE TRIGGER tx_doador_orgao_befinsupd
	BEFORE INSERT OR UPDATE ON tx_doador_orgao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tx_doador_orgao_befinsupd();
