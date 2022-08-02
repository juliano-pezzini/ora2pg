-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_mat_tab_prec_prest ( nr_seq_prestador_p bigint, nr_seq_material_preco_p bigint, dt_inicio_vigencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ie_somente_vigentes_p text) AS $body$
DECLARE


qt_registro_w			bigint;
cd_material_w			bigint;
nr_seq_material_w		bigint;
ie_situacao_w			pls_material_preco_item.ie_situacao%type;

					
C01 CURSOR FOR
	SELECT	cd_material,
		ie_situacao,
		nr_seq_material
	from	pls_material_preco_item
	where	nr_seq_material_preco  = nr_seq_material_preco_p;

					

BEGIN

if (nr_seq_material_preco_p IS NOT NULL AND nr_seq_material_preco_p::text <> '') then
	open C01;
	loop
	fetch C01 into	
		cd_material_w,
		ie_situacao_w,
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_prestador_mat
		where	nr_seq_prestador = nr_seq_prestador_p
		and	cd_material	 = cd_material_w;
		
		if (qt_registro_w = 0) then
			if (ie_somente_vigentes_p = 'N') or (ie_situacao_w = 'A') then
					insert into pls_prestador_mat(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_prestador,
						cd_material,
						ie_liberar,
						dt_inicio_vigencia,
						ie_internado,
						nr_seq_material)
					values (nextval('pls_prestador_mat_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_prestador_p,
						cd_material_w,
						'S',
						dt_inicio_vigencia_p,
						'N',
						nr_seq_material_w);		
			end if;	
		end if;
		end;
	end loop;
	close C01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_mat_tab_prec_prest ( nr_seq_prestador_p bigint, nr_seq_material_preco_p bigint, dt_inicio_vigencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ie_somente_vigentes_p text) FROM PUBLIC;

