-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_vl_lote_remessa ( nr_seq_lote_remessa_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_lote_rem_dest_w		pls_ame_lote_rem_destino.nr_sequencia%type;
nr_seq_lote_rem_arquivo_w	pls_ame_lote_rem_arquivo.nr_sequencia%type;
vl_total_w			pls_ame_lote_rem_arquivo.vl_total%type := 0;

-- Arquivo
c01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_ame_lote_rem_arquivo 	b
	where	b.nr_seq_lote_rem_dest = nr_seq_lote_rem_dest_w;

-- Destino
c02 CURSOR FOR
	SELECT	c.nr_sequencia
	from	pls_ame_lote_rem_destino 	c
	where	c.nr_seq_lote_rem = nr_seq_lote_remessa_p;


BEGIN
open c02;
loop
fetch c02 into
	nr_seq_lote_rem_dest_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	open c01;
	loop
	fetch c01 into
		nr_seq_lote_rem_arquivo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	coalesce((sum(vl_total)),0)
		--select	sum((nvl(vl_total,0)))
		into STRICT	vl_total_w
		from	pls_ame_lote_rem_valor
		where	nr_seq_lote_rem_arq = nr_seq_lote_rem_arquivo_w
		and	coalesce(nr_seq_titular::text, '') = '';

		update	pls_ame_lote_rem_arquivo
		set	vl_total = vl_total_w
		where	nr_sequencia = nr_seq_lote_rem_arquivo_w;

		vl_total_w := 0;

	end;
	end loop;
	close c01;

select	coalesce((sum(vl_total)),0)
into STRICT	vl_total_w
from	pls_ame_lote_rem_arquivo
where	nr_seq_lote_rem_dest = nr_seq_lote_rem_dest_w;

update	pls_ame_lote_rem_destino
set	vl_total = vl_total_w
where	nr_sequencia = nr_seq_lote_rem_dest_w;

vl_total_w := 0;

end;
end loop;
close c02;

select	coalesce((sum(vl_total)),0)
into STRICT	vl_total_w
from	pls_ame_lote_rem_destino
where	nr_seq_lote_rem = nr_seq_lote_remessa_p;

update	pls_ame_lote_remessa
set	vl_total = vl_total_w
where	nr_sequencia = nr_seq_lote_remessa_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_vl_lote_remessa ( nr_seq_lote_remessa_p bigint, nm_usuario_p text ) FROM PUBLIC;
