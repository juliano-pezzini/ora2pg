-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_conta_atualizar_material (nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_mat_w		bigint;
cd_material_imp_w		bigint;
ie_origem_preco_imp_w		smallint;
cd_brasindice_w			varchar(15);
nr_seq_material_w		bigint;
cd_simpro_w			bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		somente_numero(cd_material_imp),
		ie_origem_preco_imp
	from	pls_conta_mat
	where	nr_seq_conta	= nr_seq_conta_p
	and	coalesce(nr_seq_material::text, '') = '';


BEGIN

open c01;
loop
fetch c01 into	nr_seq_conta_mat_w,
		cd_material_imp_w,
		ie_origem_preco_imp_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	nr_seq_material_w	:= null;


	if (ie_origem_preco_imp_w = 5) then

		select	coalesce(max(cd_tiss),'0')
		into STRICT	cd_brasindice_w
		from	brasindice_preco
		where	cd_tiss	= cd_material_imp_w;

		if (cd_brasindice_w <> '0') then

			select	max(nr_sequencia)
			into STRICT	nr_seq_material_w
			from	pls_material
			where	cd_tiss_brasindice	= cd_brasindice_w;
		end if;

	elsif (ie_origem_preco_imp_w = 12) then

		select	coalesce(max(cd_simpro),0)
		into STRICT	cd_simpro_w
		from	simpro_preco
		where	cd_simpro	= cd_material_imp_w;

		if (cd_simpro_w > 0) then

			select	max(nr_sequencia)
			into STRICT	nr_seq_material_w
			from	pls_material
			where	cd_simpro	= cd_simpro_w;

		end if;

	elsif (ie_origem_preco_imp_w in (95,96,99)) then

		select	max(nr_sequencia)
		into STRICT	nr_seq_material_w
		from	pls_material
		where	nr_sequencia	= cd_material_imp_w;

	end if;

	if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then

		update	pls_conta_mat
		set	nr_seq_material	= nr_seq_material_w,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_conta_mat_w;

	end if;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conta_atualizar_material (nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

