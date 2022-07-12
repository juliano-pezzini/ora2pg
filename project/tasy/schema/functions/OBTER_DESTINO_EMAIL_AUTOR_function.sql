-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_destino_email_autor (nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_cgc_fabricante_p text) RETURNS varchar AS $body$
DECLARE


ds_email_destino_w		varchar(254);
ds_email_solic_w		varchar(254);
ie_regra_destino_email_w	varchar(3);
cd_convenio_w			bigint;
i				bigint;
cd_medico_solicitante_w		varchar(10);


BEGIN

/*
Regra definição de e-mail destino p/ autorização

S:  E-mail Fornecedor (pasta 'Materiais') / E-mail autorização (TISS parâmetros) / E-mail PJ (Convênio)
N:  E-mail autorização (TISS parâmetros) / E-mail PJ (Convênio)
M:  E-mail Médico solicitante (Autorização) / E-mail autorização (TISS parâmetros) / E-mail PJ (Convênio)*/
ie_regra_destino_email_w := coalesce(obter_valor_param_usuario(3004, 144, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ds_email_destino_w	 := null;

select 	coalesce(max(cd_convenio),0)
into STRICT	cd_convenio_w
from 	autorizacao_convenio
where 	nr_sequencia = nr_sequencia_p;

 select  max(ds_email_autor)
 into STRICT	 ds_email_destino_w
 from    tiss_parametros_convenio
 where   cd_convenio = cd_convenio_w
 and     cd_estabelecimento = cd_estabelecimento_p;

if (coalesce(ds_email_destino_w,'0') = '0') then

	select 	max(c.ds_email)
	into STRICT	ds_email_destino_w
	from 	pessoa_juridica_estab c,
		pessoa_juridica a,
		convenio b
	where  	b.cd_convenio = cd_convenio_w
	and    	a.cd_cgc = b.cd_cgc
	and 	a.cd_cgc = c.cd_cgc
	and    	c.cd_estabelecimento = cd_estabelecimento_p;

end if;

if (coalesce(ds_email_destino_w,'0') = '0') then

	Select 	max(a.ds_email)
	into STRICT	ds_email_destino_w
	from   	pessoa_juridica a,
		convenio b
	where  	b.cd_convenio = cd_convenio_w
	and    	a.cd_cgc = b.cd_cgc;

end if;

 if (ie_regra_destino_email_w = 'S') then

	 select	coalesce(max(ds_email),ds_email_destino_w)
	 into STRICT	ds_email_destino_w
	 from   pessoa_juridica_estab
	 where	cd_cgc = cd_cgc_fabricante_p
	 and	cd_estabelecimento = cd_estabelecimento_p;

elsif (ie_regra_destino_email_w = 'N') then

	ds_email_destino_w:= ds_email_destino_w;

elsif (ie_regra_destino_email_w = 'M') then

	select 	coalesce(max(cd_medico_solicitante),'0')
	into STRICT	cd_medico_solicitante_w
	from 	autorizacao_convenio
	where 	nr_sequencia = nr_sequencia_p;

	if (cd_medico_solicitante_w <> '0') then

		select 	max(ds_email)
		into STRICT	ds_email_solic_w
		from	compl_pessoa_fisica
		where 	cd_pessoa_fisica = cd_medico_solicitante_w
		and 	ie_tipo_complemento = 1;

		if (coalesce(ds_email_solic_w,'0') = '0') then

			select 	coalesce(max(ds_email), ds_email_destino_w)
			into STRICT	ds_email_solic_w
			from	compl_pessoa_fisica
			where 	cd_pessoa_fisica = cd_medico_solicitante_w
			and 	ie_tipo_complemento = 2;

		end if;

		ds_email_destino_w:= ds_email_solic_w;

	else
		ds_email_destino_w:= ds_email_destino_w;
	end if;

end if;

return	ds_email_destino_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_destino_email_autor (nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_cgc_fabricante_p text) FROM PUBLIC;
