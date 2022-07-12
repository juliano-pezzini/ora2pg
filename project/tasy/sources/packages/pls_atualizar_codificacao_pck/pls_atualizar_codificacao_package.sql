-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	/* Cursor 1 */

	

	/* Cursor 2 */

	

	/* Formação de preço */

	

	/* Regulamentação */

	

	/* Tipo de ato cooperado */

	

	/* Tipo de contratação */

	

	/* Tipo de contrato (PF e PJ) */

	

	/* Tipo de relação com a OPS */

	

	/* Tipo de contratação / Regulamentação */

	

        /* Tipo de despesa */

        


CREATE OR REPLACE PROCEDURE pls_atualizar_codificacao_pck.pls_atualizar_codificacao ( dt_referencia_p timestamp) AS $body$
BEGIN
	PERFORM set_config('pls_atualizar_codificacao_pck.dt_referencia_w', dt_referencia_p, false);

	/* Formação de preço */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_misto_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_pos_custo_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_pos_rateio_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_pre_w', null, false);

	/* Regulamentação */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_regul_adaptado_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_regul_pos_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_regul_pre_w', null, false);

	/* Tipo de ato cooperado */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_ato_coop_aux_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_ato_coop_prin_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_ato_nao_coop_w', null, false);

	/* Tipo de contratação */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_colet_empres_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_colet_adesao_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_indiv_familiar_w', null, false);

	/* Tipo de contrato (PF e PJ) */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_contrato_pf_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_contrato_pj_w', null, false);

	/* Tipo de relação com a OPS */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_cooper_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_fornec_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_rede_dir_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_rede_indir_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_rede_prop_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_nao_w', null, false);

	/* Tipo de contratação / Regulamentação */

	PERFORM set_config('pls_atualizar_codificacao_pck.ie_individual_pre_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_individual_pos_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_individual_adaptado_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_empresarial_pre_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_empresarial_pos_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_empresarial_adaptado_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_adesao_pre_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_adesao_pos_w', null, false);
	PERFORM set_config('pls_atualizar_codificacao_pck.ie_adesao_adaptado_w', null, false);

        /* Tipo de despesa */

        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_proced_w', null, false);
        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_taxas_w', null, false);
        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_diarias_w', null, false);
        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_pacotes_w', null, false);

	begin
		select	nr_sequencia
		into STRICT	current_setting('pls_atualizar_codificacao_pck.nr_seq_cod_versao_w')::bigint
		from	pls_contab_versao a
		where	current_setting('pls_atualizar_codificacao_pck.dt_referencia_w')::timestamp between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,current_setting('pls_atualizar_codificacao_pck.dt_referencia_w')::timestamp);
	exception
	when no_data_found then
		/*Não foi possível executar a ação, motivo:
		Não foi possível encotrar uma versão para a codificação contábil em vigência disponível para a data em referência !
		Solicite uma atualização do cadastro.*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(224729);
	when too_many_rows then
		/*Não foi possível executar a ação, motivo:
		Existe mais de uma versão de codificação contábil que está em vigência!
		Solicite uma verificação dos cadastros.*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(224731);
	end;

	open current_setting('pls_atualizar_codificacao_pck.c01')::CURSOR;
	loop
	fetch current_setting('pls_atualizar_codificacao_pck.c01')::into CURSOR
		current_setting('pls_atualizar_codificacao_pck.nr_seq_codificacao_w')::bigint,
		current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2);
	EXIT WHEN NOT FOUND; /* apply on current_setting('pls_atualizar_codificacao_pck.c01')::CURSOR */
		begin
		open current_setting('pls_atualizar_codificacao_pck.c02')::CURSOR;
		loop
		fetch current_setting('pls_atualizar_codificacao_pck.c02')::into CURSOR
			current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2),
			current_setting('pls_atualizar_codificacao_pck.ie_preco_w')::varchar(2),
			current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2),
			current_setting('pls_atualizar_codificacao_pck.ie_ato_cooperado_w')::varchar(10),
			current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2),
			current_setting('pls_atualizar_codificacao_pck.ie_tipo_pessoa_w')::varchar(2),
			current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2),
                        current_setting('pls_atualizar_codificacao_pck.ie_tipo_despesa_w')::varchar(2);
		EXIT WHEN NOT FOUND; /* apply on current_setting('pls_atualizar_codificacao_pck.c02')::CURSOR */
			begin
			if (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'FP') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_preco_w')::varchar(2) = '1') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_pre_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_preco_w')::varchar(2) = '2') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_pos_rateio_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_preco_w')::varchar(2) = '3') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_pos_custo_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_preco_w')::varchar(2) = '4') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_form_misto_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				end if;
			elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'R') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'P') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_regul_pos_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'A') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_regul_adaptado_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'R') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_regul_pre_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				end if;
			elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'TA') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_ato_cooperado_w')::varchar(10) = '1') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_ato_coop_prin_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_ato_cooperado_w')::varchar(10) = '2') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_ato_coop_aux_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_ato_cooperado_w')::varchar(10) = '3') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_ato_nao_coop_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				end if;
			elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'TC') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2) = 'I') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_indiv_familiar_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2) = 'CE') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_colet_empres_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2) = 'CA') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_colet_adesao_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				end if;
			elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'TP') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_tipo_pessoa_w')::varchar(2) = 'PF') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_contrato_pf_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_pessoa_w')::varchar(2) = 'PJ') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_contrato_pj_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				end if;
			elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'TR') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2) = 'P') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_rede_prop_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2) = 'D') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_rede_dir_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2) = 'I') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_rede_indir_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2) = 'C') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_cooper_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2) = 'F') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_fornec_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_relacao_w')::varchar(2) = 'N') then
					PERFORM set_config('pls_atualizar_codificacao_pck.ie_relac_nao_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
				end if;
			elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'RC') then
				if (current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2) = 'I') then
					if (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'P') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_individual_pos_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'A') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_individual_adaptado_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'R') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_individual_pre_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					end if;
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2) = 'CE') then
					if (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'P') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_empresarial_pos_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'A') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_empresarial_adaptado_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'R') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_empresarial_pre_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					end if;
				elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_contratacao_w')::varchar(2) = 'CA') then
					if (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'P') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_adesao_pos_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'A') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_adesao_adaptado_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					elsif (current_setting('pls_atualizar_codificacao_pck.ie_regulamentacao_w')::varchar(2) = 'R') then
						PERFORM set_config('pls_atualizar_codificacao_pck.ie_adesao_pre_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
					end if;
				end if;
                        elsif (current_setting('pls_atualizar_codificacao_pck.ie_codificacao_w')::varchar(2) = 'TD') then
                                if (current_setting('pls_atualizar_codificacao_pck.ie_tipo_despesa_w')::varchar(2) = 1) then
                                        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_proced_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
                                elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_despesa_w')::varchar(2) = 2) then
                                        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_taxas_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
                                elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_despesa_w')::varchar(2) = 3) then
                                        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_diarias_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
                                elsif (current_setting('pls_atualizar_codificacao_pck.ie_tipo_despesa_w')::varchar(2) = 4) then
                                        PERFORM set_config('pls_atualizar_codificacao_pck.ie_despesa_pacotes_w', current_setting('pls_atualizar_codificacao_pck.ds_valor_w')::varchar(2), false);
                                end if;
			end if;
			end;
		end loop;
		close current_setting('pls_atualizar_codificacao_pck.c02')::CURSOR;
		end;
	end loop;
	close current_setting('pls_atualizar_codificacao_pck.c01')::CURSOR;
	end;

	/* Getters e Setters */

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_codificacao_pck.pls_atualizar_codificacao ( dt_referencia_p timestamp) FROM PUBLIC;