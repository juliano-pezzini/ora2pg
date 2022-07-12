-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_coletivo_pck.alimentar_vetor_contratos ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, dt_rescisao_p timestamp, nr_contrato_p pls_contrato.nr_contrato%type) AS $body$
DECLARE


tx_reajuste_liminar_w		pls_processo_judicial_reaj.tx_reajuste%type;
nr_seq_processo_w		processo_judicial_liminar.nr_sequencia%type;


BEGIN

pls_obter_processo_reaj(nr_seq_contrato_p, null, null, null, current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.dt_reajuste, nr_seq_processo_w, tx_reajuste_liminar_w);

if (coalesce(nr_seq_reaj_coletivo_p::text, '') = '') then
	tb_tx_reajuste_copartic_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste_copartic;
	tb_tx_reajuste_copartic_max_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste_copartic_max;
	tb_ie_reaj_nao_aplicado_w(nr_indice_contrato_w)		:= null;
	tb_ie_status_w(nr_indice_contrato_w)			:= '1';
	tb_tx_reajuste_proposto_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste_proposto;
	tb_tx_reajuste_inscricao_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste_inscricao;
	tb_nr_seq_tipo_reajuste_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.nr_seq_tipo_reajuste;
	if	((nr_seq_processo_w IS NOT NULL AND nr_seq_processo_w::text <> '') and (coalesce(tx_reajuste_liminar_w, 0) <> 0)) then
		tb_tx_reajuste_w(nr_indice_contrato_w)		:= tx_reajuste_liminar_w;
	else
		tb_tx_reajuste_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_reajuste;
	end if;
	tb_ie_reajustar_copartic_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.ie_reajustar_copartic;
	tb_ie_reajustar_inscricao_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.ie_reajustar_inscricao;
	tb_ie_reajustar_via_adic_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.ie_reajustar_via_adic;
	tb_tx_via_adicional_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.tx_via_adicional;
	tb_ie_reajusta_vl_manutencao_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.ie_reajustar_vl_manutencao;
	tb_dt_aplicacao_reajuste_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.dt_aplicacao_reajuste;
else
	tb_tx_reajuste_proposto_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_proposto;
	tb_nr_seq_tipo_reajuste_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.nr_seq_tipo_reajuste;
	if	((nr_seq_processo_w IS NOT NULL AND nr_seq_processo_w::text <> '') and (coalesce(tx_reajuste_liminar_w, 0) <> 0)) then
		tb_tx_reajuste_w(nr_indice_contrato_w)		:= tx_reajuste_liminar_w;
	else
		tb_tx_reajuste_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_programado;
	end if;
	tb_ie_reajustar_copartic_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_copartic;
	tb_ie_reajustar_inscricao_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_tx_inscricao;
	tb_ie_reajustar_via_adic_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_via_cart;
	tb_tx_via_adicional_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_programado;
	tb_ie_reajusta_vl_manutencao_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_vl_manutencao;
	tb_dt_aplicacao_reajuste_w(nr_indice_contrato_w)	:= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.dt_aplicacao_reajuste;
	
	if (current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_via_cart = 'S') then
		tb_tx_via_adicional_w(nr_indice_contrato_w)	:= coalesce(current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_via_cart, current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_programado);
	else
		tb_tx_via_adicional_w(nr_indice_contrato_w)	:= null;
	end if;
	
	if (current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_tx_inscricao = 'S') then
		tb_tx_reajuste_inscricao_w(nr_indice_contrato_w) := coalesce(current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_inscricao, current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_programado);
	else
		tb_tx_reajuste_inscricao_w(nr_indice_contrato_w) := null;
	end if;
	
	if (current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.ie_reajustar_copartic = 'S') then
		tb_tx_reajuste_copartic_w(nr_indice_contrato_w)	:= coalesce(current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_copartic, current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_programado);
		tb_tx_reajuste_copartic_max_w(nr_indice_contrato_w) := coalesce(current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_copartic_max, current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.tx_reajuste_programado);
	else
		tb_tx_reajuste_copartic_w(nr_indice_contrato_w) := null;
		tb_tx_reajuste_copartic_max_w(nr_indice_contrato_w) := null;
	end if;
	
	if (current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%coalesce(rowtype.tx_reajuste_programado::text, '') = '') then
		if (current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%(rowtype.nr_seq_tipo_reajuste IS NOT NULL AND rowtype.nr_seq_tipo_reajuste::text <> '')) then
			select	coalesce(max(ie_sem_reajuste),'N')
			into STRICT	ie_sem_reajuste_w
			from	pls_tipo_reajuste
			where	nr_sequencia	= current_setting('pls_reajuste_coletivo_pck.pls_prog_reaj_coletivo_w')::pls_prog_reaj_coletivo%rowtype.nr_seq_tipo_reajuste;
			
			if (ie_sem_reajuste_w = 'S') then
				tb_ie_status_w(nr_indice_contrato_w)	:= '2';
				tb_ie_reaj_nao_aplicado_w(nr_indice_contrato_w)	:= 'S';
			else
				tb_ie_status_w(nr_indice_contrato_w)	:= '1';
				tb_ie_reaj_nao_aplicado_w(nr_indice_contrato_w)	:= 'N';
			end if;
		else
			tb_ie_reaj_nao_aplicado_w(nr_indice_contrato_w)	:= 'N';
			tb_ie_status_w(nr_indice_contrato_w)		:= '1';
		end if;
	else
		tb_ie_reaj_nao_aplicado_w(nr_indice_contrato_w)	:= 'N';
		tb_ie_status_w(nr_indice_contrato_w)		:= '1';
	end if;
end if;

tb_nr_seq_processo_contrato_w(nr_indice_contrato_w)	:= nr_seq_processo_w;
tb_nr_seq_reajuste_w(nr_indice_contrato_w)		:= current_setting('pls_reajuste_coletivo_pck.pls_reajuste_w')::pls_reajuste%rowtype.nr_sequencia;
tb_nr_seq_contrato_w(nr_indice_contrato_w)		:= nr_seq_contrato_p;
tb_nr_contrato_w(nr_indice_contrato_w)			:= nr_contrato_p;
tb_nr_seq_intercambio_w(nr_indice_contrato_w)		:= nr_seq_intercambio_p;
nr_indice_contrato_w	:= nr_indice_contrato_w + 1;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_coletivo_pck.alimentar_vetor_contratos ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, dt_rescisao_p timestamp, nr_contrato_p pls_contrato.nr_contrato%type) FROM PUBLIC;
