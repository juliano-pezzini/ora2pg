-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_itens_regra_setor (ie_tipo_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_retorno_regra_p INOUT text) AS $body$
DECLARE


dt_nascimento_w			timestamp;
dt_obito_w			timestamp;
ds_setor_atendimento_w		varchar(70);
ds_lista_w			varchar(2000);
qt_idade_w			double precision;
ie_mostra_regra_w		varchar(1);
qt_itens_w			integer;

c01 CURSOR FOR
	SELECT  substr(obter_nome_setor(b.cd_setor_atendimento),1,70)
	from	regra_setor a,
		setor_atendimento b
	where	a.cd_setor_atendimento = b.cd_setor_atendimento
	and	qt_idade_w between a.QT_IDADE_MIN and a.QT_IDADE_MAX
	and	cd_classif_setor = 1;


BEGIN
ds_retorno_regra_p	:= null;

ie_mostra_regra_w := Obter_Param_Usuario(916, 261, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_mostra_regra_w);

select	max(a.dt_nascimento),
	max(coalesce(a.dt_obito,clock_timestamp()))
into STRICT	dt_nascimento_w,
	dt_obito_w
from	pessoa_fisica a
where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;

select	max(obter_idade(dt_nascimento_w,dt_obito_w,'A'))
into STRICT	qt_idade_w
;

select  	count(*)
into STRICT	qt_itens_w
from	regra_setor a,
	setor_atendimento b
where	a.cd_setor_atendimento = b.cd_setor_atendimento
and	qt_idade_w between a.QT_IDADE_MIN and a.QT_IDADE_MAX
and	cd_classif_setor = 1;

if (ie_tipo_atendimento_p = 3) and (ie_mostra_regra_w = 'S') and (qt_itens_w > 1) then

	select	a.dt_nascimento,
		coalesce(a.dt_obito,clock_timestamp())
	into STRICT	dt_nascimento_w,
		dt_obito_w
	from	pessoa_fisica a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;

	select	obter_idade(dt_nascimento_w,dt_obito_w,'A')
	into STRICT	qt_idade_w
	;


	open C01;
	loop
	fetch C01 into
		ds_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ds_lista_w	:= ds_lista_w || ds_setor_atendimento_w || chr(10);

		end;
	end loop;
	close C01;

	if (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then
		ds_lista_w := OBTER_DESC_EXPRESSAO(756508,'De acordo com a idade do paciente o mesmo utilizar o(s) seguinte(s) setores:') ||  chr(10) || ds_lista_w;
	end if;

	ds_retorno_regra_p	:= substr(ds_lista_w,1,255);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_itens_regra_setor (ie_tipo_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_retorno_regra_p INOUT text) FROM PUBLIC;
