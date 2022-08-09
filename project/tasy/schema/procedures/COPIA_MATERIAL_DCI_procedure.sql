-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_material_dci ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Campos da tabela LOOP */

nr_seq_dci_w			bigint;

/*  Sequencia da tabela */

nr_sequencia_w			bigint;

C01 CURSOR FOR
	SELECT	nr_seq_dci
	from	material_dci
	where	cd_material = cd_material_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_dci_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('material_dci_seq')
	into STRICT	nr_sequencia_w
	;

	insert into material_dci(	nr_sequencia,
				cd_material,
				dt_atualizacao,
				nm_usuario,
				nr_seq_dci
				)
	values (	nr_sequencia_w,
				cd_material_novo_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_dci_w
				);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_material_dci ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) FROM PUBLIC;
