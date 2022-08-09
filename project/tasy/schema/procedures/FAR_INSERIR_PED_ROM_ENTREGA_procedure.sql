-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_inserir_ped_rom_entrega (nr_seq_pedido_p bigint, nr_seq_romaneio_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;


BEGIN

if (nr_seq_pedido_p IS NOT NULL AND nr_seq_pedido_p::text <> '') and (nr_seq_romaneio_p IS NOT NULL AND nr_seq_romaneio_p::text <> '') then
	begin

	select	nextval('far_rom_entrega_pedido_seq')
	into STRICT	nr_sequencia_w
	;

	insert into far_rom_entrega_pedido(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_romaneio,
			nr_seq_pedido,
			dt_entrega_real) values (
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_romaneio_p,
				nr_seq_pedido_p,
				null);

	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_inserir_ped_rom_entrega (nr_seq_pedido_p bigint, nr_seq_romaneio_p bigint, nm_usuario_p text) FROM PUBLIC;
