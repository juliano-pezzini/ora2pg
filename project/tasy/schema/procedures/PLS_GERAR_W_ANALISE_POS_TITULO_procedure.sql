-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_analise_pos_titulo ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gerar os títulos dos itens da análise (Tipos de despesa) na tabela temporária da nova geração de pós-estabelecido. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ +++++++++++++++++++++++++++++++++++*/
 
 
ds_tipo_despesa_w	varchar(255);
ie_tipo_despesa_w	varchar(10);
ie_tipo_item_w		varchar(3);
ie_selecionado_w	varchar(1)	:= 'N';
qt_registro_w		integer;
nr_sequencia_w		bigint	:= 0;
qt_selecao_w		integer;

C01 CURSOR FOR 
	SELECT	'P', 
		a.ie_tipo_despesa, 
		obter_valor_dominio(3796,a.ie_tipo_despesa) 
	from	pls_conta_proc a, 
		pls_conta_pos_proc b 
	where	a.nr_sequencia	= b.nr_seq_conta_proc 
	and	b.nr_seq_conta	= nr_seq_conta_p 
	and	b.nr_seq_analise = nr_seq_analise_p 
	group by 
		a.ie_tipo_despesa 
	
union all
 
	SELECT	'M', 
		a.ie_tipo_despesa, 
		obter_valor_dominio(1854,a.ie_tipo_despesa) 
	from	pls_conta_mat a, 
		pls_conta_pos_mat b 
	where	a.nr_sequencia	= b.nr_seq_conta_mat 
	and	b.nr_seq_conta	= nr_seq_conta_p 
	and	b.nr_seq_analise = nr_seq_analise_p 
	group by 
		a.ie_tipo_despesa;


BEGIN 
open C01;
loop 
fetch C01 into 
	ie_tipo_item_w, 
	ie_tipo_despesa_w, 
	ds_tipo_despesa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* Ver se o título ainda não foi gerado */
 
	select	count(1) 
	into STRICT	qt_registro_w 
	from	w_pls_analise_item 
	where	nr_seq_analise	= nr_seq_analise_p 
	and	ie_tipo_linha	= 'T' 
	and	ds_item		= ds_tipo_despesa_w  LIMIT 1;
	 
	if (qt_registro_w = 0) then 
		nr_sequencia_w	:= pls_consulta_analise_pos_pck.get_nr_seq_item;
		 
		select	count(1) 
		into STRICT	qt_selecao_w 
		from	w_pls_analise_selecao_item a 
		where	a.nr_seq_analise = nr_seq_analise_p 
		and	a.nr_seq_w_item = nr_sequencia_w  LIMIT 1;
		 
		if (qt_selecao_w > 0) then 
			ie_selecionado_w	:= 'S';
		else 
			ie_selecionado_w	:= 'N';
		end if;
		 
		insert into w_pls_analise_item( 
			nr_sequencia, nr_seq_analise, nm_usuario, 
			dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, 
			ie_tipo_linha, ie_tipo_despesa, ds_item, 
			ie_tipo_item, ie_selecionado 
		) values ( 
			nr_sequencia_w, nr_seq_analise_p, nm_usuario_p, 
			clock_timestamp(), nm_usuario_p, clock_timestamp(), 
			'T', ie_tipo_despesa_w, ds_tipo_despesa_w, 
			ie_tipo_item_w, ie_selecionado_w 
		);
			 
		CALL pls_consulta_analise_pos_pck.set_nr_seq_item(nr_sequencia_w + 1);
	end if;
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_analise_pos_titulo ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

