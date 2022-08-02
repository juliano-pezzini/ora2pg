-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_item_ap_lote_item ( nr_seq_lote_p bigint, nr_seq_horario_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_reg_w	bigint;


BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update  ap_lote_item
	set     dt_retirada = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where   nr_seq_lote = nr_seq_lote_p
	and     nr_seq_mat_hor = nr_seq_horario_p;

    
	select	count(1)
	into STRICT	qt_reg_w
	from	ap_lote_item
	where	nr_seq_lote = nr_seq_lote_p
	and		coalesce(dt_retirada::text, '') = '';

	if (qt_reg_w	= 0) then
		CALL cancelar_ap_lote(nr_seq_lote_p,nm_usuario_p);
	end if;

	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_item_ap_lote_item ( nr_seq_lote_p bigint, nr_seq_horario_p bigint, nm_usuario_p text) FROM PUBLIC;

