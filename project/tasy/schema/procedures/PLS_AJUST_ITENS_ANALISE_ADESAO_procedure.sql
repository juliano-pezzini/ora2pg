-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajust_itens_analise_adesao ( nm_usuario_p text) AS $body$
DECLARE


cd_perfil_w		integer;
nr_seq_item_w		bigint;
qt_registros_w		bigint;

C01 CURSOR FOR
	SELECT	cd_perfil
	from	funcao_perfil
	where	cd_funcao = 1236;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	PLS_ITENS_ANALISE_ADESAO
	where	ie_situacao	= 'A';


BEGIN

open C01;
loop
fetch C01 into
	cd_perfil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_item_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	count(*)
		into STRICT	qt_registros_w
		from	PLS_ANALISE_ITEM_PERFIL
		where	cd_perfil	= cd_perfil_w
		and	nr_seq_item	= nr_seq_item_w;

		if (qt_registros_w = 0) then
			CALL pls_copiar_item_analise_adesao(nr_seq_item_w,cd_perfil_w,nm_usuario_p);
		end if;

		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajust_itens_analise_adesao ( nm_usuario_p text) FROM PUBLIC;

