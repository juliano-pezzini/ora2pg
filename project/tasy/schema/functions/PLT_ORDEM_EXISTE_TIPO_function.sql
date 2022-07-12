-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_ordem_existe_tipo ( ie_tipo_item_p text, nm_usuario_p text, ie_status_item_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_apres_w			bigint;
ie_ordena_suspenso_w		varchar(1);
ie_ordem_existe_w		varchar(1);


BEGIN


ie_ordena_suspenso_w := Obter_Param_Usuario(950, 135, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_ordena_suspenso_w);
ie_ordem_existe_w := Obter_Param_Usuario(950, 56, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_ordem_existe_w);

if (ie_ordem_existe_w	=	'S')	then

	select	CASE WHEN count(nr_sequencia)=0 THEN 3  ELSE 1 END
	into STRICT	nr_seq_apres_w
	from	w_rep_t
	where	ie_tipo_item	= ie_tipo_item_p
	and	nm_usuario	= nm_usuario_p
	and	(nr_prescricoes IS NOT NULL AND nr_prescricoes::text <> '');

	if (ie_ordena_suspenso_w	=	'S')	and (ie_status_item_p	=	'S')	then

		nr_seq_apres_w	:=  2;

	elsif (ie_ordena_suspenso_w	=	'S')	and (coalesce(ie_status_item_p::text, '') = '')	then

		select	CASE WHEN count(nr_sequencia)=0 THEN 3  ELSE 1 END
		into STRICT	nr_seq_apres_w
		from	w_rep_t
		where	ie_tipo_item	= ie_tipo_item_p
		and	nm_usuario	= nm_usuario_p
		and	(nr_prescricoes IS NOT NULL AND nr_prescricoes::text <> '')
		and	coalesce(ie_status_item,'X')	<> 'S';

	end if;
elsif (ie_ordena_suspenso_w	=	'S')	and (ie_status_item_p	=	'S')	then
	    nr_seq_apres_w	:=  2;
else
	nr_seq_apres_w	:= 1;
end if;

return	nr_seq_apres_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_ordem_existe_tipo ( ie_tipo_item_p text, nm_usuario_p text, ie_status_item_p text) FROM PUBLIC;
