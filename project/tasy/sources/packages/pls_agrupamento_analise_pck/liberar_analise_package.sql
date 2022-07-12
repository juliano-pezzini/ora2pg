-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_agrupamento_analise_pck.liberar_analise ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_protocolo_w	pls_protocolo_conta.nr_sequencia%type;
nr_seq_lote_conta_w	pls_protocolo_conta.nr_seq_lote_conta%type;
ds_retorno_w		varchar(255);
C01 CURSOR(nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type)FOR
	SELECT	conta.nr_sequencia,
		conta.nr_seq_lote_conta_orig,
		prot.nr_seq_prestador,
		prot.ie_tipo_guia,
		prot.nr_sequencia nr_seq_protocolo
	from	pls_conta		conta,
		pls_protocolo_conta	prot
	where	conta.nr_seq_analise	= nr_seq_analise_pc
	and	conta.nr_seq_protocolo	= prot.nr_sequencia;

BEGIN

for r_c01_w in C01(nr_seq_analise_p) loop
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_protocolo_w
	from	pls_protocolo_conta
	where	nr_seq_lote_conta	= r_c01_w.nr_seq_lote_conta_orig
	and	nr_seq_prestador	= r_c01_w.nr_seq_prestador
	and	ie_tipo_guia		= r_c01_w.ie_tipo_guia;
	
	if (coalesce(nr_seq_protocolo_w::text, '') = '') then
		begin
		SELECT * FROM pls_agrupamento_analise_pck.gera_protocolo_conta(	r_c01_w.nr_seq_protocolo, r_c01_w.ie_tipo_guia, r_c01_w.nr_seq_lote_conta_orig, nm_usuario_p, cd_estabelecimento_p, nr_seq_protocolo_w, ds_retorno_w) INTO STRICT nr_seq_protocolo_w, ds_retorno_w;
	        end;
        end if;
	
	update	pls_conta
	set		nr_seq_protocolo	= nr_seq_protocolo_w,
			ie_status			= 'A'
	where	nr_sequencia		= r_c01_w.nr_sequencia;

	update	pls_analise_conta
	set	nr_seq_lote_protocolo	= r_c01_w.nr_seq_lote_conta_orig,
		ie_status		= 'G'
	where	nr_sequencia		= nr_seq_analise_p;
	
	CALL pls_gravar_log_conta( r_c01_w.nr_sequencia, null, null,
			'liberar_analise - Liberacao de analise em lotes pendentes pelo Controle de producao medica', nm_usuario_p);
	
	/* Gerar valores */


	CALL pls_gerar_valores_protocolo(nr_seq_protocolo_w, nm_usuario_p);
	/* Alterar status */


	CALL pls_altera_status_protocolo(nr_seq_protocolo_w, 'L', 'N', cd_estabelecimento_p, nm_usuario_p);
	
	
	
	end;
end loop;

CALL pls_tratar_analise_consistida(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_agrupamento_analise_pck.liberar_analise ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;