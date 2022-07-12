-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_gera_plano (nr_seq_plano_p text) RETURNS varchar AS $body$
DECLARE


C01 CURSOR FOR
SELECT	nr_sequencia
from	man_plano_insp_item a
where	obter_se_contido(a.nr_seq_plano_inspecao,nr_seq_plano_p) = 'S'
and	coalesce(a.nr_seq_tipo_equip::text, '') = ''
and	a.nr_seq_plano_inspecao	= nr_seq_plano_p;

vet01_w			c01%rowtype;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	man_plano_insp_item_ativ a
	where	a.nr_seq_item = vet01_w.nr_sequencia;

vet02_w			c02%rowtype;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	man_plano_insp_item_acao a
	where	a.nr_seq_ativ = vet02_w.nr_sequencia;

vet03_w			c03%rowtype;

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	man_plano_insp_item_result a
	where	a.nr_seq_acao = vet03_w.nr_sequencia;

vet04_w			c04%rowtype;
cont_ativ_w		bigint	:= 0;
cont_acao_w		bigint	:= 0;
cont_result_w		bigint	:= 0;

ds_retorno_w			varchar(2) := 'S';


BEGIN
open C01;
loop
fetch C01 into
	vet01_w;
exit when(C01%notfound or ds_retorno_w = 'N');
	begin
	cont_ativ_w	:= 0;
	open C02;
	loop
	fetch C02 into
		vet02_w;
	exit when(C02%notfound or cont_ativ_w > 0);
		begin
		cont_acao_w	:= 0;
		cont_ativ_w	:= cont_ativ_w + 1;
		open C03;
		loop
		fetch C03 into
			vet03_w;
		exit when(C03%notfound or cont_acao_w > 0);
			begin
			cont_result_w	:= 0;
			cont_acao_w	:= cont_acao_w + 1;
			open C04;
			loop
			fetch C04 into
				vet04_w;
			exit when(C04%notfound or cont_result_w > 0);
				begin
				cont_result_w	:= cont_result_w + 1;
				end;
			end loop;
			close C04;
			end;

			if (cont_result_w	= 0) then
				ds_retorno_w	:= 'N';
			end if;

		end loop;
		close C03;

		if (cont_acao_w	= 0) then
			ds_retorno_w	:= 'N';
		end if;

		end;
	end loop;
	close C02;

	if (cont_ativ_w	= 0) then
		ds_retorno_w	:= 'N';
	end if;

	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_gera_plano (nr_seq_plano_p text) FROM PUBLIC;
