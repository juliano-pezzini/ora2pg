-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_acatar_rec_glosa_conta ( nr_seq_rec_glosa_conta_p pls_rec_glosa_conta.nr_sequencia%type, nr_seq_protocolo_p pls_rec_glosa_protocolo.nr_sequencia%type, ds_justificativa_p pls_rec_glosa_conta.ds_justificativa_oper%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_valor_acatar_p text, nr_seq_mot_lib_glosa_p pls_mot_rec_glosa.nr_sequencia%type) AS $body$
DECLARE


/*
ie_tipo_valor_acatar_p
	VRP - Valor recursado prestador
	VGO - Valor glosa original
	VGC - Valor glosa calculado
*/
vl_ref_w		pls_rec_glosa_conta.vl_total_acatado%type;
vl_recursado_w		double precision;
vl_glosa_proc_w		pls_conta_proc.vl_glosa%type;
vl_glosa_mat_w		pls_conta_mat.vl_glosa%type;
ds_justificativa_w	pls_rec_glosa_conta.ds_justificativa_oper%type;
qt_glosas_w		integer;
ie_acatado_glosa_w	pls_rec_glosa_conta.ie_acatado_glosa%type;
ie_acao_total_w		pls_rec_glosa_conta.ie_acao_total%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_conta_rec,
		(SELECT	count(1)
		 from	pls_rec_glosa_glosas b
		 where	b.nr_seq_conta_rec = a.nr_sequencia
		 and	coalesce(b.nr_seq_proc_rec::text, '') = ''
		 and	coalesce(b.nr_seq_mat_rec::text, '') = '') qt_glosas
	from	pls_rec_glosa_conta a
	where	a.nr_seq_protocolo = nr_seq_protocolo_p
	and	((ie_tipo_valor_acatar_p = 'VRP') or ((ie_tipo_valor_acatar_p <> 'VRP') and (coalesce(a.ie_acatado_glosa,'N') = 'N')))
	group by a.nr_sequencia;

C02 CURSOR(nr_seq_rec_glosa_conta_pc	pls_rec_glosa_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		vl_recursado,
		nr_seq_conta_proc
	from	pls_rec_glosa_proc
	where	nr_seq_conta_rec	= nr_seq_rec_glosa_conta_pc;

C03 CURSOR(nr_seq_rec_glosa_conta_pc	pls_rec_glosa_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		vl_recursado,
		nr_seq_conta_mat
	from	pls_rec_glosa_mat
	where	nr_seq_conta_rec	= nr_seq_rec_glosa_conta_pc;
BEGIN

if (nr_seq_rec_glosa_conta_p IS NOT NULL AND nr_seq_rec_glosa_conta_p::text <> '') then

	select	count(1)
	into STRICT	qt_glosas_w
	from	pls_rec_glosa_glosas
	where	nr_seq_conta_rec = nr_seq_rec_glosa_conta_p
	and	coalesce(nr_seq_proc_rec::text, '') = ''
	and	coalesce(nr_seq_mat_rec::text, '') = '';

	ds_justificativa_w := ds_justificativa_p;

	if (qt_glosas_w = 0) then
		ds_justificativa_w := null;
	end if;

	-- Se o tipo de acatar for por valor de glosa original ou calculado, então grava 'S' no campo ie_acatado_glosa, para que em uma próxima tentativa de acatar pelo valor original ou calculado o sistema aborte o processo visto que esta ação deve ser permitida somente uma vez
	if (ie_tipo_valor_acatar_p in ('VGO','VGC')) then
		-- Grava a justificativa, e os dados padrões de atualização de registro (data e usuário)
		update	pls_rec_glosa_conta
		set	ds_justificativa_oper	= ds_justificativa_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ie_acatado_glosa	= 'S'
		where	nr_sequencia		= nr_seq_rec_glosa_conta_p;
	else
		-- Grava a justificativa, e os dados padrões de atualização de registro (data e usuário)
		update	pls_rec_glosa_conta
		set	ds_justificativa_oper	= ds_justificativa_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_seq_rec_glosa_conta_p;
	end if;

	if (ie_tipo_valor_acatar_p = 'VRP') then
		update	pls_rec_glosa_proc
		set	vl_acatado		= vl_recursado,
			ds_justificativa_oper	= ds_justificativa_p,
			ie_status		= '3',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_seq_conta_rec	= nr_seq_rec_glosa_conta_p;

		update	pls_rec_glosa_mat
		set	vl_acatado		= vl_recursado,
			ds_justificativa_oper	= ds_justificativa_p,
			ie_status		= '3',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_seq_conta_rec	= nr_seq_rec_glosa_conta_p;

	elsif (ie_tipo_valor_acatar_p = 'VGO') then
		for r_C02_w in C02(nr_seq_rec_glosa_conta_p) loop
			select	max(vl_glosa)
			into STRICT	vl_glosa_proc_w
			from	pls_conta_proc
			where	nr_sequencia = r_C02_w.nr_seq_conta_proc;

			if (r_C02_w.vl_recursado < vl_glosa_proc_w) then
				vl_recursado_w := r_C02_w.vl_recursado;
			else
				vl_recursado_w := vl_glosa_proc_w;
			end if;

			update	pls_rec_glosa_proc
			set	vl_acatado		= vl_recursado_w,
				ds_justificativa_oper	= ds_justificativa_p,
				ie_status		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= r_C02_w.nr_sequencia;
		end loop;

		for r_C03_w in C03(nr_seq_rec_glosa_conta_p) loop
			select	max(vl_glosa)
			into STRICT	vl_glosa_mat_w
			from	pls_conta_mat
			where	nr_sequencia = r_C03_w.nr_seq_conta_mat;

			if (r_C03_w.vl_recursado < vl_glosa_mat_w) then
				vl_recursado_w := r_C03_w.vl_recursado;
			else
				vl_recursado_w := vl_glosa_mat_w;
			end if;

			update	pls_rec_glosa_mat
			set	vl_acatado		= vl_recursado_w,
				ds_justificativa_oper	= ds_justificativa_p,
				ie_status		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= r_C03_w.nr_sequencia;
		end loop;

	elsif (ie_tipo_valor_acatar_p = 'VGC') then
		for r_C02_w in C02(nr_seq_rec_glosa_conta_p) loop
			select	pls_obter_valor_glosa_calc(r_C02_w.nr_seq_conta_proc, null)
			into STRICT	vl_glosa_proc_w
			;

			if (r_C02_w.vl_recursado < vl_glosa_proc_w) then
				vl_recursado_w := r_C02_w.vl_recursado;
			else
				vl_recursado_w := vl_glosa_proc_w;
			end if;

			update	pls_rec_glosa_proc
			set	vl_acatado		= vl_recursado_w,
				ds_justificativa_oper	= ds_justificativa_p,
				ie_status		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= r_C02_w.nr_sequencia;
		end loop;

		for r_C03_w in C03(nr_seq_rec_glosa_conta_p) loop
			select	pls_obter_valor_glosa_calc(null, r_C03_w.nr_seq_conta_mat)
			into STRICT	vl_glosa_mat_w
			;

			if (r_C03_w.vl_recursado < vl_glosa_mat_w) then
				vl_recursado_w := r_C03_w.vl_recursado;
			else
				vl_recursado_w := vl_glosa_mat_w;
			end if;

			update	pls_rec_glosa_mat
			set	vl_acatado		= vl_recursado_w,
				ds_justificativa_oper	= ds_justificativa_p,
				ie_status		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= r_C03_w.nr_sequencia;
		end loop;
	end if;

	CALL pls_atualizar_valor_recurso(nr_seq_rec_glosa_conta_p,'C',nm_usuario_p);

	select	vl_total_acatado
	into STRICT	vl_ref_w
	from	pls_rec_glosa_conta
	where	nr_sequencia = nr_seq_rec_glosa_conta_p;

	CALL pls_gerar_log_rec_glosa('A', vl_ref_w, nr_seq_rec_glosa_conta_p, nm_usuario_p, 'C', null, nr_seq_mot_lib_glosa_p);

elsif (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	for r_C01_w in C01 loop

		ds_justificativa_w := ds_justificativa_p;

		if (r_C01_w.qt_glosas = 0) then
			ds_justificativa_w := null;
		end if;

		-- Se o tipo de acatar for por valor de glosa original ou calculado, então grava 'S' no campo ie_acatado_glosa, para que em uma próxima tentativa de acatar pelo valor original ou calculado o sistema aborte o processo visto que esta ação deve ser permitida somente uma vez
		if (ie_tipo_valor_acatar_p in ('VGO','VGC')) then
			ie_acatado_glosa_w := 'S';
		end if;

		-- Grava a justificativa, e os dados padrões de atualização de registro (data e usuário)
		update	pls_rec_glosa_conta
		set	ds_justificativa_oper	= ds_justificativa_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ie_acatado_glosa	= ie_acatado_glosa_w,
			ie_acao_total		= 'S'
		where	nr_sequencia		= r_C01_w.nr_seq_conta_rec;

		if (ie_tipo_valor_acatar_p = 'VRP') then
			update	pls_rec_glosa_proc
			set	vl_acatado		= vl_recursado,
				ds_justificativa_oper	= ds_justificativa_p,
				ie_status		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_acao_total		= 'S'
			where	nr_seq_conta_rec	= r_C01_w.nr_seq_conta_rec;

			update	pls_rec_glosa_mat
			set	vl_acatado		= vl_recursado,
				ds_justificativa_oper	= ds_justificativa_p,
				ie_status		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_acao_total		= 'S'
			where	nr_seq_conta_rec	= r_C01_w.nr_seq_conta_rec;

		elsif (ie_tipo_valor_acatar_p = 'VGO') then
			for r_C02_w in C02(r_C01_w.nr_seq_conta_rec) loop
				select	max(vl_glosa)
				into STRICT	vl_glosa_proc_w
				from	pls_conta_proc
				where	nr_sequencia = r_C02_w.nr_seq_conta_proc;

				if (r_C02_w.vl_recursado < vl_glosa_proc_w) then
					vl_recursado_w := r_C02_w.vl_recursado;
				else
					vl_recursado_w := vl_glosa_proc_w;
				end if;

				update	pls_rec_glosa_proc
				set	vl_acatado		= vl_recursado_w,
					ds_justificativa_oper	= ds_justificativa_p,
					ie_status		= '3',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_acao_total		= 'S'
				where	nr_sequencia		= r_C02_w.nr_sequencia;
			end loop;

			for r_C03_w in C03(r_C01_w.nr_seq_conta_rec) loop
				select	max(vl_glosa)
				into STRICT	vl_glosa_mat_w
				from	pls_conta_mat
				where	nr_sequencia = r_C03_w.nr_seq_conta_mat;

				if (r_C03_w.vl_recursado < vl_glosa_mat_w) then
					vl_recursado_w := r_C03_w.vl_recursado;
				else
					vl_recursado_w := vl_glosa_mat_w;
				end if;

				update	pls_rec_glosa_mat
				set	vl_acatado		= vl_recursado_w,
					ds_justificativa_oper	= ds_justificativa_p,
					ie_status		= '3',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_acao_total		= 'S'
				where	nr_sequencia		= r_C03_w.nr_sequencia;
			end loop;

		elsif (ie_tipo_valor_acatar_p = 'VGC') then
			for r_C02_w in C02(r_C01_w.nr_seq_conta_rec) loop
				select	pls_obter_valor_glosa_calc(r_C02_w.nr_seq_conta_proc, null)
				into STRICT	vl_glosa_proc_w
				;

				if (r_C02_w.vl_recursado < vl_glosa_proc_w) then
					vl_recursado_w := r_C02_w.vl_recursado;
				else
					vl_recursado_w := vl_glosa_proc_w;
				end if;

				update	pls_rec_glosa_proc
				set	vl_acatado		= vl_recursado_w,
					ds_justificativa_oper	= ds_justificativa_p,
					ie_status		= '3',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_acao_total		= 'S'
				where	nr_sequencia		= r_C02_w.nr_sequencia;
			end loop;

			for r_C03_w in C03(r_C01_w.nr_seq_conta_rec) loop
				select	pls_obter_valor_glosa_calc(null, r_C03_w.nr_seq_conta_mat)
				into STRICT	vl_glosa_mat_w
				;

				if (r_C03_w.vl_recursado < vl_glosa_mat_w) then
					vl_recursado_w := r_C03_w.vl_recursado;
				else
					vl_recursado_w := vl_glosa_mat_w;
				end if;

				update	pls_rec_glosa_mat
				set	vl_acatado		= vl_recursado_w,
					ds_justificativa_oper	= ds_justificativa_p,
					ie_status		= '3',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_acao_total		= 'S'
				where	nr_sequencia		= r_C03_w.nr_sequencia;
			end loop;
		end if;

		CALL pls_atualizar_valor_recurso(r_C01_w.nr_seq_conta_rec,'C',nm_usuario_p);

		select	vl_total_acatado
		into STRICT	vl_ref_w
		from	pls_rec_glosa_conta
		where	nr_sequencia = r_C01_w.nr_seq_conta_rec;

		CALL pls_gerar_log_rec_glosa('A', vl_ref_w, r_C01_w.nr_seq_conta_rec, nm_usuario_p, 'C', null, nr_seq_mot_lib_glosa_p);
	end loop;

	-- Atualiza a justificativa do protocolo, somente deve ser atualizado a
	-- justificativa do protocolo quando a ação for a nível de protocolo
	update	pls_rec_glosa_protocolo
	set	ds_justificativa_oper	= ds_justificativa_p,
		nm_usuario 		= nm_usuario_p,
		dt_atualizacao 		= clock_timestamp()
	where	nr_sequencia 		= nr_seq_protocolo_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_acatar_rec_glosa_conta ( nr_seq_rec_glosa_conta_p pls_rec_glosa_conta.nr_sequencia%type, nr_seq_protocolo_p pls_rec_glosa_protocolo.nr_sequencia%type, ds_justificativa_p pls_rec_glosa_conta.ds_justificativa_oper%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_valor_acatar_p text, nr_seq_mot_lib_glosa_p pls_mot_rec_glosa.nr_sequencia%type) FROM PUBLIC;

