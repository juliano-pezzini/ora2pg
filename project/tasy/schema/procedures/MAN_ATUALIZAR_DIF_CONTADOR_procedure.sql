-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualizar_dif_contador ( nr_sequencia_p bigint, ie_opcao_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	IE_OPCAO
		1 - Qunado Insert
		3 - Quando Delet
		2 - Quando Edit
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_contador_w			double precision	:= 0;
qt_contador_ant_w		double precision	:= 0;
nr_sequencia_w			bigint;
nr_sequencia_ant_w		bigint;
qt_existe_w			bigint;


BEGIN
if (ie_opcao_p in (1,2)) then
	begin
	select	coalesce(max(qt_contador),0)
	into STRICT	qt_contador_w
	from	man_equip_contador a
	where	nr_sequencia	= nr_sequencia_p
	and	coalesce(dt_cancelamento::text, '') = '';

	select	coalesce(max(qt_contador),0),
		max(a.nr_sequencia)
	into STRICT	qt_contador_ant_w,
		nr_sequencia_ant_w
	from	man_equip_contador a
	where	nr_seq_equipamento	= (	SELECT	nr_seq_equipamento
						from	man_equip_contador x
						where	x.nr_sequencia	= nr_sequencia_p
						and	coalesce(x.dt_cancelamento::text, '') = '')
	and	dt_registro	= (	select	max(dt_registro)
					from	man_equip_contador b
					where	a.nr_seq_equipamento = b.nr_seq_equipamento
					and	b.nr_sequencia <> nr_sequencia_p
					and	b.nr_sequencia < nr_sequencia_p
					and	coalesce(b.dt_cancelamento::text, '') = '');

	if (qt_contador_ant_w >= 0) and (qt_contador_w >= 0) and (nr_sequencia_ant_w IS NOT NULL AND nr_sequencia_ant_w::text <> '') then
		update	man_equip_contador
		set	qt_diferenca	= qt_contador_w - qt_contador_ant_w
		where	nr_sequencia	= nr_sequencia_p;
	end if;

	end;
end if;

if (ie_opcao_p in (2,3)) then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	man_equip_contador a
	where	a.nr_seq_equipamento	= (	SELECT	nr_seq_equipamento
						from	man_equip_contador x
						where	x.nr_sequencia	= nr_sequencia_p
						and	coalesce(x.dt_cancelamento::text, '') = '')
	and	a.nr_sequencia	= (	select	min(x.nr_sequencia)
					from	man_equip_contador x
					where	x.dt_registro > (	select	dt_registro
									from	man_equip_contador b
									where	x.nr_seq_equipamento = b.nr_seq_equipamento
									and	b.nr_sequencia = nr_sequencia_p
									and	coalesce(b.dt_cancelamento::text, '') = ''));
	if (qt_existe_w <> 0) then
		begin
		select	coalesce(max(qt_contador),0),
			nr_sequencia
		into STRICT	qt_contador_w,
			nr_sequencia_w
		from	man_equip_contador a
		where	nr_seq_equipamento	= (	SELECT	nr_seq_equipamento
							from	man_equip_contador x
							where	x.nr_sequencia	= nr_sequencia_p
							and	coalesce(x.dt_cancelamento::text, '') = '')
		and	a.nr_sequencia = (	select	min(x.nr_sequencia)
						from	man_equip_contador x
						where	x.dt_registro > (	select	dt_registro
										from	man_equip_contador b
										where	x.nr_seq_equipamento = b.nr_seq_equipamento
										and	b.nr_sequencia = nr_sequencia_p
										and	coalesce(b.dt_cancelamento::text, '') = ''))
		group	by nr_sequencia;
		end;
	end if;

	if (ie_opcao_p = 3) then
		begin
		select	coalesce(max(qt_contador),0)
		into STRICT	qt_contador_ant_w
		from	man_equip_contador a
		where	nr_seq_equipamento	= (	SELECT	nr_seq_equipamento
							from	man_equip_contador x
							where	x.nr_sequencia	= nr_sequencia_p
							and	coalesce(x.dt_cancelamento::text, '') = '')
		and	a.nr_sequencia = (	select	max(x.nr_sequencia)
						from	man_equip_contador x
						where	x.dt_registro < (	select	dt_registro
										from	man_equip_contador b
										where	x.nr_seq_equipamento = b.nr_seq_equipamento
										and	b.nr_sequencia = nr_sequencia_p
										and	coalesce(b.dt_cancelamento::text, '') = ''));
		end;
	else
		begin
		select	coalesce(max(qt_contador),0)
		into STRICT	qt_contador_ant_w
		from	man_equip_contador a
		where	nr_sequencia	= nr_sequencia_p
		and	coalesce(dt_cancelamento::text, '') = '';
		end;
	end if;

	if (qt_contador_ant_w >= 0) and (qt_contador_w > 0) then
		update	man_equip_contador
		set	qt_diferenca	= qt_contador_w - qt_contador_ant_w
		where	nr_sequencia	= nr_sequencia_w;
	end if;

	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualizar_dif_contador ( nr_sequencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;
