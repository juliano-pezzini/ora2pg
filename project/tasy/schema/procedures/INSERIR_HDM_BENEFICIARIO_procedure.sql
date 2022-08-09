-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_hdm_beneficiario (Nm_Mae_P text default null, Nr_Cpf_P text default null, Nr_Identidade_P text default null, NR_TELEFONE_P text default null, Dt_Nascimento_P timestamp default null, Cd_Estabelecimento_P bigint default null, Nm_Pessoa_Fisica_P text default null, Nm_Usuario_P text default null, Ie_Sexo_P text default null, Ds_Preco_Plano_P text default null, Dt_Inclusao_Plano_P timestamp default null, Ie_Situacao_Contrato_P text default null, Cd_Usuario_Plano_P text default null, Ie_Situacao_Atend_P text default null, Ie_Origem_P text Default Null, Ie_Preco_Plano_P text Default Null, SEQ_HDM_BENEF_CUBO_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE


Retorno_function_PF_W	bigint;
Cd_Pessoa_Fisica_W	bigint;
Valida_Pessoa_Fisica_w bigint;
Seq_Hdm_Benef_Cubo_W bigint;
Sql_Errm_W	varchar(255);
seq_coml_pessoa_fisica_w bigint;


BEGIN

Seq_Hdm_Benef_Cubo_P := Null;

Retorno_Function_Pf_W := Obter_retorno_Paciente_Hdm(Cd_Estabelecimento_P,
Nm_Pessoa_Fisica_P,
Dt_Nascimento_P,
Nm_Mae_P,
Nr_Cpf_P,
Nr_Identidade_P,
NR_TELEFONE_P);

If (Retorno_Function_Pf_W  = 0 And (Nm_Usuario_P IS NOT NULL AND Nm_Usuario_P::text <> '')) Then /*pessoa_fisica não existe, inserir nova*/
        Select	nextval('pessoa_fisica_seq')
        Into STRICT	Cd_Pessoa_Fisica_W
;

	begin
	Insert Into Pessoa_Fisica(Cd_Pessoa_Fisica,
		Ie_Tipo_Pessoa,
		Dt_Atualizacao,
		Dt_Atualizacao_nrec,
		Dt_Nascimento,
		Nm_Pessoa_Fisica,
		Nm_Usuario,
		nm_usuario_nrec,
		Ie_Sexo,
		Nr_Cpf,
		Nr_Identidade)
	Values (Cd_Pessoa_Fisica_W,
		2,
		clock_timestamp(),
		clock_timestamp(),
		Dt_Nascimento_P,
		Nm_Pessoa_Fisica_P,
		Nm_Usuario_P,
		Nm_Usuario_P,
		Ie_Sexo_P,
		nr_cpf_p,
		nr_identidade_p);
	Exception
	When Others Then
	Sql_Errm_W	:= Sqlerrm;
	Insert Into Hdm_Log_Integracao(Nr_Sequencia,
		Dt_Atualizacao,
		Nm_Usuario,
		Dt_Atualizacao_Nrec,
		Nm_Usuario_Nrec,
		Ie_Tipo_Log,
		Ds_Titulo,
		Ds_Log_Hdm)
	Values (nextval('hdm_log_integracao_seq'),
		clock_timestamp(),
		Nm_Usuario_P,
		clock_timestamp(),
		Nm_Usuario_P,
		'I',
		'Inserir PESSOA_FISICA (Beneficiario)', Sql_Errm_W);
	end;

        if (NR_TELEFONE_P IS NOT NULL AND NR_TELEFONE_P::text <> '') then

		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	seq_coml_pessoa_fisica_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = Cd_Pessoa_Fisica_W;

		Begin
                Insert Into Compl_Pessoa_Fisica(Nr_Sequencia,
			Cd_Pessoa_Fisica,
			Ie_Tipo_Complemento,
			Dt_Atualizacao,
			dt_atualizacao_nrec,
			Nm_Usuario,
			nm_usuario_nrec,
			nr_telefone)
                Values (seq_coml_pessoa_fisica_w,
			Cd_Pessoa_Fisica_W,
			1,
			clock_timestamp(),
			clock_timestamp(),
			Nm_Usuario_P,
			Nm_Usuario_P,
			NR_TELEFONE_P);
                Exception
                When Others Then
                Sql_Errm_W	:= Sqlerrm;
                Insert Into Hdm_Log_Integracao(Nr_Sequencia,
			Dt_Atualizacao,
			Nm_Usuario,
			Dt_Atualizacao_Nrec,
			Nm_Usuario_Nrec,
			Ie_Tipo_Log,
			Ds_Titulo,
			Ds_Log_Hdm)
                Values (nextval('hdm_log_integracao_seq'),
			clock_timestamp(),
			Nm_Usuario_P,
			clock_timestamp(),
			Nm_Usuario_P,
			'I',
			'Inserir COMPL_PESSOA_FISICA (Beneficiario)',
			Sql_Errm_W);
		End;
         End If;

         if (NM_MAE_P IS NOT NULL AND NM_MAE_P::text <> '') then

		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	seq_coml_pessoa_fisica_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = Cd_Pessoa_Fisica_W;

                Begin
		Insert Into Compl_Pessoa_Fisica(Nr_Sequencia,
			Cd_Pessoa_Fisica,
			Ie_Tipo_Complemento,
			Dt_Atualizacao,
			Dt_Atualizacao_nrec,
			Nm_Usuario,
			nm_usuario_nrec,
			Nm_Contato)
		Values (seq_coml_pessoa_fisica_w,
			Cd_Pessoa_Fisica_W,
			5,
			clock_timestamp(),
			clock_timestamp(),
			Nm_Usuario_P,
			nm_usuario_p,
			Nm_Mae_P);
		Exception
		When Others Then
		Sql_Errm_W	:= Sqlerrm;
		Insert Into Hdm_Log_Integracao(Nr_Sequencia,
			Dt_Atualizacao,
			Nm_Usuario,
			Dt_Atualizacao_Nrec,
			Nm_Usuario_Nrec,
			Ie_Tipo_Log,
			Ds_Titulo,
			Ds_Log_Hdm)
		Values (nextval('hdm_log_integracao_seq'),
			clock_timestamp(),
			Nm_Usuario_P,
			clock_timestamp(),
			Nm_Usuario_P,
			'I',
			'Inserir COMPL_PESSOA_FISICA (Beneficiario)',
			Sql_Errm_W);
                End;
          end if;

Else
	cd_pessoa_fisica_w := Retorno_function_PF_W;
end if;

select coalesce(max(nr_sequencia),0) into STRICT Valida_Pessoa_Fisica_w from hdm_benef_cubo where cd_pessoa_fisica = cd_pessoa_fisica_w and CD_USUARIO_PLANO = cd_usuario_plano_p;

if (Valida_Pessoa_Fisica_w = 0) then

	Select nextval('hdm_benef_cubo_seq') Into STRICT Seq_Hdm_Benef_Cubo_W;

	begin
	Insert Into Hdm_Benef_Cubo(Nr_Sequencia,
		Cd_Pessoa_Fisica,
		Ds_Preco_Plano,
		Dt_Atualizacao,
		Dt_Atualizacao_nrec,
		Dt_Inclusao_Plano,
		Ie_Situacao_Contrato,
		Nm_Usuario,
		nm_usuario_nrec,
		Cd_Usuario_Plano,
		Ie_Situacao_Atend,
		Ie_Origem,
		Ie_Preco_Plano)
	Values (Seq_Hdm_Benef_Cubo_W,
		Cd_Pessoa_Fisica_W,
		Ds_Preco_Plano_P,
		clock_timestamp(),
		clock_timestamp(),
		Dt_Inclusao_Plano_P,
		Ie_Situacao_Contrato_P,
		Nm_Usuario_P,
		Nm_Usuario_P,
		Cd_Usuario_Plano_P,
		Ie_Situacao_Atend_P,
		Ie_Origem_P,
		Ie_Preco_Plano_P);
	Exception
	When Others Then
	Sql_Errm_W	:= Sqlerrm;
	Insert Into Hdm_Log_Integracao(Nr_Sequencia,
		Dt_Atualizacao,
		Nm_Usuario,
		Dt_Atualizacao_Nrec,
		Nm_Usuario_Nrec,
		Ie_Tipo_Log,
		Ds_Titulo,
		Ds_Log_Hdm)
	Values (nextval('hdm_log_integracao_seq'),
		clock_timestamp(),
		Nm_Usuario_P,
		clock_timestamp(),
		Nm_Usuario_P,
		'I',
		'Inserir HDM_BENEF_CUBO (Beneficiario)',
		Sql_Errm_W);
	end;

        if (coalesce(Sql_Errm_W::text, '') = '') then
		SEQ_HDM_BENEF_CUBO_p := SEQ_HDM_BENEF_CUBO_W;
        end if;
Else

	SEQ_HDM_BENEF_CUBO_p := Valida_Pessoa_Fisica_w;
end if;

commit;
End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_hdm_beneficiario (Nm_Mae_P text default null, Nr_Cpf_P text default null, Nr_Identidade_P text default null, NR_TELEFONE_P text default null, Dt_Nascimento_P timestamp default null, Cd_Estabelecimento_P bigint default null, Nm_Pessoa_Fisica_P text default null, Nm_Usuario_P text default null, Ie_Sexo_P text default null, Ds_Preco_Plano_P text default null, Dt_Inclusao_Plano_P timestamp default null, Ie_Situacao_Contrato_P text default null, Cd_Usuario_Plano_P text default null, Ie_Situacao_Atend_P text default null, Ie_Origem_P text Default Null, Ie_Preco_Plano_P text Default Null, SEQ_HDM_BENEF_CUBO_p INOUT bigint DEFAULT NULL) FROM PUBLIC;
