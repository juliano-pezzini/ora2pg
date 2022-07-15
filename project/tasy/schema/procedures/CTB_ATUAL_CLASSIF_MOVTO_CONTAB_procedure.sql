-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_atual_classif_movto_contab ( nr_lote_contabil_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_classif_nova_w			varchar(40);
ds_erro_w				varchar(2000);

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.dt_movimento,
	a.cd_conta_contabil,
	a.cd_classificacao
from	movimento_contabil a
where	a.nr_lote_contabil	= nr_lote_contabil_p;

vet01	C01%RowType;


BEGIN

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	cd_classif_nova_w	:= ctb_obter_classif_conta(vet01.cd_conta_contabil, null, vet01.dt_movimento);

	/*Sobrepor - Atualiza o registro porem somente se trocou a classificaçao */

	if (coalesce(vet01.cd_classificacao,'X') <> coalesce(cd_classif_nova_w,'X')) then

		begin
		update	movimento_contabil
		set	cd_classificacao	= cd_classif_nova_w
		where	nr_lote_contabil	= nr_lote_contabil_p
		and	nr_sequencia	= vet01.nr_sequencia;
		exception when others then
			ds_erro_w	:= substr(nr_lote_contabil_p || ' / ' || vet01.nr_sequencia || ' / ' ||
						vet01.cd_conta_contabil,1,2000);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(266397,'DS_ERRO_W=' || ds_erro_w);
		end;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_atual_classif_movto_contab ( nr_lote_contabil_p bigint, nm_usuario_p text) FROM PUBLIC;

