-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pcs_sup_gerar_planej_pck.pcs_gerar_vl_formula (( ds_macro_p text default null, cd_material_p bigint, nr_seq_grupamento_p bigint, nr_Seq_segmento_p bigint, cd_local_estoque_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) is  --aqui irá substiuír as macros da fórmula. 
 nr_sequencia_w bigint) AS $body$
DECLARE

 
PERFORM	a.nr_sequencia, 
	a.ds_macro, 
	a.ds_composicao 
from	pcs_formulas a, 
	pcs_reg_calc_com_formula c 
where	a.nr_sequencia = c.nr_seq_formula_planej 
and	(a.ds_composicao IS NOT NULL AND a.ds_composicao::text <> '') 
and	a.ds_macro = coalesce(ds_macro_p,ds_macro) 
order by nr_ordem_calculo;--nome da macro 
 
c02 CURSOR FOR 
 
SELECT	ds_macro, 
		ds_resultado 
from 	w_pcs_atributo_formula 
where	nm_usuario = nm_usuario_p 
and		cd_material = cd_material_p;

C03 CURSOR FOR 
 
SELECT	cd_dominio 
from	pcs_atributos_v 
where	position('#A'  ds_formula_orig_w) > 0 
and	cd_dominio = nm_macro_parametro_w 
order by cd_dominio;


BEGIN 
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	ds_macro_w, 
	ds_formula_orig_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	open c02;
	loop 
	fetch c02 into 
		ds_macro_ww, 
		ds_resultado_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		ds_formula_orig_w := replace(ds_formula_orig_w, ds_macro_ww, replace(to_char(ds_resultado_w),',','.'));
	end loop;
	close c02;
 
	i := 0;
	while position('#A' in ds_formula_orig_w) > 0 loop 
		begin 
		i := i + 1;
 
		if (i > 40000) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(323770);
			-- Feito este controle afim de segurar que não fique em loop. 
			--Ultrapassou a quantidade limite de loops. Favor contatar a Philips para verificações. 
			-- Caso entrar aqui é porque houve algum problema na substituição das macros, deve haver algum tipo de problema na escrita das fórmulas. 
		end if;
 
		qt_macro_padrao_A_w := null;
		qt_macro_padrao_arroba_w := null;
		nm_macro_w := null;
		nm_macro_parametro_w := null;
		--Verificado se existe alguma macro não substituida, caso for verdadeiro, será buscado como atributo padrão - (Pasta atributos padrões). 
		qt_tamanho_form_w := length(ds_formula_orig_w);
		qt_macro_padrao_A_w := position('#A' in ds_formula_orig_w);
		qt_macro_padrao_arroba_w := position('@' in ds_formula_orig_w);
 
		--nm_macro_padrao_w := substr(ds_formula_orig_w,qt_macro_padrao_A_w + 3, qt_tamanho_form_w); 
		if (position('@' in ds_formula_orig_w) > 0) then 
 
			qt_macro_padrao_arroba_w := position('@' in ds_formula_orig_w);
			nm_macro_parametro_w := substr(ds_formula_orig_w,qt_macro_padrao_A_w+3, qt_macro_padrao_arroba_w - qt_macro_padrao_A_w - 3);
			nm_macro_w := substr(ds_formula_orig_w,qt_macro_padrao_A_w, qt_macro_padrao_arroba_w - qt_macro_padrao_A_w + 1);
 
		end if;
 
		open C03;
		loop 
		fetch C03 into 
			cd_dominio_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
 
 
			if (cd_dominio_w = nm_macro_parametro_w) then 
				ds_atrib_padrao_w := obter_dados_pcs(cd_empresa_p,null,nr_Seq_segmento_p,cd_material_p,2,cd_estabelecimento_p,nm_macro_parametro_w);
 
			ds_formula_orig_w := replace(ds_formula_orig_w, nm_macro_w, replace(to_char(ds_atrib_padrao_w),',','.'));
 
			end if;
 
			end;
		end loop;
		close C03;
 
		end;
	end loop;
 
		qt_tamanho_form_w	:= null;
		qt_macro_padrao_F_w := null;
		qt_macro_padrao_arroba_w := null;
 
		--Verificado se existe alguma macro não substituida, caso for verdadeiro, será buscado como atributo padrão - (Pasta atributos padrões). 
		qt_tamanho_form_w	:= length(ds_formula_orig_w);
		qt_macro_padrao_F_w := position('#F' in ds_formula_orig_w);
 
		if (qt_macro_padrao_F_w > 0) then 
 
			qt_macro_padrao_arroba_w := position('@' in substr(ds_formula_orig_w, qt_macro_padrao_F_w,qt_tamanho_form_w));
 
			--nm_macro_parametro_w := substr(ds_formula_orig_w,qt_macro_padrao_F_w+3, qt_macro_padrao_arroba_w - qt_macro_padrao_F_w - 3); 
			nm_macro_parametro_w := substr(ds_formula_orig_w,qt_macro_padrao_F_w + 1, qt_macro_padrao_arroba_w);
			nm_macro_w := substr(ds_formula_orig_w,qt_macro_padrao_F_w, qt_macro_padrao_arroba_w - qt_macro_padrao_F_w + 1);
 
			commit;
 
			CALL pcs_sup_gerar_planej_pck.pcs_gerar_vl_formula(nm_macro_parametro_w, 
								 cd_material_p, 
								 nr_seq_grupamento_p, 
								 nr_Seq_segmento_p, 
								 cd_local_Estoque_p, 
								 cd_empresa_p, 
								 cd_estabelecimento_p, 
								 nm_usuario_p); -- CHAMADA RECURSIVA 
		end if;
 
	/* Caso identifique a palavra "SE", compreende que é uma fórmula com condição lógica */
 
	/* e executa a rotina para validar se a condição é verdadeira */
 
 
	--if (instr(ds_formula_orig_w,'#') = 0) then 
 
		if (substr(ds_formula_orig_w,1,2) = 'SE') then 
			begin 
			ie_cond_verdadeira_w	:= 'N';
 
			/* Enquanto a condição não for verdadeira, continua testando */
 
			while(ie_cond_verdadeira_w <> 'S') loop 
				begin 
 
				/* Desmonta a condição para executar a rotina de validação */
 
				ds_formula_orig_w	:= substr(ds_formula_orig_w,4,length(ds_formula_orig_w)); --vai cortar a formula depouis do 'SE' 
				tam_formula_w		:= length(ds_formula_orig_w); --vai pegar o tamanho depois de cortado a fórmula 
				ie_pos_separador_w	:= position('ENTAO' in ds_formula_orig_w); --identifica a posição do entao 
 
				/* Joga a condição para a variavel ds_informacao_w e o restante da fórmula para a ds_formula_w */
				ds_informacao_w		:= substr(ds_formula_orig_w,1,(ie_pos_separador_w - 1)); -- só irá pegar a condicao 'SE' sem o 'ENTAO'  ex (1 = 1) 
				if position('ENTAO' in ds_formula_orig_w) > 0 then 
					ds_formula_orig_w	:= substr(ds_formula_orig_w,(ie_pos_separador_w + 5),tam_formula_w); --Pega depois do entao o resto da fórmula 
				else
					ds_formula_orig_w	:= substr(ds_formula_orig_w,(ie_pos_separador_w + 2),tam_formula_w); --Pega depois do entao o resto da fórmula 
				end if;
 
				ie_cond_verdadeira_w := pcs_sup_gerar_planej_pck.obter_se_condicao_verdadeira(ds_informacao_w, ie_cond_verdadeira_w, nm_usuario_p);
 
				/* Caso a condição não seja verdadeira, verifica se existem outras opções */
 
				/* Se existir, apaga a parte da fórmula (na variavel) que estava dentro da condição falsa, e continua adiante */
 
				/* Caso não houver novas condições, retorna 0 */
 
				if (ie_cond_verdadeira_w = 'N') then 
					begin 
 
					tam_formula_w			:= length(ds_formula_orig_w);
					ie_pos_separador_w		:= position('SE' in ds_formula_orig_w);
 
					/* Para retornar zero na fórmula, pois nenhuma condição foi válida (ao acabar as opções)*/
 
					if (ie_pos_separador_w = 0) then 
						ds_formula_orig_w    := '';
						ds_formula_w		:= '0';
						ie_cond_verdadeira_w	:= 'S';
					else 
						ds_formula_orig_w		:= substr(ds_formula_orig_w,ie_pos_separador_w,tam_formula_w);
					end if;
 
					end;
				/* Se a condição for verdadeira, busca a parte da fórmula referente a esta condição, apagando todo o resto (da variavel) */
 
				else 
					begin 
 
					ie_pos_separador_w	:= position('SE' in ds_formula_w);
 
					if (ie_pos_separador_w > 0) then 
						ds_formula_orig_w	:= substr(ds_formula_orig_w,1,(ie_pos_separador_w - 1));
					end if;
 
					ds_formula_orig_w		:= trim(both ds_formula_orig_w);
					end;
				end if;
 
				end;
			end loop;
 
			end;
		end if;
 
--preciso arranjar uma forma de verificar aqui, se existe outro se 
 
/*if (cd_material_p = 44) and 
	  (ds_macro_w = 'PCS_TESTE') then 
			insert into mhbarth3 ( 
				ds 
				) 
			values(	'cd_material_p712= ' || cd_material_p || 
				'nm_macro_w = ' || nm_macro_w || 
				'ds_atrib_padrao_w = ' || ds_atrib_padrao_w || 
				'nm_macro_parametro_w = ' || nm_macro_parametro_w || 
			'ds_macro_w = ' || ds_macro_w || 
			'ds_formula_orig_w = ' || ds_formula_orig_w); 
			commit; 
		end if;			*/
 
 
		if (ds_formula_orig_w IS NOT NULL AND ds_formula_orig_w::text <> '') then 
			begin 
			begin 
			--SE ( 1 = 1 ) ENTAO 2 * 2   o ds_formula_orig_w fica desta maneira 
			qt_condicao_se_w := position('SE' in ds_formula_orig_w);
 
			if (qt_condicao_se_w > 0) then 
				ds_formula_orig_w := substr(ds_formula_orig_w,1,qt_condicao_se_w - 2);
			end if;
 
			ds_sql_w := 'select ' || trim(both ds_formula_orig_w) || ' from dual';
 
			c001	:= dbms_sql.open_cursor;
			dbms_sql.parse(c001,ds_sql_w,dbms_sql.native);
			dbms_sql.define_column(c001, 1, vl_coluna_w, 17);
			ds_resultado_w	:= dbms_sql.execute(c001);
			ds_resultado_w	:= dbms_sql.fetch_rows(c001);
			dbms_sql.column_value(c001,1,vl_coluna_w);
			dbms_sql.close_cursor(c001);
 
			ds_resultado_w := coalesce(vl_coluna_w,0);
 
			ds_macro_w := '#F_'||ds_macro_w||'@';
			exception 
				when others then 
				begin 
				ds_resultado_w := null;
				ds_macro_w := '#E_'|| ds_macro_w ||'@';
				end;
			end;
 
			insert into w_pcs_atributo_formula( 
						ds_macro, 
						ds_resultado, 
						nr_seq_formula, 
						ds_sql, 
						cd_material, 
						nm_usuario) 
			values (	ds_macro_w, 
						ds_resultado_w, 
						nr_sequencia_w, 
						ds_sql_w, 
						cd_material_p, 
						nm_usuario_p);
 
			end;
		end if;
	end;
 
end loop;
close c01;
 
commit;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_sup_gerar_planej_pck.pcs_gerar_vl_formula (( ds_macro_p text default null, cd_material_p bigint, nr_seq_grupamento_p bigint, nr_Seq_segmento_p bigint, cd_local_estoque_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) is  nr_sequencia_w bigint) FROM PUBLIC;
