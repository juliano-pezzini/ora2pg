-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_atualiza_indices_pendente ( nm_usuario_p text) AS $body$
DECLARE


nm_tabela_w		varchar(50);
nm_indice_w		varchar(200);
qt_pendente_w	bigint;

C010 CURSOR FOR
SELECT	a.nm_tabela,
		b.nm_indice
from	tabela_sistema a,
		indice b
where	b.nm_tabela = a.nm_tabela
and		gerar_objeto_aplicacao(a.ds_aplicacao) = 'S'
and		upper(b.nm_indice) not like '%_PK'
and    Obter_Se_Cria_Indice(a.nm_tabela,b.nm_indice) = 'S'
and	not exists (
		SELECT 1
		from	user_indexes c
		where	b.nm_tabela = c.table_name
		and	b.nm_indice = c.index_name);


BEGIN

delete from TASY_INDICE_PENDENTE
where ie_status = 'P';
commit;

open C010;
loop
fetch C010 into
	nm_tabela_w,
	nm_indice_w;
EXIT WHEN NOT FOUND; /* apply on C010 */
	begin

	select	count(*)
	into STRICT	qt_pendente_w
	from	tasy_indice_pendente
	WHERE upper(nm_tabela) = upper(nm_tabela_w)
	AND upper(nm_indice) = upper(nm_indice_w);

	if (qt_pendente_w > 0) then
		update	TASY_INDICE_PENDENTE
		set		ie_status = 'E'
		WHERE upper(nm_tabela) = upper(nm_tabela_w)
		AND upper(nm_indice) = upper(nm_indice_w)
		and ie_status = 'G';
		commit;
	else
		insert into TASY_INDICE_PENDENTE(nm_tabela, nm_indice,ie_dropar,ie_status) values (nm_tabela_w, nm_indice_w, 'N', 'P');
		commit;
	end if;

	end;
end loop;
close C010;

delete from TASY_INDICE_PENDENTE
where ie_status = 'G';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_atualiza_indices_pendente ( nm_usuario_p text) FROM PUBLIC;
