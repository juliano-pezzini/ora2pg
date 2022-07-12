-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

						

-- Gerar dados PTU_AVISO_PROTOCOLO para envio



CREATE OR REPLACE PROCEDURE ptu_aviso_pck.gerar_dados_ptu_prot_env_a520 (dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
nr_seq_aviso_protocolo_w		ptu_aviso_protocolo.nr_sequencia%type;

c01 CURSOR(	nr_seq_lote_pc	ptu_lote_aviso.nr_sequencia%type) FOR
	SELECT	aa.nr_seq_protocolo,
		(	SELECT	max(coalesce(pc.ie_tipo_guia, x.ie_tipo_guia))
			from	pls_conta		x
			where	x.nr_seq_protocolo	= pc.nr_sequencia) ie_tipo_guia,
		aa.nr_sequencia nr_seq_arquivo,
		aa.nr_seq_congenere,
		(	select	max(x.nr_sequencia)
			from	ptu_aviso_protocolo	x
			where	x.nr_seq_protocolo	= pc.nr_sequencia
			and	x.nr_seq_arquivo	= aa.nr_sequencia) nr_seq_aviso_protocolo
	from	ptu_aviso_arquivo aa,
		pls_protocolo_conta pc
	where	pc.nr_sequencia	= aa.nr_seq_protocolo
	and	aa.nr_seq_lote	= nr_seq_lote_pc;
BEGIN

for r_c01_w in c01( dados_a520_p.nr_seq_lote ) loop

	-- se ja tiver inserido um protocolo, apenas gera as contas

	if (coalesce(r_c01_w.nr_seq_aviso_protocolo::text, '') = '') then
	
		insert into ptu_aviso_protocolo(nr_sequencia,				dt_atualizacao,		nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,	nr_seq_arquivo,
			nr_seq_protocolo,			ie_tipo_guia)
		values (nextval('ptu_aviso_protocolo_seq'),	clock_timestamp(),		nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,		r_c01_w.nr_seq_arquivo,
			r_c01_w.nr_seq_protocolo,		r_c01_w.ie_tipo_guia) returning nr_sequencia into nr_seq_aviso_protocolo_w;
	else
		
		nr_seq_aviso_protocolo_w := r_c01_w.nr_seq_aviso_protocolo;
	end if;
	
	-- Gerar dados PTU_AVISO_CONTA para envio

	CALL ptu_aviso_pck.gerar_dados_ptu_conta_env_a520( nr_seq_aviso_protocolo_w, r_c01_w.nr_seq_congenere, nm_usuario_p, dados_a520_p, dados_gerais_a520_p, alias_p);
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_pck.gerar_dados_ptu_prot_env_a520 (dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
