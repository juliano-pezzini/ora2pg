-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_envio_pacote_a1200 ( nr_seq_pacote_p ptu_pacote.nr_sequencia%type, cd_interface_p interface.cd_interface%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [X]  Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------


PTU 7.0 - 02		PTU 8.0 - 03		PTU 9.0 - 04		PTU 11.0a - 05
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 

nr_seq_arquivo_w		ptu_pacote.nr_seq_arquivo%type;
cd_unimed_origem_w		ptu_pacote.cd_unimed_origem%type;
dt_atual_w			timestamp := trunc(clock_timestamp());
ds_arquivo_w			ptu_pacote.ds_arquivo%type;
	

BEGIN
select	max(nr_seq_arquivo),
	max(cd_unimed_origem)
into STRICT	nr_seq_arquivo_w,
	cd_unimed_origem_w
from	ptu_pacote
where	nr_sequencia	= nr_seq_pacote_p;

if (coalesce(nr_seq_arquivo_w::text, '') = '') then
	select	coalesce(max(nr_seq_arquivo),0) + 1
	into STRICT	nr_seq_arquivo_w
	from	ptu_pacote
	where	trunc(dt_geracao_arquivo)	= dt_atual_w
	and	cd_unimed_origem		= cd_unimed_origem_w
	and	nr_sequencia			<> nr_seq_pacote_p;
end if;

-- Atualizar a versao do PTU da fatura
update	ptu_pacote
set	nr_versao_transacao	= CASE WHEN cd_interface_p='2750' THEN '02' WHEN cd_interface_p='2787' THEN '03' WHEN cd_interface_p='2837' THEN '04' WHEN cd_interface_p='3073' THEN '05' WHEN cd_interface_p='3153' THEN '06' WHEN cd_interface_p='08' THEN nr_versao_transacao END ,
	nr_seq_arquivo		= nr_seq_arquivo_w,
	dt_geracao_arquivo	= clock_timestamp(),
	nm_usuario_arq		= nm_usuario_p
where	nr_sequencia		= nr_seq_pacote_p;

if (cd_interface_p = '2750') then
	CALL ptu_gerar_a1200_70( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);
	
elsif (cd_interface_p = '2787') then
	CALL ptu_gerar_a1200_80( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);
	
elsif (cd_interface_p = '2837') then
	CALL ptu_gerar_a1200_90( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);

elsif (cd_interface_p = '3073') then
	CALL ptu_gerar_a1200_11( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);

elsif (cd_interface_p = '3153') then
	CALL ptu_gerar_a1200_11_3( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);
	
elsif (cd_interface_p = '3232') then
	CALL ptu_gerar_a1200_12_0( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);

elsif (cd_interface_p = '10107') then
	CALL ptu_gerar_a1200_13_0( nr_seq_pacote_p, cd_interface_p, cd_estabelecimento_p, nm_usuario_p);
end if;

-- Atualizar o nome do arquivo
ds_arquivo_w :=	ptu_obter_nome_exportacao(nr_seq_pacote_p,'PC',cd_interface_p);

update	ptu_pacote
set	ds_arquivo	= ds_arquivo_w
where	nr_sequencia	= nr_seq_pacote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_envio_pacote_a1200 ( nr_seq_pacote_p ptu_pacote.nr_sequencia%type, cd_interface_p interface.cd_interface%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

