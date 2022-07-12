-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cobranca_envio_insert ON cobranca_envio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cobranca_envio_insert() RETURNS trigger AS $BODY$
declare

nr_seq_notif_pagador_w		pls_notificacao_pagador.nr_sequencia%type;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
select  coalesce(max(b.nr_sequencia),0)
into STRICT	nr_seq_notif_pagador_w
from	cobranca	d,
	pls_notificacao_item    c, 
	pls_notificacao_pagador	b, 
	pls_notificacao_lote    a  
where	a.nr_sequencia = b.nr_seq_lote 
and	b.nr_sequencia = c.nr_seq_notific_pagador 
and	c.nr_sequencia = d.nr_seq_notific_item 
and	d.nr_sequencia = NEW.nr_seq_cobranca;

if (nr_seq_notif_pagador_w > 0) then
	CALL pls_registrar_receb_notif(nr_seq_notif_pagador_w,
			NEW.ds_destino,
			LOCALTIMESTAMP,
			'E');
end if;

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cobranca_envio_insert() FROM PUBLIC;

CREATE TRIGGER cobranca_envio_insert
	AFTER INSERT ON cobranca_envio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cobranca_envio_insert();
