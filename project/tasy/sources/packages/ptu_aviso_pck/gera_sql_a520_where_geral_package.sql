-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_a520_where_geral ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, ie_possui_join_proc_p text, ie_possui_join_mat_p text, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL, parte do WHERE "Geral", para o A520.
		
		O que e considerado "Geral", seria todas as validacoes que independem de regras, e que 
		devem ser aplicadas sempre que se buscar os dados do A520.
		
		Por exemplo: Quando for considerado o item da conta, entao nao trazer os itens cancelados.
		
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_sql_w	varchar(32000);
cta_w		alias_t%type;
pos_w		alias_t%type;
item_w		alias_t%type;
ds_and_w	varchar(10);

BEGIN

cta_w		:= alias_p.conta;
pos_w		:= alias_p.pos;
ds_sql_w	:= '';
ds_and_w	:= '	';

-- se for baseado no Pos

if (dados_a520_p.ie_geracao_aviso_cobr in ('PO', 'PA')) then

	if (dados_a520_p.ie_novo_pos_estab = 'N') then -- Pos anterior
	
		-- verifica o nivel do filtro

		if	(ie_possui_join_proc_p = 'N' AND ie_possui_join_mat_p = 'N') then
			
			ds_sql_w	:= ds_sql_w ||ds_and_w||'not exists(	select	1 ' 							|| pls_util_pck.enter_w ||
								'		from	pls_conta_pos_estabelecido x ' 				|| pls_util_pck.enter_w ||
								'		where	x.nr_seq_conta		= '||cta_w||'.nr_sequencia '	|| pls_util_pck.enter_w ||
								'		and	x.ie_status_faturamento	= ''L'' ' 			|| pls_util_pck.enter_w ||
								'		and	x.ie_situacao		= ''A'' ' 			|| pls_util_pck.enter_w ||
								'		and	x.nr_seq_evento_fat is not null ' 			|| pls_util_pck.enter_w ||
								'		and	x.nr_seq_lote_fat is not null ) ' 			|| pls_util_pck.enter_w;
			ds_and_w	:= 'and	';
		else	
		
			ds_sql_w	:= ds_sql_w ||ds_and_w||''||pos_w||'.ie_status_faturamento	= :ie_status_faturamento '		|| pls_util_pck.enter_w ||
								'and	'||pos_w||'.ie_situacao			= ''A'' '			|| pls_util_pck.enter_w ||
								'and	'||pos_w||'.nr_seq_evento_fat		is null '			|| pls_util_pck.enter_w ||
								'and	'||pos_w||'.nr_seq_lote_fat		is null '			|| pls_util_pck.enter_w;
			ds_and_w	:= 'and	';
		end if;

	elsif (dados_a520_p.ie_novo_pos_estab = 'S') then -- Pos novo
	
	
		-- verifica o nivel do filtro

		if	(ie_possui_join_proc_p = 'N' AND ie_possui_join_mat_p = 'N') then
			
			ds_sql_w	:= ds_sql_w ||ds_and_w||'(not exists(select	1 ' 							|| pls_util_pck.enter_w ||
								'		from	pls_conta_pos_proc	x ' 				|| pls_util_pck.enter_w ||
								'		where	x.nr_seq_conta		= '||cta_w||'.nr_sequencia '	|| pls_util_pck.enter_w ||
								'		and	x.ie_status_faturamento	= ''L'' ' 			|| pls_util_pck.enter_w ||
								'		and	x.nr_seq_evento_fat	is not null ' 			|| pls_util_pck.enter_w ||
								'		and	x.nr_seq_lote_fat	is not null  ' 			|| pls_util_pck.enter_w ||
								'		union all '							|| pls_util_pck.enter_w ||
								'		select	1 ' 							|| pls_util_pck.enter_w ||
								'		from	pls_conta_pos_mat	x ' 				|| pls_util_pck.enter_w ||
								'		where	x.nr_seq_conta		= '||cta_w||'.nr_sequencia '	|| pls_util_pck.enter_w ||
								'		and	x.ie_status_faturamento	= ''L'' ' 			|| pls_util_pck.enter_w ||
								'		and	x.nr_seq_evento_fat	is not null '			|| pls_util_pck.enter_w ||
								'		and	x.nr_seq_lote_fat	is not null )) '		|| pls_util_pck.enter_w;
			ds_and_w	:= 'and	';
		else
		
			--levanta o alias correto, sendo PROC OU MAT (nunca os dois ao mesmo tempo)

			item_w 	:=	case	
						when(ie_possui_join_proc_p = 'S') then alias_p.pos_proc
						when(ie_possui_join_mat_p = 'S') then alias_p.pos_mat
					end;
			
			-- restricoes que se aplicam tanto para proc e mat

			ds_sql_w	:= ds_sql_w ||ds_and_w||''||item_w||'.ie_status_faturamento	= :ie_status_faturamento '		|| pls_util_pck.enter_w ||
								'and	'||item_w||'.nr_seq_evento_fat	is null ' 				|| pls_util_pck.enter_w ||
								'and	'||item_w||'.nr_seq_lote_fat	is null ' 				|| pls_util_pck.enter_w;
			ds_and_w	:= 'and	';
			
		
		end if;
	end if;
	
	dados_bind_p := sql_pck.bind_variable(':ie_status_faturamento', case dados_a520_p.ie_geracao_aviso_cobr when 'PA' then 'A' else 'L' end, dados_bind_p);
		
else

	-- aplica o nivel do filtro

	if	(ie_possui_join_proc_p = 'N' AND ie_possui_join_mat_p = 'N') then

		ds_sql_w	:= ds_sql_w ||ds_and_w||'(exists(select	1 ' 									|| pls_util_pck.enter_w ||
							'		from	pls_conta_proc		x ' 					|| pls_util_pck.enter_w ||
							'		where	x.nr_seq_conta		= '||cta_w||'.nr_sequencia '		|| pls_util_pck.enter_w ||
							'		and	x.ie_status		!= ''D'' ' 				|| pls_util_pck.enter_w ||
							'		union all ' 								|| pls_util_pck.enter_w ||
							'		select	1 ' 								|| pls_util_pck.enter_w ||
							'		from	pls_conta_mat		x ' 					|| pls_util_pck.enter_w ||
							'		where	x.nr_seq_conta		= '||cta_w||'.nr_sequencia '		|| pls_util_pck.enter_w ||
							'		and	x.ie_status		!= ''D'' ))' 				|| pls_util_pck.enter_w;
		ds_and_w	:= 'and	';
	else
	
		--levanta o alias correto, sendo PROC OU MAT (nunca os dois ao mesmo tempo)

		item_w 	:=	case	
					when(ie_possui_join_proc_p = 'S') then alias_p.procedimento
					when(ie_possui_join_mat_p = 'S') then alias_p.material
				end;
		-- restricoes em comum com proc e mat

		ds_sql_w	:= ds_sql_w ||ds_and_w||''||item_w||'.ie_status	!= ''D'' '		 					|| pls_util_pck.enter_w;
		ds_and_w	:= 'and	';
	
	end if;
	
	
	
	-- quando e usado como base o pagamento (prestador), e necessario remover os itens que possuem pos, entao o not exists fica sendo obrigatorio

	ds_sql_w :=	ds_sql_w||ds_and_w||	'not exists (	select	1 ' 									|| pls_util_pck.enter_w ||
						'			from	pls_conta_pos_estabelecido	x '				|| pls_util_pck.enter_w ||
						'			where	x.nr_seq_conta	= '||cta_w||'.nr_sequencia '			|| pls_util_pck.enter_w ||
						'			union all '								|| pls_util_pck.enter_w ||
						'			select	1 ' 								|| pls_util_pck.enter_w ||
						'			from	pls_conta_pos_proc	x '					|| pls_util_pck.enter_w ||
						'			where	x.nr_seq_conta	= '||cta_w||'.nr_sequencia '			|| pls_util_pck.enter_w ||
						'			union all '								|| pls_util_pck.enter_w ||
						'			select	1 ' 								|| pls_util_pck.enter_w ||
						'			from	pls_conta_pos_mat	x '					|| pls_util_pck.enter_w ||
						'			where	x.nr_seq_conta	= '||cta_w||'.nr_sequencia ) '			|| pls_util_pck.enter_w;
	ds_and_w	:= 'and	';

end if;


return;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_a520_where_geral ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, ie_possui_join_proc_p text, ie_possui_join_mat_p text, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;