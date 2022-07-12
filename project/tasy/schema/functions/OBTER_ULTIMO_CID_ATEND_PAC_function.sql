-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_cid_atend_pac (nr_atendimento_p bigint, ie_classificacao_p text, ie_opcao_p text, ie_por_usuario_logado bigint default 0) RETURNS varchar AS $body$
DECLARE


/*	ie_classificacao_p(classificação do cid)	 P-Principal S-Secundário
	ie_opcao_p		C-Código D-Descricao
	ie_por_usuario_logado  1 true or 0 false  */
cd_pessoa_fisica_w	varchar(10);
cd_doenca_w		varchar(10);
ds_doenca_w		varchar(100);
ie_classificacao_w	varchar(3);
dt_diagnostico_w	timestamp;

c01 CURSOR FOR
	SELECT	 a.cd_doenca,
		 substr(obter_desc_cid(a.cd_doenca),1,100),
		 a.ie_classificacao_doenca
	from	 diagnostico_medico b,
		 diagnostico_doenca a,
		 atendimento_paciente x
	where	 a.nr_atendimento			= x.nr_atendimento
	and	 x.cd_pessoa_fisica			= cd_pessoa_fisica_w
	and	 a.nr_atendimento			= b.nr_atendimento
	and	 a.dt_diagnostico			= b.dt_diagnostico
	and      ( (ie_por_usuario_logado = 0 ) or (ie_por_usuario_logado = 1 and a.nm_usuario = Obter_Usuario_Ativo)
		 )
	order by a.dt_diagnostico desc;


BEGIN
cd_doenca_w	:= '';

begin
cd_pessoa_fisica_w	:=	obter_pessoa_atendimento(nr_atendimento_p,'C');

if (ie_opcao_p = 'C') then
	cd_doenca_w := obter_ultimo_cid_atend(nr_atendimento_p,ie_classificacao_p, ie_por_usuario_logado);
elsif (ie_opcao_p = 'D') then
	ds_doenca_w := obter_diagnostico_atendimento(nr_atendimento_p, ie_por_usuario_logado);
end if;

if	((ie_opcao_p = 'C') and (coalesce(cd_doenca_w::text, '') = '')) or
	((ie_opcao_p = 'D') and (coalesce(ds_doenca_w::text, '') = '')) then
	open C01;
	loop
	fetch C01 into
		cd_doenca_w,
		ds_doenca_w,
		ie_classificacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if	((ie_opcao_p = 'C') and (cd_doenca_w IS NOT NULL AND cd_doenca_w::text <> '') and (ie_classificacao_w = ie_classificacao_p)) or
			(ie_opcao_p = 'D' AND ds_doenca_w IS NOT NULL AND ds_doenca_w::text <> '') then
			exit;
		end if;
		end;
	end loop;
	close C01;
end if;

if (ie_opcao_p = 'C') then
	return cd_doenca_w;
elsif (ie_opcao_p = 'D') then
	return ds_doenca_w;
end if;

exception
	when others then
	return '';
end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_cid_atend_pac (nr_atendimento_p bigint, ie_classificacao_p text, ie_opcao_p text, ie_por_usuario_logado bigint default 0) FROM PUBLIC;

