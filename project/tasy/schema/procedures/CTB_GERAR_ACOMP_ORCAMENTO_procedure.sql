-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_acomp_orcamento ( cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, dt_ref_realizado_p timestamp, cd_classif_conta_p text, cd_classif_centro_p text, cd_conta_contabil_p text, cd_centro_custo_p text, qt_min_nivel_conta_p bigint, qt_max_nivel_conta_p bigint, qt_min_nivel_centro_p bigint, qt_max_nivel_centro_p bigint, nm_usuario_p text, ie_ordem_inicio_p text, ie_orc_empresa_p text, ie_real_acum_saldo_p text) IS cd_conta_gravar_w varchar(20) RETURNS varchar AS $body$
DECLARE


qt_nao_contido_w	smallint;
ds_retorno_w		varchar(1);
qt_existe_w		smallint;

BEGIN
/* Inicializar a variavel com o valor ja definido */

ds_retorno_w := ie_opcao_p;

/* Verificar se existe o sinal de MENOS, indicando que o resultado deve ser TODOS MENOS OS SELECIONADOS */

qt_nao_contido_w := position('-' in substr(ds_possib_p,1,position('(' in ds_possib_p)));
/* Caso nao encontrar sinal de MENOS, verifica se existe a palavra NOT -> not in (opcoes)*/

if (qt_nao_contido_w = 0) then
	begin
	/* Alguns tratamentos em funcoes/relatorio para enviar como AND CAMPO NOT IN (OPCAO1,OPCAO2) */

	qt_nao_contido_w := position(' NOT ' in substr(ds_possib_p,1,position('(' in ds_possib_p)));
	end;
end if;

/* Caso esteja utilizando a opcao TODOS MENOS OS SELECIONADOS */

if (qt_nao_contido_w > 0) then
	begin
	/* Inverte a opcao passada por parametro */

	if (ie_opcao_p = 'S') then
		begin
		ds_retorno_w := 'N';
		end;
	else
		begin
		ds_retorno_w := 'S';
		end;
	end if;
	end;
end if;

return	ds_retorno_w;

end;

begin

ie_separador_conta_w		:= philips_contabil_pck.get_separador_conta;
ie_separador_centro_w		:= philips_contabil_pck.get_separador_centro;

ie_orc_empresa_w	:= coalesce(ie_orc_empresa_p,'N');
begin
ie_regra_lib_conta_w		:= coalesce(obter_valor_param_usuario(925,69,obter_perfil_ativo,nm_usuario_p, null),'S');
ie_concat_codigo_centro_w	:= coalesce(obter_valor_param_usuario(925,108,obter_perfil_ativo,nm_usuario_p, null),'N');
exception when others then
	ie_regra_lib_conta_w	:= 'S';
end;

if (ie_orc_empresa_w = 'S') then
	cd_estabelecimento_w	:= 0;
end if;

DELETE	FROM W_CTB_ACOMP_ORCAMENTO
where	nm_usuario	= nm_usuario_p;
commit;

dt_referencia_w		:= PKG_DATE_UTILS.start_of(dt_Referencia_p , 'month', 0);
dt_inicio_ano_w		:= PKG_DATE_UTILS.start_of(dt_referencia_w, 'year', 0);
dt_fim_ano_w		:= fim_dia(PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(dt_referencia_w,'year', 0),12,0)-1);
dt_ref_realizado_w	:= PKG_DATE_UTILS.start_of(coalesce(dt_Ref_realizado_p,dt_referencia_p) , 'month', 0);
dt_ini_realizar_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_referencia_w,1,0);
dt_fim_realizar_w	:= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(dt_Referencia_p , 'year', 0),11,0);
dt_ref_ano_realizar_w	:= PKG_DATE_UTILS.start_of(coalesce(dt_Ref_realizado_p,dt_referencia_p) , 'yyyy', 0);

controle_commit_w := 0;
if (coalesce(cd_centro_custo_p, '0') <> '0') and (cd_estabelecimento_w = 0) then
	ds_centro_regra_w := cd_centro_custo_p || ',';
	
	open C03;
	loop
	fetch C03 into	
		cd_centro_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ds_centro_regra_w := ds_centro_regra_w || cd_centro_regra_w || ',';
		end;
	end loop;
	close C03;
end if;

OPEN  C001;
LOOP
FETCH C001 BULK COLLECT INTO s_array LIMIT 200;
	for i in 1..s_array.COUNT loop
		begin
		cd_conta_contabil_w 	:= s_array[i].cd_conta_contabil;
		cd_centro_custo_w	:= s_array[i].cd_centro_custo;
		ie_tipo_conta_w		:= s_array[i].ie_tipo_conta;
		vl_orcado_acum_w	:= s_array[i].vl_orcado_acum;
		vl_original_acum_w	:= s_array[i].vl_original_acum;
		vl_real_acum_w		:= s_array[i].vl_real_acum;
		vl_orcado_mes_w		:= s_array[i].vl_orcado_mes;
		vl_original_mes_w	:= s_array[i].vl_original_mes;
		vl_real_mes_w		:= s_array[i].vl_real_mes;
		ie_orc_real_w		:= s_array[i].ie_orc_real;
		vl_empenho_w		:= coalesce(s_array[i].vl_empenho,0);
		
		-- Marcio OS 454107 (na procedure ctb_obter_se_conta_ce_usuario faz um get estabelecimento, precisa fazer o set para poder consultar em outro estabelecimento)
		cd_estab_anterior_w := wheb_usuario_pck.get_cd_estabelecimento;
		CALL wheb_usuario_pck.set_cd_estabelecimento(cd_estabelecimento_w);		
		
		if (coalesce(ie_regra_lib_conta_w,'S') = 'S') then
			ie_gerar_w := SUBSTR(ctb_obter_se_conta_ce_usuario(cd_empresa_p,cd_centro_custo_w,cd_conta_contabil_w,nm_usuario_p),1,1);
		else
			ie_gerar_w := ctb_obter_se_centro_usuario(cd_centro_custo_w, cd_empresa_p, nm_usuario_p);
		end if;
		
		if (ie_gerar_w = 'S') then
			ie_gerar_w	:= substr(obter_se_conta_vigente(cd_conta_contabil_w, dt_referencia_w),1,1);
		end if;		
		
		CALL wheb_usuario_pck.set_cd_estabelecimento(cd_estab_anterior_w);
		
		if (ie_gerar_w = 'S') and ( coalesce(cd_classif_conta_p,'0') <> '0' ) then
			begin
			ie_gerar_w	:= 'N';
			cd_classif_w	:= cd_classif_conta_p;
			cd_classif_w	:= replace(cd_classif_w,'(','');
			cd_classif_w	:= replace(cd_classif_w,')','');
			cd_classif_w	:= replace(cd_classif_w,' ','');
			while(ie_gerar_w = 'N') and (length(cd_classif_w) > 0)  loop
				begin
				ie_pos_w 	:= position(',' in cd_classif_w);
				if (ie_pos_w = 0) then
					cd_classif_ww	:= cd_classif_w;
					cd_classif_w	:= '';
				else
					cd_classif_ww	:= substr(cd_classif_w,1, ie_pos_w - 1);
					cd_classif_w	:= substr(cd_classif_w, ie_pos_w + 1, 255);
				end if;
				ie_gerar_w := ctb_obter_se_conta_sup_vig(cd_conta_contabil_w, cd_classif_ww, dt_referencia_w);
				end;
			end loop;
			
			ie_gerar_w := obter_se_gera_contido(ie_gerar_w,cd_classif_conta_p);
			
			end;
		end if;
		if (ie_gerar_w	= 'S')  and (coalesce(cd_classif_centro_p,'0') <> '0')  then
			begin
			ie_gerar_w	:= 'N';
			cd_classif_w	:= cd_classif_centro_p;
			cd_classif_w	:= replace(cd_classif_w,'(','');
			cd_classif_w	:= replace(cd_classif_w,')','');
			cd_classif_w	:= replace(cd_classif_w,' ','');
			while(ie_gerar_w = 'N') and (length(cd_classif_w) > 0)  loop
				begin
				ie_pos_w 		:= position(',' in cd_classif_w);
				if (ie_pos_w = 0) then
					cd_classif_ww	:= cd_classif_w;
					cd_classif_w	:= '';
				else
					cd_classif_ww	:= substr(cd_classif_w,1, ie_pos_w - 1);
					cd_classif_w	:= substr(cd_classif_w, ie_pos_w + 1, 255);
				end if;
				ie_gerar_w	:= CTB_Obter_Se_Centro_Sup(cd_centro_custo_w, cd_classif_ww);
				end;
			end loop;
			
			ie_gerar_w := obter_se_gera_contido(ie_gerar_w,cd_classif_centro_p);
			
			end;
		end if;

		if (ie_gerar_w	= 'S')  and (coalesce(cd_centro_custo_p, '0') <> '0') then
			ie_gerar_w	:= obter_se_contido_relat(cd_centro_custo_w, cd_centro_custo_p,',');
			
			if (cd_estabelecimento_w = 0) then
				ie_gerar_w := CTB_Obter_Centro_Contido_orc(cd_centro_custo_w, ds_centro_regra_w);
			end if;
			
		end if;
		
		if (ie_gerar_w	= 'S')  and (coalesce(cd_conta_contabil_p,'0')	<> '0') then
			ie_gerar_w := obter_se_contido_relat(cd_conta_contabil_w, cd_conta_contabil_p,',');
		end if;

		if (ie_gerar_w	= 'S')  then
			begin
			
			vl_saldo_w		:= 0;
			if (ie_orc_real_w = 0) then
						
				select	coalesce(sum(c.vl_orcado),0)
				into STRICT	vl_saldo_w
				from	ctb_mes_ref m,
					ctb_orcamento c
				where	m.nr_sequencia	= c.nr_seq_mes_ref
				and	m.dt_referencia between dt_ini_realizar_w and dt_fim_realizar_w
				and	c.cd_estabelecimento	=
						CASE WHEN cd_estabelecimento_w=0 THEN  c.cd_estabelecimento  ELSE cd_estabelecimento_w END
				and	c.cd_centro_custo	= cd_centro_custo_w
				and	c.cd_conta_contabil	= cd_conta_contabil_w;
			end if;

		
			if (ie_orc_real_w = 2) then
				vl_saldo_w		:= vl_orcado_acum_w;
				vl_orcado_acum_w	:= 0;
			end if;

			if (cd_conta_contabil_w	<> cd_conta_contabil_ww) then
				cd_conta_ww 		:= ctb_obter_conta_nivel(cd_conta_contabil_w, qt_max_nivel_conta_p, dt_referencia_w);
				cd_conta_superior_w	:= ctb_obter_conta_nivel(cd_conta_contabil_w, qt_min_nivel_conta_p, dt_referencia_w);
			
				
				/* Dados da conta contabil analitica*/

				begin
				select (cd_classificacao),
					(ds_conta_contabil),
					(b.ie_debito_credito)
				into STRICT	cd_classif_conta_w,
					ds_conta_w,
					ie_debito_credito_w
				from	ctb_grupo_conta b,
					conta_contabil a
				where	a.cd_conta_contabil	= cd_conta_ww
				and	a.cd_grupo		= b.cd_grupo;
				
				cd_classif_conta_w	:= substr(ctb_obter_classif_conta(cd_conta_ww, cd_classif_conta_w, dt_referencia_w),1,40);
				exception when others then
					cd_classif_conta_w	:= '';
					ds_conta_w		:= '';
					ie_debito_credito_w	:= '';
				end;
				cd_conta_contabil_ww		:= cd_conta_contabil_w;
				ie_orc_mes_w			:= 'N';
			end if;
			if (ie_orc_real_W = 0) then
				ie_orc_mes_w	:= 'S';
			end if;

			if (cd_centro_custo_w	<> cd_centro_custo_ww) then
				begin
				
				select	ctb_obter_centro_nivel(cd_centro_custo_w, qt_max_nivel_centro_p)
				into STRICT	cd_centro_ww
				;
				exception when others then
					cd_centro_ww	:= cd_centro_custo_w;
				end;
				
				select	max(cd_classificacao),
					max(ds_centro_custo)
				into STRICT	cd_classif_centro_w,
					ds_centro_w
				from	centro_custo
				where	cd_centro_custo	= cd_centro_ww;
				cd_centro_custo_ww		:= cd_centro_custo_w;
			end if;

			if (ie_ordem_inicio_p = 'C') then
				cd_classificacao_w	:= substr(cd_classif_conta_w || ie_separador_conta_w || cd_classif_centro_w,1,40);
				if (ie_concat_codigo_centro_w = 'S') then
				    ds_gerencial_w	:= cd_centro_custo_w||' - '||ds_centro_w;
				else
				    ds_gerencial_w	:= ds_centro_w;		
				end if;
				qt_nivel_2_w	:= qt_max_nivel_conta_p + qt_min_nivel_centro_p;
				qt_nivel_max_w	:= qt_max_nivel_conta_p;
				qt_nivel_Min_w	:= qt_min_nivel_conta_p;
				cd_classificacao_ww	:= cd_classif_conta_w;
			else
				cd_classificacao_w	:= substr(cd_classif_centro_w || ie_separador_conta_w || cd_classif_conta_w,1,40);
				ds_gerencial_w	:= ds_conta_w;
				qt_nivel_2_w	:= qt_max_nivel_centro_p + qt_min_nivel_conta_p;
				qt_nivel_max_w	:= qt_max_nivel_centro_p;
				qt_nivel_Min_w	:= qt_min_nivel_centro_p;
				cd_classificacao_ww	:= cd_classif_centro_w;
			end if;
			y				:= 1;
			FOR i IN 1..length(cd_classificacao_w) LOOP
				if (substr(cd_classificacao_w,i,1) = ie_separador_conta_w) then
					y		:= y + 1;
				end if;
			END LOOP;
			z				:= y;
			vl_saldo_conta_w		:= vl_saldo_w;
			cd_classificacao_atual_w	:= cd_classificacao_w;
			
			if (ie_real_acum_saldo_w = 'S') then
				vl_saldo_w	:= (vl_orcado_acum_w + vl_saldo_w) - vl_real_acum_w;
			end if;
			
			while(y >= qt_nivel_min_w) LOOP /* Y e o Numero de niveis */
				select	count(*)
				into STRICT	k
				from	W_CTB_ACOMP_ORCAMENTO
				where	cd_classificacao	= cd_classificacao_w
				and	nm_usuario		= nm_usuario_p;
				
				if (ie_orc_real_w = 2) then
					begin
					vl_saldo_w		:= vl_orcado_acum_w;
					vl_orcado_acum_w		:= 0;
					end;
				end if;
							
				if (k > 0) then

					update	W_CTB_ACOMP_ORCAMENTO
					set	vl_orcado_mes		= vl_orcado_mes + vl_orcado_mes_w,
						vl_orcado_acum		= vl_orcado_acum + vl_orcado_acum_w,
						vl_original_mes		= vl_original_mes + vl_original_mes_w,
						vl_original_acum	= vl_original_acum + vl_original_acum_w,
						vl_real_mes		= vl_real_mes + vl_real_mes_w,
						vl_real_acum		= vl_real_acum + vl_real_acum_w,
						vl_saldo		= vl_saldo + vl_saldo_w,
						vl_empenho		= vl_empenho + vl_empenho_w
					where	cd_classificacao	= cd_classificacao_w
					and	nm_usuario		= nm_usuario_p;
					controle_commit_w := controle_commit_w + 1;
				else
					begin
					j	:= y - qt_min_nivel_conta_p - qt_min_nivel_centro_p + 1;
					if (y = z) then
						w		:= 0;
					elsif (y > qt_nivel_max_w) then
						if (ie_ordem_inicio_p = 'C') then
							w	:= 10 + y - qt_nivel_max_w;
						else
							w	:= 20 + y - qt_nivel_max_w;
						end if;
					else
						j	:= y - qt_nivel_min_w;
						if (ie_ordem_inicio_p = 'C') then
							w	:= 20 + y;
						else
							w	:= 10 + y;
						end if;
					end if;

					if (w > 20) then
						cd_conta_ww := ctb_obter_conta_nivel(cd_conta_contabil_w, W - 20, dt_referencia_w);
						
						
						select	max(ds_conta_contabil)
						into STRICT	ds_gerencial_w
						from	conta_contabil
						where	cd_conta_contabil	= cd_conta_ww;
						

					elsif (w > 10) then
						cd_centro_ww :=	ctb_obter_centro_nivel(cd_centro_custo_w, W - 10);
					
					if (ie_concat_codigo_centro_w = 'S') then	
					
						select	cd_centro_custo_w||' - '||max(ds_centro_custo)
						into STRICT	ds_gerencial_w
						from	centro_custo
						where	cd_centro_custo		= cd_centro_ww;
					else
						select	max(ds_centro_custo)
						into STRICT	ds_gerencial_w
						from	centro_custo
						where	cd_centro_custo		= cd_centro_ww;
					end if;	
					end if;

					ds_gerencial_w	:= substr(lpad(' ', j * 2) || ds_gerencial_w,1,255);
									
					select	ie_tipo
					into STRICT	ie_tipo_conta_w
					from	conta_contabil
					where	cd_conta_contabil	= coalesce(cd_conta_ww,cd_conta_contabil_w);
					
					cd_conta_gravar_w	:= substr(cd_conta_contabil_w,1,20);
					cd_centro_gravar_w	:= cd_centro_custo_w;
					if (w > 0) then
						cd_conta_gravar_w	:= '';
						cd_centro_gravar_w	:= null;
					end if;
					
					/* Matheus OS 39240 em 12-10-2006 */

					ds_justificativa_w	:= ctb_obter_justificativa_orc(cd_empresa_p,cd_centro_gravar_w,cd_conta_gravar_w,dt_referencia_w);
				
					/*Alan Soares OS235729*/

					if (ie_orc_real_w = 2) and (ie_real_acum_saldo_w = 'N') then
					begin
						vl_saldo_w		:= s_array[i].vl_orcado_acum;
						vl_orcado_acum_w		:= 0;
					end;
					end if;
						
					if (coalesce(ds_gerencial_w::text, '') = '')  and (coalesce(coalesce(cd_conta_ww,cd_conta_contabil_w),'0') <> '0') then
						select	ds_conta_contabil
						into STRICT	ds_gerencial_w
						from	conta_contabil
						where	cd_conta_contabil	= coalesce(cd_conta_ww,cd_conta_contabil_w);
					end if;
					
					insert into W_CTB_ACOMP_ORCAMENTO(
						nm_usuario,
						cd_classificacao,
						ds_gerencial,
						vl_orcado_mes,
						vl_orcado_acum,
						vl_original_mes,
						vl_original_acum,
						vl_real_mes,
						vl_real_acum,
						vl_saldo,
						vl_empenho,
						ie_tipo_conta,
						cd_classif_conta,
						cd_conta_contabil,
						cd_centro_custo,
						ds_justificativa)
					values (nm_usuario_p,
						cd_classificacao_w,
						ds_gerencial_w,
						vl_orcado_mes_w,
						vl_orcado_acum_w,
						vl_original_mes_w,
						vl_original_acum_w,
						vl_real_mes_w,
						vl_real_acum_w,
						vl_saldo_w,
						vl_empenho_w,
						ie_tipo_conta_w,
						cd_classif_conta_w,
						coalesce(cd_conta_gravar_W,cd_conta_ww),
						cd_centro_gravar_w,
						ds_justificativa_w);
					controle_commit_w := controle_commit_w + 1;
					end;
				end if;
				if (y 	> qt_nivel_max_w) and (y 	<= qt_nivel_2_w) then
					cd_classificacao_w	:= cd_classificacao_ww;
				else
					select instr(cd_classificacao_w, ie_separador_conta_w, -1)
					into STRICT	k;
					cd_classificacao_w	:= substr(cd_classificacao_w,1,k -1);
				end if;
				y				:= 0;
				if (cd_classificacao_w IS NOT NULL AND cd_classificacao_w::text <> '') then
					y			:= 1;
					FOR i IN 1..length(cd_classificacao_w) LOOP
						if (substr(cd_classificacao_w,i,1) = ie_separador_conta_w) then
							y	:= y + 1;
					end if;
					END LOOP;
				end if;
				if (ie_ordem_inicio_p <> 'C' ) and (ie_debito_credito_w = 'D' ) and (y = qt_nivel_max_w) then

					vl_orcado_mes_w	:= vl_orcado_mes_w * -1;
					vl_orcado_acum_w	:= vl_orcado_acum_w * -1;
					vl_original_mes_w	:= vl_original_mes_w * -1;
					vl_original_acum_w	:= vl_original_acum_w * -1;
					vl_real_mes_w	:= vl_real_mes_w * -1;
					vl_real_acum_w	:= vl_real_acum_w * -1;
					vl_saldo_w		:= vl_saldo_w * -1;
					vl_saldo_conta_w	:= vl_saldo_conta_w * -1;
					vl_empenho_w		:= vl_empenho_w * -1;
				end if;
			if (controle_commit_w >= 100) then
				controle_commit_w := 0;
				commit;
			end if;	
			END LOOP;
			end;
		end if;
		end;
	end loop;
	EXIT WHEN NOT FOUND; /* apply on C001 */
	
END LOOP;

CLOSE C001;

open c02;
loop
FETCH C02 BULK COLLECT INTO w_ctb_acomp_array LIMIT 1000;
	for i in 1..w_ctb_acomp_array.COUNT loop
		begin
		ie_conta_inferior_w	:= 'N';
		vl_orcado_mes_w		:= w_ctb_acomp_array[i].vl_orcado_mes;
		vl_real_mes_w		:= w_ctb_acomp_array[i].vl_real_mes;
		cd_classif_conta_w	:= w_ctb_acomp_array[i].cd_classif_conta;
		cd_classificacao_w	:= w_ctb_acomp_array[i].cd_classificacao;
		cd_conta_contabil_w	:= w_ctb_acomp_array[i].cd_conta_contabil;
		cd_classificacao_ww	:= '';
		ie_conta_inferior_w	:= 'N';
		
		vl_variacao_w		:= VL_REAL_MES_w - VL_ORCADO_MES_w;
		pr_variacao_w 		:= ctb_obter_variacao_acomp(vl_orcado_mes_w, vl_real_mes_w);
		ds_cor_w		:= '';

		select	count(*)
		into STRICT	cont_w
		from	ctb_regra_orcamento
		where	coalesce(cd_classif_conta, cd_classif_conta_w) = cd_classif_conta_w
		and (pr_limite_acima		< pr_variacao_w
			or (pr_limite_abaixo * -1)	> pr_variacao_w)
		and	pr_variacao_w		<> 0
		and	coalesce(ie_conta_inferior,'N')	= 'N';
		
		if (cont_w = 0) then
			begin
			cd_classificacao_ww	:= substr(ctb_obter_classif_conta_sup(cd_classif_conta_w, dt_referencia_w, cd_empresa_p),1,40);
			
			select	count(*)
			into STRICT	cont_w
			from	ctb_regra_orcamento
			where	substr(ctb_obter_se_conta_classif_sup(cd_conta_contabil_w, cd_classif_conta),1,1) = 'S'
			and (pr_limite_acima		< pr_variacao_w
				or (pr_limite_abaixo * -1)	> pr_variacao_w)
			and	pr_variacao_w		<> 0
			and	coalesce(ie_conta_inferior,'N')	= 'S';
			
			if (cont_w > 0) then
				ie_conta_inferior_w		:= 'S';
			end if;
			end;
		end if;
		
		cont_w := 1;
		if (cont_w > 0) then
			begin
			if (ie_conta_inferior_w = 'N') then
				begin
				if (pr_variacao_w > 0) then
					select	coalesce(max(ds_cor),''),
						coalesce(max(ds_cor_fundo),'')
					into STRICT	ds_cor_w,
						ds_cor_fundo_w
					from	ctb_regra_orcamento
					where	coalesce(cd_classif_conta, cd_classif_conta_w) = cd_classif_conta_w
					and	ie_conta_inferior	= 'N'
					and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END
					and	pr_limite_acima 	= (
						SELECT	max(pr_limite_acima)
						from	ctb_regra_orcamento
						where	coalesce(cd_classif_conta, cd_classif_conta_w) = cd_classif_conta_w
						and	pr_limite_acima		<= pr_variacao_w
						and	ie_conta_inferior	= 'N'
						and	coalesce(vl_limite_acima,vl_variacao_w) <= vl_variacao_w
						and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END );
				else
					select	coalesce(max(ds_cor),''),
						coalesce(max(ds_cor_fundo),'')
					into STRICT	ds_cor_w,
						ds_cor_fundo_w
					from	ctb_regra_orcamento
					where	coalesce(cd_classif_conta, cd_classif_conta_w) = cd_classif_conta_w
					and	ie_conta_inferior	= 'N'
					and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END
					and	pr_limite_abaixo	= (
						SELECT	max(pr_limite_abaixo)
						from	ctb_regra_orcamento
						where	coalesce(cd_classif_conta, cd_classif_conta_w) = cd_classif_conta_w
						and	pr_limite_abaixo	<= (pr_variacao_w * -1)
						and	ie_conta_inferior	= 'N'
						and	coalesce(vl_limite_abaixo,(vl_variacao_w * -1)) <= (vl_variacao_w * -1)
						and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END );
				end if;
				end;
			elsif (ie_conta_inferior_w = 'S') then
				begin
				if (pr_variacao_w > 0) then
					select	coalesce(max(ds_cor),''),
						coalesce(max(ds_cor_fundo),'')
					into STRICT	ds_cor_w,
						ds_cor_fundo_w
					from	ctb_regra_orcamento
					where	substr(ctb_obter_se_conta_classif_sup(cd_conta_contabil_w, cd_classif_conta),1,1) = 'S'
					and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END
					and	ie_conta_inferior	= 'S'
					and	pr_limite_acima 	= (
						SELECT	max(pr_limite_acima)
						from	ctb_regra_orcamento
						where	substr(ctb_obter_se_conta_classif_sup(cd_conta_contabil_w, cd_classif_conta),1,1) = 'S'
						and	pr_limite_acima		<= pr_variacao_w
						and	ie_conta_inferior	= 'S'
						and	coalesce(vl_limite_acima,vl_variacao_w) <= vl_variacao_w
						and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END );
					
				else
					select	coalesce(max(ds_cor),''),
						coalesce(max(ds_cor_fundo),'')
					into STRICT	ds_cor_w,
						ds_cor_fundo_w
					from	ctb_regra_orcamento
					where	substr(ctb_obter_se_conta_classif_sup(cd_conta_contabil_w, cd_classif_conta),1,1) = 'S'
					and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END
					and	ie_conta_inferior	= 'S'
					and	pr_limite_abaixo	= (
						SELECT	max(pr_limite_abaixo)
						from	ctb_regra_orcamento
						where	substr(ctb_obter_se_conta_classif_sup(cd_conta_contabil_w, cd_classif_conta),1,1) = 'S'
						and	pr_limite_abaixo	<= (pr_variacao_w * -1)
						and	ie_conta_inferior	= 'S'
						and	coalesce(vl_limite_abaixo,(vl_variacao_w * -1)) <= (vl_variacao_w * -1)
						and	cd_estabelecimento	= CASE WHEN cd_estabelecimento_w=0 THEN  cd_estabelecimento  ELSE cd_estabelecimento_w END );
				end if;
				end;
			end if;
			
			update	w_ctb_acomp_orcamento
			set	ds_cor			= ds_cor_w,
				ds_cor_fundo		= ds_cor_fundo_w
			where	nm_usuario		= nm_usuario_p
			and	cd_classif_conta	= cd_classif_conta_w
			and	cd_classificacao	= cd_classificacao_w
			and	nm_usuario 		= nm_usuario_p
			and	cd_conta_contabil	= cd_conta_contabil_w;
			end;
			controle_commit_w := controle_commit_w + 1;
		end if;
		end;
		if (controle_commit_w >= 100) then
			controle_commit_w := 0;
			commit;
		end if;
	end loop;
	EXIT WHEN NOT FOUND; /* apply on C02 */
end loop;
close c02;


open c02;
loop
FETCH C02 BULK COLLECT INTO w_ctb_acomp_array LIMIT 1000;
	for i in 1..w_ctb_acomp_array.COUNT loop
		begin
		ie_conta_inferior_w	:= 'N';
		vl_orcado_mes_w		:= w_ctb_acomp_array[i].vl_orcado_mes;
		vl_real_mes_w		:= w_ctb_acomp_array[i].vl_real_mes;
		cd_classif_conta_w	:= w_ctb_acomp_array[i].cd_classif_conta;
		cd_classificacao_w	:= w_ctb_acomp_array[i].cd_classificacao;
		cd_conta_contabil_w	:= w_ctb_acomp_array[i].cd_conta_contabil;
		cd_classificacao_ww	:= '';
		ie_conta_inferior_w	:= 'N';
		vl_variacao_w		:= (coalesce(vl_real_mes_w,0) - coalesce(vl_orcado_mes_w,0));
		pr_variacao_w 		:= ctb_obter_variacao_acomp(vl_orcado_mes_w, vl_real_mes_w);
		cd_centro_custo_w	:= w_ctb_acomp_array[i].cd_centro_custo;	
		ie_regra_w		:=	0;
		vl_orcado_acum_w	:= w_ctb_acomp_array[i].vl_orcado_acum;	
		vl_real_acum_ww		:= w_ctb_acomp_array[i].vl_real_acum;
		ie_justificativa_w	:= substr(w_ctb_acomp_array[i].ds_justificativa,1,255);

		select  count(*)
		into STRICT    ie_conta_analitica_w
		from 	conta_contabil
		where	ie_tipo = 'A'
		and	cd_conta_contabil = cd_conta_contabil_w;
		
				
		if (ie_conta_analitica_w > 0) then
			

			
			select  coalesce(max(vl_superior_orc),0),
				coalesce(max(pr_sobra),0),
				coalesce(max(vl_sobra),0),
				coalesce(max(pr_estouro),0),
				coalesce(max(vl_estouro),0),
				count(*)
			into STRICT	vl_superior_orc_w,
				pr_sobra_w,
				vl_sobra_w,
				pr_estouro_w,
				vl_estouro_w,
				qt_regra_w
			from	ctb_orc_regra_just
			where	((cd_centro_custo 	= cd_centro_custo_w) or (coalesce(cd_centro_custo::text, '') = ''))
			and	((cd_conta_contabil 	= cd_conta_contabil_w) or (coalesce(cd_conta_contabil::text, '') = ''));
			
			/*select	count(*)
			into    ie_justificativa_w
			from	ctb_orcamento a,
				ctb_mes_ref m
			where	m.nr_sequencia		= a.nr_seq_mes_ref
			and	(cd_classif_conta_w is null or CTB_OBTER_SE_CONTA_CLASSIF_SUP(a.cd_conta_contabil,cd_classif_conta_w) = 'S')
			and	substr(ctb_obter_se_conta_ce_usuario(cd_empresa_p,a.cd_centro_custo,a.cd_conta_contabil, nm_usuario_p),1,1) = 'S'
			and	a.cd_estabelecimento	= cd_estabelecimento_p
			and	(a.cd_centro_custo		= nvl(cd_centro_custo_w, a.cd_centro_custo))
			and	a.ds_justificativa is not null;*/
			
		if (qt_regra_w > 0) then

			ie_sobra_w	:= 'N';
			ie_excedeu_w	:= 'N';
		
		
		
			if (vl_variacao_w > 0)	then
				if (vl_variacao_w > vl_estouro_w) and (coalesce(ie_justificativa_w::text, '') = '') and (vl_estouro_w 	<> 0) then
					ie_regra_w	:=	2;	--Exedeu o valor mensal sem justificativa
					ie_excedeu_w	:= 	'S';
				end if;	
				if (vl_variacao_w > vl_estouro_w) and (ie_justificativa_w IS NOT NULL AND ie_justificativa_w::text <> '') and (vl_estouro_w 	<> 0)then	
					ie_regra_w	:=	4;	--Exedeu o valor mensal com justificativa
					ie_excedeu_w	:= 	'S';
				end if;
			end if;
			
			
			if (pr_variacao_w > 0) then
				
				if (pr_variacao_w > pr_estouro_w) and (coalesce(ie_justificativa_w::text, '') = '') and (pr_estouro_w 	<> 0) then
					ie_regra_w	:=	2;	--Exedeu o valor mensal sem justificativa
					ie_excedeu_w	:= 	'S';
				end if;	
				if (pr_variacao_w > pr_estouro_w) and (ie_justificativa_w IS NOT NULL AND ie_justificativa_w::text <> '') and (pr_estouro_w 	<> 0) then	
					ie_regra_w	:=	4;	--Exedeu o valor mensal com justificativa
					ie_excedeu_w	:= 	'S';
				end if;	
			end if;	
	
		
		
			if (vl_variacao_w < 0)	then
			
				vl_variacao_w := vl_variacao_w * -1;
				
				if (vl_variacao_w > vl_sobra_w) and (coalesce(ie_justificativa_w::text, '') = '') and (vl_sobra_w 	<> 0) then
					ie_regra_w	:=	1;	--Sobra mensal sem justificativa
					ie_sobra_w	:= 	'S';
				end if;
				if (vl_variacao_w > vl_sobra_w) and (ie_justificativa_w IS NOT NULL AND ie_justificativa_w::text <> '') and (vl_sobra_w 	<> 0)then	
					ie_regra_w	:=	3;	--Sobra mensal Com justificativa
					ie_sobra_w	:= 	'S';
				end if;
			end if;
			
			
			if (pr_variacao_w < 0) then
			
				pr_variacao_w := pr_variacao_w * -1;	
				
				if (pr_variacao_w > pr_sobra_w) and (coalesce(ie_justificativa_w::text, '') = '') and (pr_sobra_w 	<> 0) then	
					ie_regra_w	:=	1;
					ie_sobra_w	:= 	'S';
				end if;					--Sobra mensal sem justificativa
				if (pr_variacao_w > pr_sobra_w) and (ie_justificativa_w IS NOT NULL AND ie_justificativa_w::text <> '') and (pr_sobra_w 	<> 0) then	
					ie_regra_w	:=	3;	--Sobra mensal Com justificativa
					ie_sobra_w	:= 	'S';
				end if;	
			end if;
			
			if	(ie_sobra_w = 'N' AND ie_excedeu_w = 'N') then
				ie_regra_w	:= 5;
			end if;
			
			if	((vl_orcado_acum_w + vl_superior_orc_w)  < vl_real_acum_ww)and (vl_superior_orc_w <> 0) then
				ie_excedeu_anual_w	:=	'S';
				else
				ie_excedeu_anual_w	:=	'N';
					
			end if;		

				
			update	w_ctb_acomp_orcamento
			set	ie_status_just		= ie_regra_w,
				ie_excedeu_anual	= ie_excedeu_anual_w
			where	nm_usuario		= nm_usuario_p
			and	cd_centro_custo		= cd_centro_custo_w
			and	cd_conta_contabil	= cd_conta_contabil_w;
			controle_commit_w := controle_commit_w + 1;
		end if;
		end if;
		end;
		if (controle_commit_w >= 100) then
			controle_commit_w := 0;
			commit;
		end if;
	end loop;
	EXIT WHEN NOT FOUND; /* apply on C02 */
end loop;
close c02;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_acomp_orcamento ( cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, dt_ref_realizado_p timestamp, cd_classif_conta_p text, cd_classif_centro_p text, cd_conta_contabil_p text, cd_centro_custo_p text, qt_min_nivel_conta_p bigint, qt_max_nivel_conta_p bigint, qt_min_nivel_centro_p bigint, qt_max_nivel_centro_p bigint, nm_usuario_p text, ie_ordem_inicio_p text, ie_orc_empresa_p text, ie_real_acum_saldo_p text) IS cd_conta_gravar_w varchar(20) FROM PUBLIC;

