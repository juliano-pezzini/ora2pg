-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_pls_sip_pck ( nr_seq_lote_sip_p bigint, ie_opcao text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_recarrega_contas_p text default 'S') AS $body$
DECLARE


ie_sip_w		pls_controle_estab.ie_sip%type;


BEGIN
if (nr_seq_lote_sip_p IS NOT NULL AND nr_seq_lote_sip_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	if (ie_opcao = 'PLS_ATUALIZAR_EXPOSTO_SIP') then
		CALL pls_sip_pck.pls_atualizar_exposto_sip(nr_seq_lote_sip_p, ie_sip_w, nm_usuario_p, cd_estabelecimento_p);
	elsif (ie_opcao = 'GERAR_SIP') then
		CALL pls_sip_pck.gerar_sip(nr_seq_lote_sip_p, nm_usuario_p, cd_estabelecimento_p, ie_recarrega_contas_p);
	elsif (ie_opcao = 'INATIVAR_SIP') then
		CALL pls_sip_pck.inativar_sip(nr_seq_lote_sip_p, nm_usuario_p, cd_estabelecimento_p);
	elsif (ie_opcao = 'CONSISTIR_LOTE') then
		CALL pls_sip_pck.consistir_lote(nr_seq_lote_sip_p, nm_usuario_p, cd_estabelecimento_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_pls_sip_pck ( nr_seq_lote_sip_p bigint, ie_opcao text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_recarrega_contas_p text default 'S') FROM PUBLIC;

