-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_pagador_item_mens_atual ON pls_pagador_item_mens CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_pagador_item_mens_atual() RETURNS trigger AS $BODY$
declare

qt_registro_w			bigint;
qt_item_centro_apropriacao_w	bigint;

pragma autonomous_transaction;

BEGIN

if (NEW.nr_seq_pagador_item is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1061247);
end if;

if (NEW.ie_tipo_item is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1061246);
end if;

if (NEW.nr_seq_centro_apropriacao is not null) then
	if (NEW.ie_tipo_item not in ('1','3','20')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1060045);
	end if;
	
	select	count(1)
	into STRICT	qt_item_centro_apropriacao_w
	from	pls_pagador_item_mens
	where	nr_seq_pagador	= NEW.nr_seq_pagador
	and	nr_sequencia <> NEW.nr_sequencia
	and	ie_tipo_item = NEW.ie_tipo_item
	and	nr_seq_centro_apropriacao is null;
	
	if (qt_item_centro_apropriacao_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1060046, 'IE_TIPO_ITEM='||obter_valor_dominio(1930,NEW.ie_tipo_item));
	end if;
else
	select	count(1)
	into STRICT	qt_item_centro_apropriacao_w
	from	pls_pagador_item_mens
	where	nr_seq_pagador	= NEW.nr_seq_pagador
	and	nr_sequencia <> NEW.nr_sequencia
	and	ie_tipo_item = NEW.ie_tipo_item
	and	nr_seq_centro_apropriacao is not null;

	if (qt_item_centro_apropriacao_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1060047, 'IE_TIPO_ITEM='||obter_valor_dominio(1930,NEW.ie_tipo_item));
	end if;	
end if;

select	count(1)
into STRICT	qt_registro_w
from	pls_pagador_item_mens
where	nr_sequencia	<> NEW.nr_sequencia
and	nr_seq_pagador	= NEW.nr_seq_pagador
and	ie_tipo_item	= NEW.ie_tipo_item
and	((nr_seq_centro_apropriacao = NEW.nr_seq_centro_apropriacao) or (NEW.nr_seq_centro_apropriacao is null))
and	coalesce(nr_seq_tipo_lanc,0) = coalesce(NEW.nr_seq_tipo_lanc,0);

if (qt_registro_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(358190);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_pagador_item_mens_atual() FROM PUBLIC;

CREATE TRIGGER pls_pagador_item_mens_atual
	BEFORE INSERT OR UPDATE ON pls_pagador_item_mens FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_pagador_item_mens_atual();

