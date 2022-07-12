-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Atualizar os dados default dos novos campos da SIP_NV_DADOS.

-- Qualquer novo campo adicionado na SIP_NV_DADOS pode ter seu valor default atualizado por aqui

-- pois como esta tabela e muito grande iria travar a atualizacao de versao. Para isto pode ser necessario

-- alterar a forma de leitura dos itens a ser atualizados, para que nao seja aberto mais de um cursor da 

-- NV_DADOS ao mesmo tempo.



CREATE OR REPLACE PROCEDURE pls_sip_pck.atualiza_nv_dados_default (nr_seq_lote_p pls_lote_sip.nr_sequencia%type) AS $body$
DECLARE


c_atual CURSOR(nr_seq_lote_pc	pls_lote_sip.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	sip_nv_dados a
	where	a.nr_seq_lote_sip	= nr_seq_lote_pc
	and	coalesce(a.ie_origem_info, '1') = '1';
	
tb_seq_w	pls_util_cta_pck.t_number_table;


BEGIN

begin
	-- Varre o cursor e atualiza o valor default dos campos da sip_nv_dados;

	open c_atual(nr_seq_lote_p);
	loop
		fetch c_atual
		bulk collect into tb_seq_w 
		limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
		
		exit when tb_seq_w.count = 0;
		
		forall i in tb_seq_w.first .. tb_seq_w.last
			update	sip_nv_dados
			set 	ie_origem_info = 'CM'
			where	nr_sequencia = tb_seq_w(i);
			
		commit;
	end loop;
	close c_atual;
exception
when others then
	-- caso ocorra algum problema so fecha o cursor caso esteja aberto, o processo pode continuar

	-- sem a atualizacao deste campo.

	if (c_atual%ISOPEN) then
		close c_atual;
	end if;
end;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.atualiza_nv_dados_default (nr_seq_lote_p pls_lote_sip.nr_sequencia%type) FROM PUBLIC;
