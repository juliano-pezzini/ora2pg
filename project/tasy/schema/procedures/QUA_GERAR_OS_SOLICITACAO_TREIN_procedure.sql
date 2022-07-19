-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_os_solicitacao_trein ( nm_usuario_p text, nr_seq_doc_p bigint, nr_seq_doc_rev_p bigint default 0, ds_dano_breve_p text DEFAULT NULL, ds_dano_p text DEFAULT NULL, nr_ordem_servico_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE

 
cd_pessoa_solic_w		varchar(10);			
nr_sequencia_w			bigint;
qt_doc_rev_w			bigint;
						

BEGIN 
 
select	nextval('man_ordem_servico_seq') 
into STRICT	nr_sequencia_w
;
 
select	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10) cd_pf_abertura 
into STRICT	cd_pessoa_solic_w
;
 
--Cria Ordem de serviço 
insert	into man_ordem_servico( 
	cd_pessoa_solicitante, 
	ds_dano_breve, 
	ds_dano, 
	dt_atualizacao, 
	dt_ordem_servico, 
	ie_classificacao, 
	ie_classificacao_cliente, 
	ie_origem_os, 
	ie_parado, 
	ie_prioridade, 
	ie_status_ordem, 
	ie_tipo_ordem, 
	nr_grupo_trabalho, 
	nr_grupo_planej, 
	nm_usuario, 
	nr_sequencia, 
	nr_seq_estagio, 
	nr_seq_documento, 
	dt_inicio_previsto, 
	dt_fim_previsto) 
values (	cd_pessoa_solic_w, 
	ds_dano_breve_p, 
	ds_dano_p,	 
	clock_timestamp(), 
	clock_timestamp(), 
	'S', 
	'S', 
	'6',--Qualidade 
	'N', 
	'M', 
	'1',--Aberta 
	13,--Ações da Qualidade 
	null, 
	null, 
	nm_usuario_p, 
	nr_sequencia_w, 
	null, 
	null, 
	clock_timestamp(), 
	null);
 
--inserir executor previsto 
insert	into man_ordem_servico_exec( 
			nr_sequencia, 
			nr_seq_ordem, 
			dt_atualizacao, 
			nm_usuario, 
			nm_usuario_exec, 
			nr_seq_funcao, 
			nr_seq_tipo_exec, 
			qt_min_prev) 
		values (	nextval('man_ordem_servico_exec_seq'), 
			nr_sequencia_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_p, 
			null, 
			2,--Responsável pela execução 
			10);	
 
select	count(1) 
into STRICT	qt_doc_rev_w 
from	qua_doc_revisao 
where	nr_seq_doc = nr_seq_doc_p;			
 
if (nr_seq_doc_rev_p > 0 AND qt_doc_rev_w > 0) then 
	update	qua_doc_revisao 
	set		nr_seq_ordem_trein = nr_sequencia_w 
	where 	nr_sequencia = nr_seq_doc_rev_p; 						
else 
	update	qua_documento 
	set		nr_seq_ordem_trein = nr_sequencia_w 
	where 	nr_sequencia = nr_seq_doc_p;	
end if;
 
commit;
 
nr_ordem_servico_p := nr_sequencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_os_solicitacao_trein ( nm_usuario_p text, nr_seq_doc_p bigint, nr_seq_doc_rev_p bigint default 0, ds_dano_breve_p text DEFAULT NULL, ds_dano_p text DEFAULT NULL, nr_ordem_servico_p INOUT bigint DEFAULT NULL) FROM PUBLIC;

