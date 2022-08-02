-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_consulta_prest_v50 ( cd_unimed_benef_p text, nm_prestador_p text, cd_cgc_cpf_p text, sg_cons_prof_p text, nr_cons_prof_p bigint, uf_cons_prof_p text, nr_versao_ptu_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_retorno_p INOUT bigint) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar a transação PTU de consulta de dados do prestador, via SCS
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_cooperativa_w		varchar(10);


BEGIN
cd_cooperativa_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);

select	nextval('ptu_consulta_prestador_seq')
into STRICT	nr_seq_retorno_p
;

insert	into ptu_consulta_prestador(nr_sequencia, cd_transacao, ie_tipo_cliente,
	 cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
	 nm_prestador, dt_atualizacao, nm_usuario,
	 cd_cgc_cpf, sg_cons_profissional, nr_cons_profissional,
	 uf_cons_profissional, nr_seq_guia, nr_seq_requisicao,
	 nm_usuario_nrec, dt_atualizacao_nrec, nr_versao)
values (nr_seq_retorno_p, '00418', 'U',
	 cd_cooperativa_w, cd_unimed_benef_p, nr_seq_retorno_p,
	 nm_prestador_p, clock_timestamp(), nm_usuario_p,
	 cd_cgc_cpf_p, sg_cons_prof_p, nr_cons_prof_p,
	 uf_cons_prof_p, nr_seq_retorno_p, null,
	 nm_usuario_p, clock_timestamp(), nr_versao_ptu_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_consulta_prest_v50 ( cd_unimed_benef_p text, nm_prestador_p text, cd_cgc_cpf_p text, sg_cons_prof_p text, nr_cons_prof_p bigint, uf_cons_prof_p text, nr_versao_ptu_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_retorno_p INOUT bigint) FROM PUBLIC;

