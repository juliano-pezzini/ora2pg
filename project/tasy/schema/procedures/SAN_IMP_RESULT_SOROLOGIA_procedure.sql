-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_imp_result_sorologia ( nr_seq_exame_lote_p bigint, nr_seq_doacao_p bigint, dt_liberacao_p timestamp,--data/hora do resultado do item Identificacao do arquivo
 ie_rotina_p bigint,--rotina do item Identificacao do arquivo
 ds_lote_kit_p text, --Lote do kit usado no teste do item Lotes dos kits
 nr_seq_placa_p bigint,--Placa de teste da amostra do Identificacao das amostras
 nr_seq_amostra_p bigint,--Numero sequencial da amostra na rotina  do item Identificacao das amostras
 nr_densidade_otica_p text,--do item Identificacao das amostras
 nr_cutoff_p text,--do item Identificacao das amostras
 nr_tipo_exame_p bigint,--tipo exame do item Identificacao das amostras
 nr_resultado_p bigint,--resultado do item Identificacao das amostras/absorvencia
 qt_valor_cn_p bigint,--resultado do valor de controle negativo (EIE) 
 qt_valor_cp_p bigint,--resultado do valor de controle positivo (EIE) 					
 dt_vencimento_lote_p timestamp,--data de vencimento do lote
 cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_resultado_w		varchar(255) := '';
nr_seq_lote_w		bigint;
cd_pf_lote_w		varchar(10);
nr_amostra_lote_w	bigint;
nr_seq_doacao_lote_w	bigint;
ds_tam_result_exist_w	bigint;
nr_seq_lote_dif_w	bigint;
nr_seq_lote_vago_w	bigint;
nr_seq_exame_w		bigint;
ds_abs_w		varchar(255) := '';
nr_Seq_kit_w		bigint;
nr_densidade_otica_w	double precision;


BEGIN

/*log 9004 - etapas
    log 9005 - confirmacao
    log 9006 - exception*/
CALL gravar_log_tasy(9004,wheb_mensagem_pck.get_texto(309632,'NR_TIPO_EXAME_P='||nr_tipo_exame_p||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p),nm_usuario_p);
					-- Importacao sorologia - Etapa 1 - Sequencia exame: #@NR_TIPO_EXAME_P#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@
if (nr_seq_exame_lote_p IS NOT NULL AND nr_seq_exame_lote_p::text <> '') and (nr_tipo_exame_p IS NOT NULL AND nr_tipo_exame_p::text <> '') then
	
	CALL gravar_log_tasy(9004,wheb_mensagem_pck.get_texto(309635,'NR_TIPO_EXAME_P='||nr_tipo_exame_p||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p),nm_usuario_p);
						-- Importacao sorologia - Etapa 2 - Sequencia exame: #@NR_TIPO_EXAME_P#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@
	
	if (nr_resultado_p = 1) then
		ds_resultado_w := wheb_mensagem_pck.get_texto(309101); -- Nao reagente
		ds_abs_w := 'NR';
	elsif (nr_resultado_p = 3) then
		ds_resultado_w := wheb_mensagem_pck.get_texto(309637); -- Andamento
		ds_abs_w  := 'AN';
	elsif (nr_tipo_exame_p = 8) and (nr_resultado_p = 2) then
		ds_resultado_w := wheb_mensagem_pck.get_texto(309098); -- Reagente
		ds_abs_w  := 'R';
	else
		CALL gravar_log_tasy(9005,wheb_mensagem_pck.get_texto(309640,'NR_TIPO_EXAME_P='||nr_tipo_exame_p||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p||';NR_RESULTADO_P='||nr_resultado_p),nm_usuario_p);
							-- Importacao sorologia - Exame nao importado por problemas no resultado/Resultado ABS - Sequencia exame: #@NR_TIPO_EXAME_P#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@ nr_resultado_p: #@NR_RESULTADO_P#@
	end if;
	
	/*converter codigo do exame do arquivo para o codigo do exame no tasy atraves do codigo externo do cadastro do mesmo*/

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_exame_w
	from 	san_exame
	where	cd_codigo_externo = nr_tipo_exame_p
	and	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;
	
	if (nr_seq_exame_w > 0) then
	
		select	coalesce(max(length(ds_resultado)),0)
		into STRICT	ds_tam_result_exist_w
		from 	san_exame_realizado
		where 	nr_seq_exame_lote = nr_seq_exame_lote_p
		and	nr_seq_exame = nr_seq_exame_w;
		
		CALL gravar_log_tasy(9004,wheb_mensagem_pck.get_texto(309642,'NR_SEQ_EXAME_W='||nr_seq_exame_w||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p||';DS_RESULTADO_W='||ds_resultado_w||';DS_TAM_RESULTADO_W='||length(ds_resultado_w)||';DS_TAM_RESULT_EXIST_W='||ds_tam_result_exist_w),nm_usuario_p);
							-- Importacao sorologia - Etapa 3 - Seq exame_w: #@NR_SEQ_EXAME_W#@ Seq lote: #@NR_SEQ_EXAME_LOTE_P#@ Resultado: #@DS_RESULTADO_W#@ Tam. result: #@DS_TAM_RESULTADO_W#@ Tam.res.ex: #@DS_TAM_RESULT_EXIST_W#@.
		if (length(ds_resultado_w) > 0) then --and (ds_tam_result_exist_w = 0) then
			begin

			select	max(nr_sequencia)
			into STRICT 	nr_Seq_kit_w
			from	san_kit_exame
			where	nr_Seq_exame = nr_Seq_Exame_w
			and	ds_lote_kit = ds_lote_kit_p
			and	clock_timestamp() between dt_vigencia_ini and dt_vigencia_final
      and ie_exame_interno = 'N';
			
			nr_densidade_otica_w := obter_valor_dinamico('select ' || nr_densidade_otica_p || ' from dual', nr_densidade_otica_w);
			if (position('/' in nr_densidade_otica_p) = 0) then -- Verificado se o valor da densidade esta em fracao. Se estiver, nao deve aplicar a mascara de 3 casas decimais.
				nr_densidade_otica_w := (TO_CHAR(nr_densidade_otica_w,'999999990,000'))::numeric;
			end if;
			
			update	san_exame_realizado
			set	ds_lote_kit = ds_lote_kit_p,
				nr_placa = nr_seq_placa_p,
				nr_amostra = nr_seq_amostra_p,
				nr_densidade_otica = nr_densidade_otica_w,
				nr_densidade_otica_desc = trim(both TO_CHAR(nr_densidade_otica_w,'999,999,990.000')),
				nr_cutoff = nr_cutoff_p,
				nr_cutoff_desc = trim(both TO_CHAR(nr_cutoff_p,'999,999,990.000')),
				dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p,
				dt_realizado = coalesce(dt_liberacao_p,clock_timestamp()),
				ds_resultado = ds_resultado_w,
				qt_valor_cn = qt_valor_cn_p,
				qt_valor_cp = qt_valor_cp_p,
				ds_abs = ds_abs_w,
				dt_vencimento_lote = dt_vencimento_lote_p,
				nr_kit_lote = nr_Seq_kit_w,
				ds_densidade_otica_fracao = CASE WHEN position('/' in nr_densidade_otica_p)=0 THEN null  ELSE CASE WHEN ds_resultado_w=wheb_mensagem_pck.get_texto(309098) THEN trim(both nr_densidade_otica_p)  ELSE null END  END , -- Reagente
				ie_andamento = CASE WHEN ds_resultado_w=wheb_mensagem_pck.get_texto(309637) THEN 'S'  ELSE 'N' END  -- Andamento
			where 	nr_seq_exame_lote = nr_seq_exame_lote_p
			and	nr_seq_exame = nr_seq_exame_w;
			
			commit;
			exception
			when others then
				CALL gravar_log_tasy(9006,wheb_mensagem_pck.get_texto(309653,'NR_SEQ_EXAME_W='||nr_seq_exame_w||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p||';DS_RESULTADO_W='||ds_resultado_w||';NR_DENSIDADE_OTICA_W='||nr_densidade_otica_w||';DT_VENCIMENTO_LOTE_P='||dt_vencimento_lote_p),nm_usuario_p);
									-- Importacao sorologia - Excecao1 - Sequencia exame_w: #@NR_SEQ_EXAME_W#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@ Resultado: #@DS_RESULTADO_W#@ Densidade: #@NR_DENSIDADE_OTICA_W#@ Data de vencimento:#@DT_VENCIMENTO_LOTE_P#@, #@#@
			end;
			CALL gravar_log_tasy(9005,wheb_mensagem_pck.get_texto(309667,'NR_SEQ_EXAME_W='||nr_seq_exame_w||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p||';DS_RESULTADO_W='||ds_resultado_w),nm_usuario_p);
								-- Importacao sorologia - Exame importado com sucesso - Sequencia exame_w: #@NR_SEQ_EXAME_W#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@ Resultado: #@DS_RESULTADO_W#@
		end if;
		/*elsif (ds_tam_result_exist_w > 0) then
			begin	
			select 	nvl(max(a.nr_sequencia),0)
			into	nr_seq_lote_dif_w
			from	san_exame_lote a, san_exame_realizado b
			where	a.nr_sequencia = b.nr_seq_exame_lote
			and	a.nr_seq_doacao = nr_seq_doacao_p
			and	ds_resultado is null
			and	b.nr_seq_exame = nr_seq_exame_w
			and	a.nr_sequencia <> nr_seq_exame_lote_p;
			
			if (nr_seq_lote_dif_w = 0) then
				--caso nao possua nenhuma lote com resultado a ser digitado para o exame, busca lote que nao possua o exame

				select 	nvl(max(a.nr_sequencia),0)
				into	nr_seq_lote_vago_w
				from	san_exame_lote a, san_exame_realizado b
				where	a.nr_sequencia = b.nr_seq_exame_lote
				and	a.nr_seq_doacao = nr_seq_doacao_p
				and	not exists (select 1
						    from san_exame_lote c, san_exame_realizado d
						    where c.nr_sequencia = d.nr_seq_exame_lote
						    and c.nr_sequencia = a.nr_sequencia
						    and d.nr_seq_exame = nr_seq_exame_w)
				and	a.nr_sequencia <> nr_seq_exame_lote_p;	
				
				--caso encontre lote sem o exame, insere o exame e seta variavel para fazer update na rotina posterior

				if (nr_seq_lote_vago_w <> 0) then				
					begin
					
					insert into san_exame_realizado(
							dt_atualizacao,
							nm_usuario,
							dt_realizado,
							nr_seq_exame,
							nr_seq_exame_lote,
							ds_justificativa)
					values(		sysdate,
							nm_usuario_p,
							sysdate,
							nr_seq_exame_w,
							nr_seq_lote_vago_w,
							'Exame inserido pela integracao de sorologia devido a reteste.');
							
					nr_seq_lote_dif_w := nr_seq_lote_vago_w;
					gravar_log_tasy(9005,'Importacao sorologia - Exame de reteste inserido com sucesso - Seq exame_w: '||nr_seq_exame_w||' Seq lote: '||nr_seq_lote_vago_w,nm_usuario_p);
					commit;
					exception
					when others then
						gravar_log_tasy(9006,'Importacao sorologia - Excecao2 - Seq exame_w: '||nr_seq_exame_w||' Seq lote vago: '||nr_seq_lote_vago_w||', #@#@',nm_usuario_p);
					end;
				end if;
				
			end if;
			
			gravar_log_tasy(9004,'Importacao sorologia - Etapa 4 - Seq exame_w: '||nr_seq_exame_w||' Seq outro lote: '||nr_seq_lote_dif_w||', #@#@',nm_usuario_p);
			if (nr_seq_lote_dif_w <> 0) then	
			
				select	max(nr_sequencia)
				into 	nr_Seq_kit_w
				from	san_kit_exame
				where	nr_Seq_exame = nr_Seq_Exame_w
				and	ds_lote_kit = ds_lote_kit_p
				and	sysdate between dt_vigencia_ini and dt_vigencia_final;
				
				update	san_exame_realizado
				set	ds_lote_kit = ds_lote_kit_p,
					nr_placa = nr_seq_placa_p,
					nr_amostra = nr_seq_amostra_p,
					nr_densidade_otica = nr_densidade_otica_p,
					nr_cutoff = nr_cutoff_p,
					dt_atualizacao = sysdate,
					nm_usuario = nm_usuario_p,
					dt_realizado = nvl(dt_liberacao_p,sysdate),
					ds_resultado = ds_resultado_w,
					qt_valor_cn = qt_valor_cn_p,
					qt_valor_cp = qt_valor_cp_p,
					ds_abs = ds_abs_w,
					dt_vencimento_lote = dt_vencimento_lote_p,
					nr_kit_lote = nr_Seq_kit_w
				where 	nr_seq_exame_lote = nr_seq_lote_dif_w
				and	nr_seq_exame = nr_seq_exame_w;
				
				commit;
				gravar_log_tasy(9005,'Importacao sorologia - Exame importado com sucesso em outro lote - Seq exame_w: '||nr_seq_exame_w||' Seq outro lote: '||nr_seq_lote_dif_w||' Resultado: '||ds_resultado_w||' Data de vencimento:'||dt_vencimento_lote_p,nm_usuario_p);
				
			else			
				--reteste - insere novo lote

				select 	san_exame_lote_seq.nextval
				into	nr_seq_lote_w
				from 	dual;
				
				select	max(cd_pf_realizou),
					max(nr_seq_doacao),
					max(nr_amostra)
				into	cd_pf_lote_w,
					nr_seq_doacao_lote_w,
					nr_amostra_lote_w
				from	san_exame_lote
				where	nr_sequencia = nr_seq_exame_lote_p;
				
				insert into san_exame_lote(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						ie_tipagem,
						ds_observacao,
						cd_pf_realizou,
						nr_seq_doacao,
						nr_amostra)
				values(		nr_seq_lote_w,
						sysdate,
						nm_usuario_p,
						'N',
						'Lote de reteste inserido pela importacao de resultados de sorologia',
						cd_pf_lote_w,
						nr_seq_doacao_lote_w,
						nr_amostra_lote_w);
				
				select	max(nr_sequencia)
				into 	nr_Seq_kit_w
				from	san_kit_exame
				where	nr_Seq_exame = nr_Seq_Exame_w
				and	ds_lote_kit = ds_lote_kit_p
				and	sysdate between dt_vigencia_ini and dt_vigencia_final;
				
				insert into san_exame_realizado(
						nr_seq_exame_lote,
						nr_seq_exame,
						ds_lote_kit,
						nr_placa,
						nr_amostra,
						nr_densidade_otica,
						nr_cutoff,
						dt_atualizacao,
						nm_usuario,
						dt_realizado,
						ds_resultado,
						ds_justificativa,
						qt_valor_cn,
						qt_valor_cp,
						ds_abs,
						dt_vencimento_lote,
						nr_kit_lote)
				values(		nr_seq_lote_w,
						nr_seq_exame_w,
						ds_lote_kit_p,
						nr_seq_placa_p,
						nr_seq_amostra_p,
						nr_densidade_otica_p,
						nr_cutoff_p,
						sysdate,
						nm_usuario_p,
						nvl(dt_liberacao_p,sysdate),
						ds_resultado_w,
						'Exame inserido pela importacao de sorologia devido a reteste.',
						qt_valor_cn_p,
						qt_valor_cp_p,
						ds_abs_w,
						dt_vencimento_lote_p,
						nr_Seq_kit_w
				);
				gravar_log_tasy(9004,'Importacao sorologia - Etapa 4.1 - Seq exame_w: '||nr_seq_exame_w||' Seq lote: '||nr_seq_lote_w||' Resultado: '||ds_resultado_w||' Data de vencimento:'||dt_vencimento_lote_p||', #@#@',nm_usuario_p);
			end if;
			exception
			when others then
				gravar_log_tasy(9006,'Importacao sorologia - Excecao3 - Sequencia exame_w: '||nr_seq_exame_w||' Sequencia lote: '||nr_seq_exame_lote_p||' Resultado: '||ds_resultado_w||', #@#@',nm_usuario_p);
			end;
		end if;*/
	else
		CALL gravar_log_tasy(9005,wheb_mensagem_pck.get_texto(309675,'NR_SEQ_EXAME_W='||nr_seq_exame_w||';NR_TIPO_EXAME_P='||nr_tipo_exame_p||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p),nm_usuario_p);
							-- Importacao sorologia - Exame retornado no arquivo nao possui cadastro correspondente no Tasy - Sequencia exame_w: #@NR_SEQ_EXAME_W#@ Sequencia exame arquivo: #@NR_TIPO_EXAME_P#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@
	end if;
else
	CALL gravar_log_tasy(9005,wheb_mensagem_pck.get_texto(309677,'NR_SEQ_EXAME_W='||nr_seq_exame_w||';NR_SEQ_EXAME_LOTE_P='||nr_seq_exame_lote_p),nm_usuario_p);
						-- Importacao sorologia - Exame nao importado por falta de dados - Sequencia exame_w: #@NR_SEQ_EXAME_W#@ Sequencia lote: #@NR_SEQ_EXAME_LOTE_P#@
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_imp_result_sorologia ( nr_seq_exame_lote_p bigint, nr_seq_doacao_p bigint, dt_liberacao_p timestamp, ie_rotina_p bigint, ds_lote_kit_p text, nr_seq_placa_p bigint, nr_seq_amostra_p bigint, nr_densidade_otica_p text, nr_cutoff_p text, nr_tipo_exame_p bigint, nr_resultado_p bigint, qt_valor_cn_p bigint, qt_valor_cp_p bigint, dt_vencimento_lote_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

