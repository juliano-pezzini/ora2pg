-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_consistir_classif_centro ( cd_centro_custo_p bigint, cd_grupo_p bigint, ie_tipo_conta_p text, cd_classif_conta_p text, cd_estabelecimento_p bigint, cd_classificacao_p text, ds_erro_p INOUT text, cd_centro_custo_ref_p text default null) AS $body$
DECLARE


cd_classif_grupo_w		varchar(40);
ie_classif_conta_w		varchar(01);
cd_classif_sup_w		varchar(40);
ie_consiste_mascara_w	varchar(02);
qt_reg_w			bigint;
cd_empresa_w		smallint;
cd_classif_w		varchar(40);
i			integer;
ds_erro_w		varchar(255);
ie_separador_centro_w	empresa.ie_sep_classif_centro%type;

qt_registro_w		bigint := 0;


BEGIN

ie_separador_centro_w	:= philips_contabil_pck.get_separador_centro;

select cd_empresa
into STRICT   cd_empresa_w
from   estabelecimento
where  cd_estabelecimento = cd_estabelecimento_p;

select	ie_classif_conta,
	ie_consiste_mascara_contabil
into STRICT	ie_classif_conta_w,
	ie_consiste_mascara_w
from	empresa
where	cd_empresa	= cd_empresa_w;

if (ie_classif_conta_w = 'N') then
	select	count(*)
	into STRICT	qt_reg_w
	from	centro_custo
	where	cd_classificacao	= cd_classificacao_p
	and	cd_centro_custo	<> cd_centro_custo_p
	and	cd_estabelecimento	= cd_estabelecimento_p;
	if (qt_reg_w > 0) then
		ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277837);
	end if;
end if;

select	count(cc.cd_centro_custo)
into STRICT	qt_registro_w
from	centro_custo cc
where	cc.cd_centro_custo_ref = cd_centro_custo_ref_p
and	cc.cd_estabelecimento = cd_estabelecimento_p
and	cc.cd_centro_custo <> cd_centro_custo_p
and	cc.ie_situacao = 'A';

if (qt_registro_w > 0) then
	ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(1103245);
elsif (ie_consiste_mascara_w in ('CE','A')) then
	begin
	cd_classif_w		:= cd_classif_conta_p;
	select	coalesce(max(cd_mascara), 'X')
	into STRICT	cd_classif_grupo_w
	from	ctb_grupo_centro
	where	cd_grupo	= cd_grupo_p
	  and	cd_empresa	= cd_empresa_w;

	if (coalesce(ie_tipo_conta_p::text, '') = '')  then
		ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277838);
	elsif (coalesce(cd_grupo_p::text, '') = '') then
		ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277839);
	elsif (coalesce(cd_classif_conta_p::text, '') = '') then
		ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277841);
	elsif (cd_classif_grupo_w = 'X') then
		ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277842);
	else
		begin
		for i in 1..Length(cd_classif_w) loop
			begin
			if (substr(cd_classif_w,i,1) = ie_separador_centro_w) and (substr(cd_classif_grupo_w,i,1) <> ie_separador_centro_w) then
				ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277844) ||
						cd_classif_grupo_w || ')';
			end if;
 			if (substr(cd_classif_w,i,1) in ('1','2','3','4','5','6','7','8','9','0')) and (substr(cd_classif_grupo_w,i,1) not in ('1','2','3','4','5','6','7','8','9','0')) then
				ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277844) ||
						cd_classif_grupo_w || ')';
			end if;
        		end;
		end loop;
		if (coalesce(ds_erro_w::text, '') = '') and (length(cd_classif_w)  <> length(cd_classif_grupo_w)) and (substr(cd_classif_grupo_w, length(cd_classif_w) + 1, 1) <> ie_separador_centro_w) then
			ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(277845) ||
					cd_classif_grupo_w || ')';
		end if;
		end;
	end if;
	end;
end if;
ds_erro_p		:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_consistir_classif_centro ( cd_centro_custo_p bigint, cd_grupo_p bigint, ie_tipo_conta_p text, cd_classif_conta_p text, cd_estabelecimento_p bigint, cd_classificacao_p text, ds_erro_p INOUT text, cd_centro_custo_ref_p text default null) FROM PUBLIC;
