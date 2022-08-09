-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_dados_atend_web ( nr_seq_guia_p bigint, ds_observacao_p text, dt_internacao_p text, dt_alta_p text, nm_usuario_p text, nr_seq_guia_atend_p integer, ie_tipo_registro_p integer, dt_dados_atendimento_p text, nr_seq_movimento_p integer, ie_tipo_acao_p text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Gerar dados do atendimento da autorização no portal web
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/BEGIN

if (ie_tipo_acao_p = 'I') then
	insert	into pls_guia_atendimento(nr_sequencia, nr_seq_guia, dt_atualizacao,
		     nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		     ds_observacao, dt_internacao, dt_alta,
		     ie_tipo_registro, dt_dados_atendimento, nr_seq_movimento)
	      values (nextval('pls_guia_atendimento_seq'), nr_seq_guia_p, clock_timestamp(),
		     nm_usuario_p, clock_timestamp(), nm_usuario_p,
		     substr(ds_observacao_p,1,4000), to_date(dt_internacao_p,'dd/mm/yyyy hh24:mi:ss'), to_date(dt_alta_p,'dd/mm/yyyy hh24:mi:ss'),
		     ie_tipo_registro_p, to_date(dt_dados_atendimento_p,'dd/mm/yyyy hh24:mi:ss'), nr_seq_movimento_p);
elsif (ie_tipo_acao_p = 'U') then
	update	pls_guia_atendimento
	set	dt_alta = to_date(dt_alta_p,'dd/mm/yyyy hh24:mi:ss'),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		ds_observacao = substr(ds_observacao_p,1,4000)
	where	nr_sequencia = nr_seq_guia_atend_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_dados_atend_web ( nr_seq_guia_p bigint, ds_observacao_p text, dt_internacao_p text, dt_alta_p text, nm_usuario_p text, nr_seq_guia_atend_p integer, ie_tipo_registro_p integer, dt_dados_atendimento_p text, nr_seq_movimento_p integer, ie_tipo_acao_p text) FROM PUBLIC;
