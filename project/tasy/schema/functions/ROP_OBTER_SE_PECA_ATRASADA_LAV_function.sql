-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rop_obter_se_peca_atrasada_lav ( nr_seq_roupa_p bigint) RETURNS varchar AS $body$
DECLARE


ie_lavanderia_externa_w		varchar(1) := 'N';
ie_atrasada_w			varchar(1) := 'N';
dt_confirmacao_w			timestamp;
qt_dias_w			bigint;


BEGIN

qt_dias_w := Obter_Param_Usuario(1301, 18, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, qt_dias_w);

select	coalesce(rop_obter_se_peca_lav_externa(nr_seq_roupa_p),'N')
into STRICT	ie_lavanderia_externa_w
;

if (ie_lavanderia_externa_w = 'S') and (qt_dias_w > 0) then

	select	trunc(max(a.dt_confirmacao),'dd')
	into STRICT	dt_confirmacao_w
	from	rop_lavanderia a,
		rop_lavanderia_item b
	where	a.nr_sequencia = b.nr_seq_lavanderia
	and	b.nr_seq_roupa = nr_seq_roupa_p;

	if (obter_dias_entre_datas(dt_confirmacao_w,trunc(clock_timestamp(),'dd')) >= qt_dias_w) then
		ie_atrasada_w := 'S';
	end if;
end if;

return	ie_atrasada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rop_obter_se_peca_atrasada_lav ( nr_seq_roupa_p bigint) FROM PUBLIC;
