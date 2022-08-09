-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_status_item ( nr_seq_conta_p bigint, nr_seq_mat_p bigint, nr_seq_proc_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_proc_partic_p bigint) AS $body$
DECLARE


nr_seq_proc_w		bigint;
nr_seq_mat_w		bigint;
qt_itens_w		bigint;
qt_liberado_w		bigint;
vl_unitario_w		double precision;
vl_total_w		double precision;
ie_tipo_item_w		varchar(1);
nr_seq_partic_w		bigint;
ie_status_w		varchar(1);
ie_origem_analise_w	smallint;
nr_seq_partic_proc_w	bigint;
ie_conta_inteira_w	varchar(1)	:= 'N';
nr_seq_conta_w		bigint;
ie_novo_status_w	varchar(3)	:= 'P';
qt_regra_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_conta_proc,
		nr_seq_conta_mat,
		nr_seq_partic_proc
	from	w_pls_resumo_conta
	where	nr_seq_conta = nr_seq_conta_w
	and	ie_status <> 'C'
	and	nr_seq_analise = nr_seq_analise_p;


BEGIN

nr_seq_conta_w	:= nr_seq_conta_p;
if (coalesce(nr_seq_mat_p,0) = 0)  and (coalesce(nr_seq_proc_p,0) = 0) and (coalesce(nr_seq_proc_partic_p,0) = 0) then

	open C01;
	loop
	fetch C01 into
		nr_seq_proc_w,
		nr_seq_mat_w,
		nr_seq_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if	((coalesce(nr_seq_proc_w,0) > 0) or (coalesce(nr_seq_mat_w,0) > 0) or (coalesce(nr_seq_partic_w,0) > 0)) then
			CALL pls_analise_status_item(-1,	nr_seq_mat_w, nr_seq_proc_w,
						nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_partic_w);
		end if;

		end;
	end loop;
	close C01;
else
	if (nr_seq_conta_p = -1) then
		ie_conta_inteira_w	:= 'S';

		if (coalesce(nr_seq_proc_p,0) > 0) then
			select	a.nr_seq_conta
			into STRICT	nr_seq_conta_w
			from	pls_conta_proc a
			where	a.nr_sequencia	= nr_seq_proc_p;
		elsif (coalesce(nr_seq_mat_p,0) > 0) then
			select	a.nr_seq_conta
			into STRICT	nr_seq_conta_w
			from	pls_conta_mat a
			where	a.nr_sequencia	= nr_seq_mat_p;
		elsif (coalesce(nr_seq_proc_partic_p,0) > 0) then
			select	b.nr_seq_conta
			into STRICT	nr_seq_conta_w
			from	pls_conta_proc b,
				pls_proc_participante a
			where	a.nr_seq_conta_proc = b.nr_sequencia
			and	a.nr_sequencia	= nr_seq_proc_partic_p;
		end if;
	end if;

	select	max(ie_origem_analise)
	into STRICT	ie_origem_analise_w
	from	pls_analise_conta
	where	nr_sequencia = nr_seq_analise_p;

	if (nr_seq_proc_partic_p > 0) then
		select	max(ie_status)
		into STRICT	ie_status_w
		from	w_pls_resumo_conta
		where	nr_seq_conta = nr_seq_conta_w
		and	nr_seq_analise = nr_seq_analise_p
		and 	nr_seq_partic_proc = nr_seq_proc_partic_p;
	elsif (nr_seq_proc_p > 0) then
		select	max(ie_status)
		into STRICT	ie_status_w
		from	w_pls_resumo_conta
		where	nr_seq_conta = nr_seq_conta_w
		and	nr_seq_analise = nr_seq_analise_p
		and 	nr_seq_conta_proc = nr_seq_proc_p;
	else
		select	max(ie_status)
		into STRICT	ie_status_w
		from	w_pls_resumo_conta
		where	nr_seq_conta = nr_seq_conta_w
		and	nr_seq_analise = nr_seq_analise_p
		and 	nr_seq_conta_mat = nr_seq_mat_p;
	end if;

	if (ie_status_w <> 'I') then

		/*Verificar se houve a geração de glosas/ocorrências*/

		if (nr_seq_proc_partic_p > 0) then
			select	count(nr_sequencia)
			into STRICT	qt_itens_w
			from	pls_analise_conta_item
			where	nr_seq_conta = nr_seq_conta_w
			and 	nr_seq_proc_partic  = nr_seq_proc_partic_p
			and	nr_seq_analise = nr_seq_analise_p
			and	ie_status not in ('I', 'C', 'E');
		elsif (nr_seq_proc_p > 0) then
			select	count(nr_sequencia)
			into STRICT	qt_itens_w
			from	pls_analise_conta_item
			where	nr_seq_conta = nr_seq_conta_w
			and 	nr_seq_conta_proc  = nr_seq_proc_p
			and	nr_seq_analise = nr_seq_analise_p
			and	ie_status not in ('I', 'C', 'E');
		else
			select	count(nr_sequencia)
			into STRICT	qt_itens_w
			from	pls_analise_conta_item
			where	nr_seq_conta = nr_seq_conta_w
			and 	nr_seq_conta_mat  = nr_seq_mat_p
			and	nr_seq_analise = nr_seq_analise_p
			and	ie_status not in ('I', 'C', 'E');
		end if;

		/* Se não achou para o item, verificar se teve alguma pra conta */

		if (qt_itens_w = 0) then
			select	count(nr_sequencia)
			into STRICT	qt_itens_w
			from	pls_analise_conta_item
			where	nr_seq_conta = nr_seq_conta_w
			and 	coalesce(nr_seq_conta_mat::text, '') = ''
			and	coalesce(nr_seq_conta_proc::text, '') = ''
			and	coalesce(nr_seq_proc_partic::text, '') = ''
			and	nr_seq_analise = nr_seq_analise_p
			and	ie_status not in ('I', 'C', 'E');
		end if;

		if (qt_itens_w > 0) then
			/*Verificação de glosas/ocorrências pendentes*/

			if (nr_seq_proc_partic_p > 0) then
				select	count(nr_sequencia)
				into STRICT	qt_itens_w
				from	pls_analise_conta_item
				where	nr_seq_conta = nr_seq_conta_w
				and 	nr_seq_proc_partic	= nr_seq_proc_partic_p
				and	ie_status = 'P'
				and	nr_seq_analise = nr_seq_analise_p;
			elsif (nr_seq_proc_p > 0) then
				select	count(nr_sequencia)
				into STRICT	qt_itens_w
				from	pls_analise_conta_item
				where	nr_seq_conta = nr_seq_conta_w
				and 	nr_seq_conta_proc	= nr_seq_proc_p
				and	ie_status = 'P'
				and	nr_seq_analise = nr_seq_analise_p;
			else
				select	count(nr_sequencia)
				into STRICT	qt_itens_w
				from	pls_analise_conta_item
				where	nr_seq_conta = nr_seq_conta_w
				and 	nr_seq_conta_mat	= nr_seq_mat_p
				and	ie_status = 'P'
				and	nr_seq_analise = nr_seq_analise_p;
			end if;

			if (qt_itens_w = 0) then
				ie_novo_status_w	:= 'L';
			else
				ie_novo_status_w	:= 'P';
			end if;
		else
			/*Se não houve o procedimento ou material é liberado pelo sistema*/

			ie_novo_status_w	:= 'S';

		end if;

		if (nr_seq_proc_partic_p > 0) then
			update	w_pls_resumo_conta
			set	ie_status = ie_novo_status_w
			where	nr_seq_conta = nr_seq_conta_w
			and 	nr_seq_partic_proc	= nr_seq_proc_partic_p
			and	nr_seq_analise = nr_seq_analise_p;
		elsif (nr_seq_proc_p > 0) then
			update	w_pls_resumo_conta
			set	ie_status = ie_novo_status_w
			where	nr_seq_conta = nr_seq_conta_w
			and 	nr_seq_conta_proc	= nr_seq_proc_p
			and	nr_seq_analise = nr_seq_analise_p;
		else
			update	w_pls_resumo_conta
			set	ie_status = ie_novo_status_w
			where	nr_seq_conta = nr_seq_conta_w
			and 	nr_seq_conta_mat	= nr_seq_mat_p
			and	nr_seq_analise = nr_seq_analise_p;
		end if;
	end if;

	if (coalesce(ie_conta_inteira_w,'N') = 'N') then
		CALL pls_analise_status_fat(	nr_seq_conta_w,	nr_seq_mat_p, nr_seq_proc_p,
					nr_seq_analise_p, cd_estabelecimento_p,	nm_usuario_p);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_status_item ( nr_seq_conta_p bigint, nr_seq_mat_p bigint, nr_seq_proc_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_proc_partic_p bigint) FROM PUBLIC;
