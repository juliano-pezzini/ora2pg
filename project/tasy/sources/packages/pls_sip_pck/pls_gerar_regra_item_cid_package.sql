-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- chamada diretamente no Delphi e no Java para gerar regras automaticamente



CREATE OR REPLACE PROCEDURE pls_sip_pck.pls_gerar_regra_item_cid ( ds_cd_cid_p text, nr_seq_item_sip_p sip_item_assist_regra_nv.nr_seq_item_assist%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p pls_outorgante.cd_estabelecimento%type) AS $body$
DECLARE


C01 CURSOR(ds_cd_cid_pc	text) FOR
	SELECT  ds_valor_vchr2
	from  	table(pls_util_pck.converter_lista_valores(ds_cd_cid_pc, ','));
BEGIN

if (ds_cd_cid_p IS NOT NULL AND ds_cd_cid_p::text <> '')  then
	for r_C01_w in C01(ds_cd_cid_p) loop
		-- se retornar algum valor grava no banco

		if (r_C01_w.ds_valor_vchr2 IS NOT NULL AND r_C01_w.ds_valor_vchr2::text <> '') then
			insert	into sip_item_assist_regra_nv(	
				nr_sequencia, ie_situacao, nr_seq_item_assist,
				dt_atualizacao, dt_atualizacao_nrec, cd_doenca_cid,
				nm_usuario, nm_usuario_nrec, cd_estabelecimento
			) values (	
				nextval('sip_item_assist_regra_nv_seq'), 'A', nr_seq_item_sip_p,
				clock_timestamp(), clock_timestamp(), r_C01_w.ds_valor_vchr2,
				nm_usuario_p, nm_usuario_p, cd_estabelecimento_p
			);
		end if;
	end loop;
	
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.pls_gerar_regra_item_cid ( ds_cd_cid_p text, nr_seq_item_sip_p sip_item_assist_regra_nv.nr_seq_item_assist%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p pls_outorgante.cd_estabelecimento%type) FROM PUBLIC;
