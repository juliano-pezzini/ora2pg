-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.aceitar_portabilidade ( nr_seq_portabilidade_p pls_portab_pessoa.nr_sequencia%type, nr_seq_motivo_recusa_p pls_portab_motivo_recusa.nr_sequencia%type, ie_aceita_portabilidade_p text, cd_pessoa_usuario_p pessoa_fisica.cd_pessoa_fisica%type, ie_retorno_aceite_p INOUT text, ds_mensagem_erro_p INOUT text) AS $body$
DECLARE


current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type		usuario.nm_usuario%type;


BEGIN
--Encontra o usuario
begin
select	max(nm_usuario)
into STRICT	current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type
from	usuario
where	cd_pessoa_fisica = cd_pessoa_usuario_p
and	ie_situacao = 'A';
exception
when others then
	PERFORM set_config('pls_obj_plussoft_pck.nm_usuario_w', null, false);
end;
--Aceitar
if (ie_aceita_portabilidade_p = 'S') then
	begin
	CALL pls_portab_aceitar_solic(nr_seq_portabilidade_p,'plusoft');
	ie_retorno_aceite_p := 'Aceita';
	exception
	when others then
		ds_mensagem_erro_p := substr(sqlerrm(SQLSTATE),1,255);
	end;
--Recusar
elsif (ie_aceita_portabilidade_p = 'N') then
	begin
	CALL pls_portab_recusar_solic(nr_seq_portabilidade_p,nr_seq_motivo_recusa_p,current_setting('pls_obj_plussoft_pck.nm_usuario_w')::usuario.nm_usuario%type);
	ie_retorno_aceite_p := 'Recusada';
	exception
	when others then
		ds_mensagem_erro_p := substr(sqlerrm(SQLSTATE),1,255);
	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.aceitar_portabilidade ( nr_seq_portabilidade_p pls_portab_pessoa.nr_sequencia%type, nr_seq_motivo_recusa_p pls_portab_motivo_recusa.nr_sequencia%type, ie_aceita_portabilidade_p text, cd_pessoa_usuario_p pessoa_fisica.cd_pessoa_fisica%type, ie_retorno_aceite_p INOUT text, ds_mensagem_erro_p INOUT text) FROM PUBLIC;
