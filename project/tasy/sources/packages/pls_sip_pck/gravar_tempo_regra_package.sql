-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Gerencia a gravacao do tempo de geracao da regra



CREATE OR REPLACE PROCEDURE pls_sip_pck.gravar_tempo_regra ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nr_seq_regra_p sip_item_assist_regra_nv.nr_sequencia%type, ie_inicio_fim_p text, ds_sql_p sip_nv_tempo_regra.ds_sql%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

				
nr_sequencia_w	sip_nv_tempo_regra.nr_sequencia%type;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '' AND nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then

	if (ie_inicio_fim_p = 'INICIO') then
		
		CALL pls_sip_pck.insere_tempo_regra(nr_seq_lote_p, nr_seq_regra_p, substr(ds_sql_p, 1, 4000), nm_usuario_p);
				
	elsif (ie_inicio_fim_p = 'FIM') then
	
		select	max(a.nr_sequencia)
		into STRICT	nr_sequencia_w
		from	sip_nv_tempo_regra a
		where	a.nr_seq_lote	= nr_seq_lote_p
		and	a.nr_seq_regra	= nr_seq_regra_p;
		
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		
			CALL pls_sip_pck.atualiza_tempo_regra(nr_sequencia_w, ie_inicio_fim_p, nm_usuario_p);
		end if;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.gravar_tempo_regra ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nr_seq_regra_p sip_item_assist_regra_nv.nr_sequencia%type, ie_inicio_fim_p text, ds_sql_p sip_nv_tempo_regra.ds_sql%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
