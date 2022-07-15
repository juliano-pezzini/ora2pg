-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_chama_senha_paciente ( nr_atendimento_p bigint, ds_maquina_P text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_senha_w		bigint;				
nr_seq_fila_senha_w	bigint;	
nm_paciente_w		varchar(255);	
ie_tipo_nome_w		varchar(1);
cd_pessoa_fisica_w	varchar(10);


BEGIN

ie_tipo_nome_w := Obter_param_Usuario(10021, 65, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_tipo_nome_w);

nr_seq_senha_w := obter_seq_senha_paciente(nr_atendimento_p);

if (ie_tipo_nome_w in ('1', '3')) then
		nm_paciente_w  := substr(pls_gerar_nome_abreviado(obter_dados_atendimento(nr_atendimento_p,'NP')), 1, 60);
elsif (ie_tipo_nome_w = '5') then
		nm_paciente_w := substr(OBTER_INICIAIS_NOME_SENHAS(obter_dados_atendimento(nr_atendimento_p,'CP'), obter_dados_atendimento(nr_atendimento_p,'NP')),1,250);
else
		nm_paciente_w  := substr(obter_dados_atendimento(nr_atendimento_p,'NP'), 1, 60);
end if;

cd_pessoa_fisica_w := obter_pessoa_atendimento(nr_atendimento_p,'C');

if (nr_seq_senha_w > 0) then
	select  max(coalesce(nr_seq_fila_senha,nr_seq_fila_senha_origem))
	into STRICT	nr_seq_fila_senha_w
	from	paciente_senha_fila
	where	nr_sequencia = nr_seq_senha_w;
end if;

if (nr_seq_fila_senha_w > 0) then

	CALL chamar_senha_pac_avulsa(nr_seq_senha_w,ds_maquina_p,nr_seq_fila_senha_w,'0',nm_usuario_p);

	UPDATE	paciente_senha_fila
	SET	dt_chamada_pa		=	clock_timestamp(),
		nm_paciente		=	CASE WHEN cd_pessoa_fisica_w = NULL THEN nm_paciente_w  ELSE null END ,
		nm_usuario		=	nm_usuario_p,		
		dt_visualizacao_monitor  = NULL,
		cd_pessoa_fisica		= cd_pessoa_fisica_w
	WHERE	nr_sequencia		=	nr_seq_senha_w;
	
	update	atendimento_paciente
	set 	dt_chamada_paciente = clock_timestamp(),
		ie_chamado 		= 'S'
	where	nr_atendimento = nr_atendimento_p;
else
	wheb_mensagem_pck.exibir_mensagem_abort(186212); -- O paciente não possui senha.
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_chama_senha_paciente ( nr_atendimento_p bigint, ds_maquina_P text, nm_usuario_p text) FROM PUBLIC;

