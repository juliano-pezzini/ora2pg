-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_status_item_pos ( nr_seq_conta_p bigint, nr_seq_mat_p bigint, nr_seq_proc_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
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

/*NÃOÉ MAIS UTILIZADO.
UTILIZAR A PLS_aNALISE_STATUS_FAT*/
C01 CURSOR FOR
	SELECT	CASE WHEN ie_tipo_item='P' THEN nr_seq_item  ELSE null END ,
		CASE WHEN ie_tipo_item='M' THEN nr_seq_item  ELSE null END ,
		CASE WHEN ie_tipo_item='R' THEN nr_seq_partic_proc  ELSE null END
	from	w_pls_resumo_conta
	where	nr_seq_conta = nr_seq_conta_p
	and	ie_status <> 'C'
	and	nr_seq_analise = nr_seq_analise_p;


BEGIN

if (coalesce(nr_seq_mat_p,0) = 0)  and (coalesce(nr_seq_proc_p,0) = 0) then

	open C01;
	loop
	fetch C01 into
		nr_seq_proc_w,
		nr_seq_mat_w,
		nr_seq_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if	((coalesce(nr_seq_proc_w,0) > 0) or (coalesce(nr_seq_mat_w,0) > 0) or (coalesce(nr_seq_partic_w,0) > 0)) then
			CALL pls_analise_status_item_pos(nr_seq_conta_p,	nr_seq_mat_w, nr_seq_proc_w,
						    nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);
		end if;

		end;
	end loop;
	close C01;
else

	/*Verificar se houve a geração de glosas/ocorrências*/

	select	count(nr_sequencia)
	into STRICT	qt_itens_w
	from	pls_analise_conta_item
	where	nr_seq_conta = nr_seq_conta_p
	and	(((coalesce(nr_seq_conta_proc,0) = 0) and (coalesce(nr_seq_conta_mat,0) = 0))
	or	 ((nr_seq_conta_proc = nr_seq_proc_p) or (nr_seq_conta_mat = nr_seq_mat_p)))
	and	nr_seq_analise = nr_seq_analise_p
	and	ie_status not in ('I', 'C', 'E');

	if (qt_itens_w > 0) then

		/*Verificação de glosas/ocorrências pendentes*/

		select	count(nr_sequencia)
		into STRICT	qt_itens_w
		from	pls_analise_conta_item
		where	nr_seq_conta = nr_seq_conta_p
		and	(((coalesce(nr_seq_conta_proc,0) = 0) and (coalesce(nr_seq_conta_mat,0) = 0))
		or	 ((nr_seq_conta_proc = nr_seq_proc_p) or (nr_seq_conta_mat = nr_seq_mat_p)))
		and	nr_seq_analise = nr_seq_analise_p
		and	ie_status = 'P';

		if (qt_itens_w = 0) then
			update	w_pls_resumo_conta
			set	ie_status = 'L'
			where	nr_seq_conta = nr_seq_conta_p
			and 	((nr_seq_item = nr_seq_proc_p AND ie_tipo_item = 'P')
			or 	 (nr_seq_item = nr_seq_mat_p AND ie_tipo_item = 'M'))
			and	nr_seq_analise = nr_seq_analise_p;
		else
			update	w_pls_resumo_conta
			set	ie_status = 'P'
			where	nr_seq_conta = nr_seq_conta_p
			and 	((nr_seq_item = nr_seq_proc_p AND ie_tipo_item = 'P')
			or 	 (nr_seq_item = nr_seq_mat_p AND ie_tipo_item = 'M'))
			and	nr_seq_analise = nr_seq_analise_p;
		end if;

	else
		/*Se não houve o procedimento ou material é liberado pelo sistema*/

		update	w_pls_resumo_conta
		set	ie_status = 'S'
		where	nr_seq_conta = nr_seq_conta_p
		and 	((nr_seq_item = nr_seq_proc_p AND ie_tipo_item = 'P')
		or 	 (nr_seq_item = nr_seq_mat_p AND ie_tipo_item = 'M'))
		and	nr_seq_analise = nr_seq_analise_p;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_status_item_pos ( nr_seq_conta_p bigint, nr_seq_mat_p bigint, nr_seq_proc_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

