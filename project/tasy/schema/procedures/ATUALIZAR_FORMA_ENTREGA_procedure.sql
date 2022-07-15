-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_forma_entrega ( cd_pessoa_fisica_p text, cd_medico_p text, ie_regra_p text, nr_seq_forma_p INOUT bigint) AS $body$
DECLARE


cd_cep_w		varchar(15):= '';
cd_municipio_ibge_w	varchar(6) := '';
sg_estado_w		compl_pessoa_fisica.sg_estado%type;
nr_seq_forma_laudo_w	bigint:= 0;
qt_registros_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_forma_laudo
	FROM 	(SELECT	1 ie_ordem,
			nr_seq_forma_laudo
		FROM	eup_forma_entrega_end
		WHERE	sg_estado = sg_estado_w
		AND	coalesce(cd_municipio_ibge::text, '') = ''
		AND 	coalesce(cd_cep::text, '') = ''
		
UNION

		SELECT	2 ie_ordem,
			nr_seq_forma_laudo
		FROM	eup_forma_entrega_end
		WHERE	sg_estado = sg_estado_w
		AND	((cd_municipio_ibge = cd_municipio_ibge_w) AND (coalesce(cd_cep::text, '') = ''))
		
UNION

		SELECT	3 ie_ordem,
			nr_seq_forma_laudo
		FROM	eup_forma_entrega_end
		WHERE	sg_estado = sg_estado_w
		AND	cd_cep = cd_cep_w) alias6
	ORDER BY ie_ordem;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	eup_forma_entrega_end
where	cd_estabelecimento = Obter_estabelecimento_ativo;

if (qt_registros_w > 0) then

	if (ie_regra_p = 'RP') then
		select 	coalesce(max(cd_cep),''),
			coalesce(max(cd_municipio_ibge),''),
			coalesce(max(sg_estado),'')
		into STRICT	cd_cep_w,
			cd_municipio_ibge_w,
			sg_estado_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento = 1
		and	cd_pessoa_fisica    = cd_pessoa_fisica_p;
	end if;

	if (ie_regra_p = 'CP') then
		select 	coalesce(max(cd_cep),''),
			coalesce(max(cd_municipio_ibge),''),
			coalesce(max(sg_estado),'')
		into STRICT	cd_cep_w,
			cd_municipio_ibge_w,
			sg_estado_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento = 2
		and	cd_pessoa_fisica    = cd_pessoa_fisica_p;

	end if;

	if (ie_regra_p  = 'CM') then
		select 	coalesce(max(cd_cep),''),
			coalesce(max(cd_municipio_ibge),''),
			coalesce(max(sg_estado),'')
		into STRICT	cd_cep_w,
			cd_municipio_ibge_w,
			sg_estado_w
		from	compl_pessoa_fisica a
		where	ie_tipo_complemento = 2
		and	cd_pessoa_fisica    = cd_medico_p;
	end if;

	open C01;
	loop
	fetch C01 into
		nr_seq_forma_laudo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_seq_forma_p	 := nr_seq_forma_laudo_w;
		end;
	end loop;
	close C01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_forma_entrega ( cd_pessoa_fisica_p text, cd_medico_p text, ie_regra_p text, nr_seq_forma_p INOUT bigint) FROM PUBLIC;

