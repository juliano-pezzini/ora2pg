-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- gera outro protocolo para abertura do participante
CREATE OR REPLACE PROCEDURE pls_cta_gera_hono_cirurgia_pck.gera_protocolo_abert_conta ( nr_seq_protocolo_origem_p pls_protocolo_conta.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_protocolo_p INOUT pls_protocolo_conta.nr_sequencia%type, ie_gerou_novo_p INOUT text) AS $body$
DECLARE

					
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;


BEGIN

	ie_gerou_novo_p := 'N';
	
	select  nextval('pls_protocolo_conta_seq')
	into STRICT    nr_seq_protocolo_w
	;
	ie_gerou_novo_p := 'S';

	insert into pls_protocolo_conta(nr_sequencia, nm_usuario, dt_atualizacao,
		nm_usuario_nrec, dt_atualizacao_nrec, ie_situacao,
		ie_status, dt_mes_competencia, cd_estabelecimento,
		ie_tipo_guia, ie_apresentacao, dt_protocolo,
		nr_seq_prestador, nr_protocolo_prestador, qt_contas_informadas,
		dt_base_venc, ie_tipo_protocolo, nr_seq_prot_referencia,
		nr_seq_outorgante, ie_guia_fisica, nr_seq_lote_conta,
		dt_recebimento, ie_origem_protocolo, ie_tipo_importacao,
		dt_integracao)
	SELECT	nr_seq_protocolo_w, nm_usuario_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), ie_situacao,
		1, dt_mes_competencia, cd_estabelecimento_p,
		ie_tipo_guia_p, ie_apresentacao, dt_protocolo,
		nr_seq_prestador, nr_protocolo_prestador, null,
		clock_timestamp(), 'C', nr_seq_protocolo_origem_p,
		(SELECT	max(nr_sequencia)
		 from    pls_outorgante
		 where   cd_estabelecimento = cd_estabelecimento_p), ie_guia_fisica, nr_seq_lote_conta,
		dt_recebimento, ie_origem_protocolo, ie_tipo_importacao,
		dt_integracao
	from	pls_protocolo_conta_v
	where	nr_sequencia = nr_seq_protocolo_origem_p;

	nr_seq_protocolo_p := nr_seq_protocolo_w;
			
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_gera_hono_cirurgia_pck.gera_protocolo_abert_conta ( nr_seq_protocolo_origem_p pls_protocolo_conta.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_protocolo_p INOUT pls_protocolo_conta.nr_sequencia%type, ie_gerou_novo_p INOUT text) FROM PUBLIC;