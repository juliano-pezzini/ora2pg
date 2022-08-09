-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rfc_pessoa_fisica ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_curp_p INOUT text, cd_rfc_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
-------------------------------------------------------------------------------------------------------------------

Referencias:
	http://www.consisa.com.mx/rfc.html
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nm_sobrenome_pai_w			pessoa_fisica.nm_sobrenome_pai%type;
nm_sobrenome_mae_w			pessoa_fisica.nm_sobrenome_mae%type;
nm_primeiro_nome_w			pessoa_fisica.nm_primeiro_nome%type;
cd_nacionalidade_w			pessoa_fisica.cd_nacionalidade%type;
ie_sexo_w					pessoa_fisica.ie_sexo%type;
sg_estado_nasc_w			pessoa_fisica.sg_estado_nasc%type;
ds_estado_w					valor_dominio.ds_valor_dominio%type;
cd_rfc_w					pessoa_fisica.cd_rfc%type	:= '';
cd_curp_w					pessoa_fisica.cd_curp%type	:= '';
ie_nacional_w				nacionalidade.ie_brasileiro%type;
dt_nascimento_w				timestamp;
qt_posicao_w				bigint	:= 1;
ds_vogal_w					varchar(255);
ds_consoante_w				varchar(255);
nr_seq_person_name_w		pessoa_fisica.nr_seq_person_name%type;
nm_pessoa_fisica_w			pessoa_fisica.nm_pessoa_fisica%type;
nm_mae_w					compl_pessoa_fisica.nm_contato%type;
cd_acao_w					regra_duplic_pf.ie_acao%type;
cd_pessoa_fisica_dupli_w	pessoa_fisica.cd_pessoa_fisica%type;
nm_pessoa_fisica_dupli_w	pessoa_fisica.nm_pessoa_fisica%type;
ie_rfc_duplic_w				varchar(10);
ie_curp_duplic_w				varchar(10);


BEGIN

select 	nr_seq_person_name
into STRICT 	nr_seq_person_name_w
from 	pessoa_fisica
where 	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (coalesce(nr_seq_person_name_w::text, '') = '') then
	select	upper(a.nm_sobrenome_pai),
			upper(a.nm_sobrenome_mae),
			upper(a.nm_primeiro_nome),
			a.cd_nacionalidade,
			a.dt_nascimento,
			CASE WHEN a.ie_sexo='M' THEN  'H' WHEN a.ie_sexo='F' THEN  'M'  ELSE a.ie_sexo END ,
			a.sg_estado_nasc,
			a.nm_pessoa_fisica
	into STRICT	nm_sobrenome_pai_w,
			nm_sobrenome_mae_w,
			nm_primeiro_nome_w,
			cd_nacionalidade_w,
			dt_nascimento_w,
			ie_sexo_w,
			sg_estado_nasc_w,
			nm_pessoa_fisica_w
	from	pessoa_fisica	a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
	
else	

	select	upper(b.ds_family_name),
			upper(b.ds_component_name_1),
			upper(b.ds_given_name),
			a.cd_nacionalidade,
			a.dt_nascimento,
			CASE WHEN a.ie_sexo='M' THEN  'H' WHEN a.ie_sexo='F' THEN  'M'  ELSE a.ie_sexo END ,
			a.sg_estado_nasc
	into STRICT	nm_sobrenome_pai_w,
			nm_sobrenome_mae_w,
			nm_primeiro_nome_w,
			cd_nacionalidade_w,
			dt_nascimento_w,
			ie_sexo_w,
			sg_estado_nasc_w
	from	pessoa_fisica	a,
			person_name b
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and 	a.nr_seq_person_name = b.nr_Sequencia;	

end if;

ie_nacional_w	:= null;

if (cd_nacionalidade_w IS NOT NULL AND cd_nacionalidade_w::text <> '') then
	select	coalesce(max(a.ie_brasileiro),'N')
	into STRICT	ie_nacional_w
	from	nacionalidade	a
	where	a.cd_nacionalidade	= cd_nacionalidade_w;
end if;

if (ie_nacional_w = 'S' or coalesce((pkg_i18n.get_user_locale), 'pt_BR') = 'es_MX') then
	nm_primeiro_nome_w	:= obter_excecao_nome_mx(nm_primeiro_nome_w,
							'S',
							'N',
							null);
								
	nm_sobrenome_pai_w	:= obter_excecao_nome_mx(nm_sobrenome_pai_w,
							'N',
							'S',
							nm_primeiro_nome_w);
								
	nm_sobrenome_mae_w	:= obter_excecao_nome_mx(nm_sobrenome_mae_w,
							'N',
							'S',
							null);

	-- Passo 9							
	if (coalesce(nm_sobrenome_mae_w::text, '') = '') then
		nm_sobrenome_mae_w	:= 'X';
	end if;

	while qt_posicao_w <= 16 loop
		begin
		if (qt_posicao_w = 1) then -- Letra inicial do primeiro sobrenome
			cd_rfc_w	:= substr(cd_rfc_w || substr(nm_sobrenome_pai_w,1,1),1,10);
		elsif (qt_posicao_w = 2) then -- Primeira vogal do primeiro sobrenome
			ds_vogal_w	:= obter_primeira_letra_mx(nm_sobrenome_pai_w, 'N', 'V');
			
			-- Passo 8
			if (coalesce(ds_vogal_w::text, '') = '') then
				cd_rfc_w	:= substr(cd_rfc_w || substr('X',1,1),1,10);
			else
				cd_rfc_w	:= substr(cd_rfc_w || substr(ds_vogal_w,1,1),1,10);
			end if;
		elsif (qt_posicao_w = 3) then -- Letra inicial do segundo sobrenome
			cd_rfc_w	:= substr(cd_rfc_w || substr(nm_sobrenome_mae_w,1,1),1,10);
		elsif (qt_posicao_w = 4) then -- Letra inicial do nome
			cd_rfc_w	:= substr(cd_rfc_w || substr(nm_primeiro_nome_w,1,1),1,10);
			
			cd_rfc_w	:= substr(eliminar_exp_inconven_mx(cd_rfc_w),1,10);
		elsif (qt_posicao_w = 5) then -- Data de nascimento
			cd_rfc_w	:= substr(cd_rfc_w || substr(to_char(dt_nascimento_w, 'YYMMDD'),1,6),1,10);
			cd_curp_w	:= substr(cd_rfc_w,1,16);
			qt_posicao_w	:= 10;
		elsif (qt_posicao_w = 11) then
			cd_curp_w	:= substr(cd_curp_w || substr(ie_sexo_w,1,1),1,13);
		elsif (qt_posicao_w = 12) then -- Letra inicial do estado de nascimento e primeira consoante, ou a primeira letra do primeiro nome e a primeira letra do ultimo nome.
			cd_curp_w	:= substr(cd_curp_w || substr(obter_estado_nasc_rfc(sg_estado_nasc_w),1,2),1,13);
			qt_posicao_w	:= 13;
		elsif (qt_posicao_w = 14) then -- Primeira consoante interna do primeiro sobrenome
			--Passo 10
			cd_curp_w	:= substr(cd_curp_w || substr(obter_primeira_letra_mx(nm_sobrenome_pai_w, 'N', 'C'),1,1),1,16);
		elsif (qt_posicao_w = 15) then -- Primeira consoante interna do segundo sobrenome
			--Passo 11
			if (coalesce(nm_sobrenome_mae_w, 'X') = 'X') or (coalesce(nm_sobrenome_pai_w::text, '') = '') then
				ds_consoante_w	:= 'X';
			else
				--Passo 10
				ds_consoante_w	:= substr(obter_primeira_letra_mx(nm_sobrenome_mae_w, 'N', 'C'),1,1);
			end if;

			cd_curp_w	:= substr(cd_curp_w || ds_consoante_w,1,16);
		elsif (qt_posicao_w = 16) then -- Primeira consoante interna do nome
			-- Passo 13 = Passo 2 + Passo 6
			cd_curp_w	:= substr(cd_curp_w || substr(obter_primeira_letra_mx(nm_primeiro_nome_w, 'N', 'C'),1,1),1,16);
		end if;
		
		
		qt_posicao_w	:= qt_posicao_w + 1;
		end;
	end loop;
else
	cd_rfc_w	:= 'XEXX010101000';
	cd_curp_w	:= null;
end if;

if (cd_rfc_w <> 'XEXX010101000') then
	select	obter_compl_pf(cd_pessoa_fisica_p, 5, 'N')
	into STRICT 	nm_mae_w
	;
	
	ie_rfc_duplic_w := 'N';
	ie_curp_duplic_w := 'N';
	
	SELECT * FROM obter_regra_duplic_pf_html(cd_pessoa_fisica_p, nm_pessoa_fisica_w, dt_nascimento_w, nm_mae_w, cd_estabelecimento_p, cd_acao_w, obter_perfil_ativo, cd_rfc_w, cd_curp_w, ie_sexo_w, sg_estado_nasc_w, cd_pessoa_fisica_dupli_w, nm_pessoa_fisica_dupli_w, ie_rfc_duplic_w, ie_curp_duplic_w) INTO STRICT cd_acao_w, cd_pessoa_fisica_dupli_w, nm_pessoa_fisica_dupli_w, ie_rfc_duplic_w, ie_curp_duplic_w;			
								
	if (cd_acao_w IS NOT NULL AND cd_acao_w::text <> '') and (cd_pessoa_fisica_dupli_w IS NOT NULL AND cd_pessoa_fisica_dupli_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1086242);
	end if;
end if;

cd_rfc_p	:= cd_rfc_w;
cd_curp_p	:= cd_curp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rfc_pessoa_fisica ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_curp_p INOUT text, cd_rfc_p INOUT text) FROM PUBLIC;
