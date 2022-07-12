-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.pls_conv_nv_declaracao_conta ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


_ora2pg_r RECORD;
--Dados utilizados para atualizar a tabela tempor_ria

tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_decl_conta_w		pls_util_cta_pck.t_number_table;
tb_cd_doenca_obito_w		pls_util_cta_pck.t_varchar2_table_10;
--Dados convertidos

tb_cd_doenca_obito_conv_w	pls_util_cta_pck.t_varchar2_table_10;
--Vari_veis utilizadas

nr_indice_w			integer;

C01 CURSOR(	nr_seq_protocolo_pc pls_protocolo_conta_imp.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia nr_seq_decl_conta,
		b.nr_seq_conta,
		b.cd_doenca_obito
	from	pls_conta_imp a,
		pls_decl_conta_obito_imp b	
	where	a.nr_seq_protocolo = nr_seq_protocolo_pc
	and 	b.nr_seq_conta = a.nr_sequencia;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta,
		a.cd_doenca_obito
	from	pls_decl_cta_obito_imp_tmp a;

BEGIN

-- Limpa a tabela tempor_ria

EXECUTE 'truncate table pls_decl_cta_obito_imp_tmp';

-- Alimenta a tabela tempor_ria com os dados necess_rios

open C01(nr_seq_protocolo_p);
loop
	fetch C01 bulk collect into 	tb_nr_seq_decl_conta_w, tb_nr_seq_conta_w,
					tb_cd_doenca_obito_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_decl_conta_w.count = 0;

	forall i in tb_nr_seq_decl_conta_w.first..tb_nr_seq_decl_conta_w.last
		insert 	into pls_decl_cta_obito_imp_tmp(
			nr_sequencia, nr_seq_conta, cd_doenca_obito
		) values (
			tb_nr_seq_decl_conta_w(i), tb_nr_seq_conta_w(i), tb_cd_doenca_obito_w(i)
		);
	commit;
end loop;
close C01;

-- _ chamado a procedure para limpar as vari_veis

SELECT * FROM pls_conv_xml_cta_pck.atualiza_conv_declaracao_cta(tb_nr_seq_decl_conta_w, tb_cd_doenca_obito_conv_w) INTO STRICT _ora2pg_r;
 tb_nr_seq_decl_conta_w := _ora2pg_r.tb_nr_seq_decl_conta_p; tb_cd_doenca_obito_conv_w := _ora2pg_r.tb_cd_doenca_obito_p;
nr_indice_w := 0;

-- Busca os dados da tabela tempor_ria para fazer o processamento

for r_c02_w in C02 loop
	
	tb_nr_seq_decl_conta_w(nr_indice_w) := r_c02_w.nr_sequencia;
	tb_cd_doenca_obito_conv_w(nr_indice_w)  := pls_conv_xml_cta_pck.formata_cd_doenca(r_c02_w.cd_doenca_obito, cd_estabelecimento_p);	
	
	if (nr_indice_w >= pls_util_pck.qt_registro_transacao_w) then	
		
		SELECT * FROM pls_conv_xml_cta_pck.atualiza_conv_declaracao_cta(tb_nr_seq_decl_conta_w, tb_cd_doenca_obito_conv_w) INTO STRICT _ora2pg_r;
 tb_nr_seq_decl_conta_w := _ora2pg_r.tb_nr_seq_decl_conta_p; tb_cd_doenca_obito_conv_w := _ora2pg_r.tb_cd_doenca_obito_p;
		
		nr_indice_w := 0;
	else
		nr_indice_w := nr_indice_w + 1;
	end if;	
end loop;

-- chama a procedure para verificar se ficou algo sem atualizar

SELECT * FROM pls_conv_xml_cta_pck.atualiza_conv_declaracao_cta(tb_nr_seq_decl_conta_w, tb_cd_doenca_obito_conv_w) INTO STRICT _ora2pg_r;
 tb_nr_seq_decl_conta_w := _ora2pg_r.tb_nr_seq_decl_conta_p; tb_cd_doenca_obito_conv_w := _ora2pg_r.tb_cd_doenca_obito_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.pls_conv_nv_declaracao_conta ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;