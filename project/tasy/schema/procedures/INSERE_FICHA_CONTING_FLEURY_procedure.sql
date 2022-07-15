-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_ficha_conting_fleury ( ds_xml_p text, nm_usuario_p text, cd_estabelecimento_p bigint default null, nr_controle_p bigint default null, nr_prescricao_p bigint default null) AS $body$
DECLARE



ds_xml_inicio_w			varchar(30000);
cd_estabelecimento_w	bigint;
nr_contrato_w			bigint;
nm_maquina_w			varchar(100);


BEGIN

cd_estabelecimento_w := cd_estabelecimento_p;

if (coalesce(cd_estabelecimento_p::text, '') = '') then

	/*Busca o contrato no xml*/

	ds_xml_inicio_w := substr(ds_xml_p, position('Contrato="' in ds_xml_p) + 10,20);

	begin
	nr_contrato_w := (substr(ds_xml_inicio_w,1, position('"' in ds_xml_inicio_w)-1 ))::numeric;
	exception
	when others then
	nr_contrato_w := 0;
	end;

	if (nr_contrato_w > 0) then

		select	max(cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
		from	lab_parametro
		where	cd_contrato_fleury = nr_contrato_w;

	end if;

end if;


select	substr(max(machine),1,255)
into STRICT	nm_maquina_w
from	v$session
where	audsid = (SELECT userenv('sessionid') );


insert	into ficha_contingencia_fleury(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_xml,
	ie_enviado,
	dt_envio,
	cd_estabelecimento,
	nr_controle,
	ds_maquina,
	nr_prescricao
	)
values (
	nextval('ficha_contingencia_fleury_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_xml_p,
	'N',
	null,
	cd_estabelecimento_w,
	nr_controle_p,
	nm_maquina_w,
	nr_prescricao_p
	);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_ficha_conting_fleury ( ds_xml_p text, nm_usuario_p text, cd_estabelecimento_p bigint default null, nr_controle_p bigint default null, nr_prescricao_p bigint default null) FROM PUBLIC;

