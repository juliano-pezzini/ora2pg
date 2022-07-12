-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_apres_doc_relat ( nr_seq_doc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, ie_leitura_obrigatoria_p text ) RETURNS varchar AS $body$
DECLARE


nr_seq_doc_w			bigint;
ie_apresenta_w			varchar(1);
ie_doc_pai_w			varchar(1);
ie_pai_pendente_w		varchar(1);


BEGIN

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_doc_pai_w
	from	qua_documento a
	where	a.nr_sequencia = nr_seq_doc_p
	and	coalesce(a.nr_seq_superior::text, '') = '';

	if (ie_doc_pai_w = 'S') then
		nr_seq_doc_w := nr_seq_doc_p;
		ie_apresenta_w := 'S';
	else
		select	a.nr_seq_superior
		into STRICT	nr_seq_doc_w
		from	qua_documento a
		where	a.nr_sequencia = nr_seq_doc_p;

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_pai_pendente_w
		from	qua_documento a
		where	a.nr_sequencia = nr_seq_doc_w
		and	a.ie_situacao = 'A'
		and	a.ie_status = 'D'
		and 	a.nr_seq_tipo not in (11,25,24,23,28,29)
		and	(a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '')
		and	(		(coalesce(a.ie_pergunta,'N') = 'N' and (substr(obter_se_doc_lido_usuario(a.nr_sequencia, nm_usuario_p),1,1) = 'N'))
				or (a.ie_pergunta = 'S' and (obter_se_doc_respondido(a.nr_sequencia, nm_usuario_p) = 'N'))
			)
		and	obter_acesso_docto_qual(a.nr_sequencia, nm_usuario_p, cd_estabelecimento_p, obter_param_usuario_padrao(4000, 112, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p),obter_param_usuario_padrao(4000, 113, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p)) = 'S'
		and	obter_acesso_idioma_qual(a.nr_sequencia, nm_usuario_p, cd_estabelecimento_p, obter_param_usuario_padrao(4000, 112, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p), obter_param_usuario_padrao(4000, 113, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p)) = 'S'
		and	((ie_leitura_obrigatoria_p = 'S' and qua_obter_se_doc_obrigatorio(a.nr_sequencia, nm_usuario_p) = 'S') or (ie_leitura_obrigatoria_p = 'N'));

		if (ie_pai_pendente_w = 'S') then
			ie_apresenta_w := 'N';
		else
			ie_apresenta_w := 'S';
		end if;
	end if;

return	ie_apresenta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_apres_doc_relat ( nr_seq_doc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, ie_leitura_obrigatoria_p text ) FROM PUBLIC;

