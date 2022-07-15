-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_sup_int_requisicao ( nm_usuario_p text, cd_estabelecimento_p bigint, qt_dias_aprovacao_p bigint) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_requisicao_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_requisicao
	from 	sup_int_requisicao
	where	cd_estabelecimento = coalesce(cd_estabelecimento_p,cd_estabelecimento)
	and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '')
	and	clock_timestamp() - dt_aprovacao > qt_dias_aprovacao_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_requisicao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	delete 	from sup_int_req_consist
	where	nr_sequencia = nr_sequencia_w;

	delete 	from sup_int_req_item
	where	nr_sequencia = nr_sequencia_w;

	delete	from sup_int_requisicao
	where	nr_sequencia = nr_sequencia_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_sup_int_requisicao ( nm_usuario_p text, cd_estabelecimento_p bigint, qt_dias_aprovacao_p bigint) FROM PUBLIC;

