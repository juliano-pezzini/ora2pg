-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_valores_nf_cred_item ( nr_seq_nf_credito_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_acao_w			nf_credito.ie_acao%type;
ie_aplicacao_itens_w		nf_credito.ie_aplicacao_itens%type;
ie_forma_aplicacao_w		nf_credito.ie_forma_aplicacao%type;
vl_itens_sem_imposto_orig_w	nf_credito_item.vl_itens_sem_imposto_orig%type;
vl_itens_imposto_orig_w		nf_credito_item.vl_itens_imposto_orig%type;
vl_imposto_orig_w		nf_credito_item.vl_imposto_orig%type;
vl_imposto_nao_retido_orig_w	nf_credito_item.vl_imposto_nao_retido_orig%type;
vl_aplicacao_w			nf_credito_item.vl_aplicacao%type;
pr_aplicacao_w			nf_credito_item.pr_aplicacao%type;
tx_tributo_w			nota_fiscal_item_trib.tx_tributo%type;
vl_auxiliar_w			double precision;
vl_itens_sem_imposto_w		nf_credito_item.vl_itens_sem_imposto%type;
vl_itens_imposto_w		nf_credito_item.vl_itens_imposto%type;
vl_imposto_w			nf_credito_item.vl_imposto%type;
vl_imposto_nao_retido_w		nf_credito_item.vl_imposto_nao_retido%type;
vl_taxa_w			nota_fiscal_item_trib.tx_tributo%type;
nr_seq_nf_orig_w 		nf_credito_item.nr_seq_nf_orig%type;
nr_item_nf_orig_w		nf_credito_item.nr_item_nf_orig%type;
ie_sinal_operacao_w 		varchar(1);
sql_w 				varchar(100);
qt_aplicacao_w			nf_credito_item.qt_aplicacao%type;
vl_unitario_item_nf_w		nota_fiscal_item.vl_unitario_item_nf%type;
vl_total_item_nf_w 		nota_fiscal_item.vl_total_item_nf%type;
nr_sequencia_nf_credito_w	nf_credito.nr_sequencia%type;
qt_itens_resultante_w		nf_credito_item.qt_aplicacao%type;


c01 CURSOR FOR
SELECT	b.tx_tributo
from	nota_fiscal_item_trib b,
	nf_credito_item a
where	a.nr_sequencia 	= nr_seq_nf_credito_item_p
and	b.nr_sequencia 	= a.nr_seq_nf_orig
and	b.nr_item_nf 	= a.nr_item_nf_orig
and	b.ie_rateio 	= 'N';


BEGIN
if (nr_seq_nf_credito_item_p IS NOT NULL AND nr_seq_nf_credito_item_p::text <> '') then
		EXECUTE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS= ''.,'' ';

	select	a.ie_acao,
		a.ie_aplicacao_itens,
		a.ie_forma_aplicacao,
		b.vl_itens_sem_imposto_orig,
		b.vl_itens_imposto_orig,
		b.vl_imposto_orig,
		b.vl_imposto_nao_retido_orig,
		coalesce(b.vl_aplicacao,0),
		coalesce(b.pr_aplicacao,0),
		a.nr_seq_nf_orig,
		b.nr_item_nf_orig,
		coalesce(b.qt_aplicacao,0)
	into STRICT	ie_acao_w,
		ie_aplicacao_itens_w,
		ie_forma_aplicacao_w,
		vl_itens_sem_imposto_orig_w,
		vl_itens_imposto_orig_w,
		vl_imposto_orig_w,
		vl_imposto_nao_retido_orig_w,
		vl_aplicacao_w,
		pr_aplicacao_w,
		nr_seq_nf_orig_w,
		nr_item_nf_orig_w,
		qt_aplicacao_w
	from	nf_credito_item b,
		nf_credito a
	where	b.nr_sequencia = nr_seq_nf_credito_item_p
	and	a.nr_sequencia = b.nr_seq_nf_credito;
	
	select 	coalesce(vl_unitario_item_nf, 0),
		vl_total_item_nf
	into STRICT 	vl_unitario_item_nf_w,
		vl_total_item_nf_w
	from 	nota_fiscal_item
	where 	nr_item_nf 	= nr_item_nf_orig_w
	and 	nr_sequencia	= nr_seq_nf_orig_w;
	
	select 	coalesce(max(tx_tributo),16)
	into STRICT    vl_taxa_w
	from    nota_fiscal_item_trib a,
		nota_fiscal b
	where   a.nr_sequencia 	= b.nr_sequencia
	and     b.nr_sequencia 	= nr_seq_nf_orig_w
	and     nr_item_nf 	= nr_item_nf_orig_w;

	qt_itens_resultante_w := fis_obter_qt_cred_disponivel(nr_seq_nf_orig_w, nr_item_nf_orig_w);

	vl_auxiliar_w		:= 0;
	vl_itens_sem_imposto_w	:= 0;
	vl_itens_imposto_w	:= 0;
	vl_imposto_w		:= 0;
	ie_sinal_operacao_w 	:= '-';
	
	if ('Q' = ie_forma_aplicacao_w and 'D' = ie_acao_w) then
		if (qt_aplicacao_w > qt_itens_resultante_w) then
			update	nf_credito_item
			set	qt_aplicacao 		 = NULL,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= nr_seq_nf_credito_item_p;
			commit;
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1093940);
		end if;
	end if;
	
	if ('A' = ie_acao_w) then
		ie_sinal_operacao_w := '+';
	end if;

	if ('P' = ie_forma_aplicacao_w) then
		vl_auxiliar_w 	:= (pr_aplicacao_w / 100)::numeric;
		
		EXECUTE 'select ' || vl_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ( ' || vl_imposto_orig_w || ' * to_number(' || vl_auxiliar_w || ') ) from dual'
		into STRICT vl_imposto_w;
		
		EXECUTE 'select ' || vl_imposto_nao_retido_orig_w || ' ' || ie_sinal_operacao_w || ' ( ' || vl_imposto_nao_retido_orig_w || ' * to_number(' || vl_auxiliar_w || ') ) from dual'
		into STRICT vl_imposto_nao_retido_w;
		
	elsif ('V' = ie_forma_aplicacao_w) then
	
		if (vl_itens_imposto_orig_w > 0) then
			vl_auxiliar_w := vl_aplicacao_w / vl_itens_imposto_orig_w;
			if (coalesce(vl_imposto_orig_w,0) > 0) then
			
				EXECUTE 'select ' || vl_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ( ' || vl_imposto_orig_w || ' * to_number(' || vl_auxiliar_w || ') ) from dual'
				into STRICT vl_imposto_w;
				
			end if;
			
			if (coalesce(vl_imposto_nao_retido_orig_w,0) > 0) then
			
				EXECUTE 'select ' || vl_imposto_nao_retido_orig_w || ' ' || ie_sinal_operacao_w || ' ( ' || vl_imposto_nao_retido_orig_w || ' * to_number(' || vl_auxiliar_w || ') ) from dual'
				into STRICT vl_imposto_nao_retido_w;
				
			end if;
		end if;
		vl_auxiliar_w := vl_aplicacao_w;
	elsif ('Q' = ie_forma_aplicacao_w) then

		vl_auxiliar_w := vl_unitario_item_nf_w * qt_aplicacao_w;

		if (vl_itens_imposto_orig_w > 0) then
			if (vl_imposto_orig_w > 0) then
				EXECUTE 'select ' || vl_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ((' || vl_imposto_orig_w || ' * ' ||  qt_aplicacao_w || ') / ' || qt_itens_resultante_w || ')  from dual'
				into STRICT vl_imposto_w;

			end if;
			if (vl_imposto_nao_retido_orig_w > 0) then
				EXECUTE 'select ' || vl_imposto_nao_retido_orig_w || ' ' || ie_sinal_operacao_w || ' ((' || vl_imposto_nao_retido_orig_w || ' * ' || qt_aplicacao_w || ') / ' || qt_itens_resultante_w || ') from dual'
				into STRICT vl_imposto_nao_retido_w;
			end if;
		end if;
	end if;

	if ('P' = ie_forma_aplicacao_w) then
		if (vl_itens_sem_imposto_orig_w > 0) then

			EXECUTE 'select ' || vl_itens_sem_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ( ' || vl_itens_sem_imposto_orig_w || ' * to_number(' || vl_auxiliar_w || ') ) from dual'
			into STRICT vl_itens_sem_imposto_w;

		end if;

		if (vl_itens_imposto_orig_w > 0) then

			EXECUTE 'select ' || vl_itens_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ( ' || vl_itens_imposto_orig_w || ' * to_number(' || vl_auxiliar_w || ') ) from dual'
			into STRICT vl_itens_imposto_w;
		
		end if;

	elsif ('V' = ie_forma_aplicacao_w) then
		if (vl_itens_sem_imposto_orig_w > 0) then

			EXECUTE 'select ' || vl_itens_sem_imposto_orig_w || ' ' || ie_sinal_operacao_w || vl_auxiliar_w || ' from dual'
			into STRICT vl_itens_sem_imposto_w;

		end if;
		if (vl_itens_imposto_orig_w > 0) then
			
			EXECUTE 'select ' || vl_itens_imposto_orig_w || ' ' || ie_sinal_operacao_w || vl_auxiliar_w || ' from dual'
			into STRICT vl_itens_imposto_w;
		end if;
		
	elsif ('Q' = ie_forma_aplicacao_w) then
		if (coalesce(vl_itens_sem_imposto_orig_w,0) > 0) then
			
			EXECUTE 'select ' || vl_itens_sem_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ' || vl_auxiliar_w || ' from dual'
			into STRICT vl_itens_sem_imposto_w;

		end if;
		if (coalesce(vl_itens_imposto_orig_w,0) > 0) then
			EXECUTE 'select ' || vl_itens_imposto_orig_w || ' ' || ie_sinal_operacao_w || ' ((' || vl_itens_imposto_orig_w || ' * ' || qt_aplicacao_w || ') / ' || qt_itens_resultante_w || ')  from dual'
			into STRICT vl_itens_imposto_w;
		end if;
	end if;

	update	nf_credito_item
	set	vl_itens_sem_imposto	= vl_itens_sem_imposto_w,
		vl_itens_imposto	= vl_itens_imposto_w,
		vl_imposto		= vl_imposto_w,
		vl_imposto_nao_retido	= vl_imposto_nao_retido_w,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_nf_credito_item_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_valores_nf_cred_item ( nr_seq_nf_credito_item_p bigint, nm_usuario_p text) FROM PUBLIC;
