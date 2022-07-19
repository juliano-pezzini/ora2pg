-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_proced_material ( nr_seq_item_p bigint, ie_tipo_item_p text, cd_item_p bigint, ie_origem_proced_p bigint, nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_item_w			varchar(255);
nr_seq_conta_w			bigint;
ie_origem_analise_w		bigint;


BEGIN 
 
select	max(ie_origem_analise) 
into STRICT	ie_origem_analise_w 
from	pls_analise_conta 
where	nr_sequencia	= nr_seq_analise_p;
 
 
if (ie_tipo_item_p	= 'P') then 
	begin 
	update	pls_conta_proc 
	set	cd_procedimento		= cd_item_p, 
		ie_origem_proced	= ie_origem_proced_p, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_sequencia		= nr_seq_item_p;
	exception 
	when others then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(190443);
	end;
	ds_item_w	:= substr(obter_descricao_procedimento(cd_item_p,ie_origem_proced_p),1,255);
 
	select	max(nr_seq_conta) 
	into STRICT	nr_seq_conta_w 
	from	pls_conta_proc 
	where	nr_sequencia	= nr_seq_item_p;
	 
	/*update	w_pls_resumo_conta 
	set	cd_item			= cd_item_p, 
		ie_origem_proced	= ie_origem_proced_p, 
		ds_item			= ds_item_w, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= sysdate 
	where	nr_seq_item		= nr_seq_item_p 
	and	ie_tipo_item		= 'P';*/
 
	 
	if (ie_origem_analise_w = 3) then 
		CALL pls_atual_w_resumo_conta_ptu(	nr_seq_conta_w, nr_seq_item_p, null, 
						null, nr_seq_analise_p, nm_usuario_p	);
	else	 
		CALL pls_atualiza_w_resumo_conta(	nr_seq_conta_w, nr_seq_item_p, null, 
						null, nr_seq_analise_p, nm_usuario_p	);
	end if;
 
elsif (ie_tipo_item_p	= 'M') then 
	update	pls_conta_mat 
	set	nr_seq_material		= cd_item_p, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_sequencia		= nr_seq_item_p;
	 
	ds_item_w	:= substr(obter_descricao_padrao('PLS_MATERIAL','DS_MATERIAL',cd_item_p),1,255);
	 
	select	max(nr_seq_conta) 
	into STRICT	nr_seq_conta_w 
	from	pls_conta_mat 
	where	nr_sequencia	= nr_seq_item_p;
	 
	/*update	w_pls_resumo_conta 
	set	cd_item			= cd_item_p, 
		ds_item			= ds_item_w, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= sysdate 
	where	nr_seq_item		= nr_seq_item_p 
	and	ie_tipo_item		= 'M';*/
 
	 
	if (ie_origem_analise_w = 3) then 
		CALL pls_atual_w_resumo_conta_ptu(	nr_seq_conta_w, null, nr_seq_item_p, 
						null, nr_seq_analise_p, nm_usuario_p	);
	else	 
		CALL pls_atualiza_w_resumo_conta(	nr_seq_conta_w, null, nr_seq_item_p, 
						null, nr_seq_analise_p, nm_usuario_p	);
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_proced_material ( nr_seq_item_p bigint, ie_tipo_item_p text, cd_item_p bigint, ie_origem_proced_p bigint, nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, nm_usuario_p text) FROM PUBLIC;

