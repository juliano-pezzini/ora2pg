-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_liberar_medic_ext (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_total_material_pac_w		bigint;
qt_material_w			bigint;


BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then

	if (hd_obter_dados_entrega(nr_sequencia_p,'T') = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(313645);
	end if;

	SELECT	SUM(qt_material)
	INTO STRICT	qt_total_material_pac_w
	FROM	hd_lote_paciente
	WHERE	nr_seq_entrega = nr_sequencia_p;

	SELECT	SUM(qt_material)
	INTO STRICT	qt_material_w
	FROM 	HD_LOTE_MEDIC_EXT
	WHERE	nr_seq_entrega = nr_sequencia_p;

	if (qt_total_material_pac_w > qt_material_w) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(208406);
	end if;

	update	hd_entrega_medic
	set	dt_liberacao = clock_timestamp(),
		nm_usuario   = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;

	delete
	from	hd_lote_paciente
	where	nr_seq_entrega = nr_sequencia_p
	and	qt_material = 0;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_liberar_medic_ext (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

