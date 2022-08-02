-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_cab_ped_compl_aut_v60 ( ie_tipo_cliente_p ptu_pedido_compl_aut.ie_tipo_cliente%type, cd_unimed_prestador_req_p ptu_pedido_compl_aut.cd_unimed_prestador_req%type, cd_prestador_req_p ptu_pedido_compl_aut.nr_seq_prestador_req%type, cd_especialidade_p ptu_pedido_compl_aut.cd_especialidade%type, cd_unimed_executora_p ptu_pedido_compl_aut.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_pedido_compl_aut.cd_unimed_beneficiario%type, cd_unimed_p ptu_pedido_compl_aut.cd_unimed%type, nr_seq_execucao_p ptu_pedido_compl_aut.nr_seq_execucao%type, nr_trans_original_ref_p ptu_pedido_compl_aut.nr_seq_origem%type, cd_usuario_plano_p ptu_pedido_compl_aut.cd_usuario_plano%type, ds_biometria_p ptu_pedido_compl_aut.ds_biometria%type, cd_unimed_prestador_p ptu_pedido_compl_aut.cd_unimed_prestador%type, cd_transacao_p ptu_pedido_compl_aut.cd_transacao%type, cd_versao_p ptu_pedido_compl_aut.nr_versao%type, nm_prof_solicitante_p ptu_pedido_compl_aut.nm_prof_solicitante%type, nr_fone_prof_solic_p ptu_pedido_compl_aut.nr_fone_prof_solic%type, ds_email_prof_solic_p ptu_pedido_compl_aut.ds_email_prof_solic%type, ie_anexo_p ptu_pedido_compl_aut.ie_anexo%type, ie_sexo_p ptu_pedido_compl_aut.ie_sexo%type, nr_idade_p ptu_pedido_compl_aut.nr_idade%type, ds_observacao_p ptu_pedido_compl_aut.ds_observacao%type, ds_ind_clinica_p ptu_pedido_compl_aut.ds_indicacao_clinica%type, cd_prestador_p ptu_pedido_compl_aut.nr_seq_prestador%type, ie_liminar_p ptu_pedido_compl_aut.ie_liminar%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_compl_aut_p INOUT ptu_pedido_compl_aut.nr_sequencia%type, ie_possui_registro_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação do arquivo de 006005- Pedido de Complemento de Autorização
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_cliente_w	ptu_pedido_autorizacao.ie_tipo_cliente%type;
nr_seq_pedido_existe_w	ptu_pedido_autorizacao.nr_sequencia%type;


BEGIN
--Select utilizado para verificar se já existe um pedido complemento de autorização igual na base, se existir só retorna a sequencia da resposta do pedido
--nr_ident_exec_w ptu:númeroTransaçãoPrestadora - Número da transação da Unimed Prestadora
--cd_unimed_exec_w ptu:codigoUnimedPrestadora - Código da Unimed Prestadora
select	max(a.nr_sequencia)
into STRICT	nr_seq_pedido_existe_w
from	ptu_pedido_compl_aut a,
	ptu_controle_execucao b
where	b.nr_seq_pedido_compl	= a.nr_sequencia
and	a.nr_seq_execucao	= nr_seq_execucao_p
and	a.cd_unimed_executora	= cd_unimed_executora_p;

ie_possui_registro_p := 'N';

--Se existir o pedido na base retorna a sequência
if (nr_seq_pedido_existe_w IS NOT NULL AND nr_seq_pedido_existe_w::text <> '') then
	nr_seq_pedido_compl_aut_p 	:= nr_seq_pedido_existe_w;
	ie_possui_registro_p 	:= 'S';
else
	-- Validação é necessário converter os dados para  somente uma letra
	ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);

	insert	into ptu_pedido_compl_aut(nr_sequencia, ie_tipo_cliente, cd_unimed_prestador_req,
		nr_seq_prestador_req, cd_especialidade, cd_unimed_executora,
		cd_unimed_beneficiario, cd_unimed, nr_seq_execucao,
		nm_usuario, dt_atualizacao, cd_usuario_plano,
		cd_unimed_prestador,  cd_transacao, nr_versao,
		nm_usuario_nrec, dt_atualizacao_nrec, nm_prof_solicitante,
		nr_fone_prof_solic,ds_email_prof_solic, ie_anexo,
		ie_sexo, nr_idade, ds_biometria,
		ds_observacao, ds_indicacao_clinica, nr_seq_prestador,
		nr_seq_origem, ie_liminar)
	values (nextval('ptu_pedido_compl_aut_seq'), ie_tipo_cliente_w, cd_unimed_prestador_req_p,
		cd_prestador_req_p, cd_especialidade_p, cd_unimed_executora_p,
		cd_unimed_beneficiario_p, cd_unimed_p, nr_seq_execucao_p,
		nm_usuario_p, clock_timestamp(), lpad(cd_usuario_plano_p,13,'0'),
		cd_unimed_prestador_p, cd_transacao_p, cd_versao_p,
		nm_usuario_p, clock_timestamp(), nm_prof_solicitante_p,
		nr_fone_prof_solic_p,substr(ds_email_prof_solic_p,1,60), ie_anexo_p,
		ie_sexo_p, nr_idade_p, ds_biometria_p,
		ds_observacao_p, ds_ind_clinica_p, cd_prestador_p,
		nr_trans_original_ref_p, ie_liminar_p) returning nr_sequencia into nr_seq_pedido_compl_aut_p;

	insert	into ptu_controle_execucao(nr_sequencia, dt_atualizacao, nm_usuario,
		nr_seq_pedido_compl, nm_usuario_nrec, dt_atualizacao_nrec)
	values (nextval('ptu_controle_execucao_seq'), clock_timestamp(), nm_usuario_p,
		nr_seq_pedido_compl_aut_p, nm_usuario_p, clock_timestamp());

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_cab_ped_compl_aut_v60 ( ie_tipo_cliente_p ptu_pedido_compl_aut.ie_tipo_cliente%type, cd_unimed_prestador_req_p ptu_pedido_compl_aut.cd_unimed_prestador_req%type, cd_prestador_req_p ptu_pedido_compl_aut.nr_seq_prestador_req%type, cd_especialidade_p ptu_pedido_compl_aut.cd_especialidade%type, cd_unimed_executora_p ptu_pedido_compl_aut.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_pedido_compl_aut.cd_unimed_beneficiario%type, cd_unimed_p ptu_pedido_compl_aut.cd_unimed%type, nr_seq_execucao_p ptu_pedido_compl_aut.nr_seq_execucao%type, nr_trans_original_ref_p ptu_pedido_compl_aut.nr_seq_origem%type, cd_usuario_plano_p ptu_pedido_compl_aut.cd_usuario_plano%type, ds_biometria_p ptu_pedido_compl_aut.ds_biometria%type, cd_unimed_prestador_p ptu_pedido_compl_aut.cd_unimed_prestador%type, cd_transacao_p ptu_pedido_compl_aut.cd_transacao%type, cd_versao_p ptu_pedido_compl_aut.nr_versao%type, nm_prof_solicitante_p ptu_pedido_compl_aut.nm_prof_solicitante%type, nr_fone_prof_solic_p ptu_pedido_compl_aut.nr_fone_prof_solic%type, ds_email_prof_solic_p ptu_pedido_compl_aut.ds_email_prof_solic%type, ie_anexo_p ptu_pedido_compl_aut.ie_anexo%type, ie_sexo_p ptu_pedido_compl_aut.ie_sexo%type, nr_idade_p ptu_pedido_compl_aut.nr_idade%type, ds_observacao_p ptu_pedido_compl_aut.ds_observacao%type, ds_ind_clinica_p ptu_pedido_compl_aut.ds_indicacao_clinica%type, cd_prestador_p ptu_pedido_compl_aut.nr_seq_prestador%type, ie_liminar_p ptu_pedido_compl_aut.ie_liminar%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_compl_aut_p INOUT ptu_pedido_compl_aut.nr_sequencia%type, ie_possui_registro_p INOUT text) FROM PUBLIC;

