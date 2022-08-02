-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_atualizar_id_itens ( nr_seq_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_commit_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_item_w				varchar(255);
ds_item_agr_w				varchar(255);
ie_proc_ref_w				varchar(255);
nr_seq_conta_proc_w			bigint;
nr_seq_analise_w			bigint;
nr_identificador_w			bigint;
nr_seq_partic_w				bigint;
nr_seq_conta_proc_agr_w			bigint;
nr_seq_conta_mat_w			bigint;
nr_seq_conta_w				bigint;
nr_seq_conta_ww				bigint;
nr_id_w					bigint;
nr_id_analise_w				pls_conta_proc.nr_id_analise%type;
nr_seq_ajuste_fat_w			pls_conta.nr_seq_ajuste_fat%type;

/* Procedimentos principais */

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta,
		a.nr_id_analise
	from	pls_conta_proc	a,
		pls_conta	b
	where	b.nr_sequencia		= a.nr_seq_conta
	and	b.nr_seq_analise	= nr_seq_analise_w
	order by
		a.cd_procedimento,
		a.dt_procedimento,
		a.dt_inicio_proc;

/* Participantes */

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_id_analise
	from	pls_proc_participante	a
	where	a.nr_seq_conta_proc	= nr_seq_conta_proc_w
	and	coalesce(a.nr_id_analise::text, '') = ''
	order by
		a.nr_sequencia;

/* Materiais */

C03 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_id_analise
	from	pls_conta_mat	a,
		pls_conta	b
	where	a.nr_seq_conta		= b.nr_sequencia
	and	b.nr_seq_analise	= nr_seq_analise_w
	and	coalesce(a.nr_id_analise::text, '') = ''
	order by
		CASE WHEN a.ie_tipo_despesa='2' THEN 1 WHEN a.ie_tipo_despesa='3' THEN 2  ELSE 3 END ,
		pls_obter_seq_codigo_material(a.nr_seq_material,''),
		a.nr_seq_material,
		a.dt_atendimento;

--Procedimentos de contas refat
C04 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta,
		a.nr_id_analise
	from	pls_conta_proc a
	where	nr_seq_conta = nr_seq_conta_p
	order by
		a.cd_procedimento,
		a.dt_procedimento,
		a.dt_inicio_proc;

--Materiais de contas  refat
C05 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_id_analise
	from	pls_conta_mat	a
	where	a.nr_seq_conta		= nr_seq_conta_p
	and	coalesce(a.nr_id_analise::text, '') = ''
	order by
		CASE WHEN a.ie_tipo_despesa='2' THEN 1 WHEN a.ie_tipo_despesa='3' THEN 2  ELSE 3 END ,
		pls_obter_seq_codigo_material(a.nr_seq_material,''),
		a.nr_seq_material,
		a.dt_atendimento;

/* Participantes  em procedimentos presentesem contas de refaturamento*/

C06 CURSOR( nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
			a.nr_id_analise
	from	pls_proc_participante	a
	where	a.nr_seq_conta_proc	= nr_seq_conta_proc_pc
	and	coalesce(a.nr_id_analise::text, '') = ''
	order by
		a.nr_sequencia;
BEGIN

begin
	select	a.nr_seq_analise,
		a.nr_seq_ajuste_fat
	into STRICT	nr_seq_analise_w,
		nr_seq_ajuste_fat_w
	from	pls_conta	a
	where	a.nr_sequencia	= nr_seq_conta_p;
exception
when others then
	nr_seq_analise_w	:= null;
end;

if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then
	CALL wheb_usuario_pck.set_ie_executar_trigger('N');

	select	max(nr_identificador)
	into STRICT	nr_identificador_w
	from (SELECT	a.nr_id_analise nr_identificador
		from	pls_conta_mat	a,
			pls_conta	b
		where	b.nr_sequencia		= a.nr_seq_conta
		and	b.nr_seq_analise	= nr_seq_analise_w
		
union all

		SELECT	a.nr_id_analise nr_identificador
		from	pls_conta_proc	a,
			pls_conta	b
		where	b.nr_sequencia		= a.nr_seq_conta
		and	b.nr_seq_analise	= nr_seq_analise_w
		
union all

		select	a.nr_id_analise nr_identificador
		from	pls_proc_participante	c,
			pls_conta_proc		a,
			pls_conta		b
		where	a.nr_sequencia		= c.nr_seq_conta_proc
		and	b.nr_sequencia		= a.nr_seq_conta
		and	b.nr_seq_analise	= nr_seq_analise_w) alias1;

	nr_identificador_w	:= coalesce(nr_identificador_w, 0);

	open C01;
	loop
	fetch C01 into
		nr_seq_conta_proc_w,
		nr_seq_conta_w,
		nr_id_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	max(nr_id_analise)
		into STRICT	nr_id_analise_w
		from	pls_conta_proc
		where	nr_sequencia	= nr_seq_conta_proc_w;

		if (coalesce(nr_id_analise_w::text, '') = '') then
			nr_identificador_w	:= nr_identificador_w + 1;

			update	pls_conta_proc
			set	nr_id_analise	= nr_identificador_w
			where	nr_sequencia	= nr_seq_conta_proc_w;
		end if;

		open C02;
		loop
		fetch C02 into
			nr_seq_partic_w,
			nr_id_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			nr_identificador_w	:= nr_identificador_w + 1;

			update	pls_proc_participante
			set	nr_id_analise	= nr_identificador_w
			where	nr_sequencia	= nr_seq_partic_w
			and	coalesce(nr_id_analise::text, '') = '';
			end;
		end loop;
		close C02;
		end;
	end loop;
	close C01;

	if (ie_commit_p = 'S') then
		commit;
	end if;

	open C03;
	loop
	fetch C03 into
		nr_seq_conta_mat_w,
		nr_id_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		nr_identificador_w	:= nr_identificador_w + 1;

		update	pls_conta_mat
		set	nr_id_analise	= nr_identificador_w
		where	nr_sequencia	= nr_seq_conta_mat_w
		and	coalesce(nr_id_analise::text, '') = '';
		end;
	end loop;
	close C03;

	if (ie_commit_p = 'S') then
		commit;
	end if;

	CALL wheb_usuario_pck.set_ie_executar_trigger('S');
end if;

--Se for conta oriunda de ajuste de refaturamento, não haverá análise, então é preciso atualizar id_analise de modo diferente.
if (nr_seq_ajuste_fat_w IS NOT NULL AND nr_seq_ajuste_fat_w::text <> '') then

	if (coalesce(nr_identificador_w::text, '') = '') then

		select	max(nr_identificador)
		into STRICT	nr_identificador_w
		from (SELECT	a.nr_id_analise nr_identificador
			from	pls_conta_mat	a
			where	a.nr_seq_conta = nr_seq_conta_p
			
union all

			SELECT	a.nr_id_analise nr_identificador
			from	pls_conta_proc	a
			where	a.nr_seq_conta = nr_seq_conta_p
			
union all

			select	a.nr_id_analise nr_identificador
			from	pls_proc_participante	c,
				pls_conta_proc		a
			where	a.nr_sequencia		= c.nr_seq_conta_proc
			and	a.nr_seq_conta		= nr_seq_conta_p) alias4;

		nr_identificador_w	:= coalesce(nr_identificador_w, 0);

	end if;

	for r_c04_w in C04 loop

		select	max(nr_id_analise)
		into STRICT	nr_id_analise_w
		from	pls_conta_proc
		where	nr_sequencia	= r_c04_w.nr_sequencia;

		if (coalesce(nr_id_analise_w::text, '') = '') then
			nr_identificador_w	:= nr_identificador_w + 1;

			update	pls_conta_proc
			set	nr_id_analise	= nr_identificador_w
			where	nr_sequencia	= r_c04_w.nr_sequencia;
		end if;


		for r_c06_w in C06(r_c04_w.nr_sequencia) loop

			nr_identificador_w	:= nr_identificador_w + 1;

			update	pls_proc_participante
			set		nr_id_analise	= nr_identificador_w
			where	nr_sequencia	= r_c06_w.nr_sequencia
			and		coalesce(nr_id_analise::text, '') = '';

		end loop;

	end loop;

	for r_c05_w in C05 loop

		nr_identificador_w	:= nr_identificador_w + 1;

		update	pls_conta_mat
		set	nr_id_analise	= nr_identificador_w
		where	nr_sequencia	= r_c05_w.nr_sequencia
		and	coalesce(nr_id_analise::text, '') = '';

	end loop;

	if (ie_commit_p = 'S') then
		commit;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_atualizar_id_itens ( nr_seq_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_commit_p text) FROM PUBLIC;

