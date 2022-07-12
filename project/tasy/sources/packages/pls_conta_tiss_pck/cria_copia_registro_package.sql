-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conta_tiss_pck.cria_copia_registro ( nr_seq_origem_p pls_conta_tiss.nr_sequencia%type, nr_seq_destino_p pls_conta_tiss.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Cria uma copia do registro de origem, para o sequencial do registro destino, caso nao existir
	
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atençao:

Alteraçoes:
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_validacao_benef_tiss_w	pls_conta_tiss.cd_validacao_benef_tiss%type;
cd_ausencia_val_benef_tiss_w	pls_conta_tiss.cd_ausencia_val_benef_tiss%type;
cd_ident_biometria_benef_w	pls_conta_tiss.cd_ident_biometria_benef%type;
cd_template_biomet_benef_w	pls_conta_tiss.cd_template_biomet_benef%type;
ie_tipo_ident_benef_w		pls_conta_tiss.ie_tipo_ident_benef%type;
cd_assinat_digital_prest_w	pls_conta_tiss.cd_assinat_digital_prest%type;


BEGIN

if	(nr_seq_origem_p IS NOT NULL AND nr_seq_origem_p::text <> '' AND nr_seq_destino_p IS NOT NULL AND nr_seq_destino_p::text <> '') then

	-- levanta as info para jogar no banco
	begin
		select	a.cd_validacao_benef_tiss,
			a.cd_ausencia_val_benef_tiss,
			a.cd_ident_biometria_benef,
			a.cd_template_biomet_benef,
			a.ie_tipo_ident_benef,
			a.cd_assinat_digital_prest,
			a.cd_estabelecimento
		into STRICT	cd_validacao_benef_tiss_w,
			cd_ausencia_val_benef_tiss_w,
			cd_ident_biometria_benef_w,
			cd_template_biomet_benef_w,
			ie_tipo_ident_benef_w,
			cd_assinat_digital_prest_w,
			cd_estabelecimento_w
		from	pls_conta_tiss	a
		where	a.nr_sequencia	= nr_seq_origem_p;
	exception
		when no_data_found then
			cd_validacao_benef_tiss_w	:= null;
			cd_ausencia_val_benef_tiss_w	:= null;
			cd_ident_biometria_benef_w	:= null;
			cd_template_biomet_benef_w	:= null;
			ie_tipo_ident_benef_w		:= null;
			cd_assinat_digital_prest_w	:= null;
			
			-- carrega o estabelecimento da conta destino
			select	max(x.cd_estabelecimento)
			into STRICT	cd_estabelecimento_w
			from	pls_conta	x
			where	x.nr_sequencia	= nr_seq_destino_p;
	end;

	
	CALL CALL pls_conta_tiss_pck.criar_registro(	nr_seq_destino_p,		cd_estabelecimento_w,		cd_validacao_benef_tiss_w,
			cd_ausencia_val_benef_tiss_w,	cd_ident_biometria_benef_w,	cd_template_biomet_benef_w,
			ie_tipo_ident_benef_w,		cd_assinat_digital_prest_w,	nm_usuario_p);
	
	
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conta_tiss_pck.cria_copia_registro ( nr_seq_origem_p pls_conta_tiss.nr_sequencia%type, nr_seq_destino_p pls_conta_tiss.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
