-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Registro e020: documento - nota fiscal (código 01), nota fiscal de produtor (código 04) e nota fiscal eletrônica (código 55)*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_lfpd05_pck.fis_gerar_reg_e020_edoc () AS $body$
DECLARE


/*Variaveis do procedure*/

nr_seq_fis_sef_edoc_e020_w	fis_sef_edoc_e020.nr_sequencia%type;
cd_sit_w			fis_efd_icmsipi_C100.cd_sit%type	:= null;
vl_bc_icms_w      		fis_sef_edoc_e020.vl_bc_icms%type;
vl_icms_w        		fis_sef_edoc_e020.vl_icms%type;
vl_icms_st_w      		fis_sef_edoc_e020.vl_icms_st%type;
vl_st_e_w			fis_sef_edoc_e020.vl_st_e%type;
vl_st_s_w			fis_sef_edoc_e020.vl_st_s%type;
vl_isnt_icms_w			fis_sef_edoc_e020.vl_isnt_icms%type;
vl_out_icms_w			fis_sef_edoc_e020.vl_out_icms%type;
vl_bc_ipi_w       		fis_sef_edoc_e020.vl_bc_ipi%type;
vl_ipi_w          		fis_sef_edoc_e020.vl_ipi%type;
vl_isnt_ipi_w			fis_sef_edoc_e020.vl_isnt_ipi%type;
vl_out_ipi_w			fis_sef_edoc_e020.vl_out_ipi%type;
cd_cfop_w			fis_sef_edoc_e025.cd_cfop%type;
tx_aliq_icms_w			fis_sef_edoc_e025.tx_aliq_icms%type;
vl_bc_st_p_w			fis_sef_edoc_e025.vl_bc_st_p%type;
vl_item_w			nota_fiscal_item.vl_total_item_nf%type;

/*cursor para trazer as notas do registro*/

c_reg_e020 CURSOR FOR
	SELECT	CASE WHEN e.ie_operacao_fiscal='S' THEN  1  ELSE 0 END  												cd_ind_oper,
		CASE WHEN e.ie_operacao_fiscal='S' THEN  0 WHEN e.ie_operacao_fiscal='E' THEN  CASE WHEN ie_tipo_nota='EP' THEN  0  ELSE 1 END  END  								cd_ind_emit,
		CASE WHEN e.ie_operacao_fiscal='E' THEN  coalesce(a.cd_cgc_emitente, a.cd_pessoa_fisica)  ELSE coalesce(cd_cgc,a.cd_pessoa_fisica) END  				cd_part,
		lpad(b.cd_modelo_nf, 2, 0) 														cd_mod,
		a.cd_serie_nf 																cd_ser,
		a.nr_nota_fiscal 															nr_doc,
		a.nr_danfe 																ds_chv_nfe,
		CASE WHEN e.ie_operacao_fiscal='E' THEN  a.dt_emissao  ELSE null END  											dt_emissao,
		CASE WHEN e.ie_operacao_fiscal='E' THEN  a.dt_entrada_saida  ELSE a.dt_emissao END  									dt_doc,
		a.cd_natureza_operacao															cd_nat,
		fis_sef_edoc_reg_lfpd05_pck.obter_cop(substr(Elimina_Caracter(obter_dados_natureza_operacao(a.cd_natureza_operacao, 'CF'), '.'), 1, 4), e.ie_operacao_fiscal)	cd_cop,
		null																	nr_lcto,
		substr(CASE WHEN coalesce(a.cd_condicao_pagamento,0)=0 THEN  2  ELSE CASE WHEN obter_dados_nota_fiscal(a.nr_sequencia, '28')=1 THEN  0  ELSE 1 END  END , 1, 1) 		cd_ind_pgto,
		a.vl_total_nota																vl_cont,
		null																	vl_op_iss,
		null																	vl_at,
		null																	cd_inf_obs,
		a.nr_sequencia 																nr_seq_nota,
		a.ie_status_envio															ie_status_envio,
		a.ds_observacao																ds_observacao,
		a.cd_natureza_operacao															cd_natureza_operacao,
		e.ie_operacao_fiscal															ie_operacao_fiscal
	FROM operacao_nota e, nota_fiscal a
LEFT OUTER JOIN nota_fiscal_transportadora c ON (a.nr_sequencia = c.nr_seq_nota)
, operacao_nota_modelo d
LEFT OUTER JOIN modelo_nota_fiscal b ON (d.nr_seq_modelo = b.nr_sequencia)
WHERE a.cd_operacao_nf	= d.cd_operacao_nf and a.cd_operacao_nf	= e.cd_operacao_nf and d.cd_operacao_nf	= e.cd_operacao_nf   and ((ie_tipo_data_w = 1 AND a.dt_emissao between dt_inicio_apuracao_w and dt_fim_apuracao_w)
		or (ie_tipo_data_w = 2 AND a.dt_entrada_saida between dt_inicio_apuracao_w and dt_fim_apuracao_w)) and (((obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'E') and 		-- Notas de Entrada
			(a.ie_status_envio IS NOT NULL AND a.ie_status_envio::text <> '') and  				-- Sem envio ao fisco
			(a.ie_situacao in (2,3,9)))                                   	-- Sitauação 2- Estornada    3- Estorno - 9-Cancelada
		or ((obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'E') and   	-- Notas de Entrada
			(a.ie_situacao not in (2,3,9)))                               	-- Sitauação 2- Estornada    3- Estorno - 9-Cancelada
		or (obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'S' and  		-- Nostas de saida
			(a.ie_status_envio IS NOT NULL AND a.ie_status_envio::text <> ''))
		or (obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'S' and
			coalesce(a.ie_status_envio::text, '') = '' and (exists (SELECT  1
					from	nfe_transmissao a,
						nfe_transmissao_nf b
					where	a.nr_sequencia = b.nr_seq_transmissao
					and	a.ie_tipo_nota = 'NFE'
					and 	a.ie_status_transmissao = 'T'
					and	b.nr_seq_nota_fiscal = a.nr_sequencia)))) and b.nr_sequencia		= nr_seq_modelo_nf_w and a.cd_estabelecimento	= cd_estabelecimento_w;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_0150*/

type reg_c_reg_e020 is table of c_reg_e020%RowType;
vetrege020 reg_c_reg_e020;

BEGIN

open c_reg_e020;
loop
fetch c_reg_e020 bulk collect into vetrege020 limit 1000;
	for i in 1 .. vetrege020.Count loop
		begin


		/*Incrementa a variavel para o array*/

		PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w', current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint + 1, false);

		CALL fis_sef_edoc_reg_lfpd05_pck.fis_gerar_dados_trib_item(	vetrege020[i].nr_seq_nota,
						vetrege020[i].cd_natureza_operacao,
						vetrege020[i].ie_operacao_fiscal);

		/*Incrementar variavel de controle do codigo da observação se tiver observação na nota*/

		if (vetrege020[i](.ds_observacao IS NOT NULL AND .ds_observacao::text <> '')) then
			PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.nr_cod_0450_w', current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_cod_0450_w')::fis_sef_edoc_controle.nr_cod_0450%type + 1, false);
		end if;

		/*Verificação para encontrar  a situação da nota*/

		if (coalesce(vetrege020[i].ie_status_envio, 'XX') <> 'XX') then
			case vetrege020[i].ie_status_envio
				when 'E' then
					cd_sit_w := '00';
				when 'C' then
					cd_sit_w := '90';
				when 'X' then
					cd_sit_w := '81';
				when 'D' then
					cd_sit_w := '80';
				else
					cd_sit_w := null;
			end case;
		else
			if (vetrege020[i].cd_ind_oper = 0) then
				cd_sit_w :=	'00';
			end if;
		end if;

		begin

		/*Busca os valores dos tributos para o registro agrupados por nota*/

		select	sum(vl_bc_icms) 	vl_bc_icms,
			sum(vl_icms) 		vl_icms,
			sum(vl_icms_st)		vl_icms_st,
			sum(vl_st_e)		vl_st_e,
			sum(vl_st_s)		vl_st_s,
			sum(vl_isnt_icms)	vl_isnt_icms,
			sum(vl_out_icms)	vl_out_icms,
			sum(vl_bc_ipi)		vl_bc_ipi,
			sum(vl_ipi)		vl_ipi,
			sum(vl_isnt_ipi)	vl_isnt_ipi,
			sum(vl_out_ipi)		vl_out_ipi
		into STRICT	vl_bc_icms_w,
		        vl_icms_w,
		        vl_icms_st_w,
		        vl_st_e_w,
		        vl_st_s_w,
		        vl_isnt_icms_w,
		        vl_out_icms_w,
		        vl_bc_ipi_w,
		        vl_ipi_w,
		        vl_isnt_ipi_w,
		        vl_out_ipi_w
		from	table(fis_sef_edoc_reg_lfpd05_pck.obter_valores(vetrege020[i].nr_seq_nota)) a
		where	nr_seq_nota		= vetrege020[i].nr_seq_nota
		group by	nr_seq_nota;

		exception
		when others then
			vl_bc_icms_w	:= null;
		        vl_icms_w	:= null;
		        vl_icms_st_w	:= null;
		        vl_st_e_w	:= null;
		        vl_st_s_w	:= null;
		        vl_isnt_icms_w	:= null;
		        vl_out_icms_w	:= null;
		        vl_bc_ipi_w	:= null;
		        vl_ipi_w	:= null;
		        vl_isnt_ipi_w	:= null;
		        vl_out_ipi_w	:= null;
		end;

		/*Pega a sequencia da taleba fis_sef_edoc_ para o insert*/

		select	nextval('fis_sef_edoc_e020_seq')
		into STRICT	nr_seq_fis_sef_edoc_e020_w
		;

		/*Gera o registro e025 */

		CALL fis_sef_edoc_reg_lfpd05_pck.fis_gerar_reg_e025_edoc(nr_seq_fis_sef_edoc_e020_w,
					vetrege020[i].nr_seq_nota);


		/*Inserindo valores no array para realização do forall posteriormente*/

		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nr_sequencia 		:= nr_seq_fis_sef_edoc_e020_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).dt_atualizacao 		:= clock_timestamp();
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nm_usuario 		:= current_setting('fis_sef_edoc_reg_lfpd05_pck.nm_usuario_w')::usuario.nm_usuario%type;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).dt_atualizacao_nrec	:= clock_timestamp();
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nm_usuario_nrec 		:= current_setting('fis_sef_edoc_reg_lfpd05_pck.nm_usuario_w')::usuario.nm_usuario%type;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_reg 			:= 'E020';
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_ind_oper		:= vetrege020[i].cd_ind_oper;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_ind_emit		:= vetrege020[i].cd_ind_emit;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_part			:= vetrege020[i].cd_part;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_mod			:= vetrege020[i].cd_mod;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_sit			:= cd_sit_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_ser			:= substr(vetrege020[i].cd_ser,1,3);
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nr_doc			:= substr(vetrege020[i].nr_doc,1,9);
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).ds_chv_nfe		:= vetrege020[i].ds_chv_nfe;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).dt_doc			:= vetrege020[i].dt_doc;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).dt_emissao		:= vetrege020[i].dt_emissao;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_nat			:= vetrege020[i].cd_nat;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_cop			:= vetrege020[i].cd_cop;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nr_lcto			:= vetrege020[i].nr_lcto;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_ind_pgto		:= vetrege020[i].cd_ind_pgto;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_cont			:= vetrege020[i].vl_cont;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_op_iss		:= vetrege020[i].vl_op_iss;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_bc_icms		:= vl_bc_icms_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_icms			:= vl_icms_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_icms_st		:= vl_icms_st_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_st_e			:= vl_st_e_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_st_s			:= vl_st_s_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_at			:= vetrege020[i].vl_at;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_isnt_icms		:= vl_isnt_icms_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_out_icms		:= vl_out_icms_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_bc_ipi		:= vl_bc_ipi_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_ipi			:= vl_ipi_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_isnt_ipi		:= vl_isnt_ipi_w;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).vl_out_ipi		:= vl_out_ipi_w;
		if (vetrege020[i](.ds_observacao IS NOT NULL AND .ds_observacao::text <> '')) then
			current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).cd_inf_obs	:= current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_cod_0450_w')::fis_sef_edoc_controle.nr_cod_0450%type;
		end if;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nr_seq_nota		:= vetrege020[i].nr_seq_nota;
		current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020(current_setting('fis_sef_edoc_reg_lfpd05_pck.qt_cursor_e020_w')::bigint).nr_seq_controle		:= current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_seq_controle_w')::fis_sef_edoc_controle.nr_sequencia%type;

		/*Quando a quantidade de registros no array do e025 for superior ou igual a 1000 deve-se gravar primeiro o
		registro e020 depois o e025*/
		if (current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e025_w')::registro_e025.count >= 1000) then
			begin

			CALL fis_sef_edoc_reg_lfpd05_pck.fis_gravar_reg_e020_e025_edoc();

			end;
		end if;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_e020 */
end loop;
close c_reg_e020;

if (current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e025_w')::registro_e025.count > 0) or (current_setting('fis_sef_edoc_reg_lfpd05_pck.fis_registros_e020_w')::registro_e020.count > 0) then
	begin

	CALL fis_sef_edoc_reg_lfpd05_pck.fis_gravar_reg_e020_e025_edoc();

	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_lfpd05_pck.fis_gerar_reg_e020_edoc () FROM PUBLIC;