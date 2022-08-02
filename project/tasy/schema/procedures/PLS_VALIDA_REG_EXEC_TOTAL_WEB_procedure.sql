-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_reg_exec_total_web ( nr_seq_exec_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tipo_item_w			varchar(1);
nr_seq_requisicao_w		bigint;
ie_tipo_guia_w			varchar(1);
ie_regra_w			varchar(1);
nr_seq_item_req_w		bigint;
nr_seq_exec_item_lote_w		bigint;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_requisicao,
		a.ie_tipo_guia
	from	pls_itens_lote_execucao a
	where	a.nr_seq_lote_exec 	= nr_seq_exec_lote_p
	and	a.ie_executar		= 'S';


c02 CURSOR FOR
	SELECT 	a.nr_sequencia,
		'M' ie_tipo_item
	from	pls_requisicao_mat a
	where	a.nr_seq_requisicao = nr_seq_requisicao_w
	and 	not exists (SELECT	1
			    from   	pls_itens_lote_execucao x
			    where	x.nr_seq_req_mat 	= a.nr_sequencia
			    and		x.nr_seq_lote_exec	= nr_seq_exec_lote_p
			    and		x.ie_executar		= 'S')
	and     exists (select	1
			    from   	pls_itens_lote_execucao x
			    where	x.nr_seq_req_mat 	= a.nr_sequencia
			    and		x.nr_seq_lote_exec	= nr_seq_exec_lote_p
			    and		x.ie_permite_execucao 	= 'S'
			    and         x.ie_tipo_item 		= 'M')
	
union

	select 	a.nr_sequencia,
		'P' ie_tipo_item
	from	pls_requisicao_proc a
	where	a.nr_seq_requisicao = nr_seq_requisicao_w
	and 	not exists (select	1
			    from   	pls_itens_lote_execucao x
			    where	x.nr_seq_req_proc 	= a.nr_sequencia
			    and		x.nr_seq_lote_exec	= nr_seq_exec_lote_p
			    and		x.ie_executar		= 'S')
	and     exists (select	1
			    from   	pls_itens_lote_execucao x
			    where	x.nr_seq_req_proc 	= a.nr_sequencia
			    and		x.nr_seq_lote_exec	= nr_seq_exec_lote_p
			    and		x.ie_permite_execucao 	= 'S'
			    and         x.ie_tipo_item 		= 'P');


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_exec_item_lote_w,
	nr_seq_requisicao_w,
	ie_tipo_guia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ie_regra_w := pls_obter_se_exec_total_itens(null,ie_tipo_guia_w);

	if (ie_regra_w = 'S') then
		open c02;
		loop
		fetch c02 into
			nr_seq_item_req_w,
			ie_tipo_item_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			if (ie_tipo_item_w = 'P') then
				update	pls_itens_lote_execucao
				set	ie_executar 	 = 'S',
					dt_atualizacao	 = clock_timestamp(),
					nm_usuario	 = nm_usuario_p
				where	nr_seq_lote_exec = nr_seq_exec_lote_p
				and	nr_seq_req_proc  = nr_seq_item_req_w;
			else
				update	pls_itens_lote_execucao
				set	ie_executar 	 = 'S',
					dt_atualizacao	 = clock_timestamp(),
					nm_usuario	 = nm_usuario_p
				where	nr_seq_lote_exec = nr_seq_exec_lote_p
				and	nr_seq_req_mat = nr_seq_item_req_w;
			end if;
		end loop;
		close c02;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_reg_exec_total_web ( nr_seq_exec_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

