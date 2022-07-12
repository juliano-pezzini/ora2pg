-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.gerar_comunicacao_interna ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


vl_apresentado_w	double precision;

C01 CURSOR(nr_seq_lote_protocolo_pc	pls_lote_protocolo_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.nr_protocolo_prestador,
		a.nr_seq_prestador,
		(SELECT	max(x.nm_interno)
		from	pls_prestador x
		where	x.nr_sequencia	= a.nr_seq_prestador) nm_prestador,
		a.nr_seq_transacao,
		a.ds_hash
	from	pls_protocolo_conta a
	where	a.nr_seq_lote_conta	= nr_seq_lote_protocolo_pc
	and	a.ie_situacao		= 'A';

BEGIN

for r_c01_w in C01(nr_seq_lote_protocolo_p) loop
	
	vl_apresentado_w	:= coalesce(pls_obter_valor_protocolo(r_c01_w.nr_sequencia, 'TC'), 0);
	
	CALL pls_gerar_comunic_conta(1,	
			'Protocolo: ' || to_char(r_c01_w.nr_sequencia) || chr(13) ||
			'N_ do protocolo no prestador: ' || r_c01_w.nr_seq_prestador || chr(13) ||
			'Data integracao: ' || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') || chr(13) ||
			'Usuario integracao: ' || nm_usuario_p || chr(13) ||
			'Prestador: ' || to_char(r_c01_w.nr_seq_prestador) || ' - ' || r_c01_w.nm_prestador || chr(13) ||
			'Valor apresentado: ' || to_char(vl_apresentado_w) || chr(13) ||
			'Transacao TISS: ' || r_c01_w.nr_seq_prestador || chr(13) ||
			'Hash: ' || r_c01_w.ds_hash,
			nm_usuario_p,cd_estabelecimento_p);
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.gerar_comunicacao_interna ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
