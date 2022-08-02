-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_relat_utili_bene_nov ( ds_login_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

						
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
nr_id_transacao_w	w_pls_utilizacao_benef.nr_id_transacao%type;


BEGIN

select	max(a.nr_sequencia)
into STRICT	nr_seq_segurado_w
from	pls_segurado 		a,
	wsuite_usuario 		b
where 	a.nr_sequencia 		= b.nr_seq_segurado
and	b.ds_login		= ds_login_p
and	a.cd_estabelecimento	= cd_estabelecimento_p;

nr_id_transacao_w := pls_utilizacao_benef_pck.gerar_utilizacao_benef(	nr_seq_segurado_w, dt_inicio_p, dt_fim_p, nm_usuario_p, cd_estabelecimento_p, nr_id_transacao_w, null);
							
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_relat_utili_bene_nov ( ds_login_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

