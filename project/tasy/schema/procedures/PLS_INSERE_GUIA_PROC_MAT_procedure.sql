-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_insere_guia_proc_mat ( nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE



nr_seq_guia_w		pls_guia_plano.nr_sequencia%type;
nr_seq_segurado_w 	pls_segurado.nr_sequencia%type;
nr_seq_prestador_w	pls_prestador.nr_sequencia%type;
nr_seq_guia_proc_w	pls_guia_plano_proc.nr_sequencia%type;
nr_seq_guia_mat_w	pls_guia_plano_mat.nr_sequencia%type;

C01 CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia nr_seq_conta_proc,
		null nr_seq_conta_mat,
		cd_procedimento cd_item,
		ie_origem_proced,
		null nr_seq_material,
		coalesce(qt_procedimento_imp,1) qt_apresentacao
	from	pls_conta_proc
	where	nr_seq_conta 	= nr_seq_conta_pc
	and	ie_status 	!= 'D'
	and	coalesce(nr_seq_guia_proc::text, '') = ''
	
union all

	SELECT	null nr_seq_conta_proc,
		nr_sequencia nr_seq_conta_mat,
		cd_material cd_item,
		null ie_origem_proced,
		nr_seq_material,
		0 qt_apresentacao
	from	pls_conta_mat
	where	nr_seq_conta 	= nr_seq_conta_pc
	and	ie_status 	!= 'D'
	and	coalesce(nr_seq_guia_mat::text, '') = '';

BEGIN

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	-- Pegar os dados da conta que serão usados na comparação com os dados da guia
	select 	nr_seq_guia,
		nr_seq_segurado,
		nr_seq_prestador
	into STRICT	nr_seq_guia_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_p;

	--Varre os itens
	for r_C01_w in C01(nr_seq_conta_p) loop
		begin
		if (r_c01_w.nr_seq_conta_proc IS NOT NULL AND r_c01_w.nr_seq_conta_proc::text <> '') then
			-- Obter guia do procedimento
			select	min(b.nr_sequencia)
			into STRICT	nr_seq_guia_proc_w
			from	pls_guia_plano a,
				pls_guia_plano_proc b
			where	a.nr_sequencia 		= b.nr_seq_guia
			and	a.nr_seq_segurado 	= nr_seq_segurado_w
			and	((a.nr_sequencia 	= nr_seq_guia_w) or (a.nr_seq_guia_ok = nr_seq_guia_w and a.ie_tipo_guia in ('2','8')))
			and 	b.cd_procedimento	= r_C01_w.cd_item
			and	b.ie_origem_proced	= r_C01_w.ie_origem_proced
			and	b.qt_autorizada		= r_C01_w.qt_apresentacao
			and	a.ie_status		= '1'
			and	b.ie_status 		in ('L', 'P', 'S')
			and	not exists (SELECT	1
						from	pls_conta_proc x
						where	x.nr_seq_guia_proc	= b.nr_sequencia
						and	x.nr_seq_conta		= nr_seq_conta_p);

			if (coalesce(nr_seq_guia_proc_w::text, '') = '') then
				-- Obter guia do procedimento
				select	min(b.nr_sequencia)
				into STRICT	nr_seq_guia_proc_w
				from	pls_guia_plano a,
					pls_guia_plano_proc b
				where	a.nr_sequencia 		= b.nr_seq_guia
				and	a.nr_seq_segurado 	= nr_seq_segurado_w
				and	((a.nr_sequencia 	= nr_seq_guia_w) or (a.nr_seq_guia_ok = nr_seq_guia_w and a.ie_tipo_guia in ('2','8')))
				and 	b.cd_procedimento	= r_C01_w.cd_item
				and	b.ie_origem_proced	= r_C01_w.ie_origem_proced
				and	a.ie_status		= '1'
				and	b.ie_status 		in ('L', 'P', 'S')
				and	not exists (SELECT	1
							from	pls_conta_proc x
							where	x.nr_seq_guia_proc	= b.nr_sequencia
							and	x.nr_seq_conta		= nr_seq_conta_p);
			end if;

			if (nr_seq_guia_proc_w IS NOT NULL AND nr_seq_guia_proc_w::text <> '') then
				update 	pls_conta_proc
				set	nr_seq_guia 		= coalesce(nr_seq_guia,nr_seq_guia_w),
					nr_seq_guia_proc	= nr_seq_guia_proc_w,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia 		= r_C01_w.nr_seq_conta_proc;
			end if;

		elsif (r_c01_w.nr_seq_conta_mat IS NOT NULL AND r_c01_w.nr_seq_conta_mat::text <> '') then
			-- Obter guia do material
			select	min(b.nr_sequencia)
			into STRICT	nr_seq_guia_mat_w
			from	pls_guia_plano a,
				pls_guia_plano_mat b
			where	a.nr_sequencia 		= b.nr_seq_guia
			and	a.nr_seq_segurado 	= nr_seq_segurado_w
			and	((a.nr_sequencia 	= nr_seq_guia_w) or (a.nr_seq_guia_ok 	= nr_seq_guia_w and a.ie_tipo_guia in ('2','8')))
			and 	b.nr_seq_material	= r_C01_w.nr_seq_material
			and	a.ie_status		= '1'
			and	b.ie_status 		in ('L', 'P', 'S')
			and	not exists (SELECT	1
						from	pls_conta_mat x
						where	x.nr_seq_guia_mat	= b.nr_sequencia
						and	x.nr_seq_conta		= nr_seq_conta_p);

			if (nr_seq_guia_mat_w IS NOT NULL AND nr_seq_guia_mat_w::text <> '') then
				update 	pls_conta_mat
				set	nr_seq_guia 		= coalesce(nr_seq_guia,nr_seq_guia_w),
					nr_seq_guia_mat		= nr_seq_guia_mat_w,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia 		= r_C01_w.nr_seq_conta_mat;
			end if;
		end if;
		end;
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_insere_guia_proc_mat ( nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

