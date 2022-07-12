-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_resumo_prop_online_pck.finalizar_proposta ( nr_seq_proposta_online_p pls_proposta_online.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

	
	C01 CURSOR(	nr_seq_proposta_online_pc	pls_proposta_online.nr_sequencia%type) FOR
		SELECT	a.*
		from	table(pls_resumo_prop_online_pck.obter_resumo_prop_online(nr_seq_proposta_online_pc, null, 'N')) a;
	
	
BEGIN
	
	for r_c01_w in c01(nr_seq_proposta_online_p) loop
		begin
		insert into 	pls_proposta_online_resumo(	nr_sequencia, nr_seq_proposta, dt_atualizacao,
				nm_usuario, ds_item, nr_seq_benef_proposta,
				vl_item, ie_total, ie_tipo_item)
		values (	nextval('pls_proposta_online_resumo_seq'), nr_seq_proposta_online_p, clock_timestamp(),
				nm_usuario_p, r_c01_w.ds_item, r_c01_w.nr_seq_benef_proposta,
				r_c01_w.vl_item, r_c01_w.ie_total, r_c01_w.ie_tipo_item);
		end;
	end loop;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_resumo_prop_online_pck.finalizar_proposta ( nr_seq_proposta_online_p pls_proposta_online.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
