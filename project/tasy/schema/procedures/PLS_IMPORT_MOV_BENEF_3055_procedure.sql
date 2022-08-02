-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_import_mov_benef_3055 ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) is ie_tipo_linha_w varchar(10) RETURNS bigint AS $body$
DECLARE


nr_seq_congenere_w	pls_congenere.nr_sequencia%type;

BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_congenere_w
from	pls_congenere
where	cd_cooperativa = cd_cooperativa_p;

return nr_seq_congenere_w;

end;

begin

--Loop para percorrer todas as linhas do arquivo
for r_c01_w in C01 loop
	begin
	ds_conteudo_aux_w := replace(replace(r_c01_w.ds_conteudo,CHR(10),''),CHR(13),'');
	SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, ie_tipo_linha_w) INTO STRICT ds_conteudo_aux_w, ie_tipo_linha_w;
	if (ie_tipo_linha_w = '1') then -- Lote
		begin
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_seq_lote_ant_w) INTO STRICT ds_conteudo_aux_w, nr_seq_lote_ant_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_cooperativa_destino_w) INTO STRICT ds_conteudo_aux_w, cd_cooperativa_destino_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_cooperativa_origem_w) INTO STRICT ds_conteudo_aux_w, cd_cooperativa_origem_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_referencia_w) INTO STRICT ds_conteudo_aux_w, dt_referencia_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_geracao_lote_w) INTO STRICT ds_conteudo_aux_w, dt_geracao_lote_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, ie_tipo_movimento_w) INTO STRICT ds_conteudo_aux_w, ie_tipo_movimento_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_movimento_inicial_w) INTO STRICT ds_conteudo_aux_w, dt_movimento_inicial_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_movimento_final_w) INTO STRICT ds_conteudo_aux_w, dt_movimento_final_w;
		
		nr_seq_congenere_destino_w	:= obter_seq_congenere(cd_cooperativa_destino_w);
		nr_seq_congenere_origem_w	:= obter_seq_congenere(cd_cooperativa_origem_w);
		
		insert	into	pls_mov_benef_lote(	nr_sequencia, nr_seq_regra, cd_estabelecimento,
				dt_referencia, ie_tipo_movimento, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				dt_movimento_inicial, dt_movimento_final, dt_geracao_lote, 
				ie_tipo_lote, nr_seq_congenere_origem, nr_seq_congenere_destino)
			values (	nr_seq_lote_p, null, cd_estabelecimento_p, 
				clock_timestamp(), 'M', clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				to_date(dt_movimento_inicial_w,'ddmmYYYY'), to_date(dt_movimento_final_w,'ddmmYYYY'),clock_timestamp(),
				'R', nr_seq_congenere_origem_w, nr_seq_congenere_destino_w);
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1091531, 'DS_TIPO_REGISTRO='||wheb_mensagem_pck.get_texto(1091532)||';NR_LINHA='||r_c01_w.nr_linha);
		end;
	elsif (ie_tipo_linha_w = '4') then --Beneficiário
		begin
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_cnpj_w) INTO STRICT ds_conteudo_aux_w, cd_cnpj_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_contrato_w) INTO STRICT ds_conteudo_aux_w, nr_contrato_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_usuario_plano_w) INTO STRICT ds_conteudo_aux_w, cd_usuario_plano_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_validade_carteira_w) INTO STRICT ds_conteudo_aux_w, dt_validade_carteira_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_via_carteira_w) INTO STRICT ds_conteudo_aux_w, nr_via_carteira_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nm_beneficiario_w) INTO STRICT ds_conteudo_aux_w, nm_beneficiario_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_plano_intercambio_w) INTO STRICT ds_conteudo_aux_w, cd_plano_intercambio_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_nascimento_w) INTO STRICT ds_conteudo_aux_w, dt_nascimento_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, ie_sexo_w) INTO STRICT ds_conteudo_aux_w, ie_sexo_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_cpf_w) INTO STRICT ds_conteudo_aux_w, nr_cpf_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_identidade_w) INTO STRICT ds_conteudo_aux_w, nr_identidade_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, ds_orgao_emissor_ci_w) INTO STRICT ds_conteudo_aux_w, ds_orgao_emissor_ci_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, sg_emissora_ci_w) INTO STRICT ds_conteudo_aux_w, sg_emissora_ci_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, ie_estado_civil_w) INTO STRICT ds_conteudo_aux_w, ie_estado_civil_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nm_mae_w) INTO STRICT ds_conteudo_aux_w, nm_mae_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_pis_pasep_w) INTO STRICT ds_conteudo_aux_w, nr_pis_pasep_w;	
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, nr_cartao_nac_sus_w) INTO STRICT ds_conteudo_aux_w, nr_cartao_nac_sus_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_familia_w) INTO STRICT ds_conteudo_aux_w, cd_familia_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_dependencia_w) INTO STRICT ds_conteudo_aux_w, cd_dependencia_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, cd_titular_w) INTO STRICT ds_conteudo_aux_w, cd_titular_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_inclusao_operadora_w) INTO STRICT ds_conteudo_aux_w, dt_inclusao_operadora_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_contratacao_w) INTO STRICT ds_conteudo_aux_w, dt_contratacao_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_rescisao_benef_w) INTO STRICT ds_conteudo_aux_w, dt_rescisao_benef_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_compartilhamento_w) INTO STRICT ds_conteudo_aux_w, dt_compartilhamento_w;
		SELECT * FROM pls_busca_prox_reg_sep(ds_conteudo_aux_w, ';', ds_conteudo_aux_w, dt_fim_compartilhamento_w) INTO STRICT ds_conteudo_aux_w, dt_fim_compartilhamento_w;
				
		if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then		
			select	max(nr_sequencia)
			into STRICT	nr_seq_mov_contrato_w
			from	pls_mov_benef_contrato
			where	nr_seq_lote = nr_seq_lote_p
			and	nr_contrato = nr_contrato_w;
			
			select	max(nr_sequencia)
			into STRICT	nr_seq_intercambio_w
			from	pls_intercambio
			where	nr_contrato_origem = nr_contrato_w;
		end if;	
		
		insert	into	pls_mov_benef_segurado(nr_sequencia, nr_seq_lote, dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, nr_seq_segurado, nr_seq_mov_contrato, nr_seq_mov_operadora, nr_contrato,
				cd_usuario_plano, dt_validade_carteira, nr_via_carteira, nm_beneficiario, nm_abreviado,
				nm_social, nm_social_abreviado, dt_nascimento, ie_sexo, nr_cpf,
				nr_identidade, ds_orgao_emissor_ci, sg_emissora_ci, ie_estado_civil, nm_mae,
				nr_pis_pasep, nr_cartao_nac_sus, cd_plano_intercambio, cd_familia, cd_matricula_estipulante,
				ie_nascido_plano, cd_dependencia, cd_titular, dt_contratacao, dt_inclusao_operadora,
				dt_rescisao, cd_motivo_rescisao, dt_compartilhamento, dt_fim_compartilhamento, cd_plano_origem,
				ie_tipo_repasse,nr_seq_intercambio)
			values (	nextval('pls_mov_benef_segurado_seq'), nr_seq_lote_p,clock_timestamp(), nm_usuario_p,clock_timestamp(),
				nm_usuario_p, null, nr_seq_mov_contrato_w,null, nr_contrato_w,
				cd_usuario_plano_w, to_date(dt_validade_carteira_w,'ddmmYYYY'), nr_via_carteira_w, nm_beneficiario_w, nm_abreviado_w,
				nm_social_w, nm_social_abreviado_w, to_date(dt_nascimento_w,'ddmmyyyy'), ie_sexo_w, nr_cpf_w,
				nr_identidade_w, ds_orgao_emissor_ci_w, sg_emissora_ci_w, ie_estado_civil_w, nm_mae_w,
				nr_pis_pasep_w, nr_cartao_nac_sus_w, cd_plano_intercambio_w, cd_familia_w, cd_matricula_estipulante_w, 
				ie_nascido_plano_w, cd_dependencia_w, cd_titular_w, to_date(dt_contratacao_w,'ddmmYYYY'), to_date(dt_inclusao_operadora_w,'ddmmYYYY'),
				to_date(dt_rescisao_benef_w,'ddmmYYYY'), cd_motivo_rescisao_w, to_date(dt_compartilhamento_w,'ddmmYYYY'), to_date(dt_fim_compartilhamento_w,'ddmmYYYY'), cd_plano_origem_w,
				ie_tipo_repasse_w,nr_seq_intercambio_w);
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1091531, 'DS_TIPO_REGISTRO='||wheb_mensagem_pck.get_texto(1091535)||';NR_LINHA='||r_c01_w.nr_linha);
		end;		
	end if;
	end;
end loop;

CALL pls_mov_benef_imp_pck.alterar_status_lote(nr_seq_lote_p,'I',nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_import_mov_benef_3055 ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) is ie_tipo_linha_w varchar(10) FROM PUBLIC;

