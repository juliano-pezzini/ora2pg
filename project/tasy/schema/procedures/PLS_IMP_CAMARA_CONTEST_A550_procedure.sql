-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_camara_contest_a550 ( ds_conteudo_p text, nm_usuario_p text, nr_seq_camara_contest_p bigint, ie_versao_p INOUT text, nr_seq_referencia_p INOUT bigint, cd_estabelecimento_p bigint, nr_seq_camara_cont_p INOUT bigint, ie_commit_p text default 'S') AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
OPS - Controle de Contestacoes
Finalidade: Importar o arquivo A550.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:	

04 - 3.8	05 - 4.0	06 - 4.1	07 - 4.1A	08 - 4.1B	09 - 5.0	
10 - 5.0a	11 - 6.0	12 - 6.3	13 - 7.0	14 - 8.0	15 - 9.0
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/				

BEGIN
-- OBTER A VERSAO DE TRANSACAO
if (coalesce(ie_versao_p::text, '') = '') then
	select	substr(ds_conteudo_p,105,2)
	into STRICT	ie_versao_p
	;
end if;

if	((trim(both substr(ds_conteudo_p,9,2)) is not null) and ((substr(ds_conteudo_p,9,2) <> '55') and (substr(ds_conteudo_p,9,2) <> '99'))) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(276607);
end if;

-- VERSAO PTU 4.1B (INFERIOR)
if (ie_versao_p in ('04','05','06','07','08')) then
	nr_seq_referencia_p := pls_imp_camara_contest_v41b( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p);

-- VERSAO PTU 5.0
elsif (ie_versao_p in ('09','10')) then
	nr_seq_referencia_p := pls_imp_camara_contest_v50( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p);

-- VERSAO PTU 6.0
elsif (ie_versao_p in ('11')) then
	nr_seq_referencia_p := pls_imp_camara_contest_v60( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p);

-- VERSAO PTU 6.3
elsif (ie_versao_p in ('12')) then
	nr_seq_referencia_p := pls_imp_camara_contest_v63( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p);

-- VERSAO PTU 7.0
elsif (ie_versao_p in ('13')) then
	nr_seq_referencia_p := pls_imp_camara_contest_v70( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p);
	
-- VERSAO PTU 8.0
elsif (ie_versao_p in ('14')) then
	SELECT * FROM pls_imp_camara_contest_v80( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p, nr_seq_camara_cont_p) INTO STRICT nr_seq_referencia_p, nr_seq_camara_cont_p;
	
-- VERSAO PTU 9.0
elsif (ie_versao_p in ('15')) then
	SELECT * FROM pls_imp_camara_contest_v90( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p, nr_seq_camara_cont_p) INTO STRICT nr_seq_referencia_p, nr_seq_camara_cont_p;
	
-- VERSAO PTU 9.1
elsif (ie_versao_p in ('16')) then
	SELECT * FROM pls_imp_camara_contest_v91( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p, nr_seq_camara_cont_p) INTO STRICT nr_seq_referencia_p, nr_seq_camara_cont_p;

-- VERSAO PTU 11.0
elsif (ie_versao_p in ('17', '18')) then
	SELECT * FROM pls_imp_camara_contest_v110( ds_conteudo_p, nm_usuario_p, nr_seq_camara_contest_p, nr_seq_referencia_p, cd_estabelecimento_p, nr_seq_camara_cont_p) INTO STRICT nr_seq_referencia_p, nr_seq_camara_cont_p;
end if;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_camara_contest_a550 ( ds_conteudo_p text, nm_usuario_p text, nr_seq_camara_contest_p bigint, ie_versao_p INOUT text, nr_seq_referencia_p INOUT bigint, cd_estabelecimento_p bigint, nr_seq_camara_cont_p INOUT bigint, ie_commit_p text default 'S') FROM PUBLIC;

