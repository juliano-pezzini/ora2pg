-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_acatar_rec_glosa_perc ( nr_seq_rec_glosa_prot_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_rec_glosa_cont_p pls_rec_glosa_conta.nr_sequencia%type, nr_seq_rec_glosa_proc_p pls_rec_glosa_proc.nr_sequencia%type, nr_seq_rec_glosa_mate_p pls_rec_glosa_mat.nr_sequencia%type, ds_justificativa_p text, pr_acatado_p bigint, nm_usuario_p usuario.nm_usuario%type, nr_seq_mot_lib_glosa_p pls_mot_rec_glosa.nr_sequencia%type) AS $body$
DECLARE

					
vl_ref_w		pls_rec_glosa_conta.vl_total_acatado%type;
nr_seq_conta_rec_w	pls_rec_glosa_conta.nr_sequencia%type;
qt_glosa_w		integer;
vl_saldo_w		double precision;
vl_acatado_w		pls_rec_glosa_mat.vl_acatado%type;

C01 CURSOR(nr_seq_rec_glosa_prot_pc	pls_rec_glosa_protocolo.nr_sequencia%type) FOR
	SELECT	nr_sequencia nr_seq_rec_glosa_cont
	from	pls_rec_glosa_conta
	where	nr_seq_protocolo = nr_seq_rec_glosa_prot_pc;
	
BEGIN

-- limpa as variaveis
vl_ref_w := null;
nr_seq_conta_rec_w := null;
vl_acatado_w := null;
vl_saldo_w := null;

-- Acatar percentual do recurso (Protocolo)
if (nr_seq_rec_glosa_prot_p IS NOT NULL AND nr_seq_rec_glosa_prot_p::text <> '') then

	-- Varre todas as contas do protocolo
	for r_C01_w in C01(nr_seq_rec_glosa_prot_p) loop
	
		-- Atualiza o conta/recurso com a justificativa
		update	pls_rec_glosa_conta
		set	ds_justificativa_oper = ds_justificativa_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = r_C01_w.nr_seq_rec_glosa_cont;
		
		-- Atualiza o procedimento com a justificativa e com o valor acatado baseado no recurso * percentual acatado e altera o status para 'Acatado'
		update	pls_rec_glosa_proc
		set	vl_acatado = pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p),
			ds_justificativa_oper = ds_justificativa_p,
			ie_status = '3',
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_seq_conta_rec = r_C01_w.nr_seq_rec_glosa_cont;
		
		-- Atualiza o material com a justificativa e com o valor acatado baseado no recurso * percentual acatado e altera o status para 'Acatado'
		update	pls_rec_glosa_mat
		set	vl_acatado = pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p),
			ds_justificativa_oper = ds_justificativa_p,
			ie_status = '3',
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_seq_conta_rec = r_C01_w.nr_seq_rec_glosa_cont;
		
		-- Atualiza o conta/recurso com o total acatado dos procedimentos e dos materiais
		CALL pls_atualizar_valor_recurso(r_C01_w.nr_seq_rec_glosa_cont, 'C', nm_usuario_p);
		
		-- Obtem o valor acatado da conta para inserir no log de recurso de glosa
		select	vl_total_acatado
		into STRICT	vl_ref_w
		from	pls_rec_glosa_conta
		where	nr_sequencia = r_C01_w.nr_seq_rec_glosa_cont;
		
		-- Log de recurso de glosa
		CALL pls_gerar_log_rec_glosa('A', vl_ref_w, r_C01_w.nr_seq_rec_glosa_cont, nm_usuario_p, 'C', null, nr_seq_mot_lib_glosa_p);
	end loop;
	
-- Acatar percentual do recurso (Conta)
elsif (nr_seq_rec_glosa_cont_p IS NOT NULL AND nr_seq_rec_glosa_cont_p::text <> '') then

	-- Atualiza o conta/recurso com a justificativa
	update	pls_rec_glosa_conta
	set	ds_justificativa_oper = ds_justificativa_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_rec_glosa_cont_p;
	
	-- Atualiza o procedimento com a justificativa e com o valor acatado baseado no recurso * percentual acatado e altera o status para 'Acatado'
	update	pls_rec_glosa_proc
	set	vl_acatado = pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p),
		ds_justificativa_oper = ds_justificativa_p,
		ie_status = '3',
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_conta_rec = nr_seq_rec_glosa_cont_p;
	
	-- Atualiza o material com a justificativa e com o valor acatado baseado no recurso * percentual acatado e altera o status para 'Acatado'
	update	pls_rec_glosa_mat a
	set	vl_acatado = pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p),
		ds_justificativa_oper = ds_justificativa_p,
		ie_status = '3',
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_conta_rec = nr_seq_rec_glosa_cont_p;
	
	-- Atualiza o conta/recurso com o total acatado dos procedimentos e dos materiais
	CALL pls_atualizar_valor_recurso(nr_seq_rec_glosa_cont_p, 'C', nm_usuario_p);
	
	-- Obtem o valor acatado da conta para inserir no log de recurso de glosa
	select	vl_total_acatado
	into STRICT	vl_ref_w
	from	pls_rec_glosa_conta
	where	nr_sequencia = nr_seq_rec_glosa_cont_p;
	
	-- Log de recurso de glosa
	CALL pls_gerar_log_rec_glosa('A', vl_ref_w, nr_seq_rec_glosa_cont_p, nm_usuario_p, 'C', null, nr_seq_mot_lib_glosa_p);
	
-- Acatar percentual do recurso (Procediemnto)
elsif (nr_seq_rec_glosa_proc_p IS NOT NULL AND nr_seq_rec_glosa_proc_p::text <> '') then
	-- Obtem o nr_seq_conta_rec do procedimento
	select	max(nr_seq_conta_rec),
		max(pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p)),
		max(pls_obter_saldo_rec_glosa_proc(nr_seq_conta_proc, nr_seq_rec_glosa_proc_p))
	into STRICT	nr_seq_conta_rec_w,
		vl_acatado_w,
		vl_saldo_w
	from	pls_rec_glosa_proc
	where	nr_sequencia = nr_seq_rec_glosa_proc_p;
	
	if (vl_acatado_w > vl_saldo_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(330213); --O valor acatado nao pode ser maior que o valor do saldo do item!
	end if;
	
	select	count(1)
	into STRICT	qt_glosa_w
	from	pls_rec_glosa_glosas
	where	nr_seq_conta_rec = nr_seq_conta_rec_w
	and	coalesce(nr_seq_proc_rec::text, '') = ''
	and	coalesce(nr_seq_mat_rec::text, '') = '';
	
	-- Somente vai atualizar a justificativa na conta se a mesma nao possuir glosa,

	-- Caso contrario deve permanecer o parecer aplicado sobre a mesma (Ariel)
	if (qt_glosa_w = 0) then
		-- Atualiza o conta/recurso com a justificativa
		update	pls_rec_glosa_conta
		set	ds_justificativa_oper = ds_justificativa_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_seq_conta_rec_w;
	end if;
		
	-- Atualiza o procedimento com a justificativa e com o valor acatado baseado no recurso * percentual acatado e altera o status para 'Acatado'
	update	pls_rec_glosa_proc
	set	vl_acatado = pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p),
		ds_justificativa_oper = ds_justificativa_p,
		ie_status = '3',
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_rec_glosa_proc_p;
	
	-- Atualiza o conta/recurso com o total acatado dos procedimentos e dos materiais
	CALL pls_atualizar_valor_recurso(nr_seq_conta_rec_w, 'C', nm_usuario_p);
	
	-- Obtem o valor acatado do item para inserir no log de recurso de glosa
	select	vl_acatado
	into STRICT	vl_ref_w
	from	pls_rec_glosa_proc
	where	nr_sequencia = nr_seq_rec_glosa_proc_p;
	
	-- Log de recurso de glosa
	CALL pls_gerar_log_rec_glosa('AIP', vl_ref_w, nr_seq_rec_glosa_proc_p, nm_usuario_p, 'P', null, nr_seq_mot_lib_glosa_p);
	
-- Acatar percentual do recurso (Material)
elsif (nr_seq_rec_glosa_mate_p IS NOT NULL AND nr_seq_rec_glosa_mate_p::text <> '') then

	-- Obtem o nr_seq_conta_rec do material
	select	max(nr_seq_conta_rec),
		max(pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p)),
		max(pls_obter_saldo_rec_glosa_mat(nr_seq_conta_mat, nr_seq_rec_glosa_mate_p))
	into STRICT	nr_seq_conta_rec_w,
		vl_acatado_w,
		vl_saldo_w
	from	pls_rec_glosa_mat
	where	nr_sequencia = nr_seq_rec_glosa_mate_p;
	
	if (vl_acatado_w > vl_saldo_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(330213); --O valor acatado nao pode ser maior que o valor do saldo do item!
	end if;
	
	select	count(1)
	into STRICT	qt_glosa_w
	from	pls_rec_glosa_glosas
	where	nr_seq_conta_rec = nr_seq_conta_rec_w
	and	coalesce(nr_seq_proc_rec::text, '') = ''
	and	coalesce(nr_seq_mat_rec::text, '') = '';
	
	-- Somente vai atualizar a justificativa na conta se a mesma nao possuir glosa,

	-- Caso contrario deve permanecer o parecer aplicado sobre a mesma (Ariel)
	if (qt_glosa_w = 0) then
		-- Atualiza o conta/recurso com a justificativa
		update	pls_rec_glosa_conta
		set	ds_justificativa_oper = ds_justificativa_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_seq_conta_rec_w;
	end if;	
		
	-- Atualiza o material com a justificativa e com o valor acatado baseado no recurso * percentual acatado e altera o status para 'Acatado'
	update	pls_rec_glosa_mat
	set	vl_acatado = pls_util_pck.obter_valor_percentual(vl_recursado, pr_acatado_p),
		ds_justificativa_oper = ds_justificativa_p,
		ie_status = '3',
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_rec_glosa_mate_p;
	
	-- Atualiza o conta/recurso com o total acatado dos procedimentos e dos materiais
	CALL pls_atualizar_valor_recurso(nr_seq_conta_rec_w, 'C', nm_usuario_p);
	
	-- Obtem o valor acatado da conta para inserir no log de recurso de glosa
	select	vl_acatado
	into STRICT	vl_ref_w
	from	pls_rec_glosa_mat
	where	nr_sequencia = nr_seq_rec_glosa_mate_p;
	
	-- Log de recurso de glosa
	CALL pls_gerar_log_rec_glosa('AIM', vl_ref_w, nr_seq_rec_glosa_mate_p, nm_usuario_p, 'M', null, nr_seq_mot_lib_glosa_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_acatar_rec_glosa_perc ( nr_seq_rec_glosa_prot_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_rec_glosa_cont_p pls_rec_glosa_conta.nr_sequencia%type, nr_seq_rec_glosa_proc_p pls_rec_glosa_proc.nr_sequencia%type, nr_seq_rec_glosa_mate_p pls_rec_glosa_mat.nr_sequencia%type, ds_justificativa_p text, pr_acatado_p bigint, nm_usuario_p usuario.nm_usuario%type, nr_seq_mot_lib_glosa_p pls_mot_rec_glosa.nr_sequencia%type) FROM PUBLIC;
