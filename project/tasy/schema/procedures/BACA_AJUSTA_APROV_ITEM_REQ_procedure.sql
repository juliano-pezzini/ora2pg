-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajusta_aprov_item_req () AS $body$
DECLARE


nr_requisicao_w		bigint;
dt_aprovacao_w		timestamp;
nm_usuario_aprov_w	varchar(15);

C01 CURSOR FOR
	SELECT	nr_requisicao,
		dt_aprovacao,
		nm_usuario_aprov
	from	requisicao_material
	where	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');


BEGIN


open C01;
loop
fetch C01 into
	nr_requisicao_w,
	dt_aprovacao_w,
	nm_usuario_aprov_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	item_requisicao_material
	set	dt_aprovacao = dt_aprovacao_w,
		nm_usuario_aprov = nm_usuario_aprov_w
	where	nr_requisicao = nr_requisicao_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajusta_aprov_item_req () FROM PUBLIC;

