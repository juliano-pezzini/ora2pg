-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ajusta_relatorio_swing_pck.verificar (nr_sequencia_p bigint , ie_opcao_p text,ie_classif_relat_p text) AS $body$
DECLARE

	_ora2pg_r RECORD;
qt_var_estilo_w bigint;
	ds_campos_relat_w dbms_sql.desc_tab;
	ds_campos_banda_relat_w dbms_sql.desc_tab;
	ds_campos_banda_relat_campo_w dbms_sql.desc_tab;
	ds_campos_sql_banda_w	 dbms_sql.desc_tab;
	col_cnt_relat_w integer;
	col_cnt_banda_relat_w integer;
	col_cnt_banda_relat_campo_w integer;
	qt_soma_tamanho_campo_w  integer;
	qt_soma_altura_campo_w   integer;
	ar_nm_param_sql_w	myArray;
	pos_do_alias_w  	integer;
	pos_ini_linha_w		integer;
	ds_linha_do_alias_w	varchar(2000);
	cursor_sql_banda_w	integer;
	index_coluna_w 		bigint;
	col_cnt_w		bigint;
	ds_erro_w		varchar(4000);
	ie_executou_sql_banda_w	varchar(1);
	qt_razao_campo_w	bigint;

	nr_sequencia_w 	relatorio.nr_sequencia%type;
	ie_tipo_papel_w relatorio.ie_tipo_papel%type;
	ie_orientacao_w relatorio.ie_orientacao%type;
	qt_altura_w		relatorio.qt_altura%type;
	qt_margem_sup_w	relatorio.qt_margem_sup%type;
	qt_margem_inf_w	relatorio.qt_margem_inf%type;
	ds_sql_w		relatorio.ds_sql%type;
		cd_classif_relat_w relatorio.cd_classif_relat%type;


	
BEGIN
		PERFORM set_config('ajusta_relatorio_swing_pck.ie_classif_relat_w', substr(ie_classif_relat_p,1,1), false);
		CALL exec_sql_dinamico('Tasy','truncate table log_erro_relatorio');
		PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_relatorio_w', nr_sequencia_p, false);
		if current_setting('ajusta_relatorio_swing_pck.c01')::CURSOR%ISOPEN then
      Close current_setting('ajusta_relatorio_swing_pck.c01')::CURSOR;
    end if;
    open current_setting('ajusta_relatorio_swing_pck.c01')::CURSOR;
		loop
		fetch current_setting('ajusta_relatorio_swing_pck.c01')::into CURSOR
			--relatorio_w
			nr_sequencia_w,
			ie_tipo_papel_w,
			ie_orientacao_w ,
			qt_altura_w		,
			qt_margem_sup_w	,
			qt_margem_inf_w	,
			--ds_sql_w		,
			cd_classif_relat_w;
		EXIT WHEN NOT FOUND; /* apply on current_setting('ajusta_relatorio_swing_pck.c01')::CURSOR */

			if (length(cd_classif_relat_w) < 4) then
				CALL ajusta_relatorio_swing_pck.grava_erro('A junção da classificação do relatório + o código, devem obrigatoriamente totalizar 9 ou mais dígitos', 'S');
			end if;

			PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_relatorio_w', nr_sequencia_w, false);
			PERFORM set_config('ajusta_relatorio_swing_pck.qt_altura_papel_w', ajusta_relatorio_swing_pck.obter_altura_pagina(ie_tipo_papel_w, ie_orientacao_w, qt_altura_w) - floor((qt_margem_sup_w + qt_margem_inf_w) * 2.83), false);
			PERFORM set_config('ajusta_relatorio_swing_pck.qt_altura_bandas_padrao_w', ajusta_relatorio_swing_pck.obter_altura_bandas_padrao(current_setting('ajusta_relatorio_swing_pck.nr_seq_relatorio_w')::bigint), false);  --bandas cabeçalho e rodapé + suas respectivas filhas
			ds_campos_relat_w := current_setting('ajusta_relatorio_swing_pck.campos_vazio_w')::dbms_sql.desc_tab;

		 if ( ie_opcao_p in ('A','S')) then
				SELECT * FROM ajusta_relatorio_swing_pck.verifica_sql(ds_sql_w, ds_campos_relat_w, col_cnt_relat_w) INTO STRICT _ora2pg_r;
 ds_campos_relat_w := _ora2pg_r.ds_campos_p; col_cnt_relat_w := _ora2pg_r.col_cnt_p;
			end if;

			if	((ie_tipo_papel_w = 'Custom') and (coalesce(qt_altura_w::text, '') = '' or coalesce(qt_altura_w::text, '') = '')) then
				CALL ajusta_relatorio_swing_pck.grava_erro('Os relatórios com tipo de papel "Customizado" devem ter altura e largura de papel informados.', 'S');
			end if;

		if current_setting('ajusta_relatorio_swing_pck.c02')::CURSOR%ISOPEN then
      Close current_setting('ajusta_relatorio_swing_pck.c02')::CURSOR;
    end if;
			open current_setting('ajusta_relatorio_swing_pck.c02')::CURSOR;
			loop
			fetch current_setting('ajusta_relatorio_swing_pck.c02')::into CURSOR
				current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype;
			EXIT WHEN NOT FOUND; /* apply on current_setting('ajusta_relatorio_swing_pck.c02')::CURSOR */
				begin
					ie_executou_sql_banda_w	:= 'N';
					PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_banda_w', current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.nr_sequencia, false);
					PERFORM set_config('ajusta_relatorio_swing_pck.qt_soma_altura_bandas_w', current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.qt_altura + ajusta_relatorio_swing_pck.obter_altura_bandas_filhas(current_setting('ajusta_relatorio_swing_pck.nr_seq_relatorio_w')::bigint, current_setting('ajusta_relatorio_swing_pck.nr_seq_banda_w')::bigint) + current_setting('ajusta_relatorio_swing_pck.qt_altura_bandas_padrao_w')::bigint, false);
					qt_soma_tamanho_campo_w := 0;
					qt_soma_altura_campo_w  := 0;
					PERFORM set_config('ajusta_relatorio_swing_pck.ds_expressao_w', current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_expressao, false);

					if (current_setting('ajusta_relatorio_swing_pck.ds_expressao_w')::(varchar(255) IS NOT NULL AND (varchar(255))::text <> '')) and (current_setting('ajusta_relatorio_swing_pck.ds_expressao_w')::varchar(255) = 'LINK') then
						begin
						CALL ajusta_relatorio_swing_pck.grava_erro('A expressão Link não deve ser utilizada! em vez disso colocar todos os campos na mesma banda.', 'N');
						end;
					end if;

					if (floor(current_setting('ajusta_relatorio_swing_pck.qt_soma_altura_bandas_w')::bigint * 0.75) > current_setting('ajusta_relatorio_swing_pck.qt_altura_papel_w')::bigint) then
						CALL ajusta_relatorio_swing_pck.grava_erro('A altura da banda ultrapassou a altura do papel', 'S');
					end if;
					ds_campos_banda_relat_w := current_setting('ajusta_relatorio_swing_pck.campos_vazio_w')::dbms_sql.desc_tab;
					if ( ie_opcao_p in ('A','S')) then
						SELECT * FROM ajusta_relatorio_swing_pck.verifica_sql(REPLACE(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql, '@SQL_WHERE', ''), ds_campos_banda_relat_w, col_cnt_banda_relat_w) INTO STRICT _ora2pg_r;
 ds_campos_banda_relat_w := _ora2pg_r.ds_campos_p; col_cnt_banda_relat_w := _ora2pg_r.col_cnt_p;
						ar_nm_param_sql_w := ajusta_relatorio_swing_pck.armazena_parametros_sql(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql, ar_nm_param_sql_w);
					end if;

          		if current_setting('ajusta_relatorio_swing_pck.c03')::CURSOR%ISOPEN then
      Close current_setting('ajusta_relatorio_swing_pck.c03')::CURSOR;
    end if;
          open current_setting('ajusta_relatorio_swing_pck.c03')::CURSOR;
					loop
					fetch current_setting('ajusta_relatorio_swing_pck.c03')::into CURSOR
						current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype;
					EXIT WHEN NOT FOUND; /* apply on current_setting('ajusta_relatorio_swing_pck.c03')::CURSOR */
						begin
							PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_campo_w', current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.nr_sequencia, false);


							--Barras
							if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.IE_TIPO_CAMPO = 2) then
								if (coalesce(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.QT_TAMANHO, 0) < 20) then
									CALL ajusta_relatorio_swing_pck.grava_erro('Verifique as dimensões do campo BARRAS pois a largura deve ser superior a 20 caso contrario o campo não será apresentado', 'S');
								end if;
							end if;
							if ( current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%(rowtype.ds_sql IS NOT NULL AND rowtype.ds_sql::text <> '')) and ( current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%coalesce(rowtype.DS_MASCARA::text, '') = '') and ( ar_nm_param_sql_w.count > 0) then

								pos_do_alias_w  := position(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO in upper(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql));
								pos_ini_linha_w := instr(substr(upper(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql), 1, pos_do_alias_w), chr(10), -1);
								ds_linha_do_alias_w := upper(substr(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql, pos_ini_linha_w, (pos_do_alias_w - pos_ini_linha_w)));

								for i in 1..ar_nm_param_sql_w.count loop
									if ( substr(ar_nm_param_sql_w[i].nm,1,3) = 'DT_') and ( position(':'||ar_nm_param_sql_w[i].nm in ds_linha_do_alias_w) > 0 ) and ( position('TO_CHAR(:'||ar_nm_param_sql_w[i].nm in ds_linha_do_alias_w) = 0 )then
											CALL ajusta_relatorio_swing_pck.grava_erro('Informar a mascara de data para o campo bind', 'N');
									end if;
								end loop;

							end if;

							if (current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%(rowtype.ds_sql IS NOT NULL AND rowtype.ds_sql::text <> '')) and ( col_cnt_banda_relat_w > 0) then
								for i in 1 .. col_cnt_banda_relat_w loop

									/*Data*/

									if ( ds_campos_banda_relat_w[i].col_type = 12 ) and ( ds_campos_banda_relat_w[i].col_name = current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO) and ( current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%coalesce(rowtype.DS_MASCARA::text, '') = '') then
										CALL ajusta_relatorio_swing_pck.grava_erro('Informar a mascara de data para o campo', 'N');
									/*Campo DATA passado como parâmetro sem TO_CHAR ou mascara*/

									elsif ( ds_campos_banda_relat_w[i].col_type = 1) and ( substr(ds_campos_banda_relat_w[i].col_name,1,3) = 'DT_') and ( ds_campos_banda_relat_w[i].col_name = current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO) and ( current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%coalesce(rowtype.DS_MASCARA::text, '') = '') and ( position(':'||current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO in upper(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql)) > 0 ) and ( position('TO_CHAR(:'||current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO in upper(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql)) = 0 )then
												CALL ajusta_relatorio_swing_pck.grava_erro('Informar a mascara de data para o campo', 'N');

									end if;

									if ('S' = current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.IE_AJUSTAR_TAMANHO) then
										begin
										if (coalesce(ie_executou_sql_banda_w, 'N') = 'N') then
											SELECT * FROM ajusta_relatorio_swing_pck.verifica_sql(REPLACE(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ds_sql, '@SQL_WHERE', ''), ds_campos_sql_banda_w, col_cnt_w) INTO STRICT _ora2pg_r;
 ds_campos_sql_banda_w := _ora2pg_r.ds_campos_p; col_cnt_w := _ora2pg_r.col_cnt_p;
											/*Executar o sql da banda somente uma vez, visto que itera sobre todos os campos*/

											ie_executou_sql_banda_w := 'S';
										end if;
										index_coluna_w := 0;
										for i in 1 .. col_cnt_w loop
											index_coluna_w := index_coluna_w + 1;
											exit when upper(ds_campos_sql_banda_w[index_coluna_w].col_name) = upper(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO);
										end loop;

										/*8 - razao media em pixels do gerenciador de relatorios para Strings*/

										qt_razao_campo_w	:= 8;
										if (ds_campos_banda_relat_w[i].col_type = 1) then /*Varchar*/
											qt_razao_campo_w := 8;
										elsif (ds_campos_banda_relat_w[i].col_type = 2) then /*Number*/
											/*7 - razao media em pixels do gerenciador de relatorios para Numericos*/

											qt_razao_campo_w := 7;
										elsif (ds_campos_banda_relat_w[i].col_type = 8) then /*Long*/
											if ('N' = current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.IE_ESTENDER) then
												CALL ajusta_relatorio_swing_pck.grava_erro('Para evitar problemas com cortes de conteúdo, deve-se definir o campo para estender ', 'D');
											else
												qt_razao_campo_w := 8;
											end if;
										end if;

										select	CASE WHEN coalesce(qt_razao_campo_w, 0)=0 THEN  8  ELSE qt_razao_campo_w END
										into STRICT	qt_razao_campo_w
										;

										if (index_coluna_w > 0) then
											if	(ds_campos_sql_banda_w[index_coluna_w].col_max_len > (coalesce(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.QT_TAMANHO, 0) / qt_razao_campo_w)) then
												--ajusta_relatorio_swing_pck.grava_erro('Para evitar problemas de sobreposição de campos, deve-se definir um tamanho preciso para o campo ' || ds_campos_sql_banda_w(index_coluna_w).col_name, 'D');
												CALL ajusta_relatorio_swing_pck.grava_erro('Para evitar problemas de sobreposição de campos, deve-se definir um tamanho preciso para o campo ', 'D');
											end if;
										end if;
										end;
									end if;

								end loop;
							end if;

							if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_estilo_fonte IS NOT NULL AND rowtype.ds_estilo_fonte::text <> '')) then
								qt_var_estilo_w := 1;
							else
								qt_var_estilo_w := 0;
							end if;

							if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_sql IS NOT NULL AND rowtype.ds_sql::text <> '') ) and (ie_opcao_p in ('A','S')) then

								ar_nm_param_sql_w := ajusta_relatorio_swing_pck.armazena_parametros_sql(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql, ar_nm_param_sql_w);

								if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_sql IS NOT NULL AND rowtype.ds_sql::text <> '')) and (ar_nm_param_sql_w.count > 0) and (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%coalesce(rowtype.DS_MASCARA::text, '') = '') then

									pos_do_alias_w  := position(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO in upper(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql));
									pos_ini_linha_w := instr(substr(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql, 1, pos_do_alias_w), chr(10), -1);
									ds_linha_do_alias_w := upper(substr(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql, pos_ini_linha_w, (pos_do_alias_w - pos_ini_linha_w)));


									for i in 1..ar_nm_param_sql_w.count loop
										if ( substr(ar_nm_param_sql_w[i].nm,1,3) = 'DT_') and ( position(':'||ar_nm_param_sql_w[i].nm in ds_linha_do_alias_w) > 0 ) and ( position('TO_CHAR(:'||ar_nm_param_sql_w[i].nm in ds_linha_do_alias_w) = 0 )then
												CALL ajusta_relatorio_swing_pck.grava_erro('Informar a mascara de data para o campo bind', 'N');
										end if;
									end loop;

								end if;


								SELECT * FROM ajusta_relatorio_swing_pck.verifica_sql(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql, ds_campos_banda_relat_campo_w, col_cnt_banda_relat_campo_w) INTO STRICT _ora2pg_r;
 ds_campos_banda_relat_campo_w := _ora2pg_r.ds_campos_p; col_cnt_banda_relat_campo_w := _ora2pg_r.col_cnt_p;
								if (col_cnt_banda_relat_campo_w > 0) then
									for i in 1 .. col_cnt_banda_relat_campo_w loop
										/*DATA*/

										if ( ds_campos_banda_relat_campo_w[i].col_type = 12 ) and ( ds_campos_banda_relat_campo_w[i].col_name = current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO) and (  current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%coalesce(rowtype.DS_MASCARA::text, '') = '') then
											CALL ajusta_relatorio_swing_pck.grava_erro('Informar a mascara de data para o campo', 'N');
										/*Campo DATA passado como parâmetro sem TO_CHAR ou mascara*/

										elsif ( ds_campos_banda_relat_campo_w[i].col_type = 1) and ( substr(ds_campos_banda_relat_campo_w[i].col_name,1,3) = 'DT_') and ( ds_campos_banda_relat_campo_w[i].col_name = current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO) and ( current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%coalesce(rowtype.DS_MASCARA::text, '') = '') and ( position(':'||current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO in upper(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql)) > 0 ) and ( position('TO_CHAR(:'||current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.NM_ATRIBUTO in upper(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_sql)) = 0 )then
													CALL ajusta_relatorio_swing_pck.grava_erro('Informar a mascara de data para o campo', 'N');
										end if;

									end loop;
								end if;
								ds_campos_banda_relat_campo_w := current_setting('ajusta_relatorio_swing_pck.campos_vazio_w')::dbms_sql.desc_tab;
							end if;

							if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_mascara IS NOT NULL AND rowtype.ds_mascara::text <> '')) and ( position(';;' in current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_mascara) > 0)then
								CALL ajusta_relatorio_swing_pck.grava_erro('O formato da máscara é inválido', 'S');
							end if;

							if ( ie_opcao_p in ( 'V','A')) then

								if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_altura+current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_topo > current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.qt_altura) then
									if (current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.qt_altura = 17 and current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_altura = 17 and current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_topo  = 1) then
										--A situação acima já foi tratada no gerenciador porque a maioria dos relatórios possui a mesma
										qt_var_estilo_w := qt_var_estilo_w;
									else
										CALL ajusta_relatorio_swing_pck.grava_erro('A altura do campo + topo não pode ser superior ao tamanho da banda', 'N');
									end if;
								end if;

								if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_tam_fonte+qt_var_estilo_w > floor(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_altura *.75) ) then
									if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ie_estender = 'S') then
										if (floor(current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_topo*.75) + (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_tam_fonte+qt_var_estilo_w) > floor(current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.qt_altura*.75)) then
											if (qt_var_estilo_w > 0 ) then
												CALL ajusta_relatorio_swing_pck.grava_erro('O topo do campo + tamanho de fonte + estilo é superior ao tamanho da banda', 'N');
											else
												CALL ajusta_relatorio_swing_pck.grava_erro('O topo do campo + tamanho da fonte é superior a altura da banda', 'N');
											end if;
										end if;
									else
										if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_estilo_fonte IS NOT NULL AND rowtype.ds_estilo_fonte::text <> '')) then
											CALL ajusta_relatorio_swing_pck.grava_erro('A altura do campo não suporta a configuração de fonte + estilo', 'N');
										else
											CALL ajusta_relatorio_swing_pck.grava_erro('A altura do campo não suporta o tamanho da fonte', 'N');
										end if;
									end if;
								end if;

								if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_label IS NOT NULL AND rowtype.ds_label::text <> '')) and (position(chr(38) in current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.ds_label) > 0)then
									CALL ajusta_relatorio_swing_pck.grava_erro('Não é recomendada a utilização do caracter especial "'|| chr(38) ||'" no atributo Label, pois ele pode vir a ocasionar problemas de execução', 'D');
								end if;

								if (current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ie_tipo_banda not in ('S','D')) then
									if (current_setting('ajusta_relatorio_swing_pck.banda_relatorio_w')::banda_relatorio%rowtype.ie_tipo_banda = 'F') and (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_label IS NOT NULL AND rowtype.ds_label::text <> '')) then
										CALL ajusta_relatorio_swing_pck.grava_erro('Substituir o label do campo da banda filha, por um campo do tipo conteúdo ', 'N');
									end if;

									if (qt_soma_tamanho_campo_w > 0 and
										current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_esquerda < qt_soma_tamanho_campo_w and
										current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_topo < qt_soma_altura_campo_w) then
										CALL ajusta_relatorio_swing_pck.grava_erro('Alguns campos podem estar sobrepostos (verificar campos com label)', 'D');
									end if;

									if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%(rowtype.ds_label IS NOT NULL AND rowtype.ds_label::text <> '')) then
										qt_soma_tamanho_campo_w := current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_esquerda + current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_tamanho + 10;
										qt_soma_altura_campo_w  := current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_topo + current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_altura + 1;
									end if;
								end if;

							end if;

							if (current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_tam_fonte <= 0) then

								CALL ajusta_relatorio_swing_pck.grava_erro('Campo está com o tamanho da fonte menor ou igual a zero.', 'N');

							elsif	((current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_altura / current_setting('ajusta_relatorio_swing_pck.banda_relat_campo_w')::banda_relat_campo%rowtype.qt_tam_fonte) <= 1.5) then

								CALL ajusta_relatorio_swing_pck.grava_erro('Alguns campos estão com o tamanho da fonte maior que o suportado pela altura do campo(verificar relação altura x tamanho fonte)', 'N');

							end if;
						end;
					end loop;
					close current_setting('ajusta_relatorio_swing_pck.c03')::CURSOR;
					PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_campo_w', null, false);
				end;
			end loop;
			close current_setting('ajusta_relatorio_swing_pck.c02')::CURSOR;
			PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_banda_w', null, false);
			commit;

			if current_setting('ajusta_relatorio_swing_pck.c04')::CURSOR%ISOPEN then
				Close current_setting('ajusta_relatorio_swing_pck.c04')::CURSOR;
			end if;
			open current_setting('ajusta_relatorio_swing_pck.c04')::CURSOR;
			loop
			fetch current_setting('ajusta_relatorio_swing_pck.c04')::into CURSOR
				current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype;
			EXIT WHEN NOT FOUND; /* apply on current_setting('ajusta_relatorio_swing_pck.c04')::CURSOR */
				begin
				PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_parametro_w', current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.nr_sequencia, false);
				if (current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.IE_FORMA_PASSAGEM = 'W') then
					begin
					if (current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'CD_ESTABELECIMENTO' or
						current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'NM_USUARIO' or
						current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'CD_PERFIL' or
						current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'CD_EMPRESA' or
						current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'CD_EMPRESA_COR' or
						current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'ESTABELECIMENTO_LOGO' or
						current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro = 'NM_ESTABELECIMENTO_LOGO') then
					   begin
							CALL ajusta_relatorio_swing_pck.grava_erro('Encontrado parâmetro multiseleção de parametro padrão do sistema. '|| chr(13) || chr(10) ||
										'Alterar para o nome no plural, caso contrário o parametro nao será utilizado'|| chr(13) || chr(10) ||
										'Exemplo: CD_ESTABELECIMENTOS, NM_USUARIOS, CD_PERFIS, CD_EMPRESAS, etc.', 'S');
					   end;
					end if;
					end;
				end if;
				if (length(trim(both current_setting('ajusta_relatorio_swing_pck.relatorio_parametro_w')::relatorio_parametro%rowtype.cd_parametro)) is null) then
					CALL ajusta_relatorio_swing_pck.grava_erro('Parâmetro com nome vazio ou inválido', 'S');
				end if;

				end;
			end loop;
			close current_setting('ajusta_relatorio_swing_pck.c04')::CURSOR;
			PERFORM set_config('ajusta_relatorio_swing_pck.nr_seq_parametro_w', null, false);
		end loop;
		close current_setting('ajusta_relatorio_swing_pck.c01')::CURSOR;
		ds_campos_relat_w := current_setting('ajusta_relatorio_swing_pck.campos_vazio_w')::dbms_sql.desc_tab;
		ds_campos_banda_relat_w := current_setting('ajusta_relatorio_swing_pck.campos_vazio_w')::dbms_sql.desc_tab;
		ds_campos_banda_relat_campo_w := current_setting('ajusta_relatorio_swing_pck.campos_vazio_w')::dbms_sql.desc_tab;
		if (current_setting('ajusta_relatorio_swing_pck.cursor_w')::(integer IS NOT NULL AND integer::text <> '') ) then
			DBMS_SQL.CLOSE_CURSOR(current_setting('ajusta_relatorio_swing_pck.cursor_w')::integer);
		end if;

	end;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE ajusta_relatorio_swing_pck.verificar (nr_sequencia_p bigint , ie_opcao_p text,ie_classif_relat_p text) FROM PUBLIC;
