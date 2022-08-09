-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincula_resp_credito_cir ( nr_cirurgia_p resp_credito_cir.nr_cirurgia%type, ie_responsavel_credito_p resp_credito_cir.ie_responsavel_credito%type, cd_pessoa_fisica_p resp_credito_cir.cd_pessoa_fisica%type, nm_usuario_p resp_credito_cir.nm_usuario%type, cd_estabelecimento_p resp_credito_cir.cd_estabelecimento%type, nr_seq_item_p pepo_item.nr_sequencia%type) AS $body$
DECLARE


ie_acao_w bigint;
ie_funcao_w resp_credito_cir.ie_funcao%type;


BEGIN
	if (ie_responsavel_credito_p IS NOT NULL AND ie_responsavel_credito_p::text <> '') then

		select 	count(1)
		into STRICT 	ie_acao_w
		from 	resp_credito_cir
		where 	nr_cirurgia = nr_cirurgia_p
		and 	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
		if ((nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and nr_seq_item_p = 16) then
			ie_funcao_w := 'A';
		else
			ie_funcao_w := 'C';
		end if;
			

		if ( ie_acao_w = 0 ) then
			insert into resp_credito_cir(ie_funcao, nm_usuario, cd_pessoa_fisica, ie_responsavel_credito, nr_cirurgia, cd_estabelecimento)
			values (ie_funcao_w, nm_usuario_p, cd_pessoa_fisica_p, ie_responsavel_credito_p, nr_cirurgia_p, cd_estabelecimento_p);
		else
			update 	resp_credito_cir
			set 	ie_responsavel_credito = ie_responsavel_credito_p
			where 	nr_cirurgia = nr_cirurgia_p
			and 	cd_pessoa_fisica = cd_pessoa_fisica_p;
		end if;

		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincula_resp_credito_cir ( nr_cirurgia_p resp_credito_cir.nr_cirurgia%type, ie_responsavel_credito_p resp_credito_cir.ie_responsavel_credito%type, cd_pessoa_fisica_p resp_credito_cir.cd_pessoa_fisica%type, nm_usuario_p resp_credito_cir.nm_usuario%type, cd_estabelecimento_p resp_credito_cir.cd_estabelecimento%type, nr_seq_item_p pepo_item.nr_sequencia%type) FROM PUBLIC;
