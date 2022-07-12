-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_apres_grupo_html5 ( ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_apres_w	regra_ordem_grupo_rep.nr_seq_apres%type;
nr_seq_regra_w	regra_ordem_grupo_rep.nr_seq_regra%type;



BEGIN

nr_seq_regra_w := Obter_Param_Usuario(1113, 244, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, nr_seq_regra_w);

select	coalesce(max(nr_seq_apres),0)
into STRICT 	nr_seq_apres_w
from	regra_ordem_grupo_rep
where	nr_seq_regra = nr_seq_regra_w
and		ie_grupo = ie_tipo_item_p;

if (ie_tipo_item_p = 'C') then

	select	coalesce(max(nr_seq_apres),0)
	into STRICT 	nr_seq_apres_w
	from	regra_ordem_grupo_rep
	where	nr_seq_regra = nr_seq_regra_w
	and		ie_grupo = 'G';

end if;

return nr_seq_apres_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_apres_grupo_html5 ( ie_tipo_item_p text) FROM PUBLIC;

