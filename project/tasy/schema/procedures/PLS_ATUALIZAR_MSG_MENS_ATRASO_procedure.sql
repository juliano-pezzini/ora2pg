-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_msg_mens_atraso (( nm_usuario_p text) is c01 CURSOR FOR SELECT nr_seq_evento_mens, ie_situacao_pagador, nvl(ie_tipo_alerta, 'P') ie_tipo_alerta from pls_regra_geracao_evento where ie_evento_disparo = 7 and ie_situacao = 'A') RETURNS varchar AS $body$
DECLARE


ds_retorno_w	log_envio_sms.nr_telefone%type;
				
BEGIN

ds_retorno_w	:= replace(ds_sms_dest_p,'(','');
ds_retorno_w	:= replace(ds_retorno_w,')','');
ds_retorno_w	:= replace(ds_retorno_w,'-','');

return substr(ds_retorno_w,1,20);

end;

begin

for r_C01_w in C01 loop
	
	select	max(b.nr_sequencia),
		max(a.ds_mensagem),
		max(a.ds_titulo),
		max(a.ie_tipo_envio),
		max(a.ds_remetente_email),
		max(a.ds_remetente_sms)
	into STRICT	nr_seq_tipo_evento_w,
		ds_mensagem_padrao_w,
		ds_titulo_w,
		ie_tipo_envio_w,
		ds_remetente_email_w,
		ds_remetente_sms_w
	from	pls_alerta_evento_mensagem a,
		pls_tipo_alerta_evento b
	where	a.nr_seq_tipo_evento = b.nr_sequencia
	and	a.ie_situacao = 'A'
	and	b.ie_situacao = 'A'
	and	a.nr_sequencia = r_C01_w.nr_seq_evento_mens;

	for r_C02_w in C02(r_c01_w.ie_tipo_alerta) loop

		if (r_c01_w.ie_tipo_alerta = 'P') then
			select	trunc(max(dt_pagamento_previsto)) maximo,
				trunc(min(dt_pagamento_previsto)) minimo
			into STRICT	dt_pagamento_max_w,
				dt_pagamento_min_w
			from	titulo_receber
			where	dt_pagamento_previsto < trunc(clock_timestamp())
			and	(nr_seq_mensalidade IS NOT NULL AND nr_seq_mensalidade::text <> '')
			and	coalesce(dt_liquidacao::text, '') = '';
		else	
			select	trunc(max(dt_pagamento_previsto)) maximo,
				trunc(min(dt_pagamento_previsto)) minimo
			into STRICT	dt_pagamento_max_w,
				dt_pagamento_min_w
			from	titulo_receber
			where	dt_pagamento_previsto > trunc(clock_timestamp())
			and	(nr_seq_mensalidade IS NOT NULL AND nr_seq_mensalidade::text <> '')
			and	coalesce(dt_liquidacao::text, '') = '';
		end if;

		--Loop para ir coletando os dados em atraso de 6 em 6 meses
		while(dt_pagamento_min_w < dt_pagamento_max_w) loop
			begin
			
			--Adiciona 6 meses para capturar um periodo de 6 meses de titulos em aberto
			if (trunc(add_months(dt_pagamento_min_w, 6)) < dt_pagamento_max_w) then
				dt_pagamento_6_meses_w := trunc(add_months(dt_pagamento_min_w, 6));
			else
				dt_pagamento_6_meses_w := dt_pagamento_max_w;
			end if;

			if (r_C02_w.ie_agrupar_tit_compet = 'S') then
				--Abre cursor com os titulos a receber em atraso dentro dos primeiros 6 meses
				for r_C05_w in C05(dt_pagamento_min_w, dt_pagamento_6_meses_w, r_C02_w.cd_estabelecimento, r_C02_w.qt_dias_atraso, r_C01_w.ie_situacao_pagador) loop
					begin
					select	max(c.ie_tipo_contratacao),
						max(a.nr_seq_contrato)
					into STRICT	ie_tipo_contratacao_w,
						nr_seq_contrato_w
					from	pls_contrato_pagador a,
						pls_contrato_plano b,
						pls_plano c
					where	c.nr_sequencia	= b.nr_seq_plano
					and	b.nr_seq_contrato = a.nr_seq_contrato
					and	a.nr_sequencia	= r_C05_w.nr_seq_pagador;
					
					select	count(1)
					into STRICT	qt_benef_cooperado_w
					from	pls_cooperado
					where	cd_pessoa_fisica = r_c05_w.cd_pessoa_fisica
					and	ie_status = 'A';
					
					ie_gerar_w := 'S';
					
					if (r_c02_w.ie_pagador_cooperado = 'A') or
						(r_c02_w.ie_pagador_cooperado = 'C' AND qt_benef_cooperado_w > 0) or
						(r_c02_w.ie_pagador_cooperado = 'N' AND qt_benef_cooperado_w = 0) then
						ie_gerar_w := 'S';
					else
						ie_gerar_w := 'N';
					end if;

					if	(r_C02_w.ie_tipo_contratacao = ie_tipo_contratacao_w AND ie_gerar_w = 'S') then
						--So e possivel individualizar o titular para pagadores PF, para PJ nao existe essa possibilidade
						if (r_c05_w.cd_pessoa_fisica IS NOT NULL AND r_c05_w.cd_pessoa_fisica::text <> '') then
							select	pls_obter_dados_segurado(max(nr_seq_segurado),'C')
							into STRICT	carteira_benef_titular_w
							from	pls_mensalidade_segurado
							where	nr_seq_mensalidade = r_c05_w.nr_seq_mensalidade
							and	coalesce(nr_seq_titular::text, '') = '';
						else
							carteira_benef_titular_w	:= '';
						end if;

						if (coalesce(nr_seq_tipo_evento_w,0) > 0) then
							nm_pagador_w		:= pls_obter_dados_pagador(r_C05_w.nr_seq_pagador,'N');
							cd_operadora_empresa_w	:= pls_obter_dados_contrato(nr_seq_contrato_w,'CD');
							nr_contrato_w		:= pls_obter_dados_contrato(nr_seq_contrato_w,'N');
							ds_mensagem_w		:= ds_mensagem_padrao_w;
							ds_mensalidades_w	:= '(';
							ds_titulos_w		:= '(';
							
							for r_C06_w in C06(r_C05_w.nr_seq_pagador, r_C05_w.dt_referencia) loop
								if (length(ds_mensalidades_w) > 1) then
									ds_mensalidades_w := ds_mensalidades_w||', '||r_C06_w.nr_seq_mensalidade;
								else
									ds_mensalidades_w := ds_mensalidades_w||r_C06_w.nr_seq_mensalidade;
								end if;	
								if (length(ds_titulos_w) > 1) then
									ds_titulos_w := ds_titulos_w||', '||r_C06_w.nr_titulo;
								else
									ds_titulos_w := ds_titulos_w||r_C06_w.nr_titulo;
								end if;
							end loop;
							
							ds_mensalidades_w	:= ds_mensalidades_w||')';
							ds_titulos_w		:= ds_titulos_w||')';
							
							select	count(1)
							into STRICT	qt_macro_w
							
							where	ds_mensagem_w like '%@%';
							
							if (qt_macro_w > 0) then
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@NOME_PAGADOR', substr(nm_pagador_w,1,position(' ' in nm_pagador_w))), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@PAGADOR', nm_pagador_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@DT_REFERENCIA_MENSALIDADE', r_C05_w.dt_referencia), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@REQUISICAO', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@CD_GUIA', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@ANALISE', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@DT_VALIDADE_SENHA', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@DS_PROCEDIMENTO', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@PRESTADOR', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@CARTEIRA_BENEF_TITULAR', carteira_benef_titular_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@CD_OPERADORA_EMPRESA', cd_operadora_empresa_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@NR_CONTRATO', nr_contrato_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@MENSALIDADES', ds_mensalidades_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@TITULOS', ds_titulos_w), 1, 4000);
							end if;
							
							select	nextval('pls_alerta_evento_controle_seq')
							into STRICT	nr_seq_evento_controle_w
							;

							insert 	into pls_alerta_evento_controle(nr_sequencia,
								dt_geracao_evento,
								ie_evento_disparo,
								nr_seq_tipo_evento,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ds_mensagem,
								ds_titulo,
								ie_tipo_envio
								)
							values (nr_seq_evento_controle_w,
								clock_timestamp(),
								7,
								nr_seq_tipo_evento_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								ds_mensagem_w,
								ds_titulo_w,
								ie_tipo_envio_w
								);
							
							for r_C04_w in C04(r_C01_w.nr_seq_evento_mens) loop
								begin
								if (r_C04_w.ie_forma_envio = 'EM') and (coalesce(ds_remetente_email_w,'X') <> 'X') then
									if (r_C04_w.ie_tipo_pessoa_dest = 'PG') then
										ds_email_dest_w := pls_obter_dados_pagador(r_C05_w.nr_seq_pagador,'M');
										if (coalesce(ds_email_dest_w,'X') <> 'X') then
											CALL enviar_email(	ds_titulo_w, ds_mensagem_w, ds_remetente_email_w,
													ds_email_dest_w, nm_usuario_p, 'M');
											CALL pls_gerar_destino_evento(	nr_seq_evento_controle_w, 'E', r_C04_w.ie_forma_envio,
															nm_usuario_p, cd_pessoa_fisica_w, null,
															ds_mensagem_w, id_sms_w, ds_email_dest_w);
										end if;
									end if;
								end if;
								
								if (r_C04_w.ie_forma_envio = 'SMS') and (coalesce(ds_remetente_sms_w,'X') <> 'X') then
									if (r_C04_w.ie_tipo_pessoa_dest = 'PG') then
										cd_pessoa_fisica_w 	:= pls_obter_dados_pagador(r_C05_w.nr_seq_pagador,'CPFP');
										ds_esconder_ddi_w 	:= obter_valor_param_usuario(0,214,0,obter_usuario_ativo,obter_estabelecimento_ativo);
										
										if (ds_esconder_ddi_w = 'S') then
											ds_sms_dest_w		:= obter_dados_pf(cd_pessoa_fisica_w, 'TCD');
										else
											ds_sms_dest_w		:= obter_dados_pf(cd_pessoa_fisica_w, 'TCI');										
										end if;
										
										if (coalesce(ds_sms_dest_w,'X') <> 'X') then
											ds_sms_dest_w	:= remover_caracter_invalido(ds_sms_dest_w);
										
											id_sms_w := pls_enviar_sms_alerta_evento(	ds_remetente_sms_w, ds_sms_dest_w, substr(ds_mensagem_w,1,150), nr_seq_tipo_evento_w, nm_usuario_p, id_sms_w);
											CALL pls_gerar_destino_evento(	nr_seq_evento_controle_w, 'E', r_C04_w.ie_forma_envio,
															nm_usuario_p, cd_pessoa_fisica_w, null,
															ds_mensagem_w, id_sms_w, ds_sms_dest_w);
										end if;
									end if;
								end if;
								
								end;
							end loop;
						end if;
					end if;
					end;
				end loop; --C05
			else
				--Abre cursor com os titulos a receber em atraso dentro dos primeiros 6 meses
				for r_C03_w in C03(dt_pagamento_min_w, dt_pagamento_6_meses_w, r_C02_w.cd_estabelecimento, r_C02_w.qt_dias_atraso, r_C01_w.ie_situacao_pagador) loop

					select	max(c.ie_tipo_contratacao),
						max(a.nr_seq_contrato)
					into STRICT	ie_tipo_contratacao_w,
						nr_seq_contrato_w
					from	pls_contrato_pagador a,
						pls_contrato_plano b,
						pls_plano c
					where	c.nr_Sequencia = b.nr_Seq_plano
					and	b.nr_seq_contrato = a.nr_seq_contrato
					and	a.nr_Sequencia = r_C03_w.nr_seq_pagador;
					
					if (r_C02_w.ie_tipo_contratacao = ie_tipo_contratacao_w) then
						--So e possivel individualizar o titular para pagadores PF, para PJ nao existe essa possibilidade
						if (r_C03_w.cd_pessoa_fisica IS NOT NULL AND r_C03_w.cd_pessoa_fisica::text <> '') then
							select	pls_obter_dados_segurado(max(nr_seq_segurado),'C')
							into STRICT	carteira_benef_titular_w
							from	pls_mensalidade_segurado
							where	nr_seq_mensalidade = r_C03_w.nr_seq_mensalidade
							and	coalesce(nr_seq_titular::text, '') = '';
						else
							carteira_benef_titular_w	:= '';
						end if;
						
						ie_enviar_w := 'S';
						if (r_C02_w.ie_envio_unico = 'S') 	then
							select	count(*)
							into STRICT	qt_qtde_envio_w
							from	pls_alerta_evento_controle
							where nr_seq_mensalidade = r_C03_w.nr_seq_mensalidade;
							
							if (qt_qtde_envio_w > 0) then
								ie_enviar_w := 'N';
							end if;
						end if;
						
						select	count(1)
						into STRICT	qt_benef_cooperado_w
						from	pls_cooperado
						where	cd_pessoa_fisica = r_c03_w.cd_pessoa_fisica
						and	ie_status = 'A';
						
						ie_gerar_w := 'S';
						
						if (r_c02_w.ie_pagador_cooperado = 'A') or
							(r_c02_w.ie_pagador_cooperado = 'C' AND qt_benef_cooperado_w > 0) or
							(r_c02_w.ie_pagador_cooperado = 'N' AND qt_benef_cooperado_w = 0) then
							ie_gerar_w := 'S';
						else
							ie_gerar_w := 'N';
						end if;
						
						if	((coalesce(nr_seq_tipo_evento_w,0) > 0) and (ie_enviar_w = 'S') and (ie_gerar_w = 'S')) then
							nm_pagador_w		:= pls_obter_dados_pagador(r_C03_w.nr_seq_pagador,'N');
							cd_operadora_empresa_w	:= pls_obter_dados_contrato(nr_seq_contrato_w,'CD');
							nr_contrato_w		:= pls_obter_dados_contrato(nr_seq_contrato_w,'N');
							ds_mensagem_w		:= ds_mensagem_padrao_w;
							
							select	count(1)
							into STRICT	qt_macro_w
							
							where	ds_mensagem_w like '%@%';
							
							if (qt_macro_w > 0) then
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@NOME_PAGADOR', substr(nm_pagador_w,1,position(' ' in nm_pagador_w))), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@PAGADOR', nm_pagador_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@DT_REFERENCIA_MENSALIDADE', r_C03_w.dt_referencia), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@REQUISICAO', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@CD_GUIA', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@ANALISE', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@DT_VALIDADE_SENHA', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@DS_PROCEDIMENTO', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@PRESTADOR', ''), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@CARTEIRA_BENEF_TITULAR', carteira_benef_titular_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@CD_OPERADORA_EMPRESA', cd_operadora_empresa_w), 1, 4000);
								ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@NR_CONTRATO', nr_contrato_w), 1, 4000);
							end if;

							select	nextval('pls_alerta_evento_controle_seq')
							into STRICT	nr_seq_evento_controle_w
							;
							
							insert	into pls_alerta_evento_controle(nr_sequencia,
								dt_geracao_evento,
								ie_evento_disparo,
								nr_seq_tipo_evento,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ds_mensagem,
								ds_titulo,
								ie_tipo_envio,
								nr_seq_mensalidade)
							values (nr_seq_evento_controle_w,
								clock_timestamp(),
								7,
								nr_seq_tipo_evento_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								ds_mensagem_w,
								ds_titulo_w,
								ie_tipo_envio_w,
								r_C03_w.nr_seq_mensalidade);
								
							for r_C04_w in C04(r_C01_w.nr_seq_evento_mens) loop
								begin
								if (r_C04_w.ie_forma_envio = 'EM') and (coalesce(ds_remetente_email_w,'X') <> 'X') then
									if (r_C04_w.ie_tipo_pessoa_dest = 'PG') then
										ds_email_dest_w := pls_obter_dados_pagador(r_C03_w.nr_seq_pagador,'M');
										if (coalesce(ds_email_dest_w,'X') <> 'X') then
											CALL enviar_email(	ds_titulo_w, ds_mensagem_w, ds_remetente_email_w,
													ds_email_dest_w, nm_usuario_p, 'M');
										end if;
									end if;
								end if;
								
								if (r_C04_w.ie_forma_envio = 'SMS') and (coalesce(ds_remetente_sms_w,'X') <> 'X') then
									if (r_C04_w.ie_tipo_pessoa_dest = 'PG') then
										cd_pessoa_fisica_w 	:= pls_obter_dados_pagador(r_C03_w.nr_seq_pagador,'CPFP');
										ds_esconder_ddi_w 	:= obter_valor_param_usuario(0,214,0,obter_usuario_ativo,obter_estabelecimento_ativo);

										if (ds_esconder_ddi_w = 'S') then 		
											ds_sms_dest_w		:= obter_dados_pf(cd_pessoa_fisica_w, 'TCD');
										else
											ds_sms_dest_w		:= obter_dados_pf(cd_pessoa_fisica_w, 'TCI');
										end if;
										
										if (coalesce(ds_sms_dest_w,'X') <> 'X') then
											ds_sms_dest_w	:= remover_caracter_invalido(ds_sms_dest_w);
										
											id_sms_w := pls_enviar_sms_alerta_evento(	ds_remetente_sms_w, ds_sms_dest_w, substr(ds_mensagem_w,1,150), nr_seq_tipo_evento_w, nm_usuario_p, id_sms_w);
											CALL pls_gerar_destino_evento(	nr_seq_evento_controle_w, 'E', r_C04_w.ie_forma_envio,
															nm_usuario_p, cd_pessoa_fisica_w, null,
															ds_mensagem_w, id_sms_w, ds_sms_dest_w);
										end if;
									end if;
								end if;
								
								end;
							end loop;
						end if;
					end if;
				end loop;
			end if;
			
			--Adiciona 6 meses a data minima
			dt_pagamento_min_w := dt_pagamento_6_meses_w;
			
			commit;
			end;
		end loop;
		
	end loop;
	
	commit;
	
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_msg_mens_atraso (( nm_usuario_p text) is c01 CURSOR FOR SELECT nr_seq_evento_mens, ie_situacao_pagador, nvl(ie_tipo_alerta, 'P') ie_tipo_alerta from pls_regra_geracao_evento where ie_evento_disparo = 7 and ie_situacao = 'A') FROM PUBLIC;

