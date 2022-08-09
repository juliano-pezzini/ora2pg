-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_fluxo_caixa_agrup (nr_seq_agrupador_p bigint, dt_referencia_p timestamp, ie_diario_p text, nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, ie_restringe_estab_p text) AS $body$
DECLARE


ds_create_w		varchar(32000) := '';
ds_insert_w		varchar(32000) := '';
ds_values_w		varchar(32000) := '';
ds_comando_w		varchar(32000)	:= '';
ds_valor_w		varchar(4000)	:= '';
ds_formula_w		formula_fluxo_caixa_agrup.ds_formula%type;
nr_seq_coluna_w		fluxo_caixa_agrup_coluna.nr_sequencia%type;
nr_seq_linha_w		fluxo_caixa_agrup_linha.nr_sequencia%type;
ie_tipo_coluna_w	fluxo_caixa_agrup_coluna.ie_tipo_coluna%type;
ie_virgula_w		varchar(10);
nr_atributo_w		bigint;

c03 CURSOR FOR
SELECT	a.nr_sequencia
from	fluxo_caixa_agrup_linha a
where	exists (select	1
	from	fluxo_caixa_agrup_valor x
	where	x.nr_seq_linha		= a.nr_sequencia
	and	x.nr_seq_agrupador	= nr_seq_agrupador_p)
and	a.nr_seq_agrupador	= nr_seq_agrupador_p
order by	a.nr_ordem_apres;

c04 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ie_tipo_coluna
from	fluxo_caixa_agrup_coluna a
where	exists (select	1
	from	fluxo_caixa_agrup_valor x
	where	x.nr_seq_coluna		= a.nr_sequencia
	and	x.nr_seq_agrupador	= nr_seq_agrupador_p)
and	a.nr_seq_agrupador	= nr_seq_agrupador_p
order by	a.nr_ordem_apres;


BEGIN

CALL exec_sql_dinamico('Tasy','drop table w_fluxo_caixa_agrup_' || nm_usuario_p);

ds_create_w	:= 'create table w_fluxo_caixa_agrup_' || nm_usuario_p || ' (';

ie_virgula_w	:= null;
nr_atributo_w	:= 1;

open C04;
loop
fetch C04 into
	nr_seq_coluna_w,
	ie_tipo_coluna_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
	ds_create_w	:= ds_create_w || ie_virgula_w || 'ds_atributo_' || nr_atributo_w;

	if (coalesce(ie_tipo_coluna_w,'C')	= 'C') then
		ds_create_w	:= ds_create_w || ' number(15,2)';
	elsif (ie_tipo_coluna_w		= 'D') then
		ds_create_w	:= ds_create_w || ' varchar2(255)';
	end if;

	nr_atributo_w	:= coalesce(nr_atributo_w,0) + 1;
	ie_virgula_w	:= ', ';
	end;
end loop;
close C04;

ds_create_w	:= ds_create_w || ') ';

CALL exec_sql_dinamico('Tasy',ds_create_w);

open	C03;
loop
fetch	C03 into
	nr_seq_linha_w;
EXIT WHEN NOT FOUND; /* apply on C03 */

	ds_insert_w	:= 'insert into w_fluxo_caixa_agrup_' || nm_usuario_p || ' (';
	ds_values_w	:= ' values (';
	ie_virgula_w	:= null;
	nr_atributo_w	:= 1;

	open	C04;
	loop
	fetch	C04 into
		nr_seq_coluna_w,
		ie_tipo_coluna_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */

		select	max(b.ds_formula)
		into STRICT	ds_formula_w
		from	formula_fluxo_caixa_agrup b,
			fluxo_caixa_agrup_valor a
		where	a.nr_seq_formula	= b.nr_sequencia
		and	a.nr_seq_coluna		= nr_seq_coluna_w
		and	a.nr_seq_linha		= nr_seq_linha_w
		and	a.nr_seq_agrupador	= nr_seq_agrupador_p;

		if (coalesce(ds_formula_w::text, '') = '') then
			ds_valor_w	:= 'null';
		else
			ds_valor_w	:= obter_desc_linha_formula_fluxo(	ds_formula_w,
										dt_referencia_p,
										dt_inicial_p,
										dt_final_p,
										ie_diario_p,
										cd_estabelecimento_p,
										ie_restringe_estab_p,
										nm_usuario_p);
		end if;

		ds_insert_w	:= ds_insert_w || ie_virgula_w || 'ds_atributo_' || nr_atributo_w;

		if (coalesce(ie_tipo_coluna_w,'C')	= 'C') then

			ds_values_w	:= ds_values_w || ie_virgula_w || 'to_number(' || ds_valor_w || ')';

		elsif (ie_tipo_coluna_w		= 'D') then

			ds_values_w	:= ds_values_w || ie_virgula_w || 'substr(' || chr(39) || ds_valor_w || chr(39) || ',1,255)';

		end if;
		ie_virgula_w	:= ', ';
		nr_atributo_w	:= coalesce(nr_atributo_w,0) + 1;

	end	loop;
	close	C04;

	ds_insert_w	:= ds_insert_w || ') ';
	ds_values_w	:= ds_values_w || ') ';

	ds_comando_w	:= ds_insert_w || ds_values_w;

	CALL exec_sql_dinamico('Tasy',ds_comando_w);
end	loop;
close	C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_fluxo_caixa_agrup (nr_seq_agrupador_p bigint, dt_referencia_p timestamp, ie_diario_p text, nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, ie_restringe_estab_p text) FROM PUBLIC;
