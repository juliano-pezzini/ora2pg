-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_margem_reaprazamento (dt_horario_p timestamp) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_perfil_w				perfil.cd_perfil%type;
ds_retorno_w			varchar(1);

cRegras CURSOR FOR
SELECT	a.nr_sequencia nr_seq_regra,
		a.ie_permite ie_permite,
		a.qt_min_anterior qt_min_anterior,
		a.qt_min_margem qt_min_margem
from	adep_margem_reaprazamento a
where	((a.cd_perfil = cd_perfil_w) or (coalesce(a.cd_perfil::text, '') = ''))
and		((a.cd_estabelecimento = cd_estabelecimento_w) or (coalesce(a.cd_estabelecimento::text, '') = ''))
group by
		a.nr_sequencia,
		a.ie_permite,
		a.qt_min_anterior,
		a.qt_min_margem,
		a.cd_perfil,
		a.cd_estabelecimento
order by
		coalesce(a.cd_perfil,99999),
		coalesce(a.cd_estabelecimento,99999);

BEGIN

ds_retorno_w := 'S';

if (dt_horario_p IS NOT NULL AND dt_horario_p::text <> '') then
	cd_perfil_w := wheb_usuario_pck.get_cd_perfil;
	cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
	for cRegras_w in cRegras loop
		begin
			if (clock_timestamp() > (dt_horario_p + (cRegras_w.qt_min_margem / 1440))) or
				(clock_timestamp() < (dt_horario_p - (cRegras_w.qt_min_anterior / 1440))) then
				ds_retorno_w := cRegras_w.ie_permite;
				exit;
			end if;
		end;
	end loop;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_margem_reaprazamento (dt_horario_p timestamp) FROM PUBLIC;

