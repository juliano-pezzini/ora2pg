-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.gravar_plano_sca_proposta ( nr_seq_solicitacao_p INOUT bigint, nr_seq_plano_sca_p bigint, nr_seq_tabela_sca_p bigint, ds_mensagem_erro_p INOUT text) AS $body$
DECLARE


nr_item_w		bigint;
nr_sequencia_w		bigint;
qt_sca_encontrado_w	integer;
ie_insere_registro_w	varchar(1) := 'S';


BEGIN
if (nr_seq_plano_sca_p IS NOT NULL AND nr_seq_plano_sca_p::text <> '') then
	select	count(1)
	into STRICT	qt_sca_encontrado_w
	from	pls_plano
	where	nr_sequencia = nr_seq_plano_sca_p
	and	ie_tipo_operacao = 'A';
	
	if (qt_sca_encontrado_w = 0) then
		ie_insere_registro_w := 'N';
		ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110447, 'NR_SEQ_SCA='||nr_seq_plano_sca_p),1,255);
	end if;
end if;

if (ie_insere_registro_w = 'S') then
	--Caso tenha sido informado Numero da solicitacao inserir com a mesma numeracao
	if (nr_seq_solicitacao_p IS NOT NULL AND nr_seq_solicitacao_p::text <> '') then
		begin
		select	coalesce(max(nr_item),0)+1
		into STRICT	nr_item_w
		from	w_plussoft_plano_proposta
		where	nr_sequencia = nr_seq_solicitacao_p;
		
		insert into w_plussoft_plano_proposta(		
				nr_sequencia,
				nr_item,
				nr_seq_plano_sca,
				nr_seq_tabela_sca)
		values (		nr_seq_solicitacao_p,
				nr_item_w,
				nr_seq_plano_sca_p,
				nr_seq_tabela_sca_p);
		commit;
		exception
		when others then
			ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110448) || ' ' || sqlerrm(SQLSTATE) ,1,255);
			rollback;
		end;
	--Caso contrario gera uma nova solicitacao
	else
		begin
		select	nextval('w_plussoft_plano_proposta_seq')
		into STRICT	nr_sequencia_w
		;
		
		delete	from w_plussoft_plano_proposta
		where	nr_sequencia = nr_sequencia_w;
		
		insert into w_plussoft_plano_proposta(		
				nr_sequencia,
				nr_item,
				nr_seq_plano_sca,
				nr_seq_tabela_sca)
		values (		nr_sequencia_w,
				1,
				nr_seq_plano_sca_p,
				nr_seq_tabela_sca_p);
		
		commit;
		exception
		when others then
			nr_sequencia_w := null;
			ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110448) || ' ' || sqlerrm(SQLSTATE) ,1,255);
			rollback;
		end;
		nr_seq_solicitacao_p := nr_sequencia_w;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.gravar_plano_sca_proposta ( nr_seq_solicitacao_p INOUT bigint, nr_seq_plano_sca_p bigint, nr_seq_tabela_sca_p bigint, ds_mensagem_erro_p INOUT text) FROM PUBLIC;
