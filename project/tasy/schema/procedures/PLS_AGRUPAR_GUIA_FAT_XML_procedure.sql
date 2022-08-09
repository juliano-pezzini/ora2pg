-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_agrupar_guia_fat_xml ( nr_seq_fatura_p pls_fatura.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text, qt_max_reg_p pls_regra_divisao_fatura.qt_max_conta%type ) AS $body$
DECLARE


nr_seq_lote_guia_env_w		pls_lote_fat_guia_envio.nr_sequencia%type;
nr_seq_guia_env_new_w		pls_fatura_guia_envio.nr_sequencia%type;
nr_seq_pagador_w		pls_contrato_pagador.nr_sequencia%type;
nr_seq_guia_new_w		pls_fatura_guia_envio.nr_sequencia%type;
qt_contas_w			integer := 0;
nr_seq_arquivo_w		integer;

-- Listar todas as contas de Internação (5)
C01 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	e.nr_seq_conta,
		c.cd_guia_ok,
		c.nr_seq_segurado,
		e.nr_sequencia nr_seq_guia_new,
		c.nr_seq_conta_princ,
		c.nr_sequencia nr_seq_cta
	from	pls_lote_fat_guia_envio	f,
		pls_fat_guia_arquivo	a,
		pls_fatura_guia_envio	e,
		pls_conta		c
	where	c.nr_sequencia	= e.nr_seq_conta
	and	a.nr_sequencia	= e.nr_seq_guia_arquivo
	and	f.nr_sequencia	= a.nr_seq_lote
	and	f.nr_seq_fatura	= nr_seq_fatura_p
	and	a.ie_tipo_guia	= '5'
	and	c.nr_sequencia	= c.nr_seq_conta_princ;

-- Listar todas as CONTAS de SP/SADT (4) e Honorário individual (6) filhas da conta de Internação (5)
C02 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type,
			cd_guia_ok_pc		pls_conta.cd_guia_ok%type,
			nr_seq_segurado_pc	pls_segurado.nr_sequencia%type,
			nr_seq_conta_pc		pls_conta.nr_sequencia%type ) FOR
	SELECT	e.nr_sequencia nr_seq_guia_old,
		e.ie_tipo_guia,
		substr(pls_obter_cd_tiss_participacao(e.nr_seq_grau_partic),1,2) cd_grau_partic,
		substr(e.nm_profissional_executante,1,70) nm_profissional_exec,
		e.sg_conselho_executante,
		e.nr_conselho_executante,
		e.uf_conselho_executante,
		substr(e.cd_cbos,1,6) cd_cbos,
		e.cd_cgc_contratado,
		substr(e.cd_prestador_exec,1,14) cd_prestador_exec,
		e.nr_cpf_executor,
		pls_obter_dados_prestador(c.nr_seq_prestador_exec,'CPF') cd_cpf_prest,
		(	SELECT	count(1)
			from	pls_fat_guia_envio_proc	x
			where	x.nr_seq_guia_envio	= e.nr_sequencia) qt_guia_proc,
		(	select	count(1)
			from	pls_fat_guia_envio_mat	x
			where	x.nr_seq_guia_envio	= e.nr_sequencia) qt_guia_mat
	from	pls_lote_fat_guia_envio	f,
		pls_fat_guia_arquivo	a,
		pls_fatura_guia_envio	e,
		pls_conta		c
	where	c.nr_sequencia		= e.nr_seq_conta
	and	a.nr_sequencia		= e.nr_seq_guia_arquivo
	and	f.nr_sequencia		= a.nr_seq_lote
	and	f.nr_seq_fatura		= nr_seq_fatura_pc
	and	c.cd_guia_ok		= cd_guia_ok_pc
	and	c.nr_seq_segurado	= nr_seq_segurado_pc
	and	c.nr_sequencia		!= nr_seq_conta_pc
	and	a.ie_tipo_guia	in ('4','6','5');

-- Listar todas as contas de SP/SADT (4) da fatura
C03 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	e.nr_seq_conta,
		coalesce(c.cd_guia_fat,coalesce(c.cd_guia_pos_estab,c.cd_guia_ok)) cd_guia_ok,
		c.nr_seq_segurado,
		e.nr_sequencia nr_seq_guia_new,
		c.nr_seq_conta_princ,
		CASE WHEN c.nr_seq_conta_princ=c.nr_sequencia THEN 'S'  ELSE 'N' END  ie_conta_princ
	from	pls_lote_fat_guia_envio	f,
		pls_fat_guia_arquivo	a,
		pls_fatura_guia_envio	e,
		pls_conta		c
	where	c.nr_sequencia	= e.nr_seq_conta
	and	a.nr_sequencia	= e.nr_seq_guia_arquivo
	and	f.nr_sequencia	= a.nr_seq_lote
	and	f.nr_seq_fatura	= nr_seq_fatura_p
	and	a.ie_tipo_guia	in ('4','6');

-- Listar todas as CONTAS de SP/SADT (4) filhas da conta de SP/SADT (4)
C04 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type,
			cd_guia_ok_pc		pls_conta.cd_guia_ok%type,
			nr_seq_segurado_pc	pls_segurado.nr_sequencia%type,
			nr_seq_conta_pc		pls_conta.nr_sequencia%type,
			nr_seq_conta_princ_pc	pls_conta.nr_seq_conta_princ%type) FOR
	SELECT	e.nr_sequencia nr_seq_guia_old,
		e.nr_seq_conta
	from	pls_lote_fat_guia_envio	f,
		pls_fat_guia_arquivo	a,
		pls_fatura_guia_envio	e,
		pls_fatura_conta	fc,
		pls_fatura_evento	fe,
		pls_conta		c
	where	c.nr_sequencia		= e.nr_seq_conta
	and	a.nr_sequencia		= e.nr_seq_guia_arquivo
	and	f.nr_sequencia		= a.nr_seq_lote
	and	f.nr_seq_fatura		= nr_seq_fatura_pc
	and	fc.cd_guia_referencia	= cd_guia_ok_pc
	and	c.nr_seq_segurado	= nr_seq_segurado_pc
	and	fe.nr_sequencia		= fc.nr_seq_fatura_evento
	and	fe.nr_seq_fatura	= f.nr_seq_fatura
	and	c.nr_sequencia		= fc.nr_seq_conta
	and	a.ie_tipo_guia	in ('4','6')
	and	e.nr_sequencia		not in (SELECT	min(e.nr_sequencia)
						from	pls_lote_fat_guia_envio	f,
							pls_fat_guia_arquivo	a,
							pls_fatura_guia_envio	e,
							pls_fatura_conta	fc,
							pls_fatura_evento	fe,
							pls_conta		c
						where	c.nr_sequencia		= e.nr_seq_conta
						and	a.nr_sequencia		= e.nr_seq_guia_arquivo
						and	f.nr_sequencia		= a.nr_seq_lote
						and	f.nr_seq_fatura		= nr_seq_fatura_pc
						and	fc.cd_guia_referencia	= cd_guia_ok_pc
						and	c.nr_seq_segurado	= nr_seq_segurado_pc
						and	fe.nr_sequencia		= fc.nr_seq_fatura_evento
						and	fe.nr_seq_fatura	= f.nr_seq_fatura
						and	c.nr_sequencia		= fc.nr_seq_conta
						and	a.ie_tipo_guia	in ('4','6'));

-- Recontar contas
c90 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_guia_arquivo
	from	pls_fat_guia_arquivo	a,
		pls_lote_fat_guia_envio	f
	where	f.nr_sequencia	= a.nr_seq_lote
	and	f.nr_seq_fatura	= nr_seq_fatura_pc;

-- Agrupar
c91 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_guia_arquivo_new,
		f.nr_sequencia nr_seq_lote,
		a.ie_tipo_guia,
		a.qt_contas
	from	pls_fat_guia_arquivo	a,
		pls_lote_fat_guia_envio	f
	where	f.nr_sequencia	= a.nr_seq_lote
	and	f.nr_seq_fatura	= nr_seq_fatura_pc
	and	a.ie_tipo_guia	in ('4','5','6')
	order by a.qt_contas desc;

-- Contas para serem transferidas
c92 CURSOR(	nr_seq_lote_pc			pls_lote_fat_guia_envio.nr_sequencia%type,
		nr_seq_guia_arquivo_pc		pls_fat_guia_arquivo.nr_sequencia%type,
		ie_tipo_guia_pc			pls_fat_guia_arquivo.ie_tipo_guia%type) FOR
	SELECT	nr_sequencia nr_seq_guia_envio,
		nr_seq_guia_arquivo nr_seq_guia_arquivo_old
	from	pls_fatura_guia_envio
	where	nr_seq_guia_arquivo	in (SELECT	nr_sequencia
						from	pls_fat_guia_arquivo
						where	nr_seq_lote	= nr_seq_lote_pc
						and	nr_sequencia	< nr_seq_guia_arquivo_pc
						and	ie_tipo_guia	= ie_tipo_guia_pc
						and	qt_contas	between 1 and 99);

-- Arquivo...
C00 CURSOR(	nr_seq_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_lote_fat_guia_envio	l,
		pls_fat_guia_arquivo	a
	where	l.nr_sequencia	= a.nr_seq_lote
	and	l.nr_seq_fatura	= nr_seq_fatura_pc
	and	exists (SELECT	1
			from	pls_fatura_guia_envio	e
			where	a.nr_sequencia	= e.nr_seq_guia_arquivo)
	order by a.nr_sequencia;
BEGIN
select	max(nr_sequencia),
	max(nr_seq_pagador)
into STRICT	nr_seq_lote_guia_env_w,
	nr_seq_pagador_w
from	pls_lote_fat_guia_envio
where	nr_seq_fatura	= nr_seq_fatura_p;

-- Abrir cursor das contas de Internação
for r_C01_w in C01( nr_seq_fatura_p ) loop

	-- Abrir cursor das contas filhas da internação
	for r_C02_w in C02( nr_seq_fatura_p, r_C01_w.cd_guia_ok, r_C01_w.nr_seq_segurado, r_C01_w.nr_seq_cta) loop
		-- Transferir todos os PROCEDIMENTOS (e Participantes) da conta SP/SADT (4) e Honorário individual (6) para a conta de Internação (5)
		update	pls_fat_guia_envio_proc
		set	nr_seq_guia_envio	= r_C01_w.nr_seq_guia_new
		where	nr_seq_guia_envio	= r_C02_w.nr_seq_guia_old;

		-- Transferir todos os MATERIAIS da conta SP/SADT (4) e Honorário individual (6) para a conta de Internação (5)
		update	pls_fat_guia_envio_mat
		set	nr_seq_guia_envio	= r_C01_w.nr_seq_guia_new
		where	nr_seq_guia_envio	= r_C02_w.nr_seq_guia_old;

		-- Excluir a CONTA SP/SADT (4) e Honorário individual (6)
		--delete	pls_fatura_guia_envio
		--where	nr_sequencia	= r_C02_w.nr_seq_guia_old;
	end loop;
end loop;

-- Após mudar as contas, então exclui as contas que sofreram a mudança, fora do loop acima, pois estava gerando erro ao apagar resumos que estavam no cursor superior
for r_C01_w in C01( nr_seq_fatura_p ) loop

	-- Abrir cursor das contas filhas da internação
	for r_C02_w in C02( nr_seq_fatura_p, r_C01_w.cd_guia_ok, r_C01_w.nr_seq_segurado, r_C01_w.nr_seq_cta) loop

		-- Excluir a CONTA SP/SADT (4) e Honorário individual (6) ( se não possuir itens)
		if	((coalesce(r_C02_w.qt_guia_proc, 0) + coalesce(r_C02_w.qt_guia_mat,0)) = 0) then

			delete	FROM pls_fatura_guia_envio
			where	nr_sequencia	= r_C02_w.nr_seq_guia_old;
		end if;
	end loop;
end loop;


-- Abrir cursor das contas de SP/SADT
for r_C03_w in C03( nr_seq_fatura_p ) loop
	/*nr_seq_guia_new_w := r_C03_w.nr_seq_guia_new;

	-- Se não for guia SP/SADT (4) principal, busca o min
	if	(r_C03_w.ie_conta_princ = 'N') then*/
		select	min(e.nr_sequencia)
		into STRICT	nr_seq_guia_new_w
		from	pls_lote_fat_guia_envio	f,
			pls_fat_guia_arquivo	a,
			pls_fatura_guia_envio	e,
			pls_fatura_conta	fc,
			pls_fatura_evento	fe,
			pls_conta		c
		where	c.nr_sequencia		= e.nr_seq_conta
		and	a.nr_sequencia		= e.nr_seq_guia_arquivo
		and	f.nr_sequencia		= a.nr_seq_lote
		and	f.nr_seq_fatura		= nr_seq_fatura_p
		and	fc.cd_guia_referencia	= r_C03_w.cd_guia_ok
		and	c.nr_seq_segurado	= r_C03_w.nr_seq_segurado
		and	fe.nr_sequencia		= fc.nr_seq_fatura_evento
		and	fe.nr_seq_fatura	= f.nr_seq_fatura
		and	c.nr_sequencia		= fc.nr_seq_conta
		and	a.ie_tipo_guia	in ('4','6');
	--end if;
	-- Abrir cursor das contas filhas da SP/SADT (4)
	for r_C04_w in C04( nr_seq_fatura_p, r_C03_w.cd_guia_ok, r_C03_w.nr_seq_segurado, r_C03_w.nr_seq_conta, r_C03_w.nr_seq_conta_princ ) loop

		if (nr_seq_guia_new_w IS NOT NULL AND nr_seq_guia_new_w::text <> '') and (nr_seq_guia_new_w != r_C04_w.nr_seq_guia_old) then
			-- Transferir todos os PROCEDIMENTOS (e Participantes) da conta SP/SADT (4) para a conta de SP/SADT (4)
			update	pls_fat_guia_envio_proc
			set	nr_seq_guia_envio	= nr_seq_guia_new_w
			where	nr_seq_guia_envio	= r_C04_w.nr_seq_guia_old;

			-- Transferir todos os MATERIAIS da conta SP/SADT (4) para a conta de SP/SADT (4)
			update	pls_fat_guia_envio_mat
			set	nr_seq_guia_envio	= nr_seq_guia_new_w
			where	nr_seq_guia_envio	= r_C04_w.nr_seq_guia_old;

			-- Excluir a CONTA SP/SADT (4)
			delete	FROM pls_fatura_guia_envio
			where	nr_sequencia	= r_C04_w.nr_seq_guia_old;
		end if;
	end loop;
end loop;

-- Recontar as contas
for r_C90_w in C90( nr_seq_fatura_p ) loop
	select	count(1)
	into STRICT	qt_contas_w
	from	pls_fatura_guia_envio
	where	nr_seq_guia_arquivo	= r_C90_w.nr_seq_guia_arquivo;

	update	pls_fat_guia_arquivo
	set	qt_contas	= qt_contas_w
	where	nr_sequencia	= r_C90_w.nr_seq_guia_arquivo;

	-- Se não tem conta, exclui o registro de arquivo
	if (qt_contas_w = 0) then
		delete	FROM pls_fat_guia_arquivo
		where	nr_sequencia	= r_C90_w.nr_seq_guia_arquivo;
	end if;
end loop;

-- Agrupar as contas até chegar em 100
for r_C91_w in C91( nr_seq_fatura_p ) loop
	qt_contas_w := r_C91_w.qt_contas;

	if (r_C91_w.qt_contas > 0) and (r_C91_w.qt_contas < qt_max_reg_p) then

		-- Transferir contas do menor arquivo
		for r_C92_w in C92( r_C91_w.nr_seq_lote, r_C91_w.nr_seq_guia_arquivo_new, r_C91_w.ie_tipo_guia ) loop

			if (qt_contas_w < qt_max_reg_p) then
				update	pls_fatura_guia_envio
				set	nr_seq_guia_arquivo	= r_C91_w.nr_seq_guia_arquivo_new
				where	nr_sequencia		= r_C92_w.nr_seq_guia_envio;

				-- Atualiza o menor arquivo
				update	pls_fat_guia_arquivo
				set	qt_contas	= qt_contas - 1
				where	nr_sequencia	= r_C92_w.nr_seq_guia_arquivo_old;

				qt_contas_w := qt_contas_w + 1;
			end if;
		end loop;
	end if;

	-- Atualiza o maior arquivo
	update	pls_fat_guia_arquivo
	set	qt_contas	= qt_contas_w
	where	nr_sequencia	= r_C91_w.nr_seq_guia_arquivo_new;
end loop;

nr_seq_arquivo_w := 1;
for r_C00_w in C00( nr_seq_fatura_p ) loop
	update	pls_fat_guia_arquivo
	set	nr_seq_arquivo	= nr_seq_arquivo_w
	where	nr_sequencia	= r_C00_w.nr_sequencia;

	nr_seq_arquivo_w := nr_seq_arquivo_w + 1;
end loop;

-- Atualizar a quantidade de contas dentro do XML
update	pls_fat_guia_arquivo	a
set	a.qt_contas	= (	SELECT	count(1)
				from	pls_fatura_guia_envio	b
				where	b.nr_seq_guia_arquivo	= a.nr_sequencia)
where	a.nr_seq_lote	=	nr_seq_lote_guia_env_w;

-- A rotina pode ser chamada via SQL
if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_agrupar_guia_fat_xml ( nr_seq_fatura_p pls_fatura.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text, qt_max_reg_p pls_regra_divisao_fatura.qt_max_conta%type ) FROM PUBLIC;
