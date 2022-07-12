-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.gerencia_vl_base_acumulado ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, ie_tipo_tributo_p tributo.ie_tipo_tributo%type, ie_vencimento_p tributo.ie_vencimento%type, ie_apura_piso_p tributo.ie_apuracao_piso%type, ie_rest_estab_p tributo.ie_restringe_estab%type, ie_baixa_titulo_p tributo.ie_baixa_titulo%type, ie_corpo_item_p tributo.ie_corpo_item%type, ie_repasse_titulo_p tributo.ie_repasse_titulo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_base_calc_w		integer;


BEGIN

-- verifica se gerou algum registro para o tributo neste lote de pagamento

-- pela analise feita entendi que so e necessario buscar a base acumulada quando o tributo for para PF

-- por isso e colocado uma restricao por ie_pf_pj sendo Ambos ou PF

select	count(1)
into STRICT	qt_base_calc_w
from	tributo b
where	b.cd_tributo = cd_tributo_p
and	b.ie_pf_pj in ('A', 'PF')
and 	exists (	SELECT	1
			from	pls_pp_base_atual_trib a
			where	a.nr_seq_lote = nr_seq_lote_p
			and	a.cd_tributo = b.cd_tributo);

-- se gerou registro entao carrega a base de calculo acumulada

if (qt_base_calc_w > 0) then

	-- atualmente as cartas de retencao servem apenas para o INSS (cadastro completo de pessoas > tributo)

	if (ie_tipo_tributo_p = 'INSS') then
		CALL pls_pp_tributacao_pck.gera_base_acum_carta( nr_seq_lote_p, cd_tributo_p, cd_estabelecimento_p, nm_usuario_p);
	end if;
	-- Poder migrar INSS e IR	

	--if	(ie_tipo_tributo_p in ('IR','INSS')) then

	--	pls_pp_tributacao_pck.gera_base_acum_pgto_venc_trib( nr_seq_lote_p, cd_tributo_p, cd_estabelecimento_p, nm_usuario_p);

	--end if;


	-- verifica se o checkbox esta marcado para considerar todos os processos do tasy onde pode ser calculado o tributo

	-- feito uma rotina para cada processo pois sao tabelas distintas e caso seja necessario um tratamento especifico podemos

	-- realizar sem impactar nos demais

	if (ie_apura_piso_p = 'S') then

		-- alimenta a base acumulada de titulo a pagar com os valores que ainda nao fazem parte da competencia

		CALL pls_pp_tributacao_pck.gera_base_acum_tit_pagar_imp(	nr_seq_lote_p, cd_tributo_p, ie_rest_estab_p,
						ie_vencimento_p, ie_baixa_titulo_p, cd_estabelecimento_p, 
						nm_usuario_p);

		-- verifica se o tributo na nota e gerado no vencimento ou no corpo da nota (quando for item tambem e considerado corpo)

		if (ie_corpo_item_p = 'V') then

			-- alimenta a base acumulada de nota fiscais quando o tributo e retido no corpo da nota com os valores que ainda nao fazem parte da competencia

			CALL pls_pp_tributacao_pck.gera_base_acum_nf_venc_trib(	nr_seq_lote_p, cd_tributo_p, ie_rest_estab_p,
							ie_vencimento_p, cd_estabelecimento_p, nm_usuario_p);

		else

			-- alimenta a base acumulada de nota fiscais quando o tributo e retido no vencimento da nota com os valores que ainda nao fazem parte da competencia

			CALL pls_pp_tributacao_pck.gera_base_acum_nf_corpo_trib(	nr_seq_lote_p, cd_tributo_p, ie_rest_estab_p,
							ie_vencimento_p, cd_estabelecimento_p, nm_usuario_p);
		end if;
		
		-- alimenta a base acumulada de repasse de terceiros com os valores que ainda nao fazem parte da competencia

		CALL pls_pp_tributacao_pck.gera_base_acum_repasse_terc(	nr_seq_lote_p, cd_tributo_p, ie_rest_estab_p,
						ie_vencimento_p, ie_repasse_titulo_p, cd_estabelecimento_p, 
						nm_usuario_p);
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.gerencia_vl_base_acumulado ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, ie_tipo_tributo_p tributo.ie_tipo_tributo%type, ie_vencimento_p tributo.ie_vencimento%type, ie_apura_piso_p tributo.ie_apuracao_piso%type, ie_rest_estab_p tributo.ie_restringe_estab%type, ie_baixa_titulo_p tributo.ie_baixa_titulo%type, ie_corpo_item_p tributo.ie_corpo_item%type, ie_repasse_titulo_p tributo.ie_repasse_titulo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
