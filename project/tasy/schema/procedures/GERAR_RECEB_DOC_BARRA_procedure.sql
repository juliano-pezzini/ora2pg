-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_receb_doc_barra ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_w	integer;

c01 CURSOR FOR
	SELECT	nr_seq_item
	from	protocolo_doc_item
	where	nr_sequencia = nr_sequencia_p
	and		coalesce(dt_retirada::text, '') = '';


BEGIN
if (nr_sequencia_p	> 0) then
	begin
	open c01;
	loop
	fetch c01 into
		nr_seq_item_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		update	protocolo_doc_item
		set	dt_recebimento		= clock_timestamp(),
			nm_usuario_receb		= nm_usuario_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_sequencia_p
		and	coalesce(dt_retirada::text, '') = ''
		and	coalesce(dt_recebimento::text, '') = '';
	end loop;
	close c01;
	update	protocolo_documento
	set	dt_rec_destino		= clock_timestamp(),
		nm_usuario_receb		= nm_usuario_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_sequencia_p;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_receb_doc_barra ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

