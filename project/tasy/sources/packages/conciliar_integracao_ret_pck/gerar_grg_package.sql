-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.gerar_grg (protocolo_w INOUT protocolo) AS $body$
DECLARE


nr_seq_lote_hist_guia_w		lote_audit_hist_guia.nr_sequencia%type;

nr_seq_lote_hist_item_w		lote_audit_hist_item.nr_sequencia%type;

-- Lote e analise NOVO.
nr_seq_lote_audit_novo_w	lote_auditoria.nr_sequencia%type;
nr_seq_lote_hist_novo_w		lote_audit_hist.nr_sequencia%type;

ie_guia_sem_saldo_w		varchar(1);

item_w 				item;
BEGIN

	/*
		Verificar se as guias a serem geradas na GRG ja existem ou nao.
	*/
	/*
		Criacao do lote da GRG.
	*/
	criar_lote_auditoria(protocolo_w.cd_convenio, protocolo_w.cd_estabelecimento, current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type, nr_seq_lote_audit_novo_w);

	if (protocolo_w.contas.count > 0) then	
		for i in protocolo_w.contas.first .. protocolo_w.contas.last loop
			if (protocolo_w.contas[i].ie_status = 'C') then

				if (coalesce(nr_seq_lote_hist_novo_w::text, '') = '') then
					criar_lote_audit_hist(nr_seq_lote_audit_novo_w, protocolo_w.cd_estabelecimento, current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type, nr_seq_lote_hist_novo_w);
				end if;

				select	nextval('lote_audit_hist_guia_seq')
				into STRICT	nr_seq_lote_hist_guia_w
				;

				if (protocolo_w.contas[i].vl_saldo <= 0) then
					ie_guia_sem_saldo_w := 'S';
				else
					ie_guia_sem_saldo_w := 'N';
				end if;

                if (current_setting('conciliar_integracao_ret_pck.ie_opcao_w')::varchar(2) = 'V') then
                    protocolo_w.contas[i].ie_status := 'V';
                else
				begin				
					insert into lote_audit_hist_guia(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_interno_conta,
						cd_autorizacao,
						nr_seq_lote_hist,
						nr_seq_retorno,
						vl_saldo_guia,
						ie_guia_sem_saldo,
						dt_baixa_glosa,
						ds_observacao,
						dt_integracao)
					values (nr_seq_lote_hist_guia_w,
						clock_timestamp(),
						current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type,
						clock_timestamp(),
						current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type,
						protocolo_w.contas[i].nr_interno_conta,
						protocolo_w.contas[i].cd_autorizacao,
						nr_seq_lote_hist_novo_w,
						protocolo_w.nr_seq_retorno_conv,
						protocolo_w.contas[i].vl_saldo,
						ie_guia_sem_saldo_w,
						null,
						null,
						clock_timestamp());
				exception
				when others then
					protocolo_w.contas[i].ds_erro := SQLSTATE || ' - ' || sqlerrm;
					protocolo_w.contas[i].ie_status := 'E'; -- Erro.
				end;
                end if;


				if (protocolo_w.contas[i].itens_conta.count > 0) then

					for j in protocolo_w.contas[i].itens_conta.first .. protocolo_w.contas[i].itens_conta.last loop

						if (protocolo_w.contas[i].itens_conta(j).ie_status = 'C') then
							item_w := protocolo_w.contas[i].itens_conta(j);

							select 	nextval('lote_audit_hist_item_seq')
							into STRICT	nr_seq_lote_hist_item_w
							;

                            if (current_setting('conciliar_integracao_ret_pck.ie_opcao_w')::varchar(2) = 'V') then
                                item_w.ie_status := 'V';
                            else
							begin
								insert	into lote_audit_hist_item(cd_motivo_glosa,
									cd_resposta,
									dt_atualizacao,
									dt_historico,
									ie_acao_glosa,
									ie_status,
									nm_usuario,
									nr_seq_guia,
									nr_seq_lote,
									nr_seq_matpaci,
									nr_seq_propaci,
									nr_seq_partic,
									nr_seq_ret_glosa,
									nr_seq_ret_item,
									nr_sequencia,
									vl_glosa,
									vl_amenor,
									vl_pago,
									qt_item,
									cd_setor_atendimento,
									vl_saldo_amenor,
									vl_saldo,
									vl_glosa_informada,
									cd_motivo_glosa_tiss)
								values (	item_w.cd_glosa_tasy,
									item_w.cd_resposta_glosa,
									clock_timestamp(),
									clock_timestamp(),
									item_w.ie_acao_glosa,
									current_setting('conciliar_integracao_ret_pck.ie_status_lote_item_const_w')::lote_audit_hist_item.ie_status%type,
									current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type,
									nr_seq_lote_hist_guia_w,
									nr_seq_lote_hist_novo_w,
									item_w.nr_seq_matpaci,
									item_w.nr_seq_propaci,
									item_w.nr_seq_partic,
									item_w.nr_seq_ret_glosa,
									item_w.nr_seq_ret_item,
									nr_seq_lote_hist_item_w,
									CASE WHEN item_w.ie_acao_glosa='A' THEN  coalesce(item_w.vl_glosado,0)  ELSE 0 END ,
									CASE WHEN item_w.ie_acao_glosa='R' THEN  coalesce(item_w.vl_glosado,0)  ELSE 0 END ,
									coalesce(item_w.vl_liberado, 0),
									coalesce(item_w.qt_executada, 0),
									item_w.cd_setor_atendimento,
									coalesce(item_w.vl_glosado, 0),
									coalesce(item_w.vl_glosado, 0),
									coalesce(item_w.vl_glosado, 0),
									item_w.cd_glosa
									);
							exception
							when others then
								protocolo_w.contas[i].itens_conta(j).ds_erro := SQLSTATE || ' - ' || sqlerrm;								
								protocolo_w.contas[i].itens_conta(j).ie_status := 'E';
							end;
                            end if;
						end if;

					end loop;

				end if;



			end if;
		end loop;
	end if;

	if (nr_seq_lote_audit_novo_w IS NOT NULL AND nr_seq_lote_audit_novo_w::text <> '') then
		update	lote_auditoria
		set	dt_integracao = clock_timestamp()
		where 	nr_sequencia = nr_seq_lote_audit_novo_w;
	end if;

	if (nr_seq_lote_hist_novo_w IS NOT NULL AND nr_seq_lote_hist_novo_w::text <> '') then
		update	lote_audit_hist
		set	dt_integracao = clock_timestamp()
		where	nr_sequencia = nr_seq_lote_hist_novo_w;
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.gerar_grg (protocolo_w INOUT protocolo) FROM PUBLIC;
