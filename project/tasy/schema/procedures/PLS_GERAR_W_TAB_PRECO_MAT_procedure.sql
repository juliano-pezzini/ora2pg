-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_tab_preco_mat ( nr_seq_material_p bigint, dt_ano_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_delete_simpro_w		varchar(1)	:= 'S';
ie_delete_brasindice_w		varchar(1)	:= 'S';

-- jjung OS 523315 - Inserido a nova tabela que é utilizada para armazenar os preços nos cursores C01 e C02
C01 CURSOR(	dt_ano_p		bigint,
		nr_seq_material_p	pls_material_preco_item.nr_seq_material%type) FOR

	SELECT	/*+RULE*/ b.nr_seq_material nr_seq_material,
		a.vl_material vl_material,
		c.nr_sequencia nr_seq_tabela,
		(to_char(a.dt_inicio_vigencia,'mm'))::numeric  nr_mes
	from	pls_material_valor_item	a,
		pls_material_preco_item	b,
		pls_material_preco	c
	where	a.dt_inicio_vigencia between 	pls_manipulacao_datas_pck.comeco_ano(to_char(dt_ano_p),'N') and
						pls_manipulacao_datas_pck.fim_ano(to_char(dt_ano_p), 'N')
	and	b.nr_sequencia 		= a.nr_seq_preco_item
	and	b.nr_seq_material	= nr_seq_material_p
	and	b.ie_situacao		= 'A'
	and	c.nr_sequencia 		= b.nr_seq_material_preco
	and	c.ie_situacao		= 'A'
	and	c.ie_exibe_cad_mat	= 'S'
	and	exists ( 	SELECT	1
				from	w_pls_preco_material x
				where	x.nr_seq_material = b.nr_seq_material
				and	x.nr_seq_tabela = c.nr_sequencia
				and	x.nm_usuario = nm_usuario_p)
	order by nr_mes;

C02 CURSOR(	dt_ano_p		bigint,
		nm_usuario_p		usuario.nm_usuario%type,
		nr_seq_material_p	pls_material_preco_item.nr_seq_material%type) FOR

	SELECT	/*+RULE*/ a.nr_sequencia nr_seq_tabela,
		b.nr_seq_material nr_seq_material,
		c.vl_material vl_material,
		c.dt_inicio_vigencia dt_inicio_vigencia
	from	pls_material_preco	a,
		pls_material_preco_item	b,
		pls_material_valor_item	c
	where	a.ie_exibe_cad_mat	= 'S'
	and	b.nr_seq_material_preco = a.nr_sequencia
	and	b.nr_seq_material = nr_seq_material_p
	and	b.ie_situacao = 'A'
	and	c.nr_seq_preco_item = b.nr_sequencia
	and	c.dt_inicio_vigencia = (SELECT	max(x.dt_inicio_vigencia)
					from	pls_material_valor_item x
					where	x.nr_seq_preco_item = b.nr_sequencia
					and	x.dt_inicio_vigencia <= pls_manipulacao_datas_pck.fim_ano(to_char(dt_ano_p),'N'))
	and	not exists (select	1
				from	w_pls_preco_material x
				where	x.nr_seq_tabela	= a.nr_sequencia
				and	x.nm_usuario	= nm_usuario_p);

C03 CURSOR(	dt_ano_p		bigint,
		nr_seq_material_p	pls_material.nr_sequencia%type) FOR

	SELECT	a.nr_sequencia nr_seq_material,
		CASE WHEN b.vl_preco_venda=0 THEN b.vl_preco_fabrica  ELSE b.vl_preco_venda END  vl_material,
		(to_char(b.dt_vigencia,'mm'))::numeric  nr_mes
	from	pls_material		a,
		simpro_preco		b
	where	a.nr_sequencia = nr_seq_material_p
	and	b.cd_simpro	= a.cd_simpro
	and	b.dt_vigencia = (	SELECT	max(x.dt_vigencia)
					from	simpro_preco x
					where	x.cd_simpro = b.cd_simpro
					and	x.dt_vigencia <= pls_manipulacao_datas_pck.fim_ano(to_char(dt_ano_p),'N'))
	order by nr_mes;

C04 CURSOR(	dt_ano_p		bigint,
		nr_seq_material_p	pls_material.nr_sequencia%type) FOR

	SELECT	a.nr_sequencia		nr_seq_material,
		e.vl_preco_medicamento	vl_material,
		(to_char(e.dt_inicio_vigencia,'mm'))::numeric  nr_mes
	from	pls_material		a,
		material		b,
		material_brasindice	c,
		brasindice_medicamento	d,
		brasindice_preco	e
	where	a.nr_sequencia		= nr_seq_material_p
	and	a.cd_material		= b.cd_material
	and	c.cd_material		= b.cd_material
	and	c.cd_medicamento	= d.cd_medicamento
	and	e.cd_medicamento	= d.cd_medicamento
	and	e.dt_inicio_vigencia = (	SELECT	max(x.dt_inicio_vigencia)
						from	brasindice_preco x
						where	x.cd_medicamento = e.cd_medicamento
						and	x.dt_inicio_vigencia <= pls_manipulacao_datas_pck.fim_ano(to_char(dt_ano_p),'N'))
	order by nr_mes;
BEGIN

-- Limpar geracao anterior.
delete from w_pls_preco_material where nm_usuario = nm_usuario_p;

for	r_C02_w in C02(dt_ano_p, nm_usuario_p, nr_seq_material_p) loop

	insert into w_pls_preco_material(nr_sequencia, nm_usuario, dt_atualizacao,
		nr_seq_material,
		vl_janeiro, vl_fevereiro, vl_marco,
		vl_abril, vl_maio, vl_junho,
		vl_julho, vl_agosto, vl_setembro,
		vl_outubro, vl_novembro, vl_dezembro,
		nr_seq_tabela, ie_tipo_tabela)
	values (nextval('w_pls_preco_material_seq'), nm_usuario_p, clock_timestamp(),
		r_C02_w.nr_seq_material,
		r_C02_w.vl_material, r_C02_w.vl_material, r_C02_w.vl_material,
		r_C02_w.vl_material, r_C02_w.vl_material, r_C02_w.vl_material,
		r_C02_w.vl_material, r_C02_w.vl_material, r_C02_w.vl_material,
		r_C02_w.vl_material, r_C02_w.vl_material, r_C02_w.vl_material,
		r_C02_w.nr_seq_tabela, 'T');
end loop;--C02
for	r_C01_w in C01(dt_ano_p,nr_seq_material_p) loop

	update	w_pls_preco_material
	set	vl_janeiro	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material  ELSE vl_janeiro END ,
		vl_fevereiro	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material  ELSE vl_fevereiro END ,
		vl_marco	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material  ELSE vl_marco END ,
		vl_abril	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material  ELSE vl_abril END ,
		vl_maio		= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material  ELSE vl_maio END ,
		vl_junho	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material  ELSE vl_junho END ,
		vl_julho	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=07 THEN  r_C01_w.vl_material  ELSE vl_julho END ,
		vl_agosto	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=07 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=08 THEN  r_C01_w.vl_material  ELSE vl_agosto END ,
		vl_setembro	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=07 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=08 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=09 THEN  r_C01_w.vl_material  ELSE vl_setembro END ,
		vl_outubro	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=07 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=08 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=09 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=10 THEN  r_C01_w.vl_material  ELSE vl_outubro END ,
		vl_novembro	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=07 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=08 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=09 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=10 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=11 THEN  r_C01_w.vl_material  ELSE vl_novembro END ,
		vl_dezembro	= CASE WHEN r_C01_w.nr_mes=01 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=02 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=03 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=04 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=05 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=06 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=07 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=08 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=09 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=10 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=11 THEN  r_C01_w.vl_material WHEN r_C01_w.nr_mes=12 THEN  r_C01_w.vl_material  ELSE vl_dezembro END
	where	nr_seq_material	= r_C01_w.nr_seq_material
	and	nr_seq_tabela	= r_C01_w.nr_seq_tabela
	and	nm_usuario	= nm_usuario_p;
end loop;-- C01
insert into w_pls_preco_material(nr_sequencia, nm_usuario, dt_atualizacao,
	nr_seq_material,
	vl_janeiro, vl_fevereiro, vl_marco,
	vl_abril, vl_maio, vl_junho,
	vl_julho, vl_agosto, vl_setembro,
	vl_outubro, vl_novembro, vl_dezembro,
	ie_tipo_tabela)
values (nextval('w_pls_preco_material_seq'), nm_usuario_p, clock_timestamp(),
	nr_seq_material_p,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	'S');

for	r_C03_w in C03(dt_ano_p, nr_seq_material_p) loop

	ie_delete_simpro_w	:= 'N';

	update	w_pls_preco_material
	set	vl_janeiro	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material  ELSE vl_janeiro END ,
		vl_fevereiro	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material  ELSE vl_fevereiro END ,
		vl_marco	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material  ELSE vl_marco END ,
		vl_abril	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material  ELSE vl_abril END ,
		vl_maio		= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material  ELSE vl_maio END ,
		vl_junho	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material  ELSE vl_junho END ,
		vl_julho	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=07 THEN  r_C03_w.vl_material  ELSE vl_julho END ,
		vl_agosto	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=07 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=08 THEN  r_C03_w.vl_material  ELSE vl_agosto END ,
		vl_setembro	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=07 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=08 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=09 THEN  r_C03_w.vl_material  ELSE vl_setembro END ,
		vl_outubro	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=07 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=08 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=09 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=10 THEN  r_C03_w.vl_material  ELSE vl_outubro END ,
		vl_novembro	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=07 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=08 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=09 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=10 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=11 THEN  r_C03_w.vl_material  ELSE vl_novembro END ,
		vl_dezembro	= CASE WHEN r_C03_w.nr_mes=01 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=02 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=03 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=04 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=05 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=06 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=07 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=08 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=09 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=10 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=11 THEN  r_C03_w.vl_material WHEN r_C03_w.nr_mes=12 THEN  r_C03_w.vl_material  ELSE vl_dezembro END
	where	nr_seq_material	= r_C03_w.nr_seq_material
	and	ie_tipo_tabela	= 'S'
	and	nm_usuario 	= nm_usuario_p;
end loop; --C03
if (ie_delete_simpro_w = 'S') then
	delete	from w_pls_preco_material
	where	nr_seq_material	= nr_seq_material_p
	and	nm_usuario	= nm_usuario_p
	and	ie_tipo_tabela	= 'S';
end if;

insert into w_pls_preco_material(nr_sequencia, nm_usuario, dt_atualizacao,
	nr_seq_material,
	vl_janeiro, vl_fevereiro, vl_marco,
	vl_abril, vl_maio, vl_junho,
	vl_julho, vl_agosto, vl_setembro,
	vl_outubro, vl_novembro, vl_dezembro,
	ie_tipo_tabela)
values (nextval('w_pls_preco_material_seq'),
	nm_usuario_p, clock_timestamp(), nr_seq_material_p,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	'B');

for	r_C04_w in C04(dt_ano_p,nr_seq_material_p) loop

	ie_delete_brasindice_w	:= 'N';

	update	w_pls_preco_material
	set	vl_janeiro	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material  ELSE vl_janeiro END ,
		vl_fevereiro	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material  ELSE vl_fevereiro END ,
		vl_marco	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material  ELSE vl_marco END ,
		vl_abril	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material  ELSE vl_abril END ,
		vl_maio		= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material  ELSE vl_maio END ,
		vl_junho	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material  ELSE vl_junho END ,
		vl_julho	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=07 THEN  r_C04_w.vl_material  ELSE vl_julho END ,
		vl_agosto	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=07 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=08 THEN  r_C04_w.vl_material  ELSE vl_agosto END ,
		vl_setembro	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=07 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=08 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=09 THEN  r_C04_w.vl_material  ELSE vl_setembro END ,
		vl_outubro	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=07 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=08 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=09 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=10 THEN  r_C04_w.vl_material  ELSE vl_outubro END ,
		vl_novembro	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=07 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=08 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=09 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=10 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=11 THEN  r_C04_w.vl_material  ELSE vl_novembro END ,
		vl_dezembro	= CASE WHEN r_C04_w.nr_mes=01 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=02 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=03 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=04 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=05 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=06 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=07 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=08 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=09 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=10 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=11 THEN  r_C04_w.vl_material WHEN r_C04_w.nr_mes=12 THEN  r_C04_w.vl_material  ELSE vl_dezembro END
	where	nr_seq_material	= r_C04_w.nr_seq_material
	and	ie_tipo_tabela	= 'B'
	and	nm_usuario 	= nm_usuario_p;
end loop; --C04
if (ie_delete_brasindice_w = 'S') then
	delete	from w_pls_preco_material
	where	nr_seq_material	= nr_seq_material_p
	and	nm_usuario	= nm_usuario_p
	and	ie_tipo_tabela	= 'B';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_tab_preco_mat ( nr_seq_material_p bigint, dt_ano_p bigint, nm_usuario_p text) FROM PUBLIC;

