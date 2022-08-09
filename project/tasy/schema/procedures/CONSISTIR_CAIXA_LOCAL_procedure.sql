-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_caixa_local ( nr_seq_caixa_p bigint, nr_seq_local_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



ie_permite_util_caixa_w		varchar(1);
qt_pront_w			bigint;


BEGIN

select 	max(ie_permite_util_caixa)
into STRICT	ie_permite_util_caixa_w
from	same_local
where	nr_sequencia = nr_seq_local_p;


if (ie_permite_util_caixa_w = 'S') then

	select 	count(*)
	into STRICT	qt_pront_w
	from	same_caixa
	where	nr_seq_local = nr_seq_local_p
	and	nr_sequencia <> nr_seq_caixa_p;

	if (qt_pront_w > 0) then

		CALL Wheb_mensagem_pck.exibir_mensagem_abort(264203);
	end if;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_caixa_local ( nr_seq_caixa_p bigint, nr_seq_local_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
