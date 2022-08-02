-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_verificar_prest_compl_opme ( nr_seq_auditoria_p bigint, nr_seq_requisicao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Verificar se o prestador executante da requisição possui permissão para complementar
as solicitações de dados de OPME.
Rotina chamada na inclusão de itens, na função OPS - Gestão de Análise de Autorizações
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [   ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_prestador_exec_w		pls_prestador.nr_sequencia%type;
ie_permite_compl_opme_w		pls_auditoria.ie_permite_compl_opme%type;


BEGIN
begin
	select	nr_seq_prestador_exec
	into STRICT	nr_seq_prestador_exec_w
	from	pls_requisicao
	where	nr_sequencia = nr_seq_requisicao_p;
exception
when others then
	nr_seq_prestador_exec_w	:= null;
end;
if (nr_seq_prestador_exec_w IS NOT NULL AND nr_seq_prestador_exec_w::text <> '') then
	ie_permite_compl_opme_w	:= pls_obter_prest_compl_opme( nr_seq_requisicao_p, nr_seq_prestador_exec_w );

	if (ie_permite_compl_opme_w = 'S') then
		update	pls_auditoria
		set 	ie_permite_compl_opme 	= ie_permite_compl_opme_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia = nr_seq_auditoria_p;
		commit;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_verificar_prest_compl_opme ( nr_seq_auditoria_p bigint, nr_seq_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;

