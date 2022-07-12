-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>++++++ CONSISTENCIAS ++++++<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	--Cons>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Verifica se deve ser consistido a solicitacao de compra <<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	

	/*
	Objetivo: Consistir a liberacao da solicitacao de compra caso o projeto recurso nao tenha saldo suficiente para suportar essa solicitacao.
		     Consistir a liberacao e estornacao da solicitacao de compra se o projeto vinculado ao item possui data de encerramento.	
	Parametros: 
	nr_solic_compra_p = Numero de sequencia da solicitacao de compra
	nm_usuario_p = Nome do usuario.
	cd_estabelecimento_p = Codigo do estabelecimento logado pelo usuario.
	ie_acao_p = Flag para identificacao da acao a ser executada pelo usuario: 
		'L' para liberacao, 
		'E' para estorno.
	*/
		


CREATE OR REPLACE PROCEDURE projeto_recurso_pck.consistir_sc_proj_rec ( nr_solic_compra_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_acao_p text default 'L') AS $body$
DECLARE


						
	ie_consiste_saldo_proj_w 	varchar(15);
	nr_seq_proj_rec_w		projeto_recurso.nr_sequencia%type;
	vl_total_solic_w		solic_compra_item.vl_unit_previsto%type;
	qt_proj_fim_exec		bigint;
	
	c01 CURSOR FOR
	SELECT	nr_seq_proj_rec
	from	solic_compra_item
	where	nr_solic_compra = nr_solic_compra_p
	and	(nr_seq_proj_rec IS NOT NULL AND nr_seq_proj_rec::text <> '')
	and	ie_consiste_saldo_proj_w = 'S'
	group by nr_seq_proj_rec;
	
	
BEGIN
	
	select 	count(*)
	into STRICT	qt_proj_fim_exec
	from 	projeto_recurso
	where 	nr_sequencia in (SELECT	nr_seq_proj_rec
				from	solic_compra_item
				where	nr_solic_compra = nr_solic_compra_p
				and	(nr_seq_proj_rec IS NOT NULL AND nr_seq_proj_rec::text <> ''))
	and	(dt_fim_exec IS NOT NULL AND dt_fim_exec::text <> '')		
	and (trunc(dt_fim_exec,'dd') < trunc(clock_timestamp(),'dd'));
	
	delete
	from	solic_compra_consist
	where	nr_solic_compra = nr_solic_compra_p
	and		ie_tipo_consistencia = '2';
	
	-- 2 e consistencia quando o projeto rec do item possui dt encerramento inferior a data atual

	if (qt_proj_fim_exec > 0) then
		CALL gravar_solic_compra_consist(
					nr_solic_compra_p, '2',
					wheb_mensagem_pck.get_texto(779607),
					'C', null, nm_usuario_p);
	end if;
	
	if ( ie_acao_p = 'L' ) then
		begin
		select coalesce(max(obter_valor_param_usuario(913, 288, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'C')
		into STRICT ie_consiste_saldo_proj_w
		;
		
		open C01;
		loop
		fetch C01 into	
			nr_seq_proj_rec_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			
			/*  obtem o valor total da solicitacao criada agora*/


			select	coalesce(sum(b.qt_material * b.vl_unit_previsto),0)
			into STRICT	vl_total_solic_w
			from	solic_compra a,
				solic_compra_item b
			where	a.nr_solic_compra = b.nr_solic_compra
			and	b.nr_seq_proj_rec = nr_seq_proj_rec_w
			and	a.nr_solic_compra = nr_solic_compra_p
			and	b.vl_unit_previsto > 0
			and coalesce(b.dt_reprovacao::text, '') = '';	
			
			if (projeto_recurso_pck.obter_vl_saldo_proj_rec(nr_seq_proj_rec_w, nm_usuario_p, cd_estabelecimento_p) < vl_total_solic_w) then
				
				CALL gravar_solic_compra_consist(
						nr_solic_compra_p, '2',
						wheb_mensagem_pck.get_texto(498505,
							'VL_PROJ_REC_W='|| campo_mascara_virgula_casas(projeto_recurso_pck.obter_vl_proj_rec(nr_seq_proj_rec_w),4) ||						
							';VL_TOTAL_REAL_PROJ_REC_W='|| campo_mascara_virgula_casas(projeto_recurso_pck.obter_vl_realizado(nr_seq_proj_rec_w, nm_usuario_p, cd_estabelecimento_p),4) ||
							';VL_TOTAL_COMP_PROJ_REC_W='|| campo_mascara_virgula_casas(projeto_recurso_pck.obter_vl_comprometido(nr_seq_proj_rec_w, nm_usuario_p, cd_estabelecimento_p),4) ||
							';VL_SALDO_PROJ_REC_W='|| campo_mascara_virgula_casas(projeto_recurso_pck.obter_vl_saldo_proj_rec(nr_seq_proj_rec_w, nm_usuario_p, cd_estabelecimento_p),4) ||
							';VL_SOLIC_W='|| campo_mascara_virgula_casas(vl_total_solic_w,4)),
						'C', null, nm_usuario_p);
				/*O projeto recurso nao tem saldo suficiente para atender essa solicitacao.
				Valor do projeto: #@VL_PROJ_REC_W#@
				Total realizado: #@VL_TOTAL_REAL_PROJ_REC_W#@
				Total comprometido: #@VL_TOTAL_COMP_PROJ_REC_W#@
				Saldo do projeto: #@VL_SALDO_PROJ_REC_W#@
				Valor desta solicitacao: #@VL_SOLIC_W#@.*/
					
			end if;	
			
			end;
		end loop;
		close C01;
		end;
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE projeto_recurso_pck.consistir_sc_proj_rec ( nr_solic_compra_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_acao_p text default 'L') FROM PUBLIC;