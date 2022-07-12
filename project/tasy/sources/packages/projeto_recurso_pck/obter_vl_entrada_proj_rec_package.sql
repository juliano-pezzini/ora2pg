-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>++++++ VALORES DE ENTRADA ++++++<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	--VE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Titiulo a Receber <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	--VE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Controle Bancario <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	/*
	Objetivo: Retornar o valor de entradas via titulo a receber e controle bancario no projeto recurso.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	*/



CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_vl_entrada_proj_rec ( nr_seq_proj_rec_p bigint) RETURNS bigint AS $body$
DECLARE

	
	/* Armazena o valor de entrada */
	
	vl_recebido_w	titulo_receber.vl_titulo%type;
	
	/* Armazena o valor de entrada atraves de titulos a receber */


	vl_total_tr_w	titulo_receber.vl_titulo%type;
	
	/* Armazena o valor de entrada atraves do controle bancario para transferencias do tipo Rendimento*/


	vl_total_cb_w	movto_trans_financ.vl_transacao%type;
	
	
BEGIN	
		select		coalesce(sum(vl_movimento),0)
		into STRICT		vl_recebido_w
		from		projeto_recurso_fin f
		where		f.ie_deb_cred = 'C'
		and			f.nr_seq_proj_rec = nr_seq_proj_rec_p;
	
		select  	coalesce(sum(vl_titulo),0) vl_titulo
		into STRICT		vl_total_tr_w		
		from    	titulo_receber
		where   	nr_seq_proj_rec = nr_seq_proj_rec_p
		and     	ie_situacao = 2;
		
		select  	coalesce(sum(a.vl_transacao),0)
		into STRICT		vl_total_cb_w
		from 		movto_trans_financ a,
				transacao_financeira b
		where 		b.nr_sequencia = a.nr_seq_trans_financ
		and		a.nr_seq_proj_rec = nr_seq_proj_rec_p
		and 		coalesce(a.nr_seq_titulo_pagar::text, '') = ''
		and 		coalesce(a.nr_seq_nota_fiscal::text, '') = ''
		and 		coalesce(a.nr_seq_titulo_receber::text, '') = ''
		and 		(a.nr_seq_banco IS NOT NULL AND a.nr_seq_banco::text <> '')
		and		coalesce(b.ie_proj_rec,'N') <> 'N';
	
		vl_recebido_w := coalesce(vl_recebido_w,0) + coalesce(vl_total_tr_w,0) + coalesce(vl_total_cb_w,0);
						
	return vl_recebido_w;
						
	END;				

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_vl_entrada_proj_rec ( nr_seq_proj_rec_p bigint) FROM PUBLIC;