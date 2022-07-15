-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_lotes_gerados ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_lote_w		bigint;
ie_status_lote_w		varchar(1);

C01 CURSOR FOR
	SELECT	nr_seq_lote
	from	ap_lote_agrup_item
	where 	nr_seq_agrup = nr_sequencia_p;


BEGIN

Open C01;
loop
fetch C01 into
	nr_seq_lote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	ie_status_lote
	into STRICT	ie_status_lote_w
	from	ap_lote
	where	nr_sequencia = nr_seq_lote_w;

	if (coalesce(ie_status_lote_w,'A') <> 'C') then
		update	ap_lote
		set	ie_status_lote		= 'A',
			dt_disp_farmacia	 = NULL,
			nm_usuario_disp		 = NULL,
			ds_maquina_disp		 = NULL,
			cd_perfil_disp		 = NULL
		where	nr_sequencia		= nr_seq_lote_w;
	else
		update	ap_lote
		set	dt_disp_farmacia	 = NULL,
			nm_usuario_disp		 = NULL,
			ds_maquina_disp		 = NULL,
			cd_perfil_disp		 = NULL
		where	nr_sequencia		= nr_seq_lote_w;
	end if;
	end;
end loop;
close C01;

delete from ap_lote_agrup
where nr_sequencia = nr_sequencia_p;

delete from ap_lote_agrup_item
where nr_seq_agrup = nr_sequencia_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_lotes_gerados ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

