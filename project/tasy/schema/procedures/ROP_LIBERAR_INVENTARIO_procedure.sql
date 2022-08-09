-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rop_liberar_inventario ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_roupa_w			bigint;
cd_material_w			integer;
cd_local_estoque_w		smallint;
cd_estabelecimento_w		smallint;
ie_requisicao_reposicao_w		varchar(1);
cd_local_atende_w			integer;
qt_estoque_w			double precision;
nr_sequencia_w			bigint;
qt_estoque_maximo_w		double precision;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_roupa,
	rop_obter_material_roupa(nr_seq_roupa)
from	rop_inv_roupa
where	nr_seq_inv_roupa = nr_sequencia_p;


BEGIN
select	cd_local_estoque,
	cd_estabelecimento,
	ie_requisicao_reposicao,
	cd_local_atende
into STRICT	cd_local_estoque_w,
	cd_estabelecimento_w,
	ie_requisicao_reposicao_w,
	cd_local_atende_w
from	rop_inventario
where	nr_sequencia = nr_sequencia_p;


if (ie_requisicao_reposicao_w = 'S') and (coalesce(cd_local_atende_w, 0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265551);
	--'Se informado a opção para (Gerar requisição), deve ser informado o local que atende'
end if;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_seq_roupa_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(qt_estoque),0)
	into STRICT	qt_estoque_w
	from	saldo_estoque
	where	cd_estabelecimento		= cd_estabelecimento_w
	and	dt_mesano_referencia	= trunc(clock_timestamp(),'mm')
	and	cd_local_estoque		= cd_local_estoque_w
	and	cd_material		= cd_material_w;

	update	rop_inv_roupa
	set	qt_saldo_estoque	= qt_estoque_w
	where	nr_sequencia	= nr_sequencia_w;

	if (ie_requisicao_reposicao_w = 'S') and (coalesce(cd_local_atende_w, 0) > 0 ) then
		begin

		select	coalesce(max(qt_estoque_maximo), 0)
		into STRICT	qt_estoque_maximo_w
		from	padrao_estoque_local
		where	cd_material		= cd_material_w
		and	cd_local_estoque		= cd_local_estoque_w
		and	cd_local_atende		= cd_local_atende_w
		and	ie_situacao		= 'A';

		if (qt_estoque_maximo_w > 0) then

			update	rop_inv_roupa
			set	qt_estoque_maximo	= qt_estoque_maximo_w
			where	nr_sequencia	= nr_sequencia_w;
		end if;


		end;
	end if;

	end;
end loop;
close C01;

update	rop_inventario
set	dt_liberacao	= clock_timestamp(),
	nm_usuario_lib	= nm_usuario_p
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rop_liberar_inventario ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
