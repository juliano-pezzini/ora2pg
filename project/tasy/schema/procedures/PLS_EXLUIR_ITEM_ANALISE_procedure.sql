-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_exluir_item_analise ( ds_sequencia_itens_p text, cd_estabalecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE


/*Utilizar a rotina pls_excluir_item_analise*/

ds_sequencia_itens_w		varchar(4000);
nr_seq_item_w			bigint;
nr_seq_item_ww			bigint;
ie_tipo_item_w			varchar(1);
nr_seq_proc_w			bigint;
nr_seq_mat_w			bigint;
nr_seq_analise_conta_item_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_analise_conta_item
	where	((nr_seq_conta_proc = nr_seq_proc_w)
	or (nr_seq_conta_mat  = nr_seq_mat_w))
	order by 1;


BEGIN

ds_sequencia_itens_w := ds_sequencia_itens_p;

while(position(',' in ds_sequencia_itens_w) <> 0) loop
	begin

	--obtem-se a primeira regra
	nr_seq_item_w		:= substr(ds_sequencia_itens_w,1,position(',' in ds_sequencia_itens_w)-1);
	--remove-se essa do conjunto
	ds_sequencia_itens_w	:= substr(ds_sequencia_itens_w,position(',' in ds_sequencia_itens_w)+1,255);

	select	nr_seq_item,
		ie_tipo_item
	into STRICT	nr_seq_item_ww,
		ie_tipo_item_w
	from	w_pls_resumo_conta
	where	nr_sequencia = nr_seq_item_w;

	if (ie_tipo_item_w = 'P') then
		nr_seq_proc_w	:= nr_seq_item_ww;
		nr_seq_mat_w	:= null;
	elsif (ie_tipo_item_w = 'M') then
		nr_seq_mat_w 	:= nr_seq_item_ww;
		nr_seq_proc_w	:= null;
	end if;

	open C01;
	loop
	fetch C01 into
		nr_seq_analise_conta_item_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		delete	FROM pls_analise_parecer_item
		where	nr_seq_item = nr_seq_analise_conta_item_w;

		end;
	end loop;
	close C01;

	delete	FROM pls_analise_conta_item
	where	((nr_seq_conta_proc = nr_seq_proc_w)
	or (nr_seq_conta_mat  = nr_seq_mat_w));

	delete	FROM w_pls_resumo_conta
	where	nr_seq_item = nr_seq_item_ww;

	delete	FROM pls_ocorrencia_benef
	where	coalesce(nr_seq_guia_plano::text, '') = ''
	and	coalesce(nr_seq_requisicao::text, '') = ''
	and	((nr_seq_proc = nr_seq_proc_w)
	or (nr_seq_mat  = nr_seq_mat_w));

	delete	FROM pls_conta_glosa
	where	((nr_seq_conta_proc = nr_seq_proc_w)
	or (nr_seq_conta_mat  = nr_seq_mat_w));

	delete	FROM pls_proc_participante
	where	nr_seq_conta_proc  = nr_seq_proc_w;

	delete	FROM pls_conta_proc
	where	nr_sequencia =  nr_seq_proc_w;

	delete	FROM pls_conta_mat
	where	nr_sequencia =  nr_seq_mat_w;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_exluir_item_analise ( ds_sequencia_itens_p text, cd_estabalecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

