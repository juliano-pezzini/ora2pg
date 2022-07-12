-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Registro c020: documento - nota fiscal (código 01), nota fiscal de produtor (código 04) e nota fiscal eletrônica (código 55)*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_extrato_pck.fis_gerar_reg_c020_edoc () AS $body$
DECLARE


nr_seq_fis_sef_edoc_c020_w	fis_sef_edoc_c020.nr_sequencia%type;
cd_sit_w			fis_efd_icmsipi_C100.cd_sit%type	:= null;

c_reg_c020 CURSOR FOR
	SELECT	CASE WHEN e.ie_operacao_fiscal='S' THEN  1  ELSE 0 END  											cd_ind_oper,
		CASE WHEN e.ie_operacao_fiscal='S' THEN  0 WHEN e.ie_operacao_fiscal='E' THEN  CASE WHEN ie_tipo_nota='EP' THEN  0  ELSE 1 END  END  							cd_ind_emit,
		CASE WHEN e.ie_operacao_fiscal='E' THEN  coalesce(a.cd_cgc_emitente, a.cd_pessoa_fisica)  ELSE coalesce(cd_cgc,a.cd_pessoa_fisica) END  			cd_part,
		lpad(b.cd_modelo_nf, 2, 0) 													cd_mod,
		a.cd_serie_nf 															cd_ser,
		a.nr_nota_fiscal 														nr_doc,
		a.nr_danfe 															ds_chv_nfe,
		CASE WHEN e.ie_operacao_fiscal='E' THEN  a.dt_emissao  ELSE null END  										dt_emis,
		CASE WHEN e.ie_operacao_fiscal='E' THEN  a.dt_entrada_saida  ELSE a.dt_emissao END  								dt_doc,
		a.cd_natureza_operacao														cd_nat,
		substr(CASE WHEN coalesce(a.cd_condicao_pagamento,0)=0 THEN  2  ELSE CASE WHEN obter_dados_nota_fiscal(a.nr_sequencia, '28')=1 THEN  0  ELSE 1 END  END , 1, 1) 	cd_ind_pgto,
		a.vl_total_nota															vl_doc,
		null																vl_acmo,
		a.vl_frete															vl_frt,
		a.vl_seguro															vl_seg,
		a.vl_despesa_acessoria														vl_out_da,
		null																vl_at,
		null																vl_op_iss,
		null																cd_inf_obs,
		a.nr_sequencia 															nr_seq_nota,
		a.ie_status_envio														ie_status_envio,
		a.ds_observacao															ds_observacao
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
		or (obter_dados_operacao_nota(a.cd_operacao_nf, '6') = 'S'))  		-- Nostas de saida
  and b.nr_sequencia		= nr_seq_modelo_nf_w and a.cd_estabelecimento	= cd_estabelecimento_w;

/*Criação do array com o tipo sendo do cursor eespecificado - c_reg_0150*/

type reg_c_reg_c020 is table of c_reg_c020%RowType;
vetregc020 reg_c_reg_c020;

BEGIN

open c_reg_c020;
loop
fetch c_reg_c020 bulk collect into vetregc020 limit 1000;
	for i in 1 .. vetregc020.Count loop
		begin

		/*Incrementa a variavel para o array*/

		PERFORM set_config('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w', current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint + 1, false);

		/*Incrementar variavel de controle do codigo da observação se tiver observação na nota*/

		if (vetregc020[i](.ds_observacao IS NOT NULL AND .ds_observacao::text <> '')) then
			PERFORM set_config('fis_sef_edoc_reg_extrato_pck.nr_cod_0450_w', current_setting('fis_sef_edoc_reg_extrato_pck.nr_cod_0450_w')::fis_sef_edoc_controle.nr_cod_0450%type + 1, false);
		end if;

		/*Verificação para encontrar  a situação da nota*/

		if (coalesce(vetregc020[i].ie_status_envio, 'XX') <> 'XX') then
			case vetregc020[i].ie_status_envio
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
			if (vetregc020[i].cd_ind_oper = 0) then
				cd_sit_w :=	'00';
			end if;
		end if;

		/*Pega a sequencia da taleba fis_sef_edoc_ para o insert*/

		select	nextval('fis_sef_edoc_c020_seq')
		into STRICT	nr_seq_fis_sef_edoc_c020_w
		;

		CALL fis_sef_edoc_reg_extrato_pck.fis_gerar_reg_c300_edoc(nr_seq_fis_sef_edoc_c020_w,
					vetregc020[i].nr_seq_nota);


		/*Inserindo valores no array para realização do forall posteriormente*/

		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).nr_sequencia 		:= nr_seq_fis_sef_edoc_c020_w;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).dt_atualizacao 		:= clock_timestamp();
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).nm_usuario 		:= current_setting('fis_sef_edoc_reg_extrato_pck.nm_usuario_w')::usuario.nm_usuario%type;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).dt_atualizacao_nrec	:= clock_timestamp();
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).nm_usuario_nrec 		:= current_setting('fis_sef_edoc_reg_extrato_pck.nm_usuario_w')::usuario.nm_usuario%type;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_reg 			:= 'C020';
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_ind_oper		:= vetregc020[i].cd_ind_oper;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_ind_emit		:= vetregc020[i].cd_ind_emit;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_part			:= vetregc020[i].cd_part;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_mod			:= vetregc020[i].cd_mod;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_sit			:= cd_sit_w;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_ser			:= substr(vetregc020[i].cd_ser,1,3);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).nr_doc			:= substr(vetregc020[i].nr_doc,1,9);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).ds_chv_nfe		:= vetregc020[i].ds_chv_nfe;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).dt_doc			:= vetregc020[i].dt_doc;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).dt_emis			:= vetregc020[i].dt_emis;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_doc			:= vetregc020[i].vl_doc;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_ind_pgto		:= vetregc020[i].cd_ind_pgto;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_desc			:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(1);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_merc			:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(2);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_frt			:= vetregc020[i].vl_frt;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_seg			:= vetregc020[i].vl_seg;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_out_da		:= vetregc020[i].vl_out_da;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_bc_icms		:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(3);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_icms			:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(4);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_bc_icms_st		:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(5);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_icms_st		:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(6);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_ipi			:= current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(7);
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_nat			:= vetregc020[i].cd_nat;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_acmo			:= vetregc020[i].vl_acmo;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).vl_op_iss		:= vetregc020[i].vl_op_iss;
		if (vetregc020[i](.ds_observacao IS NOT NULL AND .ds_observacao::text <> '')) then
			current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).cd_inf_obs		:= current_setting('fis_sef_edoc_reg_extrato_pck.nr_cod_0450_w')::fis_sef_edoc_controle.nr_cod_0450%type;
		end if;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).nr_seq_nota		:= vetregc020[i].nr_seq_nota;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(current_setting('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w')::bigint).nr_seq_controle		:= current_setting('fis_sef_edoc_reg_extrato_pck.nr_seq_controle_w')::fis_sef_edoc_controle.nr_sequencia%type;

		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(1) :=	0;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(2) :=	0;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(3) :=	0;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(4) :=	0;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(5) :=	0;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(6) :=	0;
		current_setting('fis_sef_edoc_reg_extrato_pck.fis_totalizador_c300_w')::totalizador_c300(7) :=	0;

		/*Quando a quantidade de registros no array do c300 for superior ou igual a 1000 deve-se gravar primeiro o
		registro c020 depois o c300*/
		if (current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c300_w')::registro_c300.count >= 1000) then
			begin

			CALL fis_sef_edoc_reg_extrato_pck.fis_gravar_reg_c020_c300_edoc();

			end;
		end if;

		end;
	end loop;
EXIT WHEN NOT FOUND; /* apply on c_reg_C020 */
end loop;
close c_reg_C020;

if (current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c300_w')::registro_c300.count > 0) or (current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020.count > 0) then
	begin

	CALL fis_sef_edoc_reg_extrato_pck.fis_gravar_reg_c020_c300_edoc();

	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_extrato_pck.fis_gerar_reg_c020_edoc () FROM PUBLIC;
