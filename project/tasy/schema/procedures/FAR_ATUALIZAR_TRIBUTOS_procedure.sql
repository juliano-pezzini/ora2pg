-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_atualizar_tributos ( nr_seq_venda_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_w	far_venda_item.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	far_venda_item
	where	nr_seq_venda = nr_seq_venda_p;


BEGIN

if (nr_seq_venda_p IS NOT NULL AND nr_seq_venda_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		nr_seq_item_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL far_gerar_tributo_item(nr_seq_venda_p,nr_seq_item_w,nm_usuario_p);
		CALL far_atualizar_total_item(nr_seq_item_w,nm_usuario_p);
		end;
	end loop;
	close C01;

	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_atualizar_tributos ( nr_seq_venda_p bigint, nm_usuario_p text) FROM PUBLIC;

